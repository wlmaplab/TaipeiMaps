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
    
    var item : ToiletItem!
    

    // MARK: - Item info to Attributed String

    override func infoToAttributedString() -> NSAttributedString {
        let title = "台北市公廁"
        let name = "\(item.depName) (\(item.attribute))"
        let address = "◎ 地址：\(item.address)"
        let property = "◎ 類別：\(item.property)"
        
        var restroom = "◎ 無障礙廁所："
        if item.restroom == "Y" || item.restroom == "y" {
            restroom += "有"
        } else {
            restroom += "無"
        }
        
        var childroom = "◎ 親子廁間："
        if item.childroom == "Y" || item.childroom == "y" {
            childroom += "有"
        } else {
            childroom += "無"
        }
        
        var kindlyroom = "◎ 貼心公廁："
        if item.kindlyroom == "Y" || item.kindlyroom == "y" {
            kindlyroom += "有"
        } else {
            kindlyroom += "無"
        }
        
        let number = "◎ 座數：\(item.number)"
        
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

}
