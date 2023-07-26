# Clean Architecture Example

> Clean architecture + MVVM + SwiftUI

Clean architecture + MVVM + SwiftUI를 사용하여 **GitHub** 로그인과 유저 검색 기능을 구현한 샘플 프로젝트입니다.

### Setting

GitHub OAuth를 사용하기 위한 `client_id`와 `client_secret`값이 필요합니다.

Public repository에 올릴 수 없는 파일은 **ignore** 처리 했기때문에 `client_id`와 `client_secret` 값이 들어있는 파일은 따로 추가가 필요합니다. 

아래 링크 안내에 따라 프로젝트를 등록하고  `Secret` 폴더를 만들고 하위에 `Constant.APIKey` 타입을 정의 해주세요.

- https://docs.github.com/ko/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app
- Authorization callback URL: didwndckdCleanArchitectureExample://login

- APIKey 정의

  ``` swift
  extension Constant {
      enum APIKey {
          static let gitHubClientId = "your client id"
          static let gitHubClientSecret = "your client secret"
      }
  }
  ```

  
