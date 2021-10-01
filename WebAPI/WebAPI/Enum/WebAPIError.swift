//
//  WebAPIError.swift
//  WebAPI
//
//  Created by Bobson on 2017/3/7.
//  Copyright © 2017年 Bobson. All rights reserved.
//

public enum WebAPIError<TResult>: Error {

    /// 無網路
    case noInternet

    /// 無效的URL
    case invalidUrl(url: String)

    /// Server return nil
    case dataIsNil

    /// Data 無法轉換成字串
    case dataCannotConvertToString

    /// 無法Parse 資料
    case dataParseError(Error)

    case fail(TResult)
}
