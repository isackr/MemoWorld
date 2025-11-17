//
//  LoginModule.swift
//  memoworld
//
//  Created by Isaac Rosas Camarillo on 15/11/25.
//

import SwiftUICore

struct LoginModule {
    static func build() -> some View {
        let loginModel = LoginModel()
        let loginViewModel = LoginViewModel(loginModel: loginModel)
        let loginView = LoginView(loginViewModel: loginViewModel)
        return loginView
    }
}
