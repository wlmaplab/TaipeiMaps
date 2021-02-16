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
    
    // CSV URL
    static let urlString = "https://data.taipei/api/getDatasetInfo/downloadResource?id=f158e1bc-8400-44c2-a93a-e09361ddb7f5&rid=52538305-ed23-490c-8f67-3efff2d777c3"
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (String?) -> Void) {
        httpGET_withFetchCSVText(charset: "big-5", URLString: urlString, callback: callback)
    }
}

