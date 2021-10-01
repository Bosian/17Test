//
//  ResponseModelProtocol.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/23.
//  Copyright © 2015年 Bobson. All rights reserved.
//

import JSONParser

public protocol ResponseModelProtocol {
    associatedtype TParameter: ParameterProtocol

    var response: HTTPURLResponse? { get set }

    var responseData: Foundation.Data? { get set }

    var parameter: TParameter? { get set }

    // ====== App custom =========

    /// metadata.status is 200
    var isSuccess: Bool { get }
}

extension ResponseModelProtocol {

    // ====== App custom =========

    //// metadata.status is 200
    public var isSuccess: Bool {
        return response?.statusCode == 200
    }
}
