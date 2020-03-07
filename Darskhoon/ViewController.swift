//
//  ViewController.swift
//  Darskhoon
//
//  Created by Saman on 3/14/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var specialCollection: UICollectionView!
    @IBOutlet weak var mostDownloadCollection: UICollectionView!
    @IBOutlet weak var newsCollection: UICollectionView!
    @IBOutlet weak var mathCollection: UICollectionView!
    @IBOutlet weak var scienceCollection: UICollectionView!
    @IBOutlet weak var farsiCollection: UICollectionView!
    
    @IBOutlet weak var mathBtn: UIButton!
    @IBOutlet weak var scienceBtn: UIButton!
    @IBOutlet weak var farsiBtn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var specialLbl: UILabel!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    var specials = [Lesson]()
    var mosts = [Lesson]()
    var news = [Lesson]()
    var maths = [Lesson]()
    var sciences = [Lesson]()
    var farsis = [Lesson]()
    
    var menuVc: MenuVC!
    
    var refreshControl: UIRefreshControl!
    
    var a = NSMutableAttributedString()
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        
        // ----------------------------------------
        
        a = NSMutableAttributedString(string: "پیشنهادات ویژه", attributes: [NSFontAttributeName:UIFont(name: "Lalezar", size: 27.0)!])
        a.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:10, length:4))
        specialLbl.attributedText = a
        
        // -----------------------------------------
        
        super.viewDidLoad()
        
        // -----------------------------------------
        
        let image = UIImage(named: "logo.png")
        
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRectMake(0, 0, 175, 85)
        
        imageView.contentMode = .ScaleAspectFit
        
        navigationItem.titleView = imageView
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Lalezar", size: 20)!]
        
        //--------------------------------------
        
        let leftButton = UIButton(frame: CGRectMake(0,0, 25, 25))
        
        leftButton.setImage(UIImage(named: "search.png"), forState: UIControlState.Normal)
        
        leftButton.addTarget(self, action: #selector(self.search), forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        // -------------------------------------
        
        let rightButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        rightButton.setImage(UIImage(named: "menu.png"), forState: UIControlState.Normal)
        
        rightButton.addTarget(self, action: #selector(self.menu), forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // -------------------------------------
        
        menuVc = storyboard?.instantiateViewControllerWithIdentifier("MenuVC") as! MenuVC
        
        // -------------------------------------
        
        mathBtn.layer.cornerRadius = 5.0
        scienceBtn.layer.cornerRadius = 5.0
        farsiBtn.layer.cornerRadius = 5.0
        
        // -------------------------------------
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureHandler))
        
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        
        view.addGestureRecognizer(rightSwipe)
        
        // -------------------------------------
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureHandler))
        
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        
        view.addGestureRecognizer(leftSwipe)
        
        // -------------------------------------
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.getData), forControlEvents: UIControlEvents.ValueChanged)
        scrollView.addSubview(refreshControl)
        
        specialCollection.delegate = self
        mostDownloadCollection.delegate = self
        newsCollection.delegate = self
        mathCollection.delegate = self
        scienceCollection.delegate = self
        farsiCollection.delegate = self
        
        specialCollection.dataSource = self
        mostDownloadCollection.dataSource = self
        newsCollection.dataSource = self
        mathCollection.dataSource = self
        scienceCollection.dataSource = self
        farsiCollection.dataSource = self
        
        scrollView.hidden = true
        
        getData()
        
        switch launchFrom {
        case "MATHS":
            launchFrom = "VC"
            performSegueWithIdentifier("Lesson", sender: "ریاضی")
        case "SCIENCES":
            launchFrom = "VC"
            performSegueWithIdentifier("Lesson", sender: "علوم")
        case "FARSIS":
            launchFrom = "VC"
            performSegueWithIdentifier("Lesson", sender: "ادبیات")
        default:
            break
        }
        
    }
    
    func getData() {
        
        let url = NSURL(string: "https://30T-Media.ir/api.php?action=getPosts")!
        
        loading(true)
        
        Alamofire.request(.GET, url).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
            
            self.loading(false)
            
            if let array = result.value as? [Dictionary<String, String>] {
                
                self.scrollView.hidden = false
                
                self.specials = []
                self.mosts = []
                self.news = []
                self.maths = []
                self.sciences = []
                self.farsis = []
                
                for dict in array.reverse() {
                    if let id = dict["id"] {
                        if let title = dict["title"] {
                            if let desc = dict["description"] {
                                if let time = dict["time"] {
                                    if let lessonType = dict["lesson"] {
                                        if let teacher = dict["teacher"] {
                                            if let video = dict["video"] {
                                                if let image = dict["photo"] {
                                                    let lesson = Lesson(id: id, title: title, desc: desc, time: time, teacher: teacher, video: video, image: image)
                                                    
                                                    switch lessonType {
                                                    case "ریاضی":
                                                        
                                                        if self.maths.count == 5 {
                                                            break
                                                        }
                                                        
                                                        self.maths.append(lesson)
                                                        
                                                    case "علوم":
                                                        
                                                        if self.sciences.count == 5 {
                                                            break
                                                        }
                                                        
                                                        self.sciences.append(lesson)
                                                        
                                                    default:
                                                        // farsi
                                                        
                                                        if self.farsis.count == 5 {
                                                            break
                                                        }
                                                        
                                                        self.farsis.append(lesson)
                                                        
                                                    }
                                                    
                                                    if self.news.count < 5 {
                                                        self.news.append(lesson)
                                                    }
                                                    
                                                    if let _ = dict["isMost"] {
                                                        if self.mosts.count < 5 {
                                                            self.mosts.append(lesson)
                                                        }
                                                    }
                                                    
                                                    if let special = dict["special"] {
                                                        if self.specials.count < 5 && special == "1" {
                                                            self.specials.append(lesson)
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.reload()
                
            } else {
                self.loading(false)
                self.statusLbl.show(INTERNET_ERROR)
            }
        }
        
    }
    
    func reload() {
        self.specialCollection.reloadData()
        self.mostDownloadCollection.reloadData()
        self.newsCollection.reloadData()
        self.mathCollection.reloadData()
        self.scienceCollection.reloadData()
        self.farsiCollection.reloadData()
    }
    
    func gestureHandler(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Left:
            
            self.view.addSubview(self.menuVc.view)
            self.addChildViewController(self.menuVc)
            
            menuVc.show(view)
        default:
            menuVc.hide()
            break
        }
    }
    
    func menu() {
        if !menuStatus {
            
            self.view.addSubview(self.menuVc.view)
            self.addChildViewController(self.menuVc)
            
            menuVc.show(view)
        } else {
            menuVc.hide()
        }
    }
    
    func search() {
        performSegueWithIdentifier("Search", sender: nil)
    }
    
    func loading(bool: Bool) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = bool
        
        navigationItem.leftBarButtonItem?.enabled = !bool
        navigationItem.rightBarButtonItem?.enabled = !bool
                
        if !bool {
            refreshControl.endRefreshing()
        }
    }
    
    @IBAction func lesson(sender: UIButton!) {
        
        var lesson = ""
        
        switch sender.tag {
        case 0:
            lesson = "ریاضی"
            break
        case 1:
            lesson = "علوم"
            break
        default:
            lesson = "ادبیات"
            break
        }
        
        performSegueWithIdentifier("Lesson", sender: lesson)
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var lesson: Lesson!
        
        var id: String!
        
        switch collectionView {
        case specialCollection:
            
            lesson = specials[indexPath.row]
            id = "specialCell"
            
        case mostDownloadCollection:
            
            lesson = mosts[indexPath.row]
            id = "mostCell"
            
        case newsCollection:
            
            lesson = news[indexPath.row]
            id = "newsCell"
            
        case mathCollection:
            
            lesson = maths[indexPath.row]
            id = "mathCell"
            
        case scienceCollection:
            
            lesson = sciences[indexPath.row]
            id = "scienceCell"
            
        default:
            
            lesson = farsis[indexPath.row]
            id = "farsiCell"
            
        }
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(id, forIndexPath: indexPath) as? LessonsCell {
            
            cell.backgroundColor = cell.contentView.backgroundColor
            
            registerForPreviewingWithDelegate(self, sourceView: cell)
            
            cell.configure(lesson)
            
            return cell
            
        } else {
            return LessonsCell()
        }
        
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var lesson: Lesson!
        
        switch collectionView {
        case specialCollection:
            lesson = specials[indexPath.row]
        case mostDownloadCollection:
            lesson = mosts[indexPath.row]
        case newsCollection:
            lesson = news[indexPath.row]
        case mathCollection:
            lesson = maths[indexPath.row]
        case scienceCollection:
            lesson = sciences[indexPath.row]
        default:
            lesson = farsis[indexPath.row]
        }
        
        performSegueWithIdentifier("Detail", sender: lesson)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case specialCollection:
            
            return specials.count
            
        case mostDownloadCollection:
            
            return mosts.count
            
        case newsCollection:
            
            return news.count
            
        case mathCollection:
            
            return maths.count
            
        case scienceCollection:
            
            return sciences.count
            
        default:
            
            return farsis.count
            
        }
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let detailVc = storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! DetailVC
        
        detailVc.lesson = Lesson(id: "1", title: "موضوع", desc: "توضیح", time: "-", teacher: "-", video: "false.mp4", image: "false.jpg")
        
        let point = scrollView.convertPoint(location, fromView: previewingContext.sourceView)
        
        if CGRectContainsPoint(specialCollection.frame, point) {
            if let indexPath = specialCollection.indexPathForItemAtPoint(specialCollection.convertPoint(point, fromView: scrollView)) {
                detailVc.lesson = specials[indexPath.row]
            }
        } else if CGRectContainsPoint(mostDownloadCollection.frame, point) {
            if let indexPath = mostDownloadCollection.indexPathForItemAtPoint(mostDownloadCollection.convertPoint(point, fromView: scrollView)) {
                detailVc.lesson = mosts[indexPath.row]
            }
        } else if CGRectContainsPoint(newsCollection.frame, point) {
            if let indexPath = newsCollection.indexPathForItemAtPoint(newsCollection.convertPoint(point, fromView: scrollView)) {
                detailVc.lesson = news[indexPath.row]
            }
        } else if CGRectContainsPoint(mathCollection.frame, point) {
            if let indexPath = mathCollection.indexPathForItemAtPoint(mathCollection.convertPoint(point, fromView: scrollView)) {
                detailVc.lesson = maths[indexPath.row]
            }
        } else if CGRectContainsPoint(scienceCollection.frame, point) {
            if let indexPath = scienceCollection.indexPathForItemAtPoint(scienceCollection.convertPoint(point, fromView: scrollView)) {
                detailVc.lesson = sciences[indexPath.row]
            }
        } else {
            if let indexPath = farsiCollection.indexPathForItemAtPoint(farsiCollection.convertPoint(point, fromView: scrollView)) {
                detailVc.lesson = farsis[indexPath.row]
            }
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
        } else if segue.identifier == "Lesson" {
            if let lessonVc = segue.destinationViewController as? LessonVC {
                if let lesson = sender as? String {
                    lessonVc.lesson = lesson
                }
            }
        }
        
    }
    
}

