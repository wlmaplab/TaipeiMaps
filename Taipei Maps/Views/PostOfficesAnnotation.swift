//
//  PostOfficesAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/18.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit


class PostOfficesAnnotation: TpMapAnnotation {

    // MARK: - Info to Attributed String
    
    override func infoToAttributedString() -> NSAttributedString {
        let title = "郵局營業據點"
        let name = "\(info?["局名"] as? String ?? "") (\(info?["電腦局名"] as? String ?? ""))"
        let address  = "◎ 地址：\(info?["縣市"] as? String ?? "")\(info?["鄉鎮市區"] as? String ?? "")\(info?["地址"] as? String ?? "")"
        
        let tel1 = "◎ 儲匯電話：\(info?["儲匯電話"] as? String ?? "")"
        let tel2 = "◎ 郵務電話：\(info?["郵務電話"] as? String ?? "")"
        let fax  = "◎ 郵務傳真：\(info?["郵務傳真"] as? String ?? "")"
        
        let textStr = "\(title)\n\(name)\n\(address)\n\(tel1)\n\(tel2)\n\(fax)" as NSString
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
        for text in ["◎ 地址：", "◎ 儲匯電話：", "◎ 郵務電話：", "◎ 郵務傳真："] {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 15),
                                 range: textStr.range(of: text))
        }
        
        return attrStr
    }
    
}
