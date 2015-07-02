//
//  BusVo.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 2/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class BusVo: NSObject {
    var name:String = ""
    var nextArrivalTime:String = ""
    
    convenience init(name:String, nextTime:String) {
        self.init()
        self.name = name
        self.nextArrivalTime = nextTime
    }
    
    class func getBusVoFromBusDto(busDto:Bus) -> BusVo {
        var newBus = BusVo(name: busDto.name, nextTime: "")
        return newBus
    }
}
