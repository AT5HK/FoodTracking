//
//  ProfileViewController.swift
//  FoodTracker
//
//  Created by Auston Salvana on 8/3/15.
//  Copyright (c) 2015 ASolo. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        username.text = currentUser?.username
        userType.text = currentUser?["userType"] as? String
        
        let fetchedImage: PFFile? = currentUser?["file"] as? PFFile
        
        if (fetchedImage != nil) {
            if let url = fetchedImage?.url {
                let data = NSData(contentsOfURL: NSURL(string:url)!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                profileImage.image = UIImage(data: data!)
            }
        }
    }
    
    //MARK - Action
    
    @IBAction func dismiss(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
