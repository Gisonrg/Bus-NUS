//
//  BusApiHelper.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol BusApiHelperDelegate {
    func getBusDataForStop(stop:BusStop)
}

class BusApiHelper: NSObject {
    
    static let sharedInstance = BusApiHelper()
    
    private let baseUrl = "http://gisonrg.me/api/nextBus/"
    
    private var delegate:BusApiHelperDelegate?
    
    class func setDelegate(vc:BusApiHelperDelegate) {
        sharedInstance.delegate = vc
    }
    
    class func get(stopId:String, stopName:String) {
        sharedInstance.getRawDataForStopId(stopId, stopName: stopName)
    }
    
    private func getRawDataForStopId(stopId:String, stopName:String) {
        Alamofire.request(.GET, baseUrl + stopId)
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    self.delegate?.getBusDataForStop(BusStop())
                } else {
                    var json = JSON(json!)
                    var busArray = [Bus]()
                    if json["shuttles"].type == Type.Dictionary {
                        busArray.append(Bus(name: json["shuttles"]["name"].string!, nextTime: json["shuttles"]["arrivalTime"].string!))
                    } else {
                        let list: Array<JSON> = json["shuttles"].arrayValue
                        for bus in list {
                            busArray.append(Bus(name: bus["name"].string!, nextTime: bus["arrivalTime"].string!))
                        }
                    }
                    self.delegate?.getBusDataForStop(BusStop(name: stopName, id: stopId, arrayOfBus: busArray))
                }
        }
    }
}
