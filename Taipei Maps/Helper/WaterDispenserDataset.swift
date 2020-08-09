//
//  WaterDispenserDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/9.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 公共飲水機
class WaterDispenserDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=52538305-ed23-490c-8f67-3efff2d777c3"
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: urlString, callback: callback)
    }
    
}

