//
//  BusExplorerViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 25/6/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class BusExplorerViewController: UITableViewController {

    let busStopTitle = ["AS7", "BIZ 2", "BTC - Oei Tiong Ham Building", "Central Library", "COM2 (CP13)", "Computer Centre", "Eusoff Hall", "Opp HSSML", "Clementi Road", "Kent Ridge MRT", "Opp Kent Ridge MRT", "LT13", "Ventus (Opp LT13)", "LT29", "NUH", "Opp NUH", "Museum", "PGP Hse No 7", "PGP Hse No 12", "Opp PGP Hse No 12", "PGP Hse No 14 & No 15", "PGPR", "Raffles Hall", "S17", "University Health Centre", "Opp University Health Centre", "Temasek Hall", "UHall", "Opp UHall", "University Town", "YIH", "Opp YIH"]
    
    let busStopId = ["AS7", "BIZ2", "BUKITTIMAH-BTC2", "CENLIB", "COM2", "COMCEN", "EUSOFF", "HSSML-OPP", "JAPSCHOOL", "KR-MRT", "KR-MRT-OPP", "LT13", "LT13-OPP", "LT29", "NUH", "NUH-OPP", "MUSEUM", "PGP7", "PGP12", "PGP12-OPP", "PGP14-15", "PGP", "RAFFLES", "S17", "STAFFCLUB", "STAFFCLUB-OPP", "TEMASEK", "UHALL", "UHALL-OPP", "UTOWN", "YIH", "YIH-OPP"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bus@NUS"
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStopId.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusStopTableViewCell", forIndexPath: indexPath) as! BusStopTableViewCell
        cell.stopName.text = busStopTitle[indexPath.row]
        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let indexPath = tableView.indexPathForSelectedRow()
        let detailViewController = segue.destinationViewController as! BusStopDetailViewController
        detailViewController.stopId = busStopId[indexPath!.row]
        detailViewController.stopName = busStopTitle[indexPath!.row]
    }

}
