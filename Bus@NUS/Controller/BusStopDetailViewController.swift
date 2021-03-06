//
//  BusStopDetailViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit

class BusStopDetailViewController: UITableViewController {
    
    var stop:BusStop?
    var timeTable:Dictionary<String, String> = Dictionary<String, String>()
    
    override func viewDidLoad() {
        setUpView()
        BusApiHelper.setDelegate(self)
        BusApiHelper.get(stop!)
        super.viewDidLoad()
    }
    
    private func setUpView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reloadData:")
        initTimeTable()
        configureTitleView()
    }
    
    private func configureTitleView() {
        let busTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        busTitleLabel.text = self.navigationItem.title
        busTitleLabel.textColor = AppUtilities.UIColorFromRGB("FFA600", alpha: 1.0)
        busTitleLabel.font = UIFont(name: "JuliusSansOne-Regular", size: 20)!
        busTitleLabel.backgroundColor = UIColor.clearColor()
        busTitleLabel.textAlignment = NSTextAlignment.Center
        busTitleLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = busTitleLabel
    }
    
    private func initTimeTable() {
        for bus in stop!.hasBus {
            timeTable[bus.name] = "-"
        }
    }
    
    func setUpStop(stop:BusStop) {
        self.stop = stop
        initTimeTable()
        BusApiHelper.setDelegate(self)
        BusApiHelper.get(stop)
        self.tableView.reloadData()
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
            // hide "N.A" since it's ugly
            if timeTable[bus.name] == "N.A" {
                timeTable[bus.name] = "-"
            }
            cell.arrivalTime.text = timeTable[bus.name]
            cell.progressView.secondaryColor = UIColor.blackColor()
            cell.startLoading()
        }
        
        return cell
    }
    
    func reloadData(sender: AnyObject) {
        self.updateCells(false)
        BusApiHelper.get(stop!)
    }

}

// MARK: - BusApiHelperDelegate
extension BusStopDetailViewController : BusApiHelperDelegate {
    func onReceiveBusData(buses:[BusVo]) {
        for bus in buses {
            timeTable[bus.name] = bus.nextArrivalTime
        }
        UIView.transitionWithView(tableView,
            duration:0.35,
            options:.TransitionCrossDissolve,
            animations: {
                self.tableView.reloadData()
            },
            completion: nil)
        self.updateCells(true)
    }
    
    private func updateCells(shouldHide:Bool) {
        var cells = [NextBusTableViewCell]()
        for (var i=0;i<tableView.numberOfRowsInSection(0);i++) {
            cells.append(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! NextBusTableViewCell)
        }
        for cell in cells {
            shouldHide ? cell.hideLoading() : cell.startLoading()
        }
    }
}
