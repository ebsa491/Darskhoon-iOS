//
//  ContactVC.swift
//  Darskhoon
//
//  Created by Saman on 3/21/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit
import MessageUI

class ContactVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barButton
        
        // -----------------------
        
        navigationItem.title = "ارتباط با ما"
        
        // -----------------------
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func sendContact(sender: UIButton) {
        
        if sender.tag == 0 || sender.tag == 1 || sender.tag == 2 {
            
            let mailVC = MFMailComposeViewController()
            
            mailVC.mailComposeDelegate = self
            
            mailVC.setSubject("از طرف یکی از کاربران درسخون")
            mailVC.setToRecipients([sender.currentTitle!])
            
            self.presentViewController(mailVC, animated: true, completion: nil)
            
        } else {
            
            let url = NSURL(string: "https://t.me/\(sender.currentTitle!.stringByReplacingOccurrencesOfString("@", withString: ""))")!
            
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
