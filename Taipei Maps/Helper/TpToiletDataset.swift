//
//  TpToiletDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/12.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 台北市公廁
class TpToiletDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "http://www.dep-in.gov.taipei/epb/webservice/toilet.asmx/GetToiletData"
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (String?) -> Void) {
        httpGET_withFetchXMLText(URLString: urlString, callback: callback)
    }
}
