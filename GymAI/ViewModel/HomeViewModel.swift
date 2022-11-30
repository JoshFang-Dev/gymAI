//
//  HomeViewModel.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-07-03.
//

import SwiftUI


//let WIDTH10 = UIScreen.main.bounds.width/10
final class HomeViewModel: ObservableObject {
    //workout page
    @Published var homeSelectedTab:TabSelection = .home
    @Published var planSelected = "My Plan"
    @Published var isLogin = false
    @Published var excercise:[Excercise] = []
    @Published var user:User?
    @Published var isShowVisionModel = false
    func fetchData(){
        FireBase.shared.fetchAllTask { excercises in
            self.excercise = excercises.sorted{$0.date > $1.date}
        }
        FireBase.shared.fetchUserData { user in
            self.user = user
        }
    }
}

enum TabSelection:String{
    case home,stat,profile
    
    var titel:String{
        switch self {
        case .home:
            return "home"
        case .stat:
            return "stat"
        case .profile:
            return "profile"
        }
    }
}


