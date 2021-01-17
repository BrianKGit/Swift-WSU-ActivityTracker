//
//  SettingsViewController.swift
//  ActivityTracker
//
//  Created by Klein, Brian K on 12/1/19.
//  Copyright © 2019 Klein, Brian K. All rights reserved.
//

import Foundation
import UIKit

var settingsColor: String = "Red"
var settingsBackgroundColor: UIColor = .red
var settingsButtonColor: UIColor = .purple

class SettingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = settingsBackgroundColor
        
        //create a label at the top of the view titled "Activity Tracker"
        let label: UILabel = UILabel(frame: CGRect(x: view.center.x-100, y: 50, width: 200, height: 50))
        label.text = "Settings"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        view.addSubview(label)
        
        var button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 125, width: 300, height: 50)
        button.setTitle("Main Screen Color: \(mainColor)", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = settingsButtonColor
        button.addTarget(self, action: #selector(mainColorButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 200, width: 300, height: 50)
        button.setTitle("Button Color: \(buttonColor)", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = settingsButtonColor
        button.addTarget(self, action: #selector(buttonColorButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 275, width: 300, height: 50)
        button.setTitle("New Activity Screen Color: \(newActivityColor)", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = settingsButtonColor
        button.addTarget(self, action: #selector(changeNewActivityColor), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 350, width: 300, height: 50)
        button.setTitle("Settings Screen Color: \(settingsColor)", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = settingsButtonColor
        button.addTarget(self, action: #selector(changeSettingsColor), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 425, width: 300, height: 50)
        button.setTitle("Clear Activity List", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = settingsButtonColor
        button.addTarget(self, action: #selector(clearButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
        button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = CGRect(x: view.center.x-150, y: 500, width: 300, height: 50)
        button.setTitle("Back to Main Screen", for: UIControl.State.normal)
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)
        button.backgroundColor = settingsButtonColor
        button.addTarget(self, action: #selector(backButtonPressed), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
    }
    
    @objc func mainColorButtonPressed() {
        let mvc: MainViewController = presentingViewController as! MainViewController
        mvc.changeMainColor()
        viewDidLoad()
    }
    
    @objc func buttonColorButtonPressed() {
        let mvc: MainViewController = presentingViewController as! MainViewController
        mvc.changeButtonColor()
        if (settingsButtonColor == .purple) {
            settingsButtonColor = .orange
            buttonColor = "Orange"
        } else if (settingsButtonColor == .orange) {
            settingsButtonColor = .white
            buttonColor = "White"
        } else if (settingsButtonColor == .white) {
            settingsButtonColor = .cyan
            buttonColor = "Cyan"
        } else {
            settingsButtonColor = .purple
            buttonColor = "Purple"
        }
        viewDidLoad()
    }
    
    @objc func changeNewActivityColor() {
        if (uiActivityColor == .blue) {
            uiActivityColor = .lightGray
            newActivityColor = "Light Gray"
        } else if (uiActivityColor == .lightGray) {
            uiActivityColor = .green
            newActivityColor = "Green"
        } else if (uiActivityColor == .green) {
            uiActivityColor = .yellow
            newActivityColor = "Yellow"
        } else if (uiActivityColor == .yellow) {
            uiActivityColor = .red
            newActivityColor = "Red"
        } else {
            uiActivityColor = .blue
            newActivityColor = "Blue"
        }
        viewDidLoad()
    }
    
    @objc func changeSettingsColor() {
        if (settingsBackgroundColor == .blue) {
            settingsBackgroundColor = .lightGray
            settingsColor = "Light Gray"
        } else if (settingsBackgroundColor == .lightGray) {
            settingsBackgroundColor = .green
            settingsColor = "Green"
        } else if (settingsBackgroundColor == .green) {
            settingsBackgroundColor = .yellow
            settingsColor = "Yellow"
        } else if (settingsBackgroundColor == .yellow) {
            settingsBackgroundColor = .red
            settingsColor = "Red"
        } else {
            settingsBackgroundColor = .blue
            settingsColor = "Blue"
        }
        viewDidLoad()
    }
    
    @objc func clearButtonPressed() {
        let mvc: MainViewController = presentingViewController as! MainViewController
        mvc.clearActivities()
        self.presentingViewController?.dismiss(animated: true, completion:
            {() -> Void in
            
        })
    }
    
    @objc func backButtonPressed() {
        self.presentingViewController?.dismiss(animated: true, completion:
            {() -> Void in
            
        })

    }
}
