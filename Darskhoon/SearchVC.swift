//
//  SearchVC.swift
//  Darskhoon
//
//  Created by Saman on 3/19/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit
import Alamofire

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var notFound: UILabel!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var lessons = [Lesson]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = leftButton
        
        // ------------------------
        
        navigationItem.title = "جستجو"
        
        // ------------------------
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        // ------------------------
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // ------------------------
        
        activity.hidesWhenStopped = true
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func loading(bool: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = bool
        
        navigationItem.leftBarButtonItem?.enabled = !bool
        
        if !bool {
            activity.stopAnimating()
        } else {
            activity.startAnimating()
        }
    }
    
    @IBAction func search(sender: AnyObject!) {
        
        notFound.hidden = true
        
        view.endEditing(true)
        
        if let word = searchBar.text where word != "" {
            
            let url = "https://30T-Media.ir/api.php?action=search&word=\(word)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            loading(true)
            
            Alamofire.request(.GET, url).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
                
                self.loading(false)
                
                if let array = result.value as? [Dictionary<String, String>] {
                    
                    self.lessons = []
                    
                    for dict in  array {
                        if let id = dict["id"] {
                            if let title = dict["title"] {
                                if let desc = dict["description"] {
                                    if let time = dict["time"] {
                                        if let teacher = dict["teacher"] {
                                            if let video = dict["video"] {
                                                if let image = dict["photo"] {
                                                    let lesson = Lesson(id: id, title: title, desc: desc, time: time, teacher: teacher, video: video, image: image)
                                                    
                                                    self.lessons.append(lesson)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if array.count == 0 {
                        self.notFound.hidden = false
                    }
                    
                    self.tableView.reloadData()
                    
                } else {
                    self.statusLbl.show(INTERNET_ERROR)
                }
            })
            
        } else {
            self.statusLbl.show("خطا: کلمه ای برای جستجو وارد کنید.")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("Search") as? TitleCell {
            
            let lesson = lessons[indexPath.row]
            
            cell.configure(lesson)
            
            cell.backgroundColor = cell.contentView.backgroundColor
            
            return cell
        } else {
            return TitleCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Detail", sender: lessons[indexPath.row])
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90.0
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Detail" {
            if let detailVc = segue.destinationViewController as? DetailVC {
                if let lesson = sender as? Lesson {
                    detailVc.lesson = lesson
                }
            }
        }
    }
    
}
