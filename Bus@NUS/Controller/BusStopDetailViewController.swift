//
//  BusStopDetailViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class BusStopDetailViewController: UITableViewController, BusApiHelperDelegate {
    
    var stopId:String = ""
    var stopName:String = ""
    
    var stop:BusStop?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stopName
        BusApiHelper.setDelegate(self)
        BusApiHelper.get(stopId, stopName: stopName)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stop != nil {
            return stop!.busArray.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NextBusTableViewCell", forIndexPath: indexPath) as! NextBusTableViewCell
        
        if self.stop != nil {
            let bus = self.stop!.busArray[indexPath.row]
            cell.busName.text = bus.name
            cell.arrivalTime.text = bus.nextArrivalTime
        }
        
        return cell
    }
    
    // MARK: - BusApiHelperDelegate
    func getBusDataForStop(stop:BusStop) {
        self.stop = stop
        self.tableView.reloadData()
    }
}
