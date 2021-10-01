//
//  ParserProtocol.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/30.
//  Copyright © 2015年 Bobson. All rights reserved.
//

import JSONParser
import PromiseKit

/**
 * WebAPI 基底類別
 */
public protocol WebAPIProtocol {
    associatedtype TParameter: ParameterProtocol
    associatedtype TResult: ResponseModelProtocol
    associatedtype TParser: WebAPIParserProtocol

    var urlString: String { get }

    /// 預設使用Post 及 FormData QueryString的方式
    ///
    /// - Parameter parameter: parameter description
    /// - Returns: return value description
    func invokeAsync(_ parameter: TParameter) -> Promise<TResult>

}
