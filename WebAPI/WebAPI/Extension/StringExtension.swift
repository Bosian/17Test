//
//  StringExtension.swift
//  WebAPI
//
//  Created by 劉柏賢 on 2021/8/11.
//

extension String {
    
    public var url: URL? {
        return URL(string: self) ?? URL(string: self.encodeURL ?? "")
    }
    
    public var encodeURL: String? {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    
    public var decodeURL: String? {
        return self.removingPercentEncoding
    }

    /*
     * 取代符合RegEx的字串
     */
    public func replaceMatchString(_ pattern: String, replacement: String) -> String? {
        var regexUnwrapped: NSRegularExpression?
        
        do {
            regexUnwrapped = try NSRegularExpression(pattern: pattern, options: [])
        } catch let error {
            print(error)
        }
        
        guard let regex: NSRegularExpression = regexUnwrapped else {
            return nil
        }

        return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: replacement)
    }
}
