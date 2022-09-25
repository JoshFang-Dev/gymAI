//
//  RegisterVM.swift
//  Calender
//
//  Created by Yilei Huang on 2021-11-28.
//

import SwiftUI
import GoogleSignIn
import Firebase

class RegisterVM: ObservableObject{
    @Published var emailz:String = ""
    @Published var passwordz:String = ""
    @Published var confirmPassword:String = ""
    var name:String = ""
    
    @Published var errorMessage:String?
    @AppStorage("log_status") var log_Status = false
    func register(completion:@escaping(Bool)->Void){
        if confirmPassword != passwordz{
            print("not equal")
        }else{
            Auth.auth().createUser(withEmail: self.emailz, password: self.passwordz) { (result, err) in
                if let err = err{
                    self.errorMessage = err.localizedDescription
                    print(err.localizedDescription)
                    completion(false)
                }else{
                    FireBase.shared.addUser(type: .email, uid: Auth.auth().currentUser!.uid,password:self.passwordz){
                        
                        completion(true)
                    }
                    
                }
            }
        }
    }
    func isValid()->Bool{
        if confirmPassword == passwordz{
            return true
        }else{
            return false
        }
        
    }
}



class LoginVm: ObservableObject{
    @Published var emailz:String = ""
    @Published var passwordz:String = ""
    @AppStorage("log_status") var log_Status = false
    @State var isLoading = false
    @Published var errMessage:String?
    @EnvironmentObject var homeVM:HomeViewModel
    func login(completion:@escaping()->Void){
        self.isLoading = true
        Auth.auth().signIn(withEmail: emailz, password: passwordz) { (result, err) in
            if let err = err{
                self.errMessage = err.localizedDescription
                print(err.localizedDescription)
                self.isLoading = false
//                if err.localizedDescription.contains("no user record corresponding to this identifier"){
//                    self.log_Status = true
//                }
               
//                self.log_Status = true
                completion()
            }else{
                withAnimation{
                    self.isLoading = false
                    self.log_Status = true
                    
                    completion()
                }
            }
        }
    }
    
    func googleLogin(completion:@escaping(Bool)->Void){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        isLoading = true
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self] user, error in
            
            if let error = error {
                // ...
                print(error.localizedDescription)
                isLoading = false
                return
              }

              guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                  isLoading = false
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: authentication.accessToken)
            //Firebase Auth
            Auth.auth().signIn(with: credential) { result, err in
                isLoading = false
                if let error = err{
                    print(error.localizedDescription)
                    return
                }
                guard let user = result?.user else{
                    isLoading = false
                    return
                }
                print(user.displayName ?? "Success")
                FireBase.shared.isExist {res in
                    if res{
                        withAnimation{
                            self.log_Status = true
                            completion(false)
                        }
                    }else{
                        FireBase.shared.addUser(type: .gmail, uid: Auth.auth().currentUser!.uid){
                            withAnimation{
                                self.log_Status = true
                                completion(true)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func anoymouseLogin(completion:@escaping(Bool)->Void){
        Auth.auth().signInAnonymously { res, err in
            if err != nil{
                print(err?.localizedDescription)
                return
            }
            print("success = \(res!.user.uid)")
            FireBase.shared.isExist {res in
                if res{
                    withAnimation{
                        self.log_Status = true
                        completion(false)
                    }
                }else{
                    FireBase.shared.addUser(type: .anonymouse, uid: Auth.auth().currentUser!.uid){
                        withAnimation{
                            self.log_Status = true
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getRootViewController()->UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
}
