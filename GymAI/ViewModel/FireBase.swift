//
//  FireBase.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-07-03.
//

import SwiftUI
import Firebase
import GoogleSignIn

class FireBase: ObservableObject {
    static let shared = FireBase()
    @Published var isLoading = false
    @Published var isLoadingMessage:String?
    var taskListener:ListenerRegistration?
    var userListener:ListenerRegistration?
    func addUser(type:RegisterType,uid:String,password:String = "N/A", completion:@escaping()->Void){
        let store = Firestore.firestore().collection(Constant.user).document(uid)
        //        let b = Auth().auth().sig
        store.setData([
            "userId":uid,
            "email":Auth.auth().currentUser?.email ?? "N/A",
            "registerType":type.rawValue,
            "name":Auth.auth().currentUser?.displayName ?? "N/A",
            "password":password
        ]){(err)in
            if let err = err{
                debugPrint(err.localizedDescription)
                return
            }
            print("success add,",uid)
            completion()
            
        }
    }
    
    func isExist(completion:@escaping(Bool)->Void) {
        var allUsers = [String]()
        Firestore.firestore().collection(Constant.user).getDocuments { snapShots, err in
            if let err = err{
                debugPrint(err.localizedDescription)
            }
            snapShots?.documents.forEach({ snapShot in
                let data = snapShot.data()
                let user = User(dictionary:data)
                allUsers.append(user.userId!)
            })
            if allUsers.contains(Auth.auth().currentUser!.uid){
                print("have user")
                completion(true)
            }else{
                
                completion(false)
            }
        }
        
    }
    
    func addTask(data:[String:Any],completion:@escaping()->Void){
        self.isLoading = true
        let taskRef = Firestore.firestore().collection(Constant.user)
            .document(Auth.auth().currentUser!.uid).collection(Constant.excercise).document()
        var data1 = data
        data1["uid"] = taskRef.documentID
        taskRef.setData(data1){ err in
            if let err = err{
                self.isLoadingMessage = (err.localizedDescription)
                self.isLoading = false
                debugPrint("failed to setData, ",err.localizedDescription)
                return
            }
//            self.isLoadingMessage =
//            print("success add event")
            self.isLoadingMessage = "success add event"
            self.isLoading = false
            completion()
        }
    }
    
    func fetchAllTask(completion:@escaping([Excercise])->Void){
        isLoading = true
        taskListener = nil
        let taskRef = Firestore.firestore().collection(Constant.user)
            .document(Auth.auth().currentUser!.uid).collection(Constant.excercise)
        
        taskListener = taskRef.addSnapshotListener { (snapShots, err) in
            if let err = err{
                debugPrint(err.localizedDescription)
                return
            }
            var resultTasks = [Excercise]()
            if snapShots?.isEmpty != nil {
                snapShots!.documents.forEach({ (snapShot) in
                    let data = snapShot.data()
                    var event = Excercise(dictionary: data)
                    resultTasks.append(event)
                })
                self.isLoading = false
                print("fetch Task")
                completion(resultTasks)
            }
        }
    }
    
    func fetchUserData(completion:@escaping(User)->Void){
        isLoading = true
        userListener = nil
        let taskRef = Firestore.firestore().collection(Constant.user)
            .document(Auth.auth().currentUser!.uid)
        
        userListener = taskRef.addSnapshotListener { (snapShots, err) in
            if let err = err{
                debugPrint(err.localizedDescription)
                return
            }
//            var resultTasks = [User]()
            let data = snapShots!.data()
            var event = User(dictionary: data!)
//            resultTasks.append(event)
            completion(event)
        }
    }
    
    func logoOut(completion:@escaping()->Void){
        isLoading = true
//        DispatchQueue.global(qos: .background).async {
            GIDSignIn.sharedInstance.signOut()
            do{ try Auth.auth().signOut()
            }catch { print("already logged out")
            }
//            self.userListener?.remove()
//            self.categoryListener?.remove()
//            self.taskListener?.remove()
//            self.taskDetailListener?.remove()
//            self.isLoading = false
            completion()
            
//        }
        
        // Setting Back View To Login...
        
    }
}

//enum workIntensity:Int{
//    case one, two, three, four, five
//}



