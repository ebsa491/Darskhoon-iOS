//
//  LessonsCell.swift
//  Darskhoon
//
//  Created by Saman on 3/16/18.
//  GNU General Public License (GPL) v3.0.
//

import UIKit
import Alamofire
import AlamofireImage

class LessonsCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        image.layer.cornerRadius = 5.0
        image.clipsToBounds = true
    }
    
    func configure(lesson: Lesson) {
        title.text = lesson.title
        
        image.image = UIImage(named: "placeholder.png")
        
        let url = NSURL(string: "https://30T-Media.ir/android/img/\(lesson.image)")!
        
        Alamofire.request(.GET, url).responseImage { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<Image>) in
            
            if let image = result.value {
                self.image.image = image
            }
            
        }
        
    }
    
}
