//
//  MainViewController.swift
//  ActivityTracker
//
//  Created by Brian Klein on 12/1/19.
//  Copyright © 2019 Tim Gegg-Harrison. All rights reserved.
//

import UIKit
import SQLite3

let activityTableView: UITableView = UITableView()
var activityList = [Activity]()
var mainColor: String = "Light Gray"
var buttonColor: String = "Purple"
var uiButtonColor: UIColor = .purple
var newActivityColor: String = "Yellow"
var uiActivityColor: UIColor = .yellow
var selection: Int = -1



class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    let ACTIVITYCELL: String = "ActivityCell"
    let dirPath: String = "\(NSHomeDirectory())/tmp"
    let filePath: String = "\(NSHomeDirectory())/tmp/activity.txt"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initialize the background color here
        view.backgroundColor = UIColor.lightGray
        
        //create a label at the top of the view titled "Activity Tracker"
        let label: UILabel = UILabel(frame: CGRect(x: view.center.x-100, y: 50, width: 200, height: 50))
        label.text = "Activity Tracker"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        view.addSubview(label)
        
        //create table view and add it to the subview
        activityTableView.frame = CGRect(x: 50, y: 125, width: view.frame.width-100, height: 220)
        activityTableView.dataSource = self
        activityTableView.delegate = self
        activityTableView.backgroundColor = UIColor.white
        view.addSubview(activityTableView)
        
        //create and add buttons to the subview. Should have four buttons: ADD, EDIT, DELETE, and SETTINGS
        //ADD button
        var button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 400, width: 300, height: 50)
        button.setTitle("ADD", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(addButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        //EDIT button
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 500, width: 300, height: 50)
        button.setTitle("EDIT", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(editButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        //DELETE button
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 600, width: 300, height: 50)
        button.setTitle("DELETE", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(deleteButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        //SETTINGS button
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 700, width: 300, height: 50)
        button.setTitle("SETTINGS", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = uiButtonColor
        button.addTarget(self, action: #selector(settingsButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        createDirectory()
        restoreFromFile()
        scrollToBottom()

    }//end viewDidLoad

    //UITableViewDataSource
    func numberOfSections(in activityTableView: UITableView) -> Int {
        return 1
    }
    
    //required for UITableViewDataSource
    func tableView(_ activityTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.count
    }
    
    //required for UITableViewDataSource
    func tableView(_ activityTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activityTableView.dequeueReusableCell(withIdentifier: ACTIVITYCELL) ?? UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: ACTIVITYCELL)
        let activity: Activity
        activity = activityList[indexPath.row]
        cell.textLabel?.text = activity.activityDescription
        return cell
    }
    
    //presents an instance of the newActivityViewController when the add button is pressed
    @objc func addButtonPressed() {
        let navc: NewActivityViewController = NewActivityViewController()
        navc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        navc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(navc, animated: true, completion: {
            () -> Void in
        })
    }//end addButtonPressed

    //brings the newActivityViewController up with the information queued up from the selected activity
    @objc func editButtonPressed() {

        //this do/catch block is taken from the restoreToFile method. It is edited to take out some of the feedback output. This is here so we can ensure that the activityList matches the data saved in the file, and if the activityList doesn't exist yet it will create it.
        do {
            //tries to find the correct data in the given file path to load an Array of Activites
            if let data = FileManager.default.contents(atPath: filePath) {
                print("Retrieving data from file \(filePath)")
                activityList = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Activity] ?? [Activity]()
            }
            else {
                print("No data available in file \(filePath)")
                activityList = [Activity]()
            }
        }
        catch {
            print("Error unarchiving data: \(error)")
        }
        
        //create an instance of the NewActivityViewController here so you can set the description and date pickers before you present the view
        let navc: NewActivityViewController = NewActivityViewController()
        
        //if the selected row in activityTableView isn't empty allow editing
        if(activityTableView.indexPathForSelectedRow != nil) {
            //selection is the number of the row
//            let selection: Int = activityTableView.indexPathForSelectedRow!.row
            selection = activityTableView.indexPathForSelectedRow!.row
            //selectedActivity is the Activity in the array where the index matches the selected row
            let selectedActivity: Activity = activityList[selection]
            
            //use the selectedActivity data to set the text field and the date pickers in the NewActivityViewController
            navc.descriptionTextField.text = selectedActivity.activityDescription
            navc.startDatePicker.date = selectedActivity.startDate
            navc.endDatePicker.date = selectedActivity.endDate
            
            //remove the old activity from the array so you do not have duplicates.
//            activityList.remove(at: selection)
            
            //present the NewActivityViewController here
            navc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            navc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            present(navc, animated: true, completion: {
                () -> Void in
            })//end present
        }//end if statement
    }//end editButtonPressed
    
    //deletes the selected activity from the table view
    @objc func deleteButtonPressed() {
        //if the selected row in activityTableView isn't empty allow deletion
        if(activityTableView.indexPathForSelectedRow != nil) {
            //selection is the number of the row
            let selection: Int = activityTableView.indexPathForSelectedRow!.row
            //remove the activity from the array, save the array to the file, and reload the data to the table view
            activityList.remove(at: selection)
            saveToFile()
            activityTableView.reloadData()
        }//end if statement

    }//end deleteButtonPressed
    
    //presents an instance of the SettingsViewController when the settings button is pressed
    @objc func settingsButtonPressed() {
        let svc: SettingsViewController = SettingsViewController()
        svc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        svc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        present(svc, animated: true, completion: {
            () -> Void in
        })
    }//end settingsButtonPressed
    
    //prints the direct file path
    private func displayDirectory() {
        print("Absolute path for Home Directory: \(NSHomeDirectory())")
        if let dirEnumerator = FileManager.default.enumerator(atPath: NSHomeDirectory()) {
            while let currentPath = dirEnumerator.nextObject() as? String {
                print(currentPath)
            }
        }
    }//end displayDirectory

    //tries to create a file at the given file path to save data to, it will print the file path after the file is created
    private func createDirectory() {
        print("Before directory is created...")
        displayDirectory()
        var isDir: ObjCBool = true
        if FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDir) {
            if isDir.boolValue {
                print("\(dirPath) exists and is a directory")
            }
            else {
                print("\(dirPath) exists and is not a directory")
            }
        }
        else {
            print("\(dirPath) does not exist")
            do {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                print("Error creating directory \(dirPath): \(error)")
            }
        }
        print("After directory is created...")
        displayDirectory()
    }//end createDirectory
    
    //saves the Array of Activities to the file in the given file path
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

    //retrieves the data from the saved file and loads it into the table view
    private func restoreFromFile() {
        do {
            //tries to find the correct data in the given file path to load an Array of Activites
            if let data = FileManager.default.contents(atPath: filePath) {
                print("Retrieving data from file \(filePath)")
                activityList = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Activity] ?? [Activity]()
            }
            else {
                print("No data available in file \(filePath)")
                activityList = [Activity]()
            }
            //reloads the data to the table view
            activityTableView.reloadData()
        }
        catch {
            print("Error unarchiving data: \(error)")
        }
    }//end restoreFromFile
    
    //deletes the saved file
    func deleteFile() {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        }
        catch {
            print("Error deleting file: \(error)")
        }
    }//end deleteFile
    
    //removes all activities from the array as well as deleting the file used to save activities, then reloads the table view to show the new blank table.
    @objc func clearActivities() {
        
        //remove all activities from the array
        activityList.removeAll()

        //delete the saved file
        deleteFile()

        //reload data for the table
        activityTableView.reloadData()
    }//end clearActivities
    
    @objc func changeButtonColor() {
        if (uiButtonColor == .purple) {
            uiButtonColor = .orange
            buttonColor = "Orange"
        } else if (uiButtonColor == .orange) {
            uiButtonColor = .white
            buttonColor = "White"
        } else if (uiButtonColor == .white) {
            uiButtonColor = .cyan
            buttonColor = "Cyan"
        } else {
            uiButtonColor = .purple
            buttonColor = "Purple"
        }
        viewDidLoad()
    }//end changeButtonColors
    
    //method to rotate through a set of background colors for the Main Screen
    // Gray->Green->Yellow->Blue->Repeat
    @objc func changeMainColor() {
        if (view.backgroundColor == .blue) {
            view.backgroundColor = .lightGray
            mainColor = "Light Gray"
        } else if (view.backgroundColor == .lightGray) {
            view.backgroundColor = .green
            mainColor = "Green"
        } else if (view.backgroundColor == .green) {
            view.backgroundColor = .yellow
            mainColor = "Yellow"
        } else {
            view.backgroundColor = .blue
            mainColor = "Blue"
        }
    }//end changeMainColor
    
    //function to scroll to the bottom of the tableview
    func scrollToBottom() {
        if(activityTableView.numberOfRows(inSection: 0) > 0) {
            let indexPath = NSIndexPath(row: activityList.count-1, section: 0)
            activityTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: false)
        }//end if statement
    }//end scrollToBottom
}

//template for an Activity Object that needs a description, a startDate, and an endDate
class Activity: NSObject, NSCoding {
    
    //variables for encoding to and from a file
    let TNDESCRIPTION: String = "Activity Description"
    let TNSTART: String = "Activity Start Date"
    let TNEND: String = "Activity End Date"
    
    //instance variables
    let activityDescription: String
    var startDate: Date
    var endDate: Date
    
    //constructor
    init(description: String, start: Date, end: Date){
        self.activityDescription = description
        self.startDate = start
        self.endDate = end
    }
    
    //constructor to build an Activity Object from a file
    required init(coder aDecoder: NSCoder) {
        activityDescription = aDecoder.decodeObject(forKey: TNDESCRIPTION) as! String
        startDate = aDecoder.decodeObject(forKey: TNSTART) as! Date
        endDate = aDecoder.decodeObject(forKey: TNEND) as! Date

    }
    
    //encodes the Activity Object to a file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(activityDescription, forKey: TNDESCRIPTION)
        aCoder.encode(startDate, forKey: TNSTART)
        aCoder.encode(endDate, forKey: TNEND)
    }
}

