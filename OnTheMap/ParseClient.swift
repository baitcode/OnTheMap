//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 17/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import PromiseKit


class ParseClient: ApiCallable<[String:AnyObject]> {
    override func deserialize(body: String) -> [String:AnyObject]? {
        let JSONData = body.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false
        )
        
        if JSONData == nil {
            return nil
        }
        
        let deserialized = try? NSJSONSerialization.JSONObjectWithData(
            JSONData!,
            options: [.AllowFragments]
        )
        
        return deserialized as? [String:AnyObject]
    }
    
    override func getBaseURL() -> String {
        return "https://api.parse.com/1/classes"
    }
    
    override func getBaseHeaders(method: Method) -> [String : String] {
        return [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
            "Content-Type": "application/json"
        ]
    }
    
    func recievedRequestDecorator(onSuccess: [String:AnyObject]->(), _ onError: [String:AnyObject]->()) -> (Int, [String:AnyObject]?) -> () {
        return {
            status, data in
            
            if status >= 200 && status < 300 {
                onSuccess(data ?? [:])
            } else {
                onError(data ?? [:])
            }
        }
    }
    
    func recievedErrorDecorator(onError: [String:AnyObject]->()) -> ([String:AnyObject]?) -> () {
        return {
            data in
            onError(data ?? [:])
        }
    }
        
    func receivedRequestDecorator(
        onSuccess: [String:AnyObject]->(),
        _ onError: ErrorType->()) -> (Int, [String:AnyObject]?) -> ()
    {
        return {
            status, data in
            if status >= 200 && status < 300 {
                onSuccess(data ?? [:])
            } else {
                onError(ApiError.Default(message: String(data!["error"]!)))
            }
        }
    }
    
    func receivedErrorDecorator(onError: ErrorType->()) -> ([String:AnyObject]?) -> ()
    {
        return {
            data in
            onError(ApiError.Default(message: String(data!["error"]!)))
        }
    }
    
    func getStudentInformation(studentId: String? = nil) -> Promise<[String:AnyObject]>
    {
        var whereClause = "?order=-updatedAt"
        if let id = studentId {
            whereClause = "?order=-updatedAt&where={\"uniqueKey\":\"\(id)\"}"
        }
        
        whereClause = whereClause.stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLQueryAllowedCharacterSet()
        )!
        
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .GET,
                url: "/StudentLocation\(whereClause)",
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }

    func updateStudentInformation(objectId: String, data: [String:AnyObject]) -> Promise<[String:AnyObject]>
    {
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .PUT,
                url: "/StudentLocation/\(objectId)",
                parameters: data,
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }

    func createStudentInformation(data: [String:AnyObject]) -> Promise<[String:AnyObject]>
    {
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .POST,
                url: "/StudentLocation",
                parameters: data,
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }

    
}