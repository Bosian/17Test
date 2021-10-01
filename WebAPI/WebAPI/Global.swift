//
//  Global.swift
//  BooKingForUser
//
//  Created by Bobson on 2017/2/16.
//  Copyright © 2017年 Bobson. All rights reserved.
//

import JSONParser

/// 只在Debug Mode輸出Print
///
/// - Parameter items: items description
func print(_ items: Any...) {
    #if DEBUG
        for item in items {
            print(item, separator: " ", terminator: "\n")
        }
    #endif
}

func printPrettyJson(data: Data?, title: String) {

    guard let data = data else {
        return
    }
    
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? JsonDictionary else {
        return
    }

    guard let prettyPrintedData = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) else {
        return
    }

    guard let prettyJson: String = String(data: prettyPrintedData, encoding: String.Encoding.utf8) else {
        return
    }


    print("\(title): \(prettyJson.replacingOccurrences(of: "\\/", with: "/"))")
}
