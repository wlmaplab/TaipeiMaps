//
//  TapWaterAnnotation.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/10.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation
import MapKit

class TapWaterAnnotation: TpMapAnnotation {
    
    
    // MARK: - Info to Attributed String
    
    func infoToAttributedString() -> NSAttributedString {
        let title = "自來水直飲臺"
        let name = "\(info?["場所名稱"] as? String ?? "") (\(info?["設置地點"] as? String ?? ""))"
        let address = "◎ 地址：\(info?["場所地址"] as? String ?? "")"
        let serialNumber = "◎ 直飲臺編號：\(info?["直飲臺編號"] as? String ?? "")"
        let arena = "◎ 場所別：\(info?["場所別"] as? String ?? "") (\(info?["場所次分類"] as? String ?? ""))"
        let openTime = "◎ 開放時間：\(info?["場所開放時間"] as? String ?? "")"
        let state = "◎ 狀態：\(info?["狀態"] as? String ?? "")"
        let bacteriumNumber = "◎ 大腸桿菌數：\(info?["大腸桿菌數"] as? String ?? "")"
        let samplingTime = "◎ 最近採樣日期：\(info?["最近採樣日期時間"] as? String ?? "")"
        
        
        let textStr = "\(title)\n\(name)\n\(address)\n\(serialNumber)\n\(arena)\n\(openTime)\n\(state)\n\(bacteriumNumber)\n\(samplingTime)" as NSString
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
        for text in ["◎ 地址：", "◎ 直飲臺編號：", "◎ 場所別：", "◎ 開放時間：", "◎ 狀態：", "◎ 大腸桿菌數：", "◎ 最近採樣日期："] {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 15),
                                 range: textStr.range(of: text))
        }
        
        return attrStr
    }
}
