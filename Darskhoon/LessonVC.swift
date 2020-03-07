//
//  LessonVC.swift
//  Darskhoon
//
//  Created by Saman on 3/19/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit
import Alamofire

class LessonVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    var lesson: String!
    var lessons = [Lesson]()
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------------------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = leftButton
        
        // ---------------------------------
        
        navigationItem.title = lesson
        
        collection.delegate = self
        collection.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getData), forControlEvents: UIControlEvents.ValueChanged)
        collection.addSubview(refreshControl)
        
        getData()
    }
    
    func getData() {
        
        var lesson = ""
        
        switch self.lesson {
        case "ریاضی":
            lesson = "getMaths"
        case "علوم":
            lesson = "getSciences"
        default:
            lesson = "getFarsis"
        }
        
        let url = NSURL(string: "https://30T-Media.ir/api.php?action=\(lesson)")!
        
        loading(true)
        
        Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?, response:NSHTTPURLResponse?, result: Result<AnyObject>) in
            
            self.loading(false)
            
            if let array = result.value as? [Dictionary<String, String>] {
                
                self.lessons = []
                
                for index in (0..<array.count).reverse() {
                    if let id = array[index]["id"] {
                        if let title = array[index]["title"] {
                            if let desc = array[index]["description"] {
                                if let time = array[index]["time"] {
                                    if let teacher = array[index]["teacher"] {
                                        if let video = array[index]["video"] {
                                            if let image = array[index]["photo"] {
                                                
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
                
                self.collection.reloadData()
                
            } else {
                self.statusLbl.show(INTERNET_ERROR)
            }
        }
        
    }
    
    func loading(bool: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = bool
        
        navigationItem.leftBarButtonItem?.enabled = !bool
        
        if !bool {
            refreshControl.endRefreshing()
        }
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collection.dequeueReusableCellWithReuseIdentifier("LessonCell", forIndexPath: indexPath) as? LessonsCell {
            
            let lesson = lessons[indexPath.row]
            
            cell.configure(lesson)
            
            registerForPreviewingWithDelegate(self, sourceView: cell)
            
            cell.backgroundColor = cell.contentView.backgroundColor
            
            return cell
        } else {
            return LessonsCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let lesson = lessons[indexPath.row]
        
        performSegueWithIdentifier("Detail", sender: lesson)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let detailVc = storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
        
        detailVc.lesson = Lesson(id: "1", title: "موضوع", desc: "توضیح", time: "-", teacher: "-", video: "false.mp4", image: "false.jpg")
        
        let cell = previewingContext.sourceView as! UICollectionViewCell
        
        if let indexPath = collection.indexPathForCell(cell) {
            detailVc.lesson = lessons[indexPath.row]
        }
        
        return detailVc
        
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
        
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
