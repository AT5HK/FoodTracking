//
//  LoginViewController.swift
//  FoodTracker
//
//  Created by Auston Salvana on 8/3/15.
//  Copyright (c) 2015 ASolo. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK - Actiion
    @IBAction func login(sender: UIButton) {
        
        PFUser.logInWithUsernameInBackground(usernameTextfield.text, password: passwordTextField.text) { (let user , let error) -> Void in
            
            if (error != nil) {
                println("Failed to login with those credentials")
            } else {
                println("login in successful")
                self.performSegueWithIdentifier("MealTableViewController", sender: self)
            }
        }
    }
}
