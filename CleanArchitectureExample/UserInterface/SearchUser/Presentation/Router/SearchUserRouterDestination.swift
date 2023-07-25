//
//  SearchUserRouterDestination.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/25.
//

import SwiftUI

enum SearchUserRouterDestination {
    case safari(URL)
}

extension SearchUserRouterDestination: RouterDestination {
    var transitionStyle: RouterTransitionStyle {
        switch self {
        case .safari:
            return .fullScreenCover
        }
    }
    
    var view: some View {
        switch self {
        case .safari(let url):
            return SafariView(url: url)
        }
    }
}
