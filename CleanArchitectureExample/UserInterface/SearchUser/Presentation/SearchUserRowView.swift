//
//  SearchUserRowView.swift
//  CleanArchitectureExample
//
//  Created by yjc on 2023/07/24.
//

import SwiftUI
import Kingfisher

struct SearchUserRowView: View {
    let user: GitHubUser
}

extension SearchUserRowView {
    var body: some View {
        HStack {
            KFImage(URL(string: user.profileImageUrl))
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(25)
            
            VStack(alignment: .leading) {
                Text(user.userName)
                Text(user.gitHubPageUrl)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct SearchUserRowView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserRowView(user: GitHubUser(id: 0, userName: "didwndckd", gitHubPageUrl: "http://github.com/didwndckd", profileImageUrl: "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*"))
            .previewLayout(.fixed(width: 300, height: 50))
    }
}
