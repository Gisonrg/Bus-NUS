//
//  Bus.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 2/7/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation
import CoreData

@objc(Bus)
class Bus: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var bus: BusStop

}
