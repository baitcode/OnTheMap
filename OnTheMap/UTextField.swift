//
//  UTextField.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit


class UTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpStyle()
    }
    
    func setUpStyle() {
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()]
        )
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 12, 0)
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 12, 0)
    }

}