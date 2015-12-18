//
//  StudentsController.swift
//  OnTheMap
//
//  Created by Ilia Batiy on 16/12/15.
//  Copyright © 2015 Ilia Batiy. All rights reserved.
//

import Foundation
import UIKit


class StudentsListController: UITableViewController {
    
    var observers: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(
            UINib(nibName: "StudentCell", bundle: nil),
            forCellReuseIdentifier: "StudentCell"
        )
    }
    
    override func viewDidAppear(animated: Bool) {
        self.observers.append(
            NotificationManager.instance.listenFor(.StudentInformationsChanged, triggers: {
                _ in
                self.refresh()
            })
        )
        self.refresh()
    }
    
    override func viewDidDisappear(animated: Bool) {
        NotificationManager.instance.silence(self.observers)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDelegate & UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformationManager.locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let location = StudentInformationManager.locations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCell") as! StudentCellView
        cell.setName(location.firstName, lastName: location.lastName)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let location = StudentInformationManager.locations[indexPath.row]
        if let url = NSURL(string: location.mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}