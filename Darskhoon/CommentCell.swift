//
//  CommentCell.swift
//  Darskhoon
//
//  Created by Saman on 3/25/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var txt: UITextView!
    
    @IBOutlet weak var userLbl: UILabel!
    
    func configure(text: String, user: String) {
        txt.text = text
        userLbl.text = user
    }
    
}
