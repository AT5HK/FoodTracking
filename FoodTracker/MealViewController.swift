//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Auston Salvana on 8/3/15.
//  Copyright (c) 2015 ASolo. All rights reserved.
//

import UIKit
import Parse

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingsControl!
    
    /*
    This value is either passed by `MealListTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new meal.
    */
    var meal = Meal?()
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        checkValidMealName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
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
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
//        if isPresentingInAddMealMode {
//            dismissViewControllerAnimated(true, completion: nil)
//        }
//        else {
            navigationController!.popViewControllerAnimated(true)
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Set the meal to be passed to MealListTableViewController after the unwind segue.
            meal = Meal(name: name, photo: photo, rating: rating)
            //imageFile
            let comppressedImage = UIImageJPEGRepresentation(self.meal?.photo, 0.1)
            let imageFile = PFFile(name: "image.jpg", data: comppressedImage)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                
                if imageFile.save() {
                    //save image
                    
                    //meal pfobject
                    let mealObject = PFObject(className: "Meal")
                    mealObject["name"] = self.meal?.name
                    mealObject["rating"] = self.meal?.rating
                    mealObject["file"] = imageFile
                    if mealObject.save() {
                    
                        //user relation
                        let currentUser = PFUser.currentUser()
                        let relation = currentUser?.relationForKey("meals")
                        relation?.addObject(mealObject)
                        if currentUser!.save() {
                            println("Successfully saved current users relations")
                        } else {
                            println("Failed to save current users relations")
                        }
                    } else {
                        println("failed to save mealObject")
                    }
                } else {
                    println("Failed to save image")
                }
            })
        }
    }
    
    //MARK: Action

    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
}

