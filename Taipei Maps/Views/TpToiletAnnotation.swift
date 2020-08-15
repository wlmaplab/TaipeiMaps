//
//  TpToiletAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/13.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit


class TpToiletAnnotation: TpMapAnnotation {

    // MARK: - Item info to Attributed String

    override func infoToAttributedString() -> NSAttributedString {
        let title = "台北市公廁"
        let name = "\(info?["DepName"] as? String ?? "") (\(info?["Attribute"] as? String ?? ""))"
        let address = "◎ 地址：\(info?["Address"] as? String ?? "")"
        let property = "◎ 類別：\(info?["Property"] as? String ?? "")"
        
        let restroom = "◎ 無障礙廁所：" + optionsTextFrom(value: "\(info?["Restroom"] as? String ?? "")")
        let childroom = "◎ 親子廁間：" + optionsTextFrom(value: "\(info?["Childroom"] as? String ?? "")")
        let kindlyroom = "◎ 貼心公廁：" + optionsTextFrom(value: "\(info?["Kindlyroom"] as? String ?? "")")
        
        let number = "◎ 座數：\(info?["Number"] as? String ?? "")"
        
        let textStr = "\(title)\n\(name)\n\(address)\n\(property)\n\(restroom)\n\(childroom)\n\(kindlyroom)\n\(number)" as NSString
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
        for text in ["◎ 地址：", "◎ 類別：", "◎ 無障礙廁所：", "◎ 親子廁間：", "◎ 貼心公廁：", "◎ 座數："] {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 15),
                                 range: textStr.range(of: text))
        }
        
        return attrStr
    }

    func optionsTextFrom(value: String) -> String {
        if value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == "y" {
            return "有"
        }
        return "無"
    }
    
}
