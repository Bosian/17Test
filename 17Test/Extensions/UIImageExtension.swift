//
//  UIImageExtension.swift
//  CMoneyTest
//
//  Created by 劉柏賢 on 2021/9/25.
//

import UIKit

extension UIImage {

    private static var cacheImages: [String: UIImage] = [:]

    func saveToCache(urlString: String) {
        Self.cacheImages[urlString] = self
    }
    
    static func getImageFromCache(urlString: String) -> UIImage? {
        return Self.cacheImages[urlString]
    }
}
