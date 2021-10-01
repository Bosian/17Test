//
//  XXXWebAPI.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/8/11.
//

import Foundation

public struct Root: JsonDeserializeable, JsonSerializeable, PropertyMapping {

    public var result: Result = Result()

    public init()
    {
    
    }
    
    public init(result: Result)
    {
        self.result = result
    }
    
    public mutating func jsonMapping(_ jsonDictionary: JsonDictionary)
    {
        self.result = Result(jsonDictionary: jsonDictionary["result"].jsonDictionaryOrDefault)
    }

    public func propertyMapping() -> [(String?, String?)]
    {
        let mapping: [(String?, String?)] = [
            ("result", "result"),
        ]

        return mapping
    }
}

extension Root {
    public struct Result: JsonDeserializeable, JsonSerializeable, PropertyMapping {

        public var sort: String = ""
        public var limit: Int = -1
        public var offset: Bool = false
        public var count: Int = -1
        public var results: [Results] = []

        public init()
        {
        
        }
        
        public init(sort: String, limit: Int, offset: Bool, count: Int, results: [Results])
        {
            self.sort = sort
            self.limit = limit
            self.offset = offset
            self.count = count
            self.results = results
        }
        
        public mutating func jsonMapping(_ jsonDictionary: JsonDictionary)
        {
            self.sort = jsonDictionary["sort"].stringOrDefault
            self.limit = jsonDictionary["limit"].intOrDefault
            self.offset = jsonDictionary["offset"].boolOrDefault
            self.count = jsonDictionary["count"].intOrDefault
            self.results = [Results](jsonArray: jsonDictionary["results"].jsonArrayOrDefault)
        }

        public func propertyMapping() -> [(String?, String?)]
        {
            let mapping: [(String?, String?)] = [
                ("sort", "sort"),
                ("limit", "limit"),
                ("offset", "offset"),
                ("count", "count"),
                ("results", "results"),
            ]

            return mapping
        }
    }

    public struct Results: JsonDeserializeable, JsonSerializeable, PropertyMapping {

        public var fFunction＆Application: String = ""
        public var fNameEn: String = ""
        public var fPdf01ALT: String = ""
        public var fPic01URL: String = ""
        public var fVoice03URL: String = ""
        public var fPic03URL: String = ""
        public var fAlsoKnown: String = ""
        public var fPic04URL: String = ""
        public var fPic04ALT: String = ""
        public var fVoice01ALT: String = ""
        public var fFamily: String = ""
        public var fCode: String = ""
        public var fPic02URL: String = ""
        public var fPdf01URL: String = ""
        public var fVoice01URL: String = ""
        public var fNameCh: String = ""
        public var fGenus: String = ""
        public var fNameLatin: String = ""
        public var fVoice03ALT: String = ""
        public var fSummary: String = ""
        public var fBrief: String = ""
        public var fCID: String = ""
        public var fPdf02URL: String = ""
        public var fVoice02ALT: String = ""
        public var fPic03ALT: String = ""
        public var fGeo: String = ""
        public var Id: Bool = false
        public var fKeywords: String = ""
        public var fPic02ALT: String = ""
        public var fPic01ALT: String = ""
        public var fUpdate: String = ""
        public var fFeature: String = ""
        public var fVedioURL: String = ""
        public var fLocation: String = ""
        public var fVoice02URL: String = ""
        public var fPdf02ALT: String = ""

        public init()
        {
        
        }
        
        public init(fFunction＆Application: String, fNameEn: String, fPdf01ALT: String, fPic01URL: String, fVoice03URL: String, fPic03URL: String, fAlsoKnown: String, fPic04URL: String, fPic04ALT: String, fVoice01ALT: String, fFamily: String, fCode: String, fPic02URL: String, fPdf01URL: String, fVoice01URL: String, fNameCh: String, fGenus: String, fNameLatin: String, fVoice03ALT: String, fSummary: String, fBrief: String, fCID: String, fPdf02URL: String, fVoice02ALT: String, fPic03ALT: String, fGeo: String, Id: Bool, fKeywords: String, fPic02ALT: String, fPic01ALT: String, fUpdate: String, fFeature: String, fVedioURL: String, fLocation: String, fVoice02URL: String, fPdf02ALT: String)
        {
            self.fFunction＆Application = fFunction＆Application
            self.fNameEn = fNameEn
            self.fPdf01ALT = fPdf01ALT
            self.fPic01URL = fPic01URL
            self.fVoice03URL = fVoice03URL
            self.fPic03URL = fPic03URL
            self.fAlsoKnown = fAlsoKnown
            self.fPic04URL = fPic04URL
            self.fPic04ALT = fPic04ALT
            self.fVoice01ALT = fVoice01ALT
            self.fFamily = fFamily
            self.fCode = fCode
            self.fPic02URL = fPic02URL
            self.fPdf01URL = fPdf01URL
            self.fVoice01URL = fVoice01URL
            self.fNameCh = fNameCh
            self.fGenus = fGenus
            self.fNameLatin = fNameLatin
            self.fVoice03ALT = fVoice03ALT
            self.fSummary = fSummary
            self.fBrief = fBrief
            self.fCID = fCID
            self.fPdf02URL = fPdf02URL
            self.fVoice02ALT = fVoice02ALT
            self.fPic03ALT = fPic03ALT
            self.fGeo = fGeo
            self.Id = Id
            self.fKeywords = fKeywords
            self.fPic02ALT = fPic02ALT
            self.fPic01ALT = fPic01ALT
            self.fUpdate = fUpdate
            self.fFeature = fFeature
            self.fVedioURL = fVedioURL
            self.fLocation = fLocation
            self.fVoice02URL = fVoice02URL
            self.fPdf02ALT = fPdf02ALT
        }
        
