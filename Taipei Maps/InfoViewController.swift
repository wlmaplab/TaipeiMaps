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
    
    var category : InfoCategory = .none
    
    
    // MARK: - viewLoad

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.title = "資源回收分類方式"
        setup()
    }
    
    
    // MARK: - Setup
    
    func setup() {
        // text view
        infoTextView.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        infoTextView.enclosingScrollView?.backgroundColor = NSColor(white: 1.0, alpha: 0.0)
        infoTextView.enclosingScrollView?.autohidesScrollers = true
        infoTextView.isEditable = false
        infoTextView.isSelectable = true
        
        // button
        closeButton.title = "關閉視窗"
        closeButton.font = NSFont.systemFont(ofSize: 11)
    }
    
    
    // MARK: - IBAction
    
    @IBAction func pressedCloseButton(_ sender: NSButton) {
        
    }
    
}
