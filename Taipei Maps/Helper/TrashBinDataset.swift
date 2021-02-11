//
//  TrashBinDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/11.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 行人清潔箱
class TrashBinDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.taipei/api/v1/dataset/807317ce-fb7b-4a85-b28e-2bfccaf59a91?scope=resourceAquire"
    
    
    // MARK: - Fetch Data
    
    class func fetch(limit: Int, offset: Int, callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: "\(urlString)&limit=\(limit)&offset=\(offset)", callback: callback)
    }
}
