//
//  ShareEnterAddress.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 18/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class ShareEnterAddressController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var fldLocation: UITextField!
    
    private var selectedPlacemark: CLPlacemark!
    
    override func viewDidLoad() {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .Center
        
        let defaultAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 81/255, green: 137/255, blue: 180/255, alpha: 1),
            NSFontAttributeName: UIFont(name: "Roboto-Thin", size: 24)!,
            NSParagraphStyleAttributeName: paragraph
        ]
        let builder = StringBuilder(defaultAttributes: defaultAttributes)
            .addText("Where are you\n")
            .addText("studying\n", attributes: [
                NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 24)!
            ])
            .addText("today?")
        
        self.titleText.attributedText = builder.getText()
        
        self.fldLocation.delegate = self
        self.fldLocation.becomeFirstResponder()
//        self.fldLocation.text = "Moscow"
        self.selectedPlacemark = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.fldLocation.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapButtonPressed(sender: AnyObject) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(
            self.fldLocation.text!,
            completionHandler: {
                placemarks, error in
                if error != nil {
                    UAlerts.show(.Error, at: self, withText: error!.localizedDescription)
                }
                
                if let placemark = placemarks?[0] {
                    self.selectedPlacemark = placemark
                    self.performSegueWithIdentifier("gotoMap", sender: self)
                } else {
                    UAlerts.show(.Error, at: self, withText: "Nothing found")
                }
                

            }
        )
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMap" {
            let controller = segue.destinationViewController as! ShareUrlController
            controller.prepareToShow(self.selectedPlacemark)
        }
    }
    
}