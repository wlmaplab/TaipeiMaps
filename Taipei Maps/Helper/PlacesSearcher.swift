//
//  PlacesSearcher.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2021/2/17.
//  Copyright © 2021 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit

class PlacesSearcher: NSObject, MKLocalSearchCompleterDelegate {
    
    private let completer : MKLocalSearchCompleter
    var completionHandler : (([MKLocalSearchCompletion]) -> Void)?
    
    
    // MARK: - Init
    
    override init() {
        completer = MKLocalSearchCompleter()
        super.init()
        
        completer.delegate = self
    }
    
    
    // MARK: - Functions
    
    func search(_ text: String, completionHandler: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.completionHandler = completionHandler
        completer.queryFragment = text
    }
    
    
    // MARK: - MKLocalSearchCompleterDelegate
        
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if let handler = self.completionHandler {
            handler(completer.results)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
        
        if let handler = self.completionHandler {
            handler([])
        }
    }
}
