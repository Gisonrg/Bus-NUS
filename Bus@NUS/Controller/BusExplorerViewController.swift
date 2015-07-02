//
//  BusExplorerViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 25/6/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import Foundation

class BusExplorerViewController: UITableViewController {
    
    var busStopArray:[BusStop] = [BusStop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bus@NUS"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStopArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusStopTableViewCell", forIndexPath: indexPath) as! BusStopTableViewCell
        cell.stopName.text = busStopArray[indexPath.row].name
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForSelectedRow()
        let detailViewController = segue.destinationViewController as! BusStopDetailViewController
        let selectedBusStop = busStopArray[indexPath!.row]
        detailViewController.title = selectedBusStop.name
        detailViewController.stop = selectedBusStop
    }

}
