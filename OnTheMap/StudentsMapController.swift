//
//  StudentsMapController.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class LocationAnnotation: MKPointAnnotation {
    var location: StudentInformation
    
    init(location: StudentInformation) {
        self.location = location
    }
    
}


class StudentsMapController: UIViewController, MKMapViewDelegate {

    class InfoButton: UIButton {
        var location: StudentInformation?
        
        convenience init(location: StudentInformation, type: UIButtonType) {
            self.init()
            self.init(type: type)
            self.location = location
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }

    
    @IBOutlet weak var mapView: MKMapView!

    var observers: [AnyObject] = []
    var refreshDataNeeded = true
    var isVisible = false
    var targets: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observers.append(
            NotificationManager.instance.listenFor(.StudentInformationsChanged, triggers: {
                _ in
                self.refreshDataNeeded = true
                if self.isVisible {
                    self.refresh()
                }
            })
        )
        
        self.mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        self.isVisible = true

        if self.refreshDataNeeded {
            self.refresh()
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)

        self.isVisible = false
    }

    deinit {
        NotificationManager.instance.silence(self.observers)
    }
    
    func clicked(sender: InfoButton) {
        if let url = NSURL(string: sender.location!.mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    func clickedOutside(sender: InfoButton) {
        (sender.superview as? MKAnnotationView)?.hidden = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let locationAnnotation = annotation as! LocationAnnotation
        let location = locationAnnotation.location
        
        let pinAnnotation = MKPinAnnotationView(
            annotation: locationAnnotation,
            reuseIdentifier: "pinAnnotation"
        )
        pinAnnotation.animatesDrop = true
        pinAnnotation.canShowCallout = true
        
        let button = InfoButton(location: location, type: .DetailDisclosure)
        pinAnnotation.rightCalloutAccessoryView = button
        
        button.addTarget(
            self,
            action: "clicked:",
            forControlEvents: .TouchUpInside
        )
        button.addTarget(
            self,
            action: "clickedOutside:",
            forControlEvents: .TouchUpOutside
        )
        return pinAnnotation
    }
    
    func refresh() {
        self.refreshDataNeeded = false
        self.targets = []
        
        var annotations: [LocationAnnotation] = []
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        for location in StudentInformationManager.locations {
            
            let annotation = LocationAnnotation(location: location)
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            )
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        
    }
    
}
