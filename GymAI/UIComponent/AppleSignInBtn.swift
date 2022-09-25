//
//  AppleSignInBtn.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-07-03.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInBtn: View {
    @StateObject var loginData = AppleLoginVM()
    @EnvironmentObject var homeVM:HomeViewModel
    @AppStorage("log_status") var log_Status = false
    var body: some View {
        SignInWithAppleButton { (request) in
            loginData.nonce = randomNonceString()
            request.requestedScopes = [.email, .fullName]
            request.nonce = sha256(loginData.nonce)
        } onCompletion: { (result) in
            switch result{
            case .success(let user):
                print("Success")
                guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                    print("err with firebase")
                    return
                }
                
                loginData.authenticate(credential: credential){i in
                    homeVM.isLogin = true
                    if i{
                        
//                        homeVM.firstLogin = true
                    }
                }
                //do logi with Firebase
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        .signInWithAppleButtonStyle(.white)
        .frame(height:55)
        .clipShape(Capsule())
    }
}
