//
//  Bus.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class Bus: NSObject {
    var name:String = ""
    var nextArrivalTime:String = ""
    
    convenience init(name:String, nextTime:String) {
        self.init()
        self.name = name
        self.nextArrivalTime = nextTime
    }
}
