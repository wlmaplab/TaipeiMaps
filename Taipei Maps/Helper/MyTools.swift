//
//  MyTools.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/10.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation

class MyTools {
    
    class func doubleFrom(string: String?) -> Double {
        if let str = string {
            let trimmingStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
            return Double(trimmingStr) ?? 0
        }
        return 0
    }
    
}
