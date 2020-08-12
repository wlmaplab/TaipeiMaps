//
//  NTpcToiletAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/12.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit


class NTpcToiletAnnotation: TpMapAnnotation {

    // MARK: - Info to Attributed String
    
    override func infoToAttributedString() -> NSAttributedString {
        let title = "新北市公廁"
        let name = "\(info?["name"] as? String ?? "")"
        let address = "◎ 地址：\(info?["address"] as? String ?? "")"
        let tel = "◎ 電話：\(info?["tel"] as? String ?? "")"
        
        let textStr = "\(title)\n\(name)\n\(address)\n\(tel)" as NSString
        let attrStr = NSMutableAttributedString(string: textStr as String)
        
        
        // set normal
        let normalStyle = NSMutableParagraphStyle()
        normalStyle.lineSpacing = 2
        
        attrStr.addAttribute(.font,
                             value: NSFont.systemFont(ofSize: 15),
                             range: NSRange(location: 0, length: textStr.length))
        
        attrStr.addAttribute(.paragraphStyle,
                             value: normalStyle,
                             range: NSRange(location: 0, length: textStr.length))
        
        
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
                             value: NSFont.boldSystemFont(ofSize: 17),
                             range: textStr.range(of: name))
        
        let nameStyle = NSMutableParagraphStyle()
        nameStyle.paragraphSpacing = 12
        
        attrStr.addAttribute(.paragraphStyle,
                             value: nameStyle,
                             range: textStr.range(of: name))
        
        
        // set field name
        for text in ["◎ 地址：", "◎ 電話："] {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 15),
                                 range: textStr.range(of: text))
        }
        
        return attrStr
    }

}
