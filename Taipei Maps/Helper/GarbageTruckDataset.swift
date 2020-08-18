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
    
    // Dataset
    static let urlString = "http://www.dep-in.gov.taipei/epb/webservice/webservice.asmx/GetTrash"
    
    // Recycling Info
    static let recyclingURLString = "https://data.taipei/api/v1/dataset/5ca550ce-6fd9-4a90-b230-bddc88f1133d?scope=resourceAquire"
    
    
    
    // MARK: - Fetch Data
    
    class func fetch(callback: @escaping (String?) -> Void) {
        httpGET_withFetchXMLText(URLString: urlString, callback: callback)
    }
    
    class func fetchRecyclingInfo(callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpGET_withFetchJsonObject(URLString: recyclingURLString, callback: callback)
    }
    
}

