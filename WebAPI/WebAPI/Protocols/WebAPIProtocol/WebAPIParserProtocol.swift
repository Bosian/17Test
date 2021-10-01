//
//  WebAPIParserProtocol.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/30.
//  Copyright © 2015年 Bobson. All rights reserved.
//

import Foundation

/// Parse Json dictionary to Model
public protocol WebAPIParserProtocol {
    associatedtype TResult: ResponseModelProtocol

    init()

    func parse(_ url: URL, data: Data?, response: HTTPURLResponse?, parameter: TResult.TParameter, error: Error?) throws -> TResult

}
