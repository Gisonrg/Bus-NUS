//
//  BusStopDetailViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class BusStopDetailViewController: UITableViewController, BusApiHelperDelegate {
    
    var stop:BusStop?
    var timeTable:Dictionary<String, String> = Dictionary<String, String>()
    
    override func viewDidLoad() {
        initTimeTable()
        BusApiHelper.setDelegate(self)
        BusApiHelper.get(stop!)
        
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentStop = stop {
            return currentStop.hasBus.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NextBusTableViewCell", forIndexPath: indexPath) as! NextBusTableViewCell

        if let currentStop = stop {
            let bus = currentStop.hasBus.objectAtIndex(indexPath.row) as! Bus
            cell.busName.text = bus.name
            cell.arrivalTime.text = timeTable[bus.name]
        }
        
        return cell
    }
    
    func setUpStop(stop:BusStop) {
        self.stop = stop
        initTimeTable()
        BusApiHelper.setDelegate(self)
        BusApiHelper.get(stop)
        self.tableView.reloadData()
    }
    
    // MARK: - BusApiHelperDelegate
    func onReceiveBusData(buses:[BusVo]) {
        for bus in buses {
            timeTable[bus.name] = bus.nextArrivalTime
        }
        self.tableView.reloadData()
    }
    
    private func initTimeTable() {
        for bus in stop!.hasBus {
            timeTable[bus.name] = "-"
        }
    }
}