        public mutating func jsonMapping(_ jsonDictionary: JsonDictionary)
        {
            self.fFunction＆Application = jsonDictionary["F_Function＆Application"].stringOrDefault
            self.fNameEn = jsonDictionary["F_Name_En"].stringOrDefault
            self.fPdf01ALT = jsonDictionary["F_pdf01_ALT"].stringOrDefault
            self.fPic01URL = jsonDictionary["F_Pic01_URL"].stringOrDefault
            self.fVoice03URL = jsonDictionary["F_Voice03_URL"].stringOrDefault
            self.fPic03URL = jsonDictionary["F_Pic03_URL"].stringOrDefault
            self.fAlsoKnown = jsonDictionary["F_AlsoKnown"].stringOrDefault
            self.fPic04URL = jsonDictionary["F_Pic04_URL"].stringOrDefault
            self.fPic04ALT = jsonDictionary["F_Pic04_ALT"].stringOrDefault
            self.fVoice01ALT = jsonDictionary["F_Voice01_ALT"].stringOrDefault
            self.fFamily = jsonDictionary["F_Family"].stringOrDefault
            self.fCode = jsonDictionary["F_Code"].stringOrDefault
            self.fPic02URL = jsonDictionary["F_Pic02_URL"].stringOrDefault
            self.fPdf01URL = jsonDictionary["F_pdf01_URL"].stringOrDefault
            self.fVoice01URL = jsonDictionary["F_Voice01_URL"].stringOrDefault
            self.fNameCh = jsonDictionary["F_Name_Ch"].stringOrDefault
            self.fGenus = jsonDictionary["F_Genus"].stringOrDefault
            self.fNameLatin = jsonDictionary["F_Name_Latin"].stringOrDefault
            self.fVoice03ALT = jsonDictionary["F_Voice03_ALT"].stringOrDefault
            self.fSummary = jsonDictionary["F_Summary"].stringOrDefault
            self.fBrief = jsonDictionary["F_Brief"].stringOrDefault
            self.fCID = jsonDictionary["F_CID"].stringOrDefault
            self.fPdf02URL = jsonDictionary["F_pdf02_URL"].stringOrDefault
            self.fVoice02ALT = jsonDictionary["F_Voice02_ALT"].stringOrDefault
            self.fPic03ALT = jsonDictionary["F_Pic03_ALT"].stringOrDefault
            self.fGeo = jsonDictionary["F_Geo"].stringOrDefault
            self.Id = jsonDictionary["_id"].boolOrDefault
            self.fKeywords = jsonDictionary["F_Keywords"].stringOrDefault
            self.fPic02ALT = jsonDictionary["F_Pic02_ALT"].stringOrDefault
            self.fPic01ALT = jsonDictionary["F_Pic01_ALT"].stringOrDefault
            self.fUpdate = jsonDictionary["F_Update"].stringOrDefault
            self.fFeature = jsonDictionary["F_Feature"].stringOrDefault
            self.fVedioURL = jsonDictionary["F_Vedio_URL"].stringOrDefault
            self.fLocation = jsonDictionary["F_Location"].stringOrDefault
            self.fVoice02URL = jsonDictionary["F_Voice02_URL"].stringOrDefault
            self.fPdf02ALT = jsonDictionary["F_pdf02_ALT"].stringOrDefault
        }

        public func propertyMapping() -> [(String?, String?)]
        {
            let mapping: [(String?, String?)] = [
                ("fFunction＆Application", "F_Function＆Application"),
                ("fNameEn", "F_Name_En"),
                ("fPdf01ALT", "F_pdf01_ALT"),
                ("fPic01URL", "F_Pic01_URL"),
                ("fVoice03URL", "F_Voice03_URL"),
                ("fPic03URL", "F_Pic03_URL"),
                ("fAlsoKnown", "F_AlsoKnown"),
                ("fPic04URL", "F_Pic04_URL"),
                ("fPic04ALT", "F_Pic04_ALT"),
                ("fVoice01ALT", "F_Voice01_ALT"),
                ("fFamily", "F_Family"),
                ("fCode", "F_Code"),
                ("fPic02URL", "F_Pic02_URL"),
                ("fPdf01URL", "F_pdf01_URL"),
                ("fVoice01URL", "F_Voice01_URL"),
                ("fNameCh", "F_Name_Ch"),
                ("fGenus", "F_Genus"),
                ("fNameLatin", "F_Name_Latin"),
                ("fVoice03ALT", "F_Voice03_ALT"),
                ("fSummary", "F_Summary"),
                ("fBrief", "F_Brief"),
                ("fCID", "F_CID"),
                ("fPdf02URL", "F_pdf02_URL"),
                ("fVoice02ALT", "F_Voice02_ALT"),
                ("fPic03ALT", "F_Pic03_ALT"),
                ("fGeo", "F_Geo"),
                ("Id", "_id"),
                ("fKeywords", "F_Keywords"),
                ("fPic02ALT", "F_Pic02_ALT"),
                ("fPic01ALT", "F_Pic01_ALT"),
                ("fUpdate", "F_Update"),
                ("fFeature", "F_Feature"),
                ("fVedioURL", "F_Vedio_URL"),
                ("fLocation", "F_Location"),
                ("fVoice02URL", "F_Voice02_URL"),
                ("fPdf02ALT", "F_pdf02_ALT"),
            ]

            return mapping
        }
    }
}
