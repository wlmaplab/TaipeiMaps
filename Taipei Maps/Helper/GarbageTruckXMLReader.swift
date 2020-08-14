//
//  GarbageTruckXMLReader.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/14.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


struct GarbageTruckItem {
    var unit : String = ""
    var title : String = ""
    var content : String = ""
    var lng : String = ""
    var lat : String = ""
    var modifyDate : String = ""
}


class GarbageTruckXMLReader: NSObject, XMLParserDelegate {

    var currentTag = ""
    
    var currentUnit = ""
    var currentTitle = ""
    var currentContent = ""
    var currentLng = ""
    var currentLat = ""
    var currentModifyDate = ""
    
    var currentGarbageTruckItem : GarbageTruckItem!
    var garbageTruckItemList = Array<GarbageTruckItem>()
    
    
    // MARK: - Read XML Data
    
    func read(data: Data) -> Array<GarbageTruckItem> {
        garbageTruckItemList.removeAll()
        let xml = XMLParser(data: data)
        xml.delegate = self
        xml.parse()
        
        print(">> XML parse done!")
        
        return garbageTruckItemList
    }
    
    
    // MARK: - XMLParser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:])
    {
        currentTag = elementName
        if elementName == "Table" {
            //print("------- GarbageTruck Item -------")
            
            // clear
            currentUnit = ""
            currentTitle = ""
            currentContent = ""
            currentLng = ""
            currentLat = ""
            currentModifyDate = ""
            
            // create a GarbageTruckItem
            currentGarbageTruckItem = GarbageTruckItem()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch currentTag {
        case "Unit":
            currentUnit += str
        case "Title":
            currentTitle += str
        case "Content":
            currentContent += str
        case "Lng":
            currentLng += str
        case "Lat":
            currentLat += str
        case "ModifyDate":
            currentModifyDate += str
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Table" {
            /*
            print("Unit: \(currentUnit)")
            print("Title: \(currentTitle)")
            print("Content: \(currentContent)")
            print("Lng: \(currentLng)")
            print("Lat: \(currentLat)")
            print("ModifyDate: \(currentModifyDate)")
            print("-------------- end --------------\n")
             */
            
            
            // set currentGarbageTruckItem
            currentGarbageTruckItem.unit = currentUnit
            currentGarbageTruckItem.title = currentTitle
            currentGarbageTruckItem.content = currentContent
            currentGarbageTruckItem.lng = currentLng
            currentGarbageTruckItem.lat = currentLat
            currentGarbageTruckItem.modifyDate = currentModifyDate
            
            // add to garbageTruckItemList
            garbageTruckItemList.append(currentGarbageTruckItem)
        }
    }
    
}
