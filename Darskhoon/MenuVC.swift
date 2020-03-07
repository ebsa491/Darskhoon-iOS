//
//  MenuVC.swift
//  Darskhoon
//
//  Created by Saman on 3/21/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit
import CoreData

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var userBtn: UIButton!
    
    var titles = ["مشاهده شده ها", "ریاضی", "علوم", "ادبیات", "ارتباط با ما", "درباره ما"]
    
    var person: Person!
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        viewDidLoad()
    }
    
    func fetchData() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Person")
        
        do {
            
            let result = try context.executeFetchRequest(fetch) as! [Person]
            
            if result.count == 0 {
                nameLbl.text = "حساب کاربری"
                id = ""
                userBtn.setTitle("ورود یا ثبت نام", forState: UIControlState.Normal)
            } else {
                person = result[0]
                nameLbl.text = result[0].name!
                id = result[0].id!
                userBtn.setTitle("خروج", forState: UIControlState.Normal)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        tableView.reloadData()
        
    }
    
    func show(view: UIView) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
            
            menuStatus = true
            }, completion: {(Bool) in
                self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        })
        
    }
    
    func hide() {
        
        view.backgroundColor = UIColor.clearColor()
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
            menuStatus = false
            
        }) { (Bool) in
            self.view.removeFromSuperview()
            
        }
    }
    
    @IBAction func user(sender: UIButton!) {
        
        switch sender.currentTitle! {
        case "خروج":
            let alert = UIAlertController(title: "خروج", message: "آیا مطمئنید می خواهید خارج شوید؟", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "لغو", style: UIAlertActionStyle.Default, handler: nil))
            
            alert.addAction(UIAlertAction(title: "بله", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = app.managedObjectContext
                
                context.deleteObject(self.person)
                
                let fetch = NSFetchRequest(entityName: "MyLessons")
                let delete = NSBatchDeleteRequest(fetchRequest: fetch)
                
                do {
                    try context.executeRequest(delete)
                } catch let err as NSError {
                    print(err.debugDescription)
                }
                
                do {
                    try context.save()
                } catch let err as NSError {
                    print(err.debugDescription)
                }
                
                self.fetchData()
                
                let fileManager = NSFileManager()
                
                let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                
                do {
                    let files = try fileManager.contentsOfDirectoryAtPath(path)
                    
                    for file in files {
                        try fileManager.removeItemAtPath(path + "/" + file)
                    }
                    
                } catch let err as NSError {
                    print(err.debugDescription)
                }
                
            }))
            
            presentViewController(alert, animated: true, completion: nil)
            
        default:
            performSegueWithIdentifier("User", sender: nil)
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as? MenuCell {
            
            cell.configure(titles[indexPath.row])
            
            cell.backgroundColor = cell.contentView.backgroundColor
            
            return cell
        } else {
            return MenuCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch titles[indexPath.row] {
        case "درباره ما":
            performSegueWithIdentifier("About", sender: nil)
        case "ارتباط با ما":
            performSegueWithIdentifier("Contact", sender: nil)
        case "مشاهده شده ها":
            performSegueWithIdentifier("MyVideo", sender: id)
        default:
            performSegueWithIdentifier("Lesson", sender: titles[indexPath.row])
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            let position = touch.locationInView(view)
            
            if !CGRectContainsPoint(tableView.frame, position) {
                hide()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Lesson" {
            if let lessonVc = segue.destinationViewController as? LessonVC {
                if let title = sender as? String {
                    lessonVc.lesson = title
                }
            }
        } else if segue.identifier == "MyVideo" {
            if let seensVc = segue.destinationViewController as? SeensVC {
                if let id = sender as? String {
                    seensVc.id = id
                }
            }
        }
        
    }
    
}
