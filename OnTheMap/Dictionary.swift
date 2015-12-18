//
//  Dictionary.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func toData() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self as! AnyObject)
    }

    func merge(with dict: Dictionary<Key, Value>) -> Dictionary<Key, Value> {
        var merged: Dictionary<Key, Value> = [:]
        for (key, value) in dict {
            merged[key] = value
        }
        for (key, value) in self {
            merged[key] = value
        }
        return merged
    }
}

