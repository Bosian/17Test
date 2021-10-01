//
//  SearchUsersWebAPI.swift
//  Zoo
//
//  Created by 劉柏賢 on 2021/10/02.
//

import JSONParser

/**
 https://docs.github.com/en/rest/reference/search#search-users
 */
public struct SearchUsersWebAPI: HttpGet {
    
    public typealias TParameter = SearchUsersParameter
    public typealias TResult = SearchUsersModel
    public typealias TParser = SearchUsersParser
    
    public let urlString: String = "https://api.github.com/search/users"
    
    public init() {
        
    }
}

public struct SearchUsersParameter: ParameterProtocol, PropertyMapping
{
    public let q: String

    /// Default is 30
    public let perPage: Int?
    
    /// start is 1
    public let page: Int?

    public init()
    {
        self.perPage = nil
        self.page = nil
        self.q = ""
    }
    
    public init(perPage: Int = 30, page: Int = 1, q: String)
    {
        self.perPage = perPage
        self.page = page
        self.q = q.encodeURL ?? ""
    }
    
    public func propertyMapping() -> [(String?, String?)] {
        return [
            ("perPage", "per_page")
        ]
    }
}

public struct SearchUsersParser: WebAPIJsonParserProtocol
{
    public typealias TResult = SearchUsersModel
    
    public init()
    {
        
    }
    
    public func parse(_ url: URL, data: Data?, response: HTTPURLResponse?, parameter: TResult.TParameter, error: Error?) throws -> TResult {
        let result = try parseJson(url, data: data, response: response, parameter: parameter, error: error)
        return result
    }
}

/*
{
    "total_count": 5,
    "items": [
        {
            "login": "Bosian",
            "avatar_url": "https://avatars.githubusercontent.com/u/9071512?v=4",
        }
    ]
}
*/
public struct SearchUsersModel: ResponseModelProtocol {
    public typealias TParameter = SearchUsersParameter
    public var response: HTTPURLResponse?
    public var responseData: Data?
    public var parameter: SearchUsersParameter?

    public var items: [Items] = []
    public let totalCount: Int
}

extension SearchUsersModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        items = try container.decode([Items].self, forKey: .items)
    }
}

extension SearchUsersModel {
    public struct Items: Decodable {
        private enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
            case login = "login"
        }

        public let avatarUrl: String
        public let login: String
    }
}

