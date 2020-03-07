//
//  StatusLbl.swift
//  Darskhoon
//
//  Created by Saman on 3/23/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit

class StatusLbl: UILabel {
    
    func show(title: String, color: UIColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)) {
        
        if hidden == true {
            
            self.backgroundColor = color
            
            self.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, 35.0)
            
            text = title
            
            self.hidden = false
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.frame = CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, 35.0)
                
                }, completion: {(Bool) in
                    _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.hide), userInfo: nil, repeats: false)
            })
        }
        
    }
    
    func hide() {
        
        UIView.animateWithDuration(0.3, animations: { 
            
            self.frame = CGRectMake(0, 20, UIScreen.mainScreen().bounds.width, 35.0)
            
            
            }, completion: {(Bool) in
                self.hidden = true
        })
        
    }
    
}
