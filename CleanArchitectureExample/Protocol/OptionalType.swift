//
//  OptionalType.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import Foundation

protocol OptionalType {
    var isNil: Bool { get }
}

extension Optional: OptionalType {
    var isNil: Bool {
        return self == nil
    }
}
