//
//  NSDate+Comparsion.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 13/8/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

extension NSDate: Comparable { }