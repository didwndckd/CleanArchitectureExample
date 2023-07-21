//
//  KeyChainStorage.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation
import KeychainSwift

@propertyWrapper
struct KeyChainStorage<StoreObject: Codable> {
    private let key: String
    private let defaultValue: StoreObject
    private let keychain = KeychainSwift()
    
    init(key: String, defaultValue: StoreObject) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: StoreObject {
        get {
            guard let data = keychain.get(key)?.data(using: .utf8),
                  let result = try? JSONDecoder().decode(StoreObject.self, from: data)
            else {
                return defaultValue
            }
            
            return result
        }
        set {
            if let optionalValue = newValue as? OptionalType, optionalValue.isNil {
                keychain.delete(key)
            }
            guard let data = try? JSONEncoder().encode(newValue),
                  let stringData = String(data: data, encoding: .utf8) else {
                return
            }
            keychain.set(stringData, forKey: key)
        }
    }
    
}
