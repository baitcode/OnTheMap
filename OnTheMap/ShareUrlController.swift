//
//  ShareUrl.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 18/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftSpinner


class ShareUrlController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    private var placemark: CLPlacemark!
    
    @IBOutlet weak var fldUrl: UITextField!
    func prepareToShow(placemark: CLPlacemark) {
        self.placemark = placemark
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let pin = MKPlacemark(placemark: placemark)
        let span = MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
        let region = MKCoordinateRegion(
            center: pin.coordinate,
            span: span
        )
        
        self.mapView.addAnnotation(pin)
        self.mapView.region = region
        self.mapView.regionThatFits(region)
        
        self.fldUrl.delegate = self
        self.fldUrl.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.fldUrl.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelButtonClicked(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButtonClicked(sender: AnyObject) {
        SwiftSpinner.show("Saving...")

        StudentInformationManager.instance.save(
            self.placemark.name!,
            url: self.fldUrl.text!,
            lat: self.placemark.location!.coordinate.latitude,
            long: self.placemark.location!.coordinate.longitude
        ).then({
            _ in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }).always({
            _ in
            SwiftSpinner.hide()
        }).error({ error in
            UAlerts.show(.Error, at: self, withTextFrom: error as! ApiError)
        })
    }
    
}