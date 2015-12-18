//
//  Models.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import PromiseKit


func makeDateFormatter(format: String) -> NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = format
    return formatter
}


struct StudentInformation {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    var createdAt: NSDate
    var updatedAt: NSDate
    
    static var dateFormatter = makeDateFormatter("yyyy-MM-dd'T'HH:mm:ss.SSSZ")

    
    init(data: [String:AnyObject]) {
        self.objectId = data["objectId"] as! String
        self.uniqueKey = data["uniqueKey"] as! String
        self.firstName = data["firstName"] as! String
        self.lastName = data["lastName"] as! String
        self.mapString = data["mapString"] as! String
        self.mediaURL = data["mediaURL"] as! String
        self.createdAt = StudentInformation.dateFormatter.dateFromString(data["createdAt"] as! String)!
        self.updatedAt = StudentInformation.dateFormatter.dateFromString(data["updatedAt"] as! String)!
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
    }
    
    func toDict() -> [String:AnyObject] {
        return [
            "objectId": self.objectId,
            "uniqueKey": self.uniqueKey,
            "firstName": self.firstName,
            "lastName": self.lastName,
            "mapString": self.mapString,
            "mediaURL": self.mediaURL,
            "createdAt": self.createdAt,
            "updatedAt": self.updatedAt,
            "latitude": self.latitude,
            "longitude": self.longitude
        ]
    }
}


class StudentInformationManager {
    static let instance = StudentInformationManager()
    static let client = ParseClient()
    static var locations: [StudentInformation] = []
    static let uniqueId = "b8iug6"
    
    func loadList() -> Promise<[StudentInformation]> {
        return StudentInformationManager.client.getStudentInformation().then({
            locationDatas in
            
            var results: [StudentInformation] = []
            
            if let locations = locationDatas["results"] as? [[String:AnyObject]] {
                for data in locations {
                    results.append(StudentInformation(data: data))
                }
            }
            StudentInformationManager.locations = results.sort({
                a, b in
                a.updatedAt.isGreaterThanDate(b.updatedAt)
            })
                        
            return Promise(results)
        }).always({
            NotificationManager.instance.notify(.StudentInformationsChanged)
        })
    }
    
    func save(location: String, url: String, lat: Double, long: Double) -> Promise<[StudentInformation]> {
        let id = StudentInformationManager.uniqueId
        let studentPromise = StudentInformationManager.client.getStudentInformation(id)
        
        return studentPromise.then({
            locationDatas in
            let results = locationDatas["results"]!
            var data: [String:AnyObject] = [:]
            if results.count > 0 {
                var result = results[0] as! [String:AnyObject]
                
                data = [
                    "uniqueKey": result["uniqueKey"]!,
                    "firstName": result["firstName"]!,
                    "lastName": result["lastName"]!,
                    "mapString": result["mapString"]!,
                    "mediaURL": result["mediaURL"]!,
                    "latitude": result["latitude"]!,
                    "longitude": result["longitude"]!
                ]
                
                StudentInformationManager.client.updateStudentInformation(
                    result["objectId"] as! String,
                    data: data
                )
                
            } else {
                let user = UserManager.instance.currentUser!
                
                data = [
                    "uniqueKey": id,
                    "firstName": user.firstName,
                    "lastName": user.lastName,
                    "mapString": location,
                    "mediaURL": url,
                    "latitude": lat,
                    "longitude": long
                ]
                StudentInformationManager.client.createStudentInformation(data)
            }
            return self.loadList()
        })
    }
    
}












































