//
//  UdacityApiClient.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import PromiseKit


class UdacityClient: ApiCallable<[String:AnyObject]> {
    
    override func deserialize(body: String) -> [String:AnyObject]? {

        let JSONData = (body as NSString)
            .substringFromIndex(5)
            .dataUsingEncoding(
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
        
        if deserialized == nil {
            return [
                "body": body
            ]
        }
        
        return deserialized as? [String:AnyObject]
    }
    
    override func getBaseURL() -> String {
        return "https://www.udacity.com"
    }

    override func getBaseHeaders(method: Method) -> [String: String] {
        switch method {
        case .POST, .PUT:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        default:
            return [:]
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
    
    func login(email email: String, password: String) -> Promise<[String:AnyObject]>
    {
        let parameters = [
            "udacity": [
                "username": email,
                "password": password
            ]
        ]
        
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .POST,
                url: "/api/session",
                parameters: parameters,
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }

    func login(facebookToken facebookToken: String) -> Promise<[String:AnyObject]>
    {
        let parameters = [
            "facebook_mobile": [
                "access_token": facebookToken
            ]
        ]
        
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .POST,
                url: "/api/session",
                parameters: parameters,
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }
    
    func logout() -> Promise<[String:AnyObject]>
    {
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        var xsrfCookie: NSHTTPCookie? = nil
        for cookie in sharedCookieStorage.cookies ?? [] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        var headers: [String:String] = [:]
        
        if let xsrfCookie = xsrfCookie {
            headers["X-XSRF-TOKEN"] = xsrfCookie.value
        }
        
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .DELETE,
                url: "/api/session",
                headers: headers,
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }
    
    func getUser(userId userId: String) -> Promise<[String:AnyObject]>
    {
        return Promise(resolvers: {
            fullfill, reject in
            self.call(
                .GET,
                url: "/api/users/\(userId)",
                onSuccess: self.receivedRequestDecorator(fullfill, reject),
                onError: self.receivedErrorDecorator(reject)
            )
        })
    }

}