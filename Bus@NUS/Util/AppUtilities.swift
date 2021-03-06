//
//  AppUtilities.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 23/7/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import UIKit

class AppUtilities: NSObject {
    class func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor{
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
