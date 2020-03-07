//
//  content.swift
//  Darskhoon
//
//  Created by Saman on 3/16/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

var menuStatus = false

let INTERNET_ERROR = "خطا: لطفا اینترنت خود را چک کنید."
let SIGN_IN_ERROR = "خطا: ابتدا باید وارد حسابتان شوید."

var launchFrom = "VC"