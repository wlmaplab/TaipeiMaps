//
//  InfoViewController.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/17.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {
    
    enum InfoCategory {
        case none
        case recycling
    }
    
    @IBOutlet var infoTextView : NSTextView!
    @IBOutlet var closeButton : NSButton!
    @IBOutlet var indicator : NSProgressIndicator!
    
    var category : InfoCategory = .none
    var recyclingInfos : Array<Dictionary<String,Any>>?
    
    
    // MARK: - viewLoad

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        setup()
        fetchData()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        // text view
        infoTextView.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        infoTextView.enclosingScrollView?.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        infoTextView.enclosingScrollView?.autohidesScrollers = true
        infoTextView.isEditable = false
        infoTextView.isSelectable = true
        infoTextView.string = ""
        
        // button
        closeButton.title = "關閉視窗"
        closeButton.font = NSFont.systemFont(ofSize: 11)
        
        // indicator
        stopIndicator()
    }
    
    
    // MARK: - Fetch
    
    func fetchData() {
        infoTextView.string = ""
        switch category {
        case .recycling:
            view.window?.title = "資源回收分類方式"
            fetchRecyclingInfoData()
        default:
            break
        }
    }
    
    func fetchRecyclingInfoData() {
        if recyclingInfos != nil && recyclingInfos!.count > 0 {
            showRecyclingInfos()
        } else {
            downloadRecyclingInfoData()
        }
    }
    
    func downloadRecyclingInfoData() {
        startIndicator()
        GarbageTruckDataset.fetchRecyclingInfo() { json in
            self.recyclingInfos = nil
            
            if let json = json,
               let result = json["result"] as? Dictionary<String,Any>,
               let results = result["results"] as? Array<Dictionary<String,Any>>
            {
                self.recyclingInfos = results
            }
            
            self.showRecyclingInfos()
            self.stopIndicator()
        }
    }
    
    
    // MARK: - Show Info
    
    func showRecyclingInfos() {
        guard let infos = self.recyclingInfos else { return }
        
        var titles = Array<String>()
        var contentStr = ""
        
        for info in infos {
            let classification = "\(info["大類別"] as? String ?? "") (\(info["子類別"] as? String ?? ""))"
            let time = "◎ 回收時間：\(info["回收時間"] as? String ?? "")"
            let help = info["說明"] as? String ?? ""
            
            titles.append(classification)
            contentStr += "\(classification)\n\(time)\n\(help)\n\n"
        }
        
        let attrStr = recyclingStringToAttributedString(content: contentStr, titles: titles)
        infoTextView.textStorage?.append(attrStr)
    }
    
    func recyclingStringToAttributedString(content: String, titles: Array<String>) -> NSAttributedString {
        let textStr = content as NSString
        let attrStr = NSMutableAttributedString(string: textStr as String)
        
        // set normal
        let normalStyle = NSMutableParagraphStyle()
        normalStyle.lineSpacing = 4
        
        attrStr.addAttribute(.font,
                             value: NSFont.systemFont(ofSize: 15),
                             range: NSRange(location: 0, length: textStr.length))
        
        attrStr.addAttribute(.paragraphStyle,
                             value: normalStyle,
                             range: NSRange(location: 0, length: textStr.length))
        
        
        // set title
        for title in titles {
            attrStr.addAttribute(.font,
                                 value: NSFont.boldSystemFont(ofSize: 17),
                                 range: textStr.range(of: title))
            
            let titleStyle = NSMutableParagraphStyle()
            titleStyle.paragraphSpacing = 8
            
            attrStr.addAttribute(.paragraphStyle,
                                 value: titleStyle,
                                 range: textStr.range(of: title))
        }
        
        return attrStr
    }
    
    
    // MARK: - Indicator
    
    func startIndicator() {
        indicator.isHidden = false
        indicator.startAnimation(nil)
    }
    
    func stopIndicator() {
        indicator.isHidden = true
        indicator.stopAnimation(nil)
    }
    
    
    // MARK: - IBAction
    
    @IBAction func pressedCloseButton(_ sender: NSButton) {
        view.window?.close()
    }
    
}
