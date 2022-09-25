//
//  LoginViewModel.swift
//  Calender
//
//  Created by Yilei Huang on 2021-08-24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Firebase

class AppleLoginVM: ObservableObject {
    @Published var nonce = ""
    @AppStorage("log_status") var log_Status = false
    @EnvironmentObject var homeVM:HomeViewModel
    func authenticate(credential:ASAuthorizationAppleIDCredential,completion:@escaping(Bool)->Void){
        //getting token..
        guard let token = credential.identityToken else{
            print("error with firebase")
            return
        }

        guard let tokenString = String(data:token,encoding: .utf8) else{
            print("error with Token")
            return
        }
        let fireabseCrediential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString,rawNonce: nonce)
        Auth.auth().signIn(with: fireabseCrediential) { [self] res, err in
            if let err = err{
                print(err.localizedDescription)
                return
            }
            //User Successfully Logged into Firebase
            print("Logged IN Sucess")
            FireBase.shared.isExist {res in
                if res{
                    log_Status = true
                    completion(false)
//                    withAnimation{
//                        self.log_Status = true
//                    }
                }else{
                    FireBase.shared.addUser(type: .apple, uid: Auth.auth().currentUser!.uid){
                        log_Status = true
                        completion(true)
//                        withAnimation{
//                            self.log_Status = true
//                            self.first_login = true
//                        }
                    }
                }
            }
        }

    }

    
}


func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()

    return hashString
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
            }
            return random
        }

        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }

            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }

    return result
}
