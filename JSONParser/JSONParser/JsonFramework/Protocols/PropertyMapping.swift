//
//  ParameterProtocol.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/22.
//  Copyright © 2015年 Bobson. All rights reserved.
//

public protocol PropertyMapping
{
    /**
     * (propertyName, JsonName)
     */
    func propertyMapping() -> [(String?, String?)]
}

#if DEBUG
extension PropertyMapping {
    public func testSwiftProperty(mirrorChildren: AnyCollection<Mirror.Child>) {
        
        let mappings = propertyMapping()
        
        for (swiftName, _) in mappings {

            let isContains: Bool = mirrorChildren.contains(where: { (label, _) -> Bool in
                return swiftName == label
            })
            
            if !isContains {

                let swiftName: String = swiftName ?? ""
                let errorMessage: String = "Swift name \"\(swiftName)\" is not correct in property mapping"
                print(errorMessage)

                assert(false)
            }
        }
    }
}
#endif
