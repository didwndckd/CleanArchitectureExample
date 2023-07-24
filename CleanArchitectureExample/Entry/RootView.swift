//
//  RootView.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appManager: AppManager
}

extension RootView {
    @ViewBuilder
    var body: some View {
        switch appManager.rootViewType {
        case .login(let viewModel):
            LoginView(viewModel: viewModel)
                .transition(.opacity.animation(.easeInOut))
        case .searchUser(let viewModel):
            SearchUserView(viewModel: viewModel)
                .transition(.opacity.animation(.easeInOut))
        }
    }
}
