//
//  StudentCell.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit


class StudentCellView: UITableViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    func setName(firstName: String, lastName: String) {
        self.lblName.text = "\(firstName) \(lastName)"
    }
}