//
//  User.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 17/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import PromiseKit


struct User {
    var key = ""
    var firstName = ""
    var lastName = ""
}


class UserManager {
    static var instance = UserManager()
    static var client = UdacityClient()
    
    var currentUser: User? = nil
    
    private init() {}
    
    var isLoggedIn: Bool {
        get {
            return currentUser != nil
        }
    }
    
    func processLoginRequest(loginRequest: Promise<[String:AnyObject]>) -> Promise<User> {
        return loginRequest.then({
            data -> Promise<[String:AnyObject]> in
            
            let account = data["account"] as! [String:AnyObject]
            let userId = account["key"] as! String
            return UserManager.client.getUser(userId: userId)
        }).then({
            data -> Promise<User> in
            
            let user = data["user"]!
            
            let firstName = user["first_name"] as! String
            let lastName = user["last_name"] as! String
            let key = user["key"] as! String
            self.currentUser = User(
                key: key,
                firstName: firstName,
                lastName: lastName
            )
            return Promise<User>(self.currentUser!)
        })
    }
    
    func login(token token: String) -> Promise<User> {
        let loginRequest = UserManager.client.login(facebookToken: token)
        return processLoginRequest(loginRequest)
    }

    
    func login(email email: String, password: String) -> Promise<User> {
        let loginRequest = UserManager.client.login(email: email, password: password)
        return processLoginRequest(loginRequest)
    }
    
    func logout() -> Promise<[String:AnyObject]> {
        return UserManager.client.logout()
    }
    
    
}

