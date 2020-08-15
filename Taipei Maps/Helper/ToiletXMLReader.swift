//
//  ToiletXMLReader.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/13.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


/*
struct ToiletItem {
    var region : String = ""
    var property : String = ""
    var attribute : String = ""
    var chiefOrg : String = ""
    var depName : String = ""
    var number : String = ""
    var address : String = ""
    var firstLevel : String = ""
    var secondLevel : String = ""
    var thirdLevel : String = ""
    var fourthLevel : String = ""
    var fifthLevel : String = ""
    var restroom : String = ""
    var childroom : String = ""
    var kindlyroom : String = ""
    var lng : String = ""
    var lat : String = ""
    var engName : String = ""
    var engAddress : String = ""
}*/


class ToiletXMLReader: NSObject, XMLParserDelegate {
    
    var currentTag = ""
    
    var currentRegion = ""
    var currentProperty = ""
    var currentAttribute = ""
    var currentChiefOrg = ""
    var currentDepName = ""
    var currentNumber = ""
    var currentAddress = ""
    var currentFirstLevel = ""
    var currentSecondLevel = ""
    var currentThirdLevel = ""
    var currentFourthLevel = ""
    var currentFifthLevel = ""
    var currentRestroom = ""
    var currentChildroom = ""
    var currentKindlyroom = ""
    var currentLng = ""
    var currentLat = ""
    var currentEngName = ""
    var currentEngAddress = ""
    
    var currentItem : Dictionary<String,String>!
    var itemList = Array<Dictionary<String,String>>()
    
    
    
    // MARK: - Read XML Data
    
    func read(data: Data) -> Array<Dictionary<String,String>> {
        itemList.removeAll()
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
        if elementName == "ToiletData" {
            //print("------- ToiletData -------")
            
            // clear
            currentRegion = ""
            currentProperty = ""
            currentAttribute = ""
            currentChiefOrg = ""
            currentDepName = ""
            currentNumber = ""
            currentAddress = ""
            currentFirstLevel = ""
            currentSecondLevel = ""
            currentThirdLevel = ""
            currentFourthLevel = ""
            currentFifthLevel = ""
            currentRestroom = ""
            currentChildroom = ""
            currentKindlyroom = ""
            currentLng = ""
            currentLat = ""
            currentEngName = ""
            currentEngAddress = ""
            
            // create a Item
            currentItem = Dictionary<String,String>()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch currentTag {
        case "Region":
            currentRegion += str
        case "Property":
            currentProperty += str
        case "Attribute":
            currentAttribute += str
        case "ChiefOrg":
            currentChiefOrg += str
        case "DepName":
            currentDepName += str
        case "Number":
            currentNumber += str
        case "Address":
            currentAddress += str
        case "FirstLevel":
            currentFirstLevel += str
        case "SecondLevel":
            currentSecondLevel += str
        case "ThirdLevel":
            currentThirdLevel += str
        case "FourthLevel":
            currentFourthLevel += str
        case "FifthLevel":
            currentFifthLevel += str
        case "Restroom":
            currentRestroom += str
        case "Childroom":
            currentChildroom += str
        case "Kindlyroom":
            currentKindlyroom += str
        case "Lng":
            currentLng += str
        case "Lat":
            currentLat += str
        case "EngName":
            currentEngName += str
        case "EngAddress":
            currentEngAddress += str
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "ToiletData" {
            /*
            print("Region: \(currentRegion)。")
            print("Property: \(currentProperty)。")
            print("Attribute: \(currentAttribute)。")
            print("ChiefOrg: \(currentChiefOrg)。")
            print("DepName: \(currentDepName)。")
            print("Number: \(currentNumber)。")
            print("Address: \(currentAddress)。")
            print("FirstLevel: \(currentFirstLevel)。")
            print("SecondLevel: \(currentSecondLevel)。")
            print("ThirdLevel: \(currentThirdLevel)。")
            print("FourthLevel: \(currentFourthLevel)。")
            print("FifthLevel: \(currentFifthLevel)。")
            print("Restroom: \(currentRestroom)。")
            print("Childroom: \(currentChildroom)。")
            print("Kindlyroom: \(currentKindlyroom)。")
            print("Lng: \(currentLng)。")
            print("Lat: \(currentLat)。")
            print("EngName: \(currentEngName)。")
            print("EngAddress: \(currentEngAddress)。")
            print("---------- end -----------\n")
             */
            
            
            // set currentToiletItem
            currentItem["Region"]      = currentRegion
            currentItem["Property"]    = currentProperty
            currentItem["Attribute"]   = currentAttribute
            currentItem["ChiefOrg"]    = currentChiefOrg
            currentItem["DepName"]     = currentDepName
            currentItem["Number"]      = currentNumber
            currentItem["Address"]     = currentAddress
            currentItem["FirstLevel"]  = currentFirstLevel
            currentItem["SecondLevel"] = currentSecondLevel
            currentItem["ThirdLevel"]  = currentThirdLevel
            currentItem["FourthLevel"] = currentFourthLevel
            currentItem["FifthLevel"]  = currentFifthLevel
            currentItem["Restroom"]    = currentRestroom
            currentItem["Childroom"]   = currentChildroom
            currentItem["Kindlyroom"]  = currentKindlyroom
            currentItem["Lng"]         = currentLng
            currentItem["Lat"]         = currentLat
            currentItem["EngName"]     = currentEngName
            currentItem["EngAddress"]  = currentEngAddress
            
            // add to toiletItemList
            itemList.append(currentItem)
        }
    }
    
}
