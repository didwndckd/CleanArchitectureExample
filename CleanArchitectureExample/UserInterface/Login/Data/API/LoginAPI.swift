//
//  LoginAPI.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Moya

enum LoginAPI {
    case getGitHubAccessToken(code: String)
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .getGitHubAccessToken: return URL(string: Constant.URL.gitHub)!
        }
    }
    
    var path: String {
        switch self {
        case .getGitHubAccessToken: return "login/oauth/access_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGitHubAccessToken: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getGitHubAccessToken(code: let code):
            let parameters = ["client_id": Constant.APIKey.gitHubClientId,
                              "client_secret": Constant.APIKey.gitHubClientSecret,
                              "code": code]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
