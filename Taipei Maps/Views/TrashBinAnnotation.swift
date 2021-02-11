//
//  TrashBinAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/11.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit


class TrashBinAnnotation: TpMapAnnotation {

    // MARK: - Info to Attributed String

    override func infoToAttributedString() -> NSAttributedString {
        let title = "行人清潔箱 (垃圾桶)"
        let address = "\(info?["路名"] as? String ?? "")"
        let note = "\(info?["段號及其他註明"] as? String ?? "")"
        let name = "\(address)\(note)"
        
        let textStr = "\(title)\n\(name)" as NSString
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
        
        
        // set name
        attrStr.addAttribute(.font,
                             value: NSFont.boldSystemFont(ofSize: 16),
                             range: textStr.range(of: name))
        
        return attrStr
    }

}


