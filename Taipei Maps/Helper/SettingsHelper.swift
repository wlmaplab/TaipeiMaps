//
//  SettingsHelper.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/18.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation

class SettingsHelper {
    
    private static let lastSelectedMapIdKey = "lastSelectedMapID"
    
    
    class func readLastSelectedMapID() -> String? {
        return UserDefaults.standard.string(forKey: lastSelectedMapIdKey)
    }
    
    class func saveSelectedMapID(_ mapID: String) {
        UserDefaults.standard.set(mapID, forKey: lastSelectedMapIdKey)
    }
    
}
