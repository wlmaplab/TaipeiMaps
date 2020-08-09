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
    
    
    // MARK: - Info to Attributed String
    
    func infoToAttributedString() -> NSAttributedString {
        let title = "公共飲水機"
        let name = "\(info?["場所名稱"] as? String ?? "") (\(info?["設置地點"] as? String ?? ""))"
        let address = "◎ 地址：\(info?["場所地址"] as? String ?? "")"
        let time = "◎ 開放時間：\(info?["場所開放時間"] as? String ?? "")"
        let number = "◎ 飲水台數：\(info?["飲水台數"] as? String ?? "")"
        
        let textStr = "\(title)\n\(name)\n\(address)\n\(time)\n\(number)" as NSString
        let attrStr = NSMutableAttributedString(string: textStr as String)
        
        
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
        titleStyle.paragraphSpacing = 6
        
        attrStr.addAttribute(.paragraphStyle,
                             value: titleStyle,
                             range: textStr.range(of: title))
        
        // set name
        attrStr.addAttribute(.font,
                             value: NSFont.boldSystemFont(ofSize: 17),
                             range: textStr.range(of: name))
        
        let nameStyle = NSMutableParagraphStyle()
        nameStyle.paragraphSpacing = 9
        
        attrStr.addAttribute(.paragraphStyle,
                             value: nameStyle,
                             range: textStr.range(of: name))
        
        
        // set field name
        for text in ["◎ 地址：", "◎ 開放時間：", "◎ 飲水台數："] {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 15),
                                 range: textStr.range(of: text))
        }
        
        return attrStr
    }
    
}
