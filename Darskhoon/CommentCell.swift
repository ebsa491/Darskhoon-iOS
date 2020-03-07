//
//  CommentCell.swift
//  Darskhoon
//
//  Created by Saman on 3/25/18.
//  GNU General Public License (GPL) v3.0.
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
