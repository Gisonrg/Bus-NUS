//
//  BusExplorerViewController.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 25/6/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class BusExplorerViewController: UITableViewController, CLLocationManagerDelegate {
    
    private let LOCATION_SERVICE_DISABLED = "Location service disabled"
    
    var busStopArray:[BusStop] = [BusStop]()
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewController()
        
    }
    
    private func setUpViewController() {
        self.title = "Bus@NUS"
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    // MARK: - Location service
    func setUpLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case CLAuthorizationStatus.AuthorizedAlways:
                configLocationManager(startImmediately: true)
            case .AuthorizedWhenInUse:
                configLocationManager(startImmediately: true)
            case .Denied:
                NSLog(LOCATION_SERVICE_DISABLED)
            case .NotDetermined:
                configLocationManager(startImmediately: false)
                self.locationManager.requestWhenInUseAuthorization()
            case .Restricted:
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
            println("Long: \(currentLocation.coordinate.longitude)")
            println("Lat: \(currentLocation.coordinate.latitude)")
            
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
