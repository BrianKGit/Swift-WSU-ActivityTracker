//
//  NewActivityViewController.swift
//  ActivityTracker
//
//  Created by Brian Klein on 12/1/19.
//  Copyright © 2019 Tim Gegg-Harrison. All rights reserved.
//
//  A view controller used to take user input and create an Activity object to add to an array

import UIKit
import SQLite3

//var uiNewActivityColor: UIColor = .purple

class NewActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    let ACTIVITYCELL: String = "ActivityCell"
    let dirPath: String = "\(NSHomeDirectory())/tmp"
    let filePath: String = "\(NSHomeDirectory())/tmp/activity.txt"
    let descriptionLabel: UILabel = UILabel()
    let startTimeLabel: UILabel = UILabel()
    let endTimeLabel: UILabel = UILabel()
    let descriptionTextField: UITextField = UITextField()
    let startDatePicker: UIDatePicker = UIDatePicker()
    let endDatePicker: UIDatePicker = UIDatePicker()
    

//    var activityList = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = uiActivityColor
        
        //label for the Activity Description text field
        descriptionLabel.frame = CGRect(x: view.center.x-200, y: 50, width: 400, height: 50)
        descriptionLabel.text = "Activity Information"
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.font = UIFont.systemFont(ofSize: 24.0)
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.backgroundColor = UIColor.clear
        view.addSubview(descriptionLabel)
        
        //label for the Start Time date picker
        startTimeLabel.frame = CGRect(x: view.center.x-200, y: 200, width: 400, height: 50)
        startTimeLabel.text = "Activity Start Time"
        startTimeLabel.textColor = UIColor.black
        startTimeLabel.font = UIFont.systemFont(ofSize: 24.0)
        startTimeLabel.textAlignment = NSTextAlignment.center
        startTimeLabel.backgroundColor = UIColor.clear
        view.addSubview(startTimeLabel)
        
        //label for the End Time date picker
        endTimeLabel.frame = CGRect(x: view.center.x-200, y: 350, width: 400, height: 50)
        endTimeLabel.text = "Activity End Time"
        endTimeLabel.textColor = UIColor.black
        endTimeLabel.font = UIFont.systemFont(ofSize: 24.0)
        endTimeLabel.textAlignment = NSTextAlignment.center
        endTimeLabel.backgroundColor = UIColor.clear
        view.addSubview(endTimeLabel)
        
        //a text field for entering the description of the new activity to add to the array
        descriptionTextField.frame = CGRect(x: view.center.x-135, y: 125, width: 270, height: 50)
        descriptionTextField.textColor = UIColor.black
        descriptionTextField.font = UIFont.systemFont(ofSize: 24.0)
        descriptionTextField.placeholder = "<enter description>"
        descriptionTextField.backgroundColor = UIColor.white
        descriptionTextField.keyboardType = UIKeyboardType.default
        descriptionTextField.returnKeyType = UIReturnKeyType.done
        descriptionTextField.clearButtonMode = UITextField.ViewMode.always
        descriptionTextField.layer.borderColor = UIColor.black.cgColor
        descriptionTextField.borderStyle = UITextField.BorderStyle.line
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.delegate = self
        view.addSubview(descriptionTextField)
        
        //a date picker to select the begining time and date for the new activity, must use 15 minute intervals
        startDatePicker.frame = CGRect(x: view.center.x-135, y: 275, width: 270, height: 50)
        startDatePicker.minuteInterval = 15
        startDatePicker.backgroundColor = UIColor.white
        startDatePicker.layer.borderColor = UIColor.black.cgColor
        startDatePicker.layer.borderWidth = 1
        view.addSubview(startDatePicker)
        
        //a date picker to select the ending time and date for the new activity, must use 15 minute intervals
        endDatePicker.minuteInterval = 15
        endDatePicker.frame = CGRect(x: view.center.x-135, y: 425, width: 270, height: 50)
        endDatePicker.backgroundColor = UIColor.white
        endDatePicker.layer.borderColor = UIColor.black.cgColor
        endDatePicker.layer.borderWidth = 1
        view.addSubview(endDatePicker)
        
        //create 3 buttons and add them to the subview
        //first button will be an ADD button used to create a new activity from the data entered and add it to the array. will also dismiss this view and exit to the main view controller
        var button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-100, y: 575, width: 200, height: 50)
        button.setTitle("ADD", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(addButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        //second button will be a CLEAR button used to clear the data from the fields above
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-100, y: 650, width: 200, height: 50)
        button.setTitle("CLEAR", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(clearButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        //third button will be a CANCEL button, will exit this view to the main view controller without saving anything to the array
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-100, y: 725, width: 200, height: 50)
        button.setTitle("BACK", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)

    }//end viewDidLoad
    
    //required for UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }//end tableView
    
    //required for UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ACTIVITYCELL) ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: ACTIVITYCELL)
        let activity: Activity
        activity = activityList[indexPath.row]
        cell.textLabel?.text = activity.activityDescription
        return cell
    }//end tableView
    
    //add a new activity to the activity array using the data from this NewActivityViewController
    //get the description from the descriptionTextField
    //get the starting date from the startDatePicker
    //get the ending date from the endDatePicker
    @objc func addButtonPressed() {
        if(!descriptionTextField.text!.isEmpty) {
            if let newDescription = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty {
                let newStart = startDatePicker.date
                let newEnd = endDatePicker.date
                let newActivity: Activity = Activity(description: newDescription, start: newStart, end: newEnd)
                let mvc: MainViewController = self.presentingViewController as! MainViewController
                if(selection != -1) {
                    //remove the old object from the array
                    activityList.remove(at: selection)
                    selection = -1
                }
                //add the new object
                activityList.append(newActivity)
                saveToFile()
                activityTableView.reloadData()

                mvc.dismiss(animated: true, completion: {() -> Void in
                        mvc.scrollToBottom()
                })//end dismiss
            }//end if let statement
        }//end if statement
    }//end addButtonPressed
    
    @objc func clearButtonPressed() {
        descriptionTextField.text = ""
        startDatePicker.date = Date()
        endDatePicker.date = Date()
    }//end clearButtonPressed
    
    //method to handle the BACK button, dismisses the NewActivityView without saving data.
    @objc func backButtonPressed() {
        //dismiss the ViewController
        self.presentingViewController?.dismiss(animated: true, completion:
            {() -> Void in

        })
    }
    
    //method to save activityList to the file
    private func saveToFile() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: activityList, requiringSecureCoding: false)
            if FileManager.default.createFile(atPath: filePath,
                                      contents: data,
                                      attributes: nil) {
                print("File \(filePath) successfully created")
            }
            else {
                print("File \(filePath) could not be created")
            }
            
        }
        catch {
            print("Error archiving data: \(error)")
        }
    }//end saveToFile
    
}//end NewActivityViewController
    


