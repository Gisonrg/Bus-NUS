//
//  BusStop.swift
//  
//
//  Created by Jiang Sheng on 2/7/15.
//
//

import Foundation
import CoreData

@objc(BusStop)
class BusStop: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var hasBus: NSOrderedSet

}
