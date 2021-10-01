//
//  JsonDeserializeable.swift
//  JSONParser
//
//  Created by Bobson on 2016/7/21.
//  Copyright © 2016年 Bobson. All rights reserved.
//

import Foundation

public protocol JsonDeserializeable {
    
    init(jsonDictionary: JsonDictionary)
    init(jsonString: String)
    
    init?(jsonDictionary: JsonDictionary?)
    init?(jsonString: String?)
    
    // 以下需struct各自實作
    init()
    mutating func jsonMapping(_ jsonDictionary: JsonDictionary)
    mutating func jsonMapping(_ jsonArray: JsonArray)
}

extension JsonDeserializeable
{
    public func jsonMapping(_ jsonArray: JsonArray) {
        assertionFailure("Not implemented")
    }
    
    public init(jsonDictionary: JsonDictionary) {
        self.init()
        
        jsonMapping(jsonDictionary)
    }
    
    public init?(jsonDictionary: JsonDictionary?)
    {
        guard let jsonDictionary = jsonDictionary else {
            return nil
        }
        
        self.init(jsonDictionary: jsonDictionary)
    }
    
    public init(jsonString: String) {
        
        self.init()
        
        guard let data = jsonString.data(using: String.Encoding.utf8) else {
            return
        }
        
        do
        {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            switch jsonObject {
            case let jsonDictionary as JsonDictionary:
                jsonMapping(jsonDictionary)

            case let jsonArray as JsonArray:
                jsonMapping(jsonArray)
                
            default:


                let message: String = "\r\nJson反序列化(未實作的Type): \r\n\(type(of: jsonObject))"
                assertionFailure(message)
                
                #if DEBUG
                    print(message)
                #endif
            }
        }
        catch let error
        {
            let message: String = "\r\nJson反序列化(catch error): \r\n\(error.localizedDescription)"
            assertionFailure(message)

            #if DEBUG
                print(message)
            #endif
        }
    }
    
    public init?(jsonString: String?)
    {
        guard let data = jsonString?.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        do
        {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            switch jsonObject {
            case let jsonDictionary as JsonDictionary:
                
                self.init()
                
                jsonMapping(jsonDictionary)
                
            default:
                #if DEBUG
                    print("\r\nJson反序列化(未實作的Type): \r\n\(type(of: jsonObject))")
                #endif
                
                return nil
            }
        }
        catch let error
        {
            #if DEBUG
                print("\r\nJson反序列化(catch error): \r\n\(error.localizedDescription)")
            #endif
            
            return nil
        }
    }
}

