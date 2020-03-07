//
//  MenuCell.swift
//  Darskhoon
//
//  Created by Saman on 4/16/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    func configure(title: String) {
        titleLbl.text = title
    }
    
}
