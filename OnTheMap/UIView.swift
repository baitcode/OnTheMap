//
//  UIView.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    class func createWith(xibName xibName: String) -> UIView {
        return UINib(nibName: xibName, bundle: nil)
            .instantiateWithOwner(nil, options: nil).first as! UIView
    }
    
}