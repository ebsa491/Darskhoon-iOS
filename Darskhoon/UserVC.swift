//
//  UserVC.swift
//  Darskhoon
//
//  Created by Saman on 3/19/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class UserVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var statusLbl: StatusLbl!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = leftButton
        
        // ------------------------
        
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        
        nameField.returnKeyType = UIReturnKeyType.Done
        usernameField.returnKeyType = UIReturnKeyType.Done
        passwordField.returnKeyType = UIReturnKeyType.Done
        
        activity.hidesWhenStopped = true
        
        self.hideKeyboard()
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
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func done(sender: AnyObject!) {
        
        view.endEditing(true)
        
        if let username = usernameField.text where username != "" {
            if let password = passwordField.text where password != "" {
                
                let app = UIApplication.sharedApplication().delegate as! AppDelegate
                let context = app.managedObjectContext
                
                let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
                
                let person = Person(entity: entity, insertIntoManagedObjectContext: context)
                
                if !nameField.hidden {
                    // Sign Up
                    
                    if let name = nameField.text where name != "" {
                        
                        if username.characters.count > 5 && username.characters.count > 7 {
                            let url = "https://30T-Media.ir/api.php?action=newUser&name=\(name)&username=\(username)&password=\(password)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                            
                            loading(true)
                            
                            Alamofire.request(.GET, url).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
                                
                                self.loading(false)
                                
                                if let dict = result.value as? Dictionary<String, String> {
                                    
                                    if let id = dict["id"] {
                                        person.id = id
                                        person.name = name
                                        person.username = username
                                        person.password = password
                                        
                                        context.insertObject(person)
                                        
                                        do {
                                            try context.save()
                                        } catch let err as NSError {
                                            print(err.debugDescription)
                                        }
                                        
                                        self.navigationController?.popViewControllerAnimated(true)
                                        
                                    }
                                    
                                    if let error = dict["error"] {
                                        self.statusLbl.show(error)
                                    }
                                } else {
                                    self.statusLbl.show(INTERNET_ERROR)
                                }
                            })
                        } else {
                            self.statusLbl.show("خطا: نام کاربری نباید کمتر از ۵ و بیشتر از ۷ کارکتر باشد.")
                        }
                        
                    }
                    
                } else {
                    // Sign In
                    
                    let url = "https://30T-Media.ir/api.php?action=getUser&username=\(username)&password=\(password)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    
                    loading(true)
                    
                    Alamofire.request(.GET, url).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) in
                        
                        self.loading(false)
                        
                        if let dict = result.value as? Dictionary<String, String> {
                            
                            if let id = dict["id"] {
                                if let name = dict["name"] {
                                    person.id = id
                                    person.name = name
                                    person.username = username
                                    person.password = password
                                    
                                    context.insertObject(person)
                                    
                                    do {
                                        try context.save()
                                    } catch let err as NSError {
                                        print(err.debugDescription)
                                    }
                                    
                                    self.navigationController?.popViewControllerAnimated(true)
                                    
                                }
                            }
                            
                            if let error = dict["error"] {
                                self.statusLbl.show(error)
                            }
                        } else {
                            self.statusLbl.show(INTERNET_ERROR)
                        }
                    })
                    
                }
                
            } else {
                self.statusLbl.show("رمز عبور را وارد کنید.")
            }
        } else {
            self.statusLbl.show("خطا: نام کاربری را وارد کنید.")
        }
        
    }
    
    @IBAction func changeStatus(sender: UIButton) {
        if sender.currentTitle == "حساب دارید؟" {
            sender.setTitle("ثبت نام نکرده اید؟", forState: UIControlState.Normal)
            nameField.hidden = true
        } else {
            sender.setTitle("حساب دارید؟", forState: UIControlState.Normal)
            nameField.hidden = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let frame = view.frame
        
        view.center = CGPointMake(frame.width / 2, (frame.height / 2) - 60)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let frame = view.frame
        
        view.center = CGPointMake(frame.width / 2, frame.height / 2)
    }
    
}
