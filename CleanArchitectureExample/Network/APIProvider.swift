//
//  APIProvider.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import Combine

import CombineMoya
import Moya

final class APIProvider<Target: TargetType>: MoyaProvider<Target> {
    func request<DecodeType: Decodable>(_ target: Target, callbackQueue: DispatchQueue? = nil, decodeType: DecodeType.Type) -> some Publisher<DecodeType, APIError> {
        return requestPublisher(target, callbackQueue: callbackQueue)
            .mapError { moyaError in
                return APIError.unknown(origin: moyaError)
            }
            .map { $0.data }
            .decode(type: DecodeType.self, decoder: JSONDecoder())
            .mapError { moyaError in
                return APIError.decodeFailure(origin: moyaError)
            }
    }
}
