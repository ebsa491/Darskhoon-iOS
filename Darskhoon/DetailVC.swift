//
//  DetailVC.swift
//  Darskhoon
//
//  Created by Saman on 3/19/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit
import AVKit
import CoreData
import Alamofire
import AVFoundation
import AlamofireImage

class DetailVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var teacherLbl: UILabel!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var descriptionTxt: UITextView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    var lesson: Lesson!
    
    var id = ""
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------------------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = leftButton
        
        // ---------------------------------
        
        commentBtn.layer.cornerRadius = commentBtn.bounds.width / 2
        
        downloadBtn.layer.cornerRadius = downloadBtn.bounds.width / 2
        
        enableBtn(true)
        
        // ---------------------------------
        
        imageView.clipsToBounds = true
        
        navigationItem.title = lesson.title
        
        timeLbl.text = lesson.time
        
        teacherLbl.text = lesson.teacher
        
        // ----------------------------------
        
        visualEffectView.hidden = true
        
        imageView.addSubview(visualEffectView)
        
        // ----------------------------------
        
        fetchId()
        
        progressBar.hidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fullPath = path.stringByAppendingPathComponent(lesson.video)
        
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(fullPath) {
            downloadBtn.hidden = true
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        descriptionTxt.text = lesson.desc
        
        descriptionTxt.textAlignment = NSTextAlignment.Center
        descriptionTxt.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        descriptionTxt.font = UIFont(name: "Lalezar", size: 16.0)
        
        let url = NSURL(string: "https://30T-Media.ir/android/img/\(lesson.image)")!
        
        imageView.image = UIImage(named: "placeholder.png")
        
        Alamofire.request(.GET, url).responseImage { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<Image>) in
            if let image = result.value {
                self.imageView.image = image
            }
        }
        
        visualEffectView.frame = CGRectMake(0, 0, imageView.frame.width, imageView.frame.height)
        
        visualEffectView.alpha = 0.6
        
        visualEffectView.hidden = false
        
    }
    
    func fetchId() {
        let app = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = app.managedObjectContext
        
        let fetch = NSFetchRequest(entityName: "Person")
        
        do {
            let result = try context.executeFetchRequest(fetch) as! [Person]
            
            if result.count != 0 {
                id = result[0].id!
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func loading(bool: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = bool
        
        navigationItem.leftBarButtonItem?.enabled = !bool
        
    }
    
    func enableBtn(bool: Bool) {
        
        playBtn.enabled = bool
        navigationItem.leftBarButtonItem?.enabled = bool
        commentBtn.enabled = bool
        downloadBtn.enabled = bool
        
    }
    
    @IBAction func download(sender: AnyObject!) {
        
        if id != "" {
            if let url = NSURL(string: "https://30T-Media.ir/\(lesson.video)") {
                
                enableBtn(false)
                
                self.progressBar.hidden = false
                
                let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
                
                Alamofire.download(.GET, url, parameters: nil, encoding: ParameterEncoding.JSON, headers: nil, destination: destination).progress({ (_, read, all) in
                    
                    self.progressBar.setProgress(Float(read) / Float(all), animated: false)
                    
                    if Float(read) / Float(all) == 1 {
                        
                        self.progressBar.hidden = true
                        
                        self.enableBtn(true)
                        
                        self.downloadBtn.hidden = true
                        
                        self.statusLbl.show("ویدیو با موفقیت دانلود شد.", color: UIColor.greenColor())
                        
                    }
                    
                })
            }
        } else {
            self.statusLbl.show(SIGN_IN_ERROR)
        }
        
    }
    
    @IBAction func playVideo(sender: UIButton) {
        
        if id != "" {
            
            let url = "https://30T-media.ir/api.php?action=addMyVideo&id=\(id)&postId=\(lesson.id)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            loading(true)
            
            Alamofire.request(.GET, url).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
                
                self.loading(false)
                
                let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                
                let fullPath = path.stringByAppendingPathComponent(self.lesson.video)
                
                let fileManager = NSFileManager()
                
                var playUrl = NSURL(string: "https://30T-Media.ir/\(self.lesson.video)")!
                
                let player = AVPlayer(URL: playUrl)
                
                let playerVc = AVPlayerViewController()
                
                playerVc.player = player
                
                if fileManager.fileExistsAtPath(fullPath) {
                    playUrl = NSURL(fileURLWithPath: fullPath)
                    
                } else {
                    if result.value == nil {
                        self.statusLbl.show(INTERNET_ERROR)
                        
                        return
                    }
                }
                
                self.presentViewController(playerVc, animated: true, completion: {
                    player.play()
                })
                
            })
            
        } else {
            self.statusLbl.show(SIGN_IN_ERROR)
        }
        
    }
    
    @IBAction func comment(sender: AnyObject!) {
        performSegueWithIdentifier("Comment", sender: lesson.id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Comment" {
            if let commentVc = segue.destinationViewController as? CommentVC {
                if let id = sender as? String {
                    commentVc.id = id
                }
            }
        }
    }
    
}
