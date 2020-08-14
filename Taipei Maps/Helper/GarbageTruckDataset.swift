//
//  GarbageTruckDataset.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/14.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


// 垃圾清運點位
class GarbageTruckDataset: APIHelper {
    
    // MARK: - API URL String
    
    static let urlString = "http://www.dep-in.gov.taipei/epb/webservice/webservice.asmx/GetTrash"
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (String?) -> Void) {
        httpGET_withFetchXMLText(URLString: urlString, callback: callback)
    }
}

