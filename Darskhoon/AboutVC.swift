//
//  AboutVC.swift
//  Darskhoon
//
//  Created by Saman on 3/21/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var descTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -------------------------------
        
        let backButton = UIButton(frame: CGRectMake(0, 0, 25, 25))
        
        backButton.setImage(UIImage(named: "back.png"), forState: UIControlState.Normal)
        
        backButton.addTarget(self, action: #selector(self.back), forControlEvents: UIControlEvents.TouchUpInside)
        
        let barButton = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = barButton
        
        // -------------------------------
        
        navigationItem.title = "درباره ما"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let url = NSBundle.mainBundle().URLForResource("about", withExtension: "txt")!
        
        do {
            descTxt.text = try String(contentsOfURL: url)
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        descTxt.font = UIFont(name: "Lalezar", size: 16.0)
        descTxt.textColor = UIColor(red: 0.5, green: 0.7, blue: 0.2, alpha: 1.0)
        descTxt.textAlignment = NSTextAlignment.Center
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
