//
//  NTpcToiletDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/12.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 新北市公廁
class NTpcToiletDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://data.ntpc.gov.tw/api/datasets/3A43D9D0-BC7F-4F8F-9940-080005F6AC8C/json"
    
    
    // MARK: - Fetch Data
    
    class func fetch(page: Int, size: Int, callback: @escaping (Array<Dictionary<String,Any>>?) -> Void) {
        httpGET_withFetchJsonArray(URLString: "\(urlString)?page=\(page)&size=\(size)", callback: callback)
    }
}
