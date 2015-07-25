//
//  BusApiHelper.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol BusApiHelperDelegate {
    func onReceiveBusData(buses:[BusVo])
}

class BusApiHelper: NSObject {
    
    static let sharedInstance = BusApiHelper()
    
    private let baseUrl = "http://gisonrg.me/api/nextBus/"
    
    private var delegate:BusApiHelperDelegate?
    
    class func setDelegate(vc:BusApiHelperDelegate) {
        sharedInstance.delegate = vc
    }
    
    class func get(stop:BusStop) {
        sharedInstance.getRawDataForStop(stop)
    }
    
    private func getRawDataForStop(stop:BusStop) {
        Alamofire.request(.GET, baseUrl + stop.id)
            .responseJSON { (request, response, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    self.delegate?.onReceiveBusData([])
                } else {
                    var json = JSON(json!)
                    var busArray = [BusVo]()
                    if json["shuttles"].type == Type.Dictionary {
                        busArray.append(BusVo(name: json["shuttles"]["name"].string!, nextTime: json["shuttles"]["arrivalTime"].string!))
                    } else {
                        let list: Array<JSON> = json["shuttles"].arrayValue
                        for bus in list {
                            busArray.append(BusVo(name: bus["name"].string!, nextTime: bus["arrivalTime"].string!))
                        }
                    }
                    self.delegate?.onReceiveBusData(busArray)
                }
            }
    }
}
