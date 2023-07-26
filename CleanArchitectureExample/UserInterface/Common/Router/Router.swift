//
//  Router.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/25.
//

import SwiftUI

protocol Router {
    associatedtype Destination: RouterDestination
    var destination: Destination? { get set }
}

extension Router {
    var isPush: Bool {
        get {
            return destination?.transitionStyle == .push
        }
        set {
            if !newValue {
                destination = nil
            }
        }
    }
    
    var isSheet: Bool {
        get {
            return destination?.transitionStyle == .sheet
        }
        set {
            if !newValue {
                destination = nil
            }
        }
    }
    
    var isFullScreenCover: Bool {
        get {
            return destination?.transitionStyle == .fullScreenCover
        }
        set {
            if !newValue {
                destination = nil
            }
        }
    }
}

struct DefaultRouter<Destination: RouterDestination>: Router {
    var destination: Destination?
}
