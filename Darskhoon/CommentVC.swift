//
//  CommentVC.swift
//  Darskhoon
//
//  Created by Saman on 3/24/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    @IBOutlet weak var null: UILabel!
    
    var comments = [String]()
    
    var users = [String]()
    
    var id: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------------------
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textBegan(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        // ------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barButton
        
        // ------------------
        
        navigationItem.title = "نظرات"
        
        // ------------------
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.delegate = self
        
        textField.returnKeyType = UIReturnKeyType.Done
        
        getData()
        
    }
    
    func getData() {
        
        null.hidden = true
        
        let url = NSURL(string: "https://30T-Media.ir/api.php?action=getComments&id=\(id)")!
        
        loading(true)
        
        Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
            
            self.loading(false)
            
            if let array = result.value as? [Dictionary<String, String>] {
                for dict in array.reverse() {
                    if let comment = dict["text"] {
                        self.comments.append(comment)
                    }
                    
                    if let user = dict["user"] {
                        self.users.append(user)
                    }
                }
                
                if array.count == 0 {
                    self.null.hidden = false
                }
                
                self.tableView.reloadData()
                
            } else {
                self.statusLbl.show(INTERNET_ERROR)
            }
        }
        
    }
    
    func textBegan(notification: NSNotification) {
        
        let userInfo: NSDictionary = notification.userInfo!
        
        let keyFrame = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        let rect = keyFrame.CGRectValue()
        
        let height = rect.height
        
        let frame = view.frame
        
        view.center = CGPointMake(frame.width / 2, (frame.height / 2) - height)
        
    }
    
    func loading(bool: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = bool
        
        navigationItem.leftBarButtonItem?.enabled = !bool
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func send(sender: AnyObject!) {
        
        view.endEditing(true)
        
        if let comment = textField.text where comment != "" {
            
            var name = ""
            
            let app = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = app.managedObjectContext
            
            let fetch = NSFetchRequest(entityName: "Person")
            
            do {
                
                let result = try context.executeFetchRequest(fetch) as? [Person]
                
                if result!.count == 0 {
                    self.statusLbl.show(SIGN_IN_ERROR)
                } else {
                    name = result![0].name!
                }
                
            } catch let err as NSError {
                print(err.debugDescription)
            }
            
            if name != "" {
                let url = "https://30T-Media.ir/api.php?action=newComment&id=\(id)&name=\(name)&text=\(comment)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                
                loading(true)
                
                Alamofire.request(.GET, url).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
                    
                    self.loading(false)
                    
                    if let dict = result.value as? Dictionary<String, String> {
                        if let status = dict["status"] {
                            if status == "True" {
                                
                                self.textField.text = ""
                                
                                self.statusLbl.show("نظرتان منتظر تایید است.", color: UIColor.greenColor())
                                
                            }
                        }
                    } else {
                        self.statusLbl.show(INTERNET_ERROR)
                    }
                    
                })
            }
            
        } else {
            self.statusLbl.show("خطا: قبل ارسال باید نظرتان را وارد کنید.")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Comment") as? CommentCell {
            
            let text = comments[indexPath.row]
            
            let user = users[indexPath.row]
            
            cell.configure(text, user: user)
            
            cell.txt.textColor = UIColor(red: 0.5, green: 0.7, blue: 0.2, alpha: 1.0)
            cell.txt.font = UIFont(name: "Lalezar", size: 14.0)
            cell.txt.textAlignment = NSTextAlignment.Right
            
            cell.backgroundColor = cell.contentView.backgroundColor
            
            return cell
        } else {
            return CommentCell()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let frame = view.frame
        
        view.center = CGPointMake(frame.width / 2, frame.height / 2)
    }
    
}
