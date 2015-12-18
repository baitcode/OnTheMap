//
//  UTextField.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit


class UButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpStyle()
    }
    
    func setUpStyle() {
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
        
}