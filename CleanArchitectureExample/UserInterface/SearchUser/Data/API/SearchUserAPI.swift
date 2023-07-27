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
            guard let tokenData = AccountManager.shared.accessToken else { return nil }
            return ["Authorization": "\(tokenData.tokenType) \(tokenData.accessToken)"]
        }
    }
}

// MARK: Test
extension SearchUserAPI {
    var sampleData: Data {
        switch self {
        case .getUsers(_, _, _):
            let stringData =
            """
            {
                "total_count": 1,
                "incomplete_results": false,
                "items": [
                    {
                        "login": "didwndckd",
                        "id": 56557507,
                        "node_id": "MDQ6VXNlcjU2NTU3NTA3",
                        "avatar_url": "https://avatars.githubusercontent.com/u/56557507?v=4",
                        "gravatar_id": "",
                        "url": "https://api.github.com/users/didwndckd",
                        "html_url": "https://github.com/didwndckd",
                        "followers_url": "https://api.github.com/users/didwndckd/followers",
                        "following_url": "https://api.github.com/users/didwndckd/following{/other_user}",
                        "gists_url": "https://api.github.com/users/didwndckd/gists{/gist_id}",
                        "starred_url": "https://api.github.com/users/didwndckd/starred{/owner}{/repo}",
                        "subscriptions_url": "https://api.github.com/users/didwndckd/subscriptions",
                        "organizations_url": "https://api.github.com/users/didwndckd/orgs",
                        "repos_url": "https://api.github.com/users/didwndckd/repos",
                        "events_url": "https://api.github.com/users/didwndckd/events{/privacy}",
                        "received_events_url": "https://api.github.com/users/didwndckd/received_events",
                        "type": "User",
                        "site_admin": false,
                        "score": 1.0
                    }
                ]
            }
            """
            return stringData.data(using: .utf8)!
        }
    }
}
