//
//  SearchUserAPI.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import Foundation
import Moya

enum SearchUserAPI {
    case getUsers(query: String, page: Int, perPage: Int)
}

extension SearchUserAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getUsers: return URL(string: Constant.URL.gitHubApi)!
        }
    }
    
    var path: String {
        switch self {
        case .getUsers: return "search/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUsers: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUsers(query: let query, page: let page, perPage: let perPage):
            let parameters: [String: Any] = ["q": query,
                                             "page": page,
                                             "per_page": perPage]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUsers:
            guard let tokenData = LoginManager.shared.accessToken else { return nil }
            return ["Authorization": "\(tokenData.tokenType) \(tokenData.accessToken)"]
        }
    }
}

