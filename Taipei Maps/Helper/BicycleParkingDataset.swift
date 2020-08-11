//
//  BicycleParkingDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/11.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 自行車停放區
class BicycleParkingDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.taipei/api/v1/dataset/df937aac-3ec6-43bf-b54d-3cb990521ffe?scope=resourceAquire"
    
    
    // MARK: - Fetch Bicycle Parking Data
    
    class func fetch(limit: Int, offset: Int, callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: "\(urlString)&limit=\(limit)&offset=\(offset)", callback: callback)
    }
}
