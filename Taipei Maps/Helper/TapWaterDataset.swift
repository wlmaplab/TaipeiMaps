//
//  TapWaterDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/9.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 自來水直飲臺
class TapWaterDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.taipei/api/v1/dataset/59629791-5f4f-4c91-903b-e9ab9aa0653b?scope=resourceAquire"
    
    
    // MARK: - Fetch Data
    
    class func fetch(limit: Int, offset: Int, callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: "\(urlString)&limit=\(limit)&offset=\(offset)", callback: callback)
    }
}

