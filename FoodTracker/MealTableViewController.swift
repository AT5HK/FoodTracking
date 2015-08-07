//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 5/27/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//  See LICENSE.txt for this sample’s licensing information.
//

import UIKit
import Parse

class MealTableViewController: UITableViewController {
    // MARK: Properties
    
    var meals = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load the sample data.
        loadUserMeals()
    }
    
//    func loadSampleMeals() {
//        let photo1 = UIImage(named: "meal1.jpg")!
//        let meal1 = Meal(name: "Burger", photo: photo1, rating: 4)!
//        
//        let photo2 = UIImage(named: "meal2.jpg")!
//        let meal2 = Meal(name: "Burrito", photo: photo2, rating: 5)!
//        
//        let photo3 = UIImage(named: "meal3.jpg")!
//        let meal3 = Meal(name: "Pizza", photo: photo3, rating: 3)!
//        
//        meals += [meal1, meal2, meal3]
//    }
    
    func loadUserMeals() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
            let currentUser = PFUser.currentUser()
            let query = currentUser?.relationForKey("meals").query()
            if let mealsArray = query?.findObjects() {
                self.meals += mealsArray
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let userMeal: (PFObject) = meals[indexPath.row] as! (PFObject)
        
        cell.nameLabel.text = userMeal["name"] as? String
        cell.ratingControl.rating = (userMeal["rating"] as? Int)!
        
        cell.photoImageView.image = cell.downloadImageFunc(userMeal["file"] as! PFFile)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal: (PFObject) = meals[indexPath.row] as! (PFObject)
                
                let fetchedImage: PFFile? = selectedMeal["file"] as? PFFile
                
                if let url = fetchedImage?.url {
                    let data = NSData(contentsOfURL: NSURL(string:url)!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                    var newMeal = Meal(name: selectedMeal["name"] as! String, photo: UIImage(data: data!), rating: selectedMeal["rating"] as! Int)
                    mealDetailViewController.meal = newMeal
                }
            }
        }
        else if segue.identifier == "addItem" {
            print("Adding new meal.")
        }
    }
    
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow() {
                // Update an existing meal.
                meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
    }
    
    // MARK - Action
    
    
}