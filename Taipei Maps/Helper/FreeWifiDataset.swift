//
//  FreeWifiDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/9.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// Taipei Free Wi-Fi
class FreeWifiDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.taipei/api/v1/dataset/549b3a9b-eb6c-4cb1-848b-8c238735e2db?scope=resourceAquire"
    
    
    // MARK: - Fetch Data
    
    class func fetch(limit: Int, offset: Int, callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: "\(urlString)&limit=\(limit)&offset=\(offset)", callback: callback)
    }
}
