//
//  ParameterProtocol.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/22.
//  Copyright © 2015年 Bobson. All rights reserved.
//

public protocol PropertyConverters
{
    func propertyConverters() -> [(String?, () -> Any?)]
}

#if DEBUG
extension PropertyConverters {
    public func testSwiftProperty(mirrorChildren: AnyCollection<Mirror.Child>) {
        
        let mappings = propertyConverters()
        
        for (swiftName, _) in mappings {
            
            let isContains: Bool = mirrorChildren.contains(where: { (label, _) -> Bool in
                return swiftName == label
            })
            
            if !isContains {
                
                let swiftName: String = swiftName ?? ""
                let errorMessage: String = "Swift name \"\(swiftName)\" is not correct in property converters"
                print(errorMessage)
                
                assert(false)
            }
        }
    }
}
#endif
