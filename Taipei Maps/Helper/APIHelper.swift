//
//  APIHelper.swift
//  Taipei Maps
//
//  Created by Wei-Cheng Ling on 2020/8/8.
//  Copyright © 2020 Wei-Cheng Ling. All rights reserved.
//

import Foundation


class APIHelper {
    
    // MARK: - HTTP GET
    
    
    // GET Method with fetch a Dictionary
    class func httpGET_withFetchJsonObject(URLString: String, callback: @escaping (Dictionary<String,Any>?) -> Void) {
        httpRequestWithFetchJsonObject(httpMethod: "GET", URLString: URLString, parameters: nil, callback: callback)
    }
    
    // GET Method with fetch an Array
    class func httpGET_withFetchJsonArray(URLString: String, callback: @escaping (Array<Dictionary<String,Any>>?) -> Void) {
        httpRequestWithFetchJsonArray(httpMethod: "GET", URLString: URLString, parameters: nil, callback: callback)
    }
    
    // GET Method with fetch a XML text
    class func httpGET_withFetchXMLText(URLString: String, callback: @escaping (String?) -> Void) {
        httpGET_withFetchTextContent(contentType: "text/xml",
                                     charset: "utf-8",
                                     URLString: URLString,
                                     callback: callback)
    }
    
    // GET Method with fetch a CSV text
    class func httpGET_withFetchCSVText(charset: String, URLString: String, callback: @escaping (String?) -> Void) {
        httpGET_withFetchTextContent(contentType: "text/plain",
                                     charset: charset,
                                     URLString: URLString,
                                     callback: callback)
    }
    
    
    // MARK: - HTTP Request with Method
    
    //
    // fetch Dictionary
    //
    class func httpRequestWithFetchJsonObject(httpMethod: String,
                                              URLString: String,
                                              parameters: Dictionary<String,Any>?,
                                              callback: @escaping (Dictionary<String,Any>?) -> Void)
    {
        // Create request
        let url = URL(string: URLString)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        // Header
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        // Body
        if let parameterDict = parameters {
            // parameter dict to json data
            let jsonData = try? JSONSerialization.data(withJSONObject: parameterDict)
            // insert json data to the request
            request.httpBody = jsonData
        }
        
        // Task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    callback(nil)
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    callback(responseJSON)
                } else {
                    callback(nil)
                }
            }
        }
        task.resume()
    }
    
    
    //
    // fetch Array
    //
    class func httpRequestWithFetchJsonArray(httpMethod: String,
                                             URLString: String,
                                             parameters: Dictionary<String,Any>?,
                                             callback: @escaping (Array<Dictionary<String,Any>>?) -> Void)
    {
        // Create request
        let url = URL(string: URLString)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        // Header
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        // Body
        if let parameterDict = parameters {
            // parameter dict to json data
            let jsonData = try? JSONSerialization.data(withJSONObject: parameterDict)
            // insert json data to the request
            request.httpBody = jsonData
        }
        
        // Task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    callback(nil)
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? Array<Dictionary<String,Any>> {
                    callback(responseJSON)
                } else {
                    callback(nil)
                }
            }
        }
        task.resume()
    }
    
    
    //
    // fetch Text
    //
    class func httpGET_withFetchTextContent(contentType: String,
                                            charset: String,
                                            URLString: String,
                                            callback: @escaping (String?) -> Void)
    {
        // Create request
        let url = URL(string: URLString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Header:
        request.setValue("\(contentType); charset=\(charset)", forHTTPHeaderField: "Content-Type")
        
        
        // Session and configuration
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
                
        let session = URLSession(configuration: config)
        
        // Task
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    callback(nil)
                    return
                }
                
                var text : String? = nil
                
                if charset.lowercased() == "big-5" || charset.lowercased() == "big5" {
                    let big5 = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.big5.rawValue))
                    let big5encoding = String.Encoding(rawValue: big5)
                    text = String(data: data, encoding: big5encoding)
                } else if charset.lowercased() == "utf-8" || charset.lowercased() == "utf8" {
                    text = String(decoding: data, as: UTF8.self)
                }
                
                callback(text)
            }
        }
        task.resume()
    }
}
