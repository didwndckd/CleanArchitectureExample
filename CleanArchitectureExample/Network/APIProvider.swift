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
    func request<DecodeType: Decodable>(_ target: Target, callbackQueue: DispatchQueue? = nil, decodeType: DecodeType.Type) -> AnyPublisher<DecodeType, APIError> {
        return requestPublisher(target, callbackQueue: callbackQueue)
            .mapError { moyaError in
                return APIError.unknown(origin: moyaError)
            }
            .map { $0.data }
            .flatMap { data -> Result<DecodeType, APIError>.Publisher in
                do {
                    let result = try JSONDecoder().decode(DecodeType.self, from: data)
                    return Result.Publisher(.success(result))
                }
                catch let error {
                    let error = APIError.decodeFailure(origin: error, data: data)
                    return Result.Publisher(.failure(error))
                }
            }
            .eraseToAnyPublisher()
    }
}
