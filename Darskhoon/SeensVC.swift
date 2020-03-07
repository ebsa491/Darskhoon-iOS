//
//  MyVideoVC.swift
//  Darskhoon
//
//  Created by Saman on 3/22/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit
import CoreData
import Alamofire

class SeensVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    @IBOutlet weak var noItem: UILabel!
    
    var lessons = [Lesson]()
    
    var result = [MyLessons]()
    
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barButton
        
        // ---------------------
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // ---------------------
        
        navigationItem.title = "مشاهده شده ها"
        
        // ---------------------
        
        noItem.hidden = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        getData()
        
    }
    
    func fetchData() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "MyLessons")
        
        do {
            result = try context.executeFetchRequest(fetch) as! [MyLessons]
            
            lessons = []
            
            for mylesson in result {
                
                let lesson = Lesson(id: mylesson.id!, title: mylesson.title!, desc: mylesson.desc!, time: mylesson.time!, teacher: mylesson.teacher!, video: mylesson.video!, image: mylesson.image!)
                
                lessons.append(lesson)
                
            }
            
            tableView.reloadData()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    func getData() {
        if id != "" {
            let url = NSURL(string: "https://30T-Media.ir/api.php?action=getMyVideo&id=\(id)")!
            
            loading(true)
            
            Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
                
                self.loading(false)
                
                if let array = result.value as? [Dictionary<String, String>] {
                    
                    self.lessons = []
                    
                    let app = UIApplication.sharedApplication().delegate as! AppDelegate
                    let context = app.managedObjectContext
                    
                    let entity = NSEntityDescription.entityForName("MyLessons", inManagedObjectContext: context)!
                    
                    let fetch = NSFetchRequest(entityName: "MyLessons")
                    let delete = NSBatchDeleteRequest(fetchRequest: fetch)
                    
                    do {
                        try context.executeRequest(delete)
                    } catch let err as NSError {
                        print(err.debugDescription)
                    }
                    
                    for dict in array {
                        if let id = dict["id"] {
                            if let title = dict["title"] {
                                if let desc = dict["description"] {
                                    if let time = dict["time"] {
                                        if let teacher = dict["teacher"] {
                                            if let video = dict["video"] {
                                                if let image = dict["photo"] {
                                                    
                                                    let lesson = Lesson(id: id, title: title, desc: desc, time: time, teacher: teacher, video: video, image: image)
                                                    
                                                    self.lessons.append(lesson)
                                                    
                                                    let mylesson = MyLessons(entity: entity, insertIntoManagedObjectContext: context)
                                                    
                                                    mylesson.id = lesson.id
                                                    mylesson.title = lesson.title
                                                    mylesson.desc = lesson.desc
                                                    mylesson.time = lesson.time
                                                    mylesson.teacher = lesson.teacher
                                                    mylesson.video = lesson.video
                                                    mylesson.image = lesson.image
                                                    
                                                    context.insertObject(mylesson)
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if self.lessons.count == 0 {
                        self.noItem.hidden = false
                    }
                    
                    do {
                        try context.save()
                    } catch let err as NSError {
                        print(err.debugDescription)
                    }
                    
                    self.tableView.reloadData()
                    
                } else {
                    
                    self.fetchData()
                    
                    self.statusLbl.show(INTERNET_ERROR)
                }
                
            }
        } else {
            statusLbl.show(SIGN_IN_ERROR)
        }
        
    }
    
    func loading(bool: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = bool
        
        navigationItem.leftBarButtonItem?.enabled = !bool
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("VideoCell") as? TitleCell {
            let lesson = lessons.reverse()[indexPath.row]
            
            cell.configure(lesson)
            
            return cell
            
        } else {
            return TitleCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let lesson = lessons.reverse()[indexPath.row]
        
        performSegueWithIdentifier("Detail", sender: lesson)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 98.0
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
