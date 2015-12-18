//
//  StringBuilder.swift
//  qlean
//
//  Created by Ilia Batiy on 07/12/15.
//  Copyright © 2015 qlean. All rights reserved.
//

import Foundation
import UIKit


class StringBuilder {
    
    internal var representation: NSMutableAttributedString? = nil
    internal var defaultAttributes: [String:AnyObject]!
    
    
    init(defaultAttributes: [String:AnyObject]) {
        self.defaultAttributes = defaultAttributes
    }
    
    func alterRepresentation(data: NSMutableAttributedString) {
        if let repr = self.representation {
            repr.appendAttributedString(data)
        } else {
            self.representation = data
        }
    }
    
    private func apply(text: NSMutableAttributedString, attributes: [String:AnyObject]) {
        let range = NSMakeRange(0, text.length)

        var attributesToApply: [String:AnyObject] = [:]
        
        for (key, value) in self.defaultAttributes {
            attributesToApply[key] = value
        }
        for (key, value) in attributes {
            attributesToApply[key] = value
        }
        
        for (key, value) in attributesToApply {
            text.addAttribute(key, value: value, range: range)
        }

    }
    
    func addLink(linkString: String, withText: String, attributes: [String:AnyObject]) -> StringBuilder {
        let link = NSMutableAttributedString(string: withText)
        let range = NSMakeRange(0, link.length)
      
        link.addAttribute(NSLinkAttributeName, value: NSURL(string: linkString)!, range: range)
        
        self.apply(link, attributes: attributes)
        
        self.alterRepresentation(link)
        return self
    }
    
    func addText(text: String, attributes: [String:AnyObject] = [:]) -> StringBuilder {
        let text = NSMutableAttributedString(string: text)
        self.apply(text, attributes: attributes)

        self.alterRepresentation(text)
        return self
    }
    
    func getText() -> NSMutableAttributedString {
        return self.representation ?? NSMutableAttributedString(string: "")
    }

}
