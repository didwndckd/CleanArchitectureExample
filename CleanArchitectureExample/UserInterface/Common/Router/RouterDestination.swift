//
//  RouterDestination.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/25.
//

import SwiftUI

protocol RouterDestination {
    associatedtype DestinationView: View
    var view: DestinationView { get }
    var transitionStyle: RouterTransitionStyle { get }
}
