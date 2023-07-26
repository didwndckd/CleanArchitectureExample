//
//  View+.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/26.
//

import SwiftUI

extension View {
    func bindRouter<R: Router>(_ router: Binding<R>) -> some View {
        return self
            .navigationDestination(isPresented: router.isPush) {
                if let destination = router.destination.wrappedValue {
                    destination.view
                }
            }
            .sheet(isPresented: router.isSheet) {
                if let destination = router.destination.wrappedValue {
                    destination.view
                }
            }
            .fullScreenCover(isPresented: router.isFullScreenCover) {
                if let destination = router.destination.wrappedValue {
                    destination.view
                }
            }
    }
}

