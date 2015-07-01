//
//  BusStop.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 1/7/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class BusStop: NSObject {
    var name:String = ""
    var id:String = ""
    var busArray = [Bus]()
    
    convenience init(name:String, id: String, arrayOfBus:[Bus]) {
        self.init()
        self.name = name
        self.id = id
        self.busArray = arrayOfBus
    }
}
