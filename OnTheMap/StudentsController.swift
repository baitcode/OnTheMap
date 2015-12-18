//
//  StudentsController.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SwiftSpinner

class StudentsController: UITabBarController {
    
    func loadLocations() {
        StudentInformationManager.instance.loadList().error({
            error in
            UAlerts.show(.Error, at: self, withTextFrom: error as! ApiError)
        })
    }
    
    override func viewDidLoad() {
        self.loadLocations()
    }
    
    @IBAction func logOutButtonClicked(sender: AnyObject) {
        SwiftSpinner.show("Going offline...")

        when(UserManager.instance.logout(), FB.logout())
            .then({
                _ in
                self.dismissViewControllerAnimated(true, completion: nil)
            }).always({
                _ in
                SwiftSpinner.hide()
            })
    }
    
    @IBAction func refreshButtonClicked(sender: AnyObject) {
        self.loadLocations()
    }
    
    @IBAction func pushInformationButtonClicked(sender: AnyObject) {
    
    }

}