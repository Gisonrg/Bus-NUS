//
//  BusExplorerViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 25/6/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class BusExplorerViewController: UITableViewController {
    
    private let LOCATION_SERVICE_DISABLED = "Location service disabled"
    
    private let TITLE_NO_LOCATION_SERVICE = "Location service is disabled"
    private let MSG_NO_LOCATION_SERVICE = "For best experience, please check your " +
                                            "location setting, and enable location " +
                                            "service of your phone."
    
    var busStopArray:[BusStop] = [BusStop]()
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
    }
    
    private func setUpViewController() {
        self.title = "Bus@NUS"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settingButton"), style: UIBarButtonItemStyle.Plain, target: self, action: "openSetting:")
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
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
        tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    func openSetting(sender: AnyObject) {
        let aboutVC = AboutViewController.getInstance()
        // Start animation
        UIView.beginAnimations("flip", context: nil)
        self.navigationController!.pushViewController(aboutVC, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.FlipFromLeft, forView: self.navigationController!.view, cache: false)
        UIView.setAnimationDuration(0.8)
        UIView.commitAnimations()
    }
    
    // MARK: - Alert View helper
    
    func presentAlertViewWithTitle(#title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

// MARK: - Location service
extension BusExplorerViewController : CLLocationManagerDelegate {
    func setUpLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case CLAuthorizationStatus.AuthorizedAlways:
                configLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                configLocationManager(startImmediately: true)
            case .Denied:
                presentAlertViewWithTitle(title: TITLE_NO_LOCATION_SERVICE, message: MSG_NO_LOCATION_SERVICE)
                NSLog(LOCATION_SERVICE_DISABLED)
            case .NotDetermined:
                configLocationManager(startImmediately: false)
                self.locationManager.requestWhenInUseAuthorization()
            case .Restricted:
                presentAlertViewWithTitle(title: TITLE_NO_LOCATION_SERVICE, message: MSG_NO_LOCATION_SERVICE)
                NSLog(LOCATION_SERVICE_DISABLED)
            }
        }
    }
    
    func configLocationManager(#startImmediately: Bool){
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        if startImmediately{
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        setUpLocationService()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let locationArray = locations as! [CLLocation]
        if let currentLocation = locationArray.last {
            // update the user location
            userLocation = currentLocation
            // re-arrange the table by distance
            sortBusStopByDistance()
        }
    }
    
    /**
        Sort the busStop array by the distance to current location
    */
    private func sortBusStopByDistance() {
        busStopArray.sort(compareDistanceToCurrentLocation)
        tableView.reloadData()
    }
    
    private func compareDistanceToCurrentLocation(busStop1: BusStop, busStop2: BusStop) -> Bool {
        var busStopLocation1 = CLLocation(latitude: busStop1.latitude, longitude: busStop1.longitude)
        var busStopLocation2 = CLLocation(latitude: busStop2.latitude, longitude: busStop2.longitude)
        var distanceOfBusStop1 = busStopLocation1.distanceFromLocation(userLocation)
        var distanceOfBusStop2 = busStopLocation2.distanceFromLocation(userLocation)
        
        return distanceOfBusStop1 < distanceOfBusStop2
    }
}
