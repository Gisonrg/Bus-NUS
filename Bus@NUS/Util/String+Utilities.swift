//
//  String+Utilities.swift
//  Bus@NUS
//
//  Created by Jiang Sheng on 3/8/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation

extension String {
    
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}