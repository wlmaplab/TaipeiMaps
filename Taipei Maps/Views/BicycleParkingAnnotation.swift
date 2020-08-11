//
//  BicycleParkingAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/11.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit


class BicycleParkingAnnotation: TpMapAnnotation {

    // MARK: - Info to Attributed String
    
    func infoToAttributedString() -> NSAttributedString {
        let title = "自行車停放區"
        var byRoad = "自行車-停放區"
        if let str = info?["BYROAD"] as? String, str != "NULL", str != "null" {
            byRoad = str
        }
        
        let textStr = "\(title)\n\(byRoad)" as NSString
        let attrStr = NSMutableAttributedString(string: textStr as String)
        
        // set title
        attrStr.addAttribute(.font,
                             value: NSFont.boldSystemFont(ofSize: 20),
                             range: textStr.range(of: title))
        
        attrStr.addAttribute(.foregroundColor,
                             value: NSColor.systemBlue,
                             range: textStr.range(of: title))
        
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.paragraphSpacing = 8
        
        attrStr.addAttribute(.paragraphStyle,
                             value: titleStyle,
                             range: textStr.range(of: title))
        
        
        // set byRoad
        attrStr.addAttribute(.font,
                             value: NSFont.boldSystemFont(ofSize: 17),
                             range: textStr.range(of: byRoad))
        
        return attrStr
    }
    
}
