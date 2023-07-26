//
//  LoginView.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/21.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
}

extension LoginView {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                gitHubLogoImage
                Spacer()
                loginButton
            }
            .navigationTitle("로그인")
            .navigationBarTitleDisplayMode(.inline)
            .onOpenURL { url in
                viewModel.receiveUrl(url: url)
            }
        }
    }
}

extension LoginView {
    private var gitHubLogoImage: some View {
        Image("github")
            .resizable()
            .frame(width: 100, height: 100)
            .foregroundColor(.foregroundColor)
    }
    
    private var loginButton: some View {
        Button(
            action: {
                viewModel.requestLogin()
            },
            label: {
                HStack {
                    Spacer()
                    Text("GitHub Login")
                        .font(.headline)
                        .foregroundColor(.backgroundColor)
                        .padding(16)
                    Spacer()
                }
                .background(RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.foregroundColor))
                .padding(16)
            })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = DefaultAccountRepository()
        let useCase = DefaultAccountUseCase(repository: repository)
        LoginView(viewModel: LoginViewModel(useCase: useCase))
    }
}
