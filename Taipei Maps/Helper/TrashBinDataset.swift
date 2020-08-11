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

    // MARK: - Dataset ID
    
    static let datasetDict = ["士林區": "97cc923a-e9ee-4adc-8c3d-335567dc15d3",
                              "大同區": "5fa14e06-018b-4851-8316-1ff324384f79",
                              "大安區": "f40cd66c-afba-4409-9289-e677b6b8d00e",
                              "中山區": "33b2c4c5-9870-4ee9-b280-a3a297c56a22",
                              "中正區": "0b544701-fb47-4fa9-90f1-15b1987da0f5",
                              "內湖區": "37eac6d1-6569-43c9-9fcf-fc676417c2cd",
                              "文山區": "46647394-d47f-4a4d-b0f0-14a60ac2aade",
                              "北投區": "05d67de9-a034-4177-9f53-10d6f79e02cf",
                              "松山區": "179d0fe1-ef31-4775-b9f0-c17b3adf0fbc",
                              "信義區": "8cbb344b-83d2-4176-9abd-d84508e7dc73",
                              "南港區": "7b955414-f460-4472-b1a8-44819f74dc86",
                              "萬華區": "5697d81f-7c9d-43fc-a202-ae8804bbd34b"]
    
    
    class func datasetCount() -> Int {
        return datasetDict.count
    }
    
    
    // MARK: - API URL String
    
    class func urlStringWith(datasetID: String) -> String {
        return "https://data.taipei/api/v1/dataset/\(datasetID)?scope=resourceAquire"
    }
    
    
    // MARK: - Fetch Data
    
    class func fetch(datasetID: String, limit: Int, offset: Int, callback: @escaping (Dictionary<String,Any>?) -> Void) {
        let urlString = urlStringWith(datasetID: datasetID)
        httpGET_withFetchJsonObject(URLString: "\(urlString)&limit=\(limit)&offset=\(offset)", callback: callback)
    }

}
