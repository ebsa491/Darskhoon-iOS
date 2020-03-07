//
//  MenuCell.swift
//  Darskhoon
//
//  Created by Saman on 4/16/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(title: String) {
        titleLbl.text = title
    }
    
}
