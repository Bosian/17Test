//
//  WebAPIJsonParserProtocol.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/30.
//  Copyright © 2015年 Bobson. All rights reserved.
//

import JSONParser

public protocol WebAPIJsonParserProtocol: WebAPIParserProtocol {
    func parseJson(_ url: URL, data: Data?, response: HTTPURLResponse?, parameter: TResult.TParameter, error: Error?) throws -> TResult
    func debugPrint(url: URL, data: Data, jsonString: String)
    func getInstance(json: String, data: Data) throws -> TResult
}

extension WebAPIJsonParserProtocol where TResult: JsonDeserializeable {
    public func getInstance(json: String, data: Data) throws -> TResult {
        return TResult.init(jsonString: json)
    }
}

extension WebAPIJsonParserProtocol where TResult: Decodable {
    public func getInstance(json: String, data: Data) throws -> TResult {
        return try JSONDecoder().decode(TResult.self, from: data)
    }
}

extension WebAPIJsonParserProtocol {
    public func parse(_ url: URL, data: Data?, response: HTTPURLResponse?, parameter: TResult.TParameter, error: Error?) throws -> TResult {
        return try parseJson(url, data: data, response: response, parameter: parameter, error: error)
    }

    public func parseJson(_ url: URL, data: Data?, response: HTTPURLResponse?, parameter: TResult.TParameter, error: Error?) throws -> TResult {
        if let error = error {
            throw error
        }

        guard let data = data else {
            print("\(url.description) is return nil from Server!\r\n\r\n")

            throw WebAPIError<TResult>.dataIsNil
        }

        guard let jsonString = String(data: data, encoding: .utf8) else
        {
            print("\(url.description) data to string fail! \r\n\r\n")
            throw WebAPIError<TResult>.dataCannotConvertToString
        }

        debugPrint(url: url, data: data, jsonString: jsonString)

        let start: DispatchTime = DispatchTime.now() // <<<<<<<<<< Start time

        let result: TResult = try getInstance(json: jsonString, data: data)

        let end: DispatchTime = DispatchTime.now()   // <<<<<<<<<<   end time
        let nanoTime: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval: TimeInterval = TimeInterval(nanoTime) / 1_000_000_000
        print("Parsing time: \(timeInterval) seconds")

        return result
    }

    public func debugPrint(url: URL, data: Data, jsonString: String) {
        
        func printURL() {
            print("result url: \(url.absoluteString)")
        }
        
        func printRaw() {
            let convertedString = jsonString.mutableCopy() as! NSMutableString
            let transform: CFString = "Any-Hex/Java" as CFString
            CFStringTransform(convertedString, nil, transform, true)
            
            print("result raw: \(convertedString.replacingOccurrences(of: "\\/", with: "/"))")
        }

        func printIfParseError() {
            do {
                guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary else {
                    return
                }
                
                guard let convertedString = "\(dictionary)".mutableCopy() as? NSMutableString else {
                    return
                }
                
                let transform: CFString = "Any-Hex/Java" as CFString
                CFStringTransform(convertedString, nil, transform, true)
            } catch let errorType {
                print("Json Parse 有錯誤: \(errorType.localizedDescription) \r\n\r\n")
            }
        }
        
        printURL()
        printRaw()
        printPrettyJson(data: data, title: "result pretty json")
        
        print("\r\n\r\n")
        
        printIfParseError()
    }
    
    public func debugPrint(url: URL, data: Data, jsonString: String, skipJsonName: String) {
        let transform: CFString = "Any-Hex/Java" as CFString
        let convertedString = jsonString.mutableCopy() as! NSMutableString
        CFStringTransform(convertedString, nil, transform, true)
        
        print("result url: \(url.absoluteString)")
        
        let regexPattern: String = """
        "\(skipJsonName)":"[^"]*"
        """
        
        let replacement: String = """
        "\(skipJsonName)":"(skip)"
        """
        
        let raw: String = convertedString.replacingOccurrences(of: "\\/", with: "/").replaceMatchString(regexPattern, replacement: replacement) ?? (convertedString as String)
        print("result raw: \(raw)\r\n\r\n")
        
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary else {
                return
            }
            
            guard let convertedString = "\(dictionary)".mutableCopy() as? NSMutableString else {
                return
            }
            
            CFStringTransform(convertedString, nil, transform, true)
        } catch let errorType {
            print("Json Parse 有錯誤: \(errorType.localizedDescription) \r\n\r\n")
        }
    }
}
