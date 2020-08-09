//
//  WaterDispenserAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/9.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit

class WaterDispenserAnnotation: NSObject, MKAnnotation {
    
    var coordinate : CLLocationCoordinate2D
    var image : NSImage?
    var info : Dictionary<String,Any>?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()
        self.coordinate = coordinate
    }
    
}
