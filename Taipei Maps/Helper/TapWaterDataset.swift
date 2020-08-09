//
//  TapWaterDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/9.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 自來水直飲台
class TapWaterDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=59629791-5f4f-4c91-903b-e9ab9aa0653b"
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: urlString, callback: callback)
    }
}

