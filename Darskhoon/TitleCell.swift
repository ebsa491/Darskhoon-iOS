//
//  SearchCell.swift
//  Darskhoon
//
//  Created by Saman on 3/24/18.
//  Copyright © 2018 Saman Ebrahimnezhad. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TitleCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        imgView.layer.cornerRadius = 5.0
        imgView.clipsToBounds = true
    }
    
    func configure(lesson: Lesson) {
        titleLbl.text = lesson.title
        
        self.imgView.image = UIImage(named: "placeholder.png")
        
        let url = NSURL(string: "https://30T-Media.ir/android/img/\(lesson.image)")!
        
        Alamofire.request(.GET, url).responseImage { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<Image>) in
            
            if let image = result.value {
                self.imgView.image = image
            }
            
        }
        
    }
    
}
