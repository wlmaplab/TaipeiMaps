//
//  TpMapAnnotationView.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/10.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit

class TpMapAnnotationView: MKAnnotationView {

    var coordinate : CLLocationCoordinate2D
    var info : Dictionary<String,Any>?
    var selectedAction : ((_ coordinate: CLLocationCoordinate2D) -> Void)?
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if let action = selectedAction {
                action(coordinate)
            }
        }
    }

}
