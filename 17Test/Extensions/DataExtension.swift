//
//  DataExtension.swift
//  CMoneyTest
//
//  Created by 劉柏賢 on 2021/9/25.
//

import Foundation
import UIKit

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
