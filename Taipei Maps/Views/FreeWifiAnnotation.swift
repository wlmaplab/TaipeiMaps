//
//  FreeWifiAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/10.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit


class FreeWifiAnnotation: TpMapAnnotation {
    
    // MARK: - Info to Attributed String
    
    func infoToAttributedString() -> NSAttributedString {
        let title = "Taipei Free 熱點"
        let agency = "\(info?["AGENCY"] as? String ?? "")"
        let address = "◎ 地址：\(info?["ADDR"] as? String ?? "")"
        let siteType = "◎ 熱點類別：\(info?["STYPE"] as? String ?? "")"
        let hotspotName = "◎ 熱點名稱：\(info?["NAME"] as? String ?? "")"
        let vendorId = "◎ 業者：\(info?["VENDOR_ID"] as? String ?? "")"
        let hotspotId = "◎ 熱點 ID：\(info?["HOTSPOT_ID"] as? String ?? "")"
        
        let textStr = "\(title)\n\(agency)\n\(address)\n\(siteType)\n\(hotspotName)\n\(vendorId)\n\(hotspotId)" as NSString
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
        
        
        // set agency
        attrStr.addAttribute(.font,
                             value: NSFont.boldSystemFont(ofSize: 17),
                             range: textStr.range(of: agency))
        
        let nameStyle = NSMutableParagraphStyle()
        nameStyle.paragraphSpacing = 12
        
        attrStr.addAttribute(.paragraphStyle,
                             value: nameStyle,
                             range: textStr.range(of: agency))
        
        
        // set field name
        for text in ["◎ 地址：", "◎ 熱點類別：", "◎ 熱點名稱：", "◎ 業者：", "◎ 熱點 ID："] {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 15),
                                 range: textStr.range(of: text))
        }
        
        return attrStr
    }
    
}

