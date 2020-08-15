//
//  MyXMLReader.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/15.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


class MyXMLReader: NSObject, XMLParserDelegate {
    
    var currentTag = ""
    var currentItem : Dictionary<String,String>!
    
    var itemTagName = ""
    var itemFieldNames = Array<String>()
    var itemList = Array<Dictionary<String,String>>()
    
    
    // MARK: - Read XML Data
    
    func read(data: Data, tagName: String, fieldNames:Array<String>) -> Array<Dictionary<String,String>> {
        itemList.removeAll()
        itemFieldNames.removeAll()
        itemFieldNames.append(contentsOf: fieldNames)
        itemTagName = tagName
        
        let xml = XMLParser(data: data)
        xml.delegate = self
        xml.parse()
        
        print(">> XML parse done!")
        
        return itemList
    }
    
    // MARK: - XMLParser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:])
    {
        currentTag = elementName
        if elementName == itemTagName {
            //print("------- \(itemTagName) -------")
            
            // create a Item
            currentItem = Dictionary<String,String>()
            for field in itemFieldNames {
                currentItem[field] = ""
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if itemFieldNames.contains(currentTag) {
            currentItem[currentTag] = (currentItem[currentTag] ?? "") + str
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == itemTagName {
            /*
            for (key, value) in currentItem {
                print("\(key): \(value)")
            }
            print("------------- end -------------\n")
             */
            
            
            // add to itemList
            itemList.append(currentItem)
        }
    }
    
}
