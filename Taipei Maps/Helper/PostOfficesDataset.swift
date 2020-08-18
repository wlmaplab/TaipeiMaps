//
//  PostOfficesDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/18.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 郵局營業據點
class PostOfficesDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "https://quality.data.gov.tw/dq_download_json.php?nid=5950&md5_url=21483be4e8097acbd4f1e2f24e1bb3c1"
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (Array<Dictionary<String,Any>>?) -> Void) {
        httpGET_withFetchJsonArray(URLString: urlString, callback: callback)
    }
}
