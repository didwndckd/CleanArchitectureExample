//
//  SearchUserView.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import SwiftUI

struct SearchUserView: View {
    @ObservedObject private var viewModel: SearchUserViewModel
    
    init(viewModel: SearchUserViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: body
extension SearchUserView {
    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                userListView
            }
            .scrollDismissesKeyboard(.immediately)
            .navigationTitle("검색")
            .toolbar {
                logoutButton
            }
            
        }
    }
}

// MARK: private
extension SearchUserView {
    private var logoutButton: some View {
        Button("Logout", action: {
            viewModel.requestLogout()
        })
    }
    
    private var searchBar: some View {
        HStack {
            searchBarPrefixView
                .padding(.horizontal, 8)
                .foregroundColor(.secondary)
            
            TextField("검색", text: $viewModel.searchKeyword)
                .padding(.vertical, 8)
                .onSubmit {
                    viewModel.requestSearchUsers()
                }
                .submitLabel(.search)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 4)
                .stroke(.secondary)
        }
        .frame(height: 24)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var searchBarPrefixView: some View {
        if viewModel.isSearchLoading {
            ProgressView()
        }
        else {
            Image(systemName: "magnifyingglass")
        }
    }
    
    private var userListView: some View {
        List {
            Section(
                content: {
                    ForEach(viewModel.users, id: \.uuid) { user in
                        Button(
                            action: {
                                viewModel.selectedUser(user)
                            },
                            label: {
                                SearchUserRowView(user: user)
                            })
                    }
                },
                footer: {
                    if viewModel.isNextPageLoading {
                        nextPageLoadingView
                    }
                    else {
                        nextPageRequestView
                    }
                })
        }
    }
    
    private var nextPageRequestView: some View {
        Rectangle()
            .frame(height: 0)
            .onAppear {
                viewModel.requestNextPageUsers()
            }
    }
    
    private var nextPageLoadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView(viewModel: SearchUserViewModel())
    }
}
