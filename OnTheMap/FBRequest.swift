//
//  FBRequest.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 17/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import FBSDKLoginKit


class FB {

    static var manager = FBSDKLoginManager()
    
    class func login(fromViewController controller: UIViewController) -> Promise<String> {
        return Promise<String>(resolvers: {
            fullfil, reject in
            FB.manager.logInWithReadPermissions(
                ["email"],
                fromViewController: controller,
                handler: {
                    result, error in
                    if let error = error {
                        reject(ApiError.Default(message: error.description))
                    }
                    fullfil(FBSDKAccessToken.currentAccessToken().tokenString)
                }
            )
        })
    }

    class func logout() -> Promise<String> {
        return Promise<String>(resolvers: {
            fullfil, reject in
            FB.manager.logOut()
            fullfil("")
        })
    }
}
