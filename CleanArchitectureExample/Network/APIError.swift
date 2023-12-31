//
//  APIError.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation

enum APIError: Error {
    case decodeFailure(origin: Error, data: Data)
    case unknown(origin: Error)
}
