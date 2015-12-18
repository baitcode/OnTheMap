//
//  ApiClient.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 17/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit


protocol AsMessageShowable {
    func toMessageTitle() -> String
    func toMessageBody() -> String
}


enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}


enum ApiError: ErrorType, AsMessageShowable {
    func toMessageTitle() -> String {
        return "Error"
    }
    
    func toMessageBody() -> String {
        switch self {
        case Default(let message):
            return message
        default:    
            return "Unknow message happened"
        }
    }
    
    case Default(message: String)
}


class ApiCallable<DeserializedTo> {
    
    func call(
        method: Method,
        url: String,
        parameters: [String: AnyObject]? = nil,
        headers: [String: String] = [:],
        onSuccess: (Int, DeserializedTo?) -> (),
        onError: ([String:AnyObject]) -> ())
    {
            
        let baseParameters = self.getBaseParameters(method)
        let baseHeaders = self.getBaseHeaders(method)
        var mergedParameters = baseParameters
        if let parameters = parameters {
            mergedParameters = parameters.merge(with: mergedParameters ?? [:])
        }
        let mergedHeaders = headers.merge(with: baseHeaders)
        
        let fullUrl = "\(self.getBaseURL())\(url)"
        let request = NSMutableURLRequest(URL: NSURL(string: fullUrl)!)
        
        request.HTTPMethod = method.rawValue
        
        for (key, value) in mergedHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        var body: NSData? = nil
        
        if let parameters = parameters {
            switch method {
            case .PUT, .POST:
                body = try? NSJSONSerialization.dataWithJSONObject(parameters, options: .PrettyPrinted)
            default:
                body = nil
            }
            
        }
        
        if let body = body {
            request.HTTPBody = body
        }
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            
            if error != nil {
                onError([
                    "error": error!.localizedDescription
                ])
                return
            }
            
            let result = String(data: data!, encoding: NSUTF8StringEncoding)
            let statusCode = (response as! NSHTTPURLResponse).statusCode
            
            onSuccess(
                statusCode,
                self.deserialize(result!)
            )
        })
        task.resume()
    }
    
    func getBaseURL() -> String {
        return ""
    }
    
    func deserialize(body: String) -> DeserializedTo? {
        fatalError()
    }
    
    func getBaseHeaders(method: Method) -> [String:String] {
        return [:]
    }
    
    func getBaseParameters(method: Method) -> [String:AnyObject]? {
        return nil
    }
    
}
