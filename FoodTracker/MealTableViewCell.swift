//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Auston Salvana on 8/3/15.
//  Copyright (c) 2015 ASolo. All rights reserved.
//

import UIKit
import Parse

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingsControl!
    var downloadedImage = UIImage()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func downloadImageFunc (meal :PFFile) -> UIImage {
        
            if let url = meal.url {
                let data = NSData(contentsOfURL: NSURL(string:url)!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.downloadedImage = UIImage(data: data!)!
            }
        
        return downloadedImage
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
