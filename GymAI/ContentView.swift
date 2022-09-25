//
//  ContentView.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-06-29.
//

import SwiftUI
import Firebase
import HealthKit

struct ContentView: View {
    var body: some View {
        LandingView()
    }
}

struct HomeView:View{
    @EnvironmentObject var homeVM:HomeViewModel
    var plans = ["My Plan","Beginner","Intermediate","Advanced"]
    var thisWeekDays = Date().getAllWeekDay()
    var body: some View{
//        NavigationView{
            VStack{
                HStack{
                    DateText(Date().toDateString())
                        .frame(maxWidth:.infinity,alignment: .leading)
                    Spacer()
                    Image("search")
                    Image("edit")
                }
                .padding(.horizontal)
                HeaderText("GYMAI WORKOUT")
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.horizontal)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(plans,id:\.self){ input in
                            VStack{
                                Button(action:{withAnimation{
                                    homeVM.planSelected = input
                                }}){
                                    WorkoutSelectionHeaderText(input)
                                }
                                if homeVM.planSelected == input{
                                    Divider()
                                        .frame(width: WIDTH10, height: 3)
                                        .background(Color.yellow)
                                }
                            }
                            
                            
                        }
                    }
                }
                .padding(.bottom)
                .padding(.horizontal)
                VStack{
                    HStack{
                        WorkoutWeeklyText("Weekly Active Days")
                        Spacer()
                        WorkoutWeeklyText("0/3")
                    }
                    HStack{
                        ForEach(thisWeekDays,id:\.self){day in
                            Button(action:{}){
                                RegularText(day.getDateOnly())
                                    .padding(7)
                                    .background(Color.black.opacity(0.2))
                                    .clipShape(Circle())
                                if day != thisWeekDays.last{
                                    Spacer()
                                }
                                    
                            }
                        }
                    }
                    
                }
                .padding()
                .background(Constant.workoutYellow)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding(.bottom)
                .padding(.horizontal)
                HeaderText("MY PLAN")
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.horizontal)
                NavigationLink(destination: HomeWorkoutView()) {
                    Image("temp")
                        .resizable()
                        .frame(height:Constant.height10*4.5)
                }
                
//                VStack(alignment:.leading){
//                    PlanTitleText("PLANK CHALLENGE")
//                        Spacer()
//                    RegularText("Planks help gain core strength and build abs with \n minimal risks of back and neck injuries")
//                    NavigationLink(destination: HomeWorkoutView()) {
//                        HorizontalButton(text: "Start",textColor: Constant.workoutYellow)
//                    }
//
//                }
//                .padding()
//                .frame(height:Constant.height10*3.5)
//                .background(Constant.workoutYellow)
//                .cornerRadius(10)
                
                Spacer()
                    
            }
            .padding(.vertical)
            .navigationBarTitle("")
            .navigationBarHidden(true)
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
        
//        .onAppear(){
//            print("this week is: \(Date().getAllWeekDay())")
//        }
    }
}

struct WorkoutMainTabView:View{
    @EnvironmentObject var homeVM:HomeViewModel
    var body: some View{
        NavigationView{
            ZStack(alignment:.center){
                TabView(selection: $homeVM.homeSelectedTab) {
                    HomeView()
                        .tabItem {
                            Image("home")
                            
                        }
                        .tag(TabSelection.home)
                    Color.red
                        .tabItem {
                            Image("stat")
                            
                        }
                        .tag(TabSelection.stat)
                    
                    Color.black
                        .tabItem {
                            Image("profile")
                            
                        }
                        .tag(TabSelection.profile)
                    
                }
                
                .overlay(
                    
                    // Custom Tab Bar...
                    HStack(spacing: 0){
                        // tabButton...
                        TabButton(Tab: .home)
                        
                        TabButton(Tab: .stat)
                            .offset(x: -10)
                        
                        TabButton(Tab: .profile)
                        // Center Curved Button...
                        
                    }
                        .padding()
                        .background(homeVM.homeSelectedTab == .stat ? Color.tabBG : Color.homeTabBG)
                        .cornerRadius(30)
                        .padding(.horizontal)
                    // hiding tab bar when detail opens...
                    //                    .offset(y: baseData.showDetail ? 200 : 0)
                    
                    ,alignment: .bottom
                )
           
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    @ViewBuilder
    func TabButton(Tab: TabSelection)-> some View{
        Button {
            withAnimation{
                homeVM.homeSelectedTab = Tab
            }
        } label: {
            
//            Image(homeVM.homeSelectedTab == Tab ? "\(Tab.rawValue).select":"\(Tab.rawValue)")
            Image("\(Tab.rawValue)")
                .resizable()
            //                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            //                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
        }
        
    }
}

struct LandingView:View{
    @ObservedObject var loginVM = LoginVm()
    @EnvironmentObject var homeVM:HomeViewModel
//    @ObservedObject private var connectivityManager = WatchConnectivityManager.shared
    @State var isReady = false
    var body: some View {
        WorkoutMainTabView()
                .onAppear(){
                    if Auth.auth().currentUser == nil{
                        loginVM.anoymouseLogin{ isture in
                            
                        }
                    }
                    
//                    homeVM.fetchData()
                }

    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       ContentView()
            .environmentObject(HomeViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
        
    }
}
