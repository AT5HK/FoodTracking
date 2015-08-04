//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Auston Salvana on 8/3/15.
//  Copyright (c) 2015 ASolo. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {

    // MARK - properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var typePicker: UIPickerView!
    
    var userTypes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTypes = ["Foodie", "Critic"]
    }
    
    func userSignup () {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        
        //save image
        let comppressedImage = UIImageJPEGRepresentation(photoImageView.image, 0.1)
        let imageFile = PFFile(name: "image.jpg", data: comppressedImage)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            if imageFile.save() {
            
                let pickerIndex = self.typePicker.selectedRowInComponent(0)
                user["userType"] = String(self.userTypes[pickerIndex])
                user["file"]? = imageFile
                
                
                if user.signUp() {
                    println("Successfully signed up")
                } else {
                    println("Failed to sign up")
                }
    
            } else {
                println("Failed to save imageFile and did not proceed save")
            }
        })
    }
    
    //MARK: UIImagePickerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK - UIPickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
       return userTypes[row]
    }
    
    
    //MARK - Action
    
    @IBAction func signUp(sender: UIButton) {
        
        if usernameTextField.text != "" && passwordTextField.text != "" {
            userSignup()
        } else {
            println("Must fill in all TextFields")
        }
    }
    
    @IBAction func photoImagePicker(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        usernameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

}
