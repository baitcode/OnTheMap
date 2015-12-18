//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 13/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import UIKit
import SwiftSpinner


class LoginController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fldEmail: UTextField!
    @IBOutlet weak var fldPassword: UTextField!
    
    var keyboardTracker: KeyboardTrackerBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor(red: 250/255, green: 150/255, blue: 30/255, alpha: 1).CGColor,
            UIColor(red: 250/255, green: 110/255, blue: 35/255, alpha: 1).CGColor
        ]
        gradient.locations = [
            0.0,
            1.0
        ]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
        if UserManager.instance.isLoggedIn {
            self.gotoApp()
        }
        
        self.keyboardTracker = KeyboardTrackerBehavior(
            self.view,
            elementsSettings: [
                self.fldEmail: 0,
                self.fldPassword: 0,
            ]
        )
        
        self.fldEmail.delegate = self
        self.fldPassword.delegate = self
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardTracker.startTracking()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardTracker.stopTracking()
    }

    func gotoApp() {
        self.performSegueWithIdentifier("onLogin", sender: self)
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        SwiftSpinner.show("Connecting to satellite...")

        UserManager.instance.login(
            email: self.fldEmail.text!,
            password: self.fldPassword.text!
        ).then({ user in
            self.gotoApp()
        }).always({
            SwiftSpinner.hide()
        }).error({ error in
            UAlerts.show(.Error, at: self, withTextFrom: error as! ApiError)
        })
    }
    
    @IBAction func buttonSignUpClicked(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(
            NSURL(string: "https://www.udacity.com/account/auth#!/signin")!
        )
    }
    
    @IBAction func buttonSignUpThroughFacebookClicked(sender: AnyObject) {
        SwiftSpinner.show("Connecting to satellite...")
        
        FB.login(fromViewController: self).then({
            token in
            return UserManager.instance.login(token: token)
        }).then({ user in
            self.gotoApp()
        }).always({
            SwiftSpinner.hide()
        }).error({ error in
            UAlerts.show(.Error, at: self, withTextFrom: error as! ApiError)
        })
    }
    
}
