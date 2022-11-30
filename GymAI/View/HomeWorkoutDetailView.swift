//
//  HomeWorkoutView.swift
//  GymAI
//
//  Created by Josh Fang on 2022-09-23.
//

import SwiftUI

struct HomeWorkoutDetailView:View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var tags = ["Killer challenge","Core"]
    var body: some View{
        VStack{
            ZStack(alignment:.top){
                Image("plankworkout")
                    .resizable()
                    .scaledToFit()
                HStack{
                    Button(action:{presentationMode.wrappedValue.dismiss()}){
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    Button(action:{}){
                        Image(systemName: "heart")
                            .foregroundColor(Color.white)
                    }
                }
                .padding(.top, Constant.height10*0.5)
                .padding(.horizontal)
            }
            
//            .frame(height:Constant.height10*1.5)
//            .background(Color.black)
            
            VStack(spacing:20){
                HeaderText("Squad CHALLENGE")
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.bottom)
                VStack(alignment:.leading){
                    HeaderText("Intermediate",size:16)
                    DateText("Level",size:15)
                }
                .frame(maxWidth:.infinity,alignment: .leading)
                RegularText("Squad helps to gain core strength and build abs with minimal risks of back and neck injuries",Color.black)
                    .frame(maxWidth:.infinity,alignment: .leading)
                HStack{
                    ForEach(tags,id:\.self){tag in
                        TagText(tag)
                            .padding(5)
                            .background(Constant.workoutTagBG)
                            .clipShape(Capsule())
                    }
                    Spacer()
                }
                HStack{
                    WorkoutSelectionHeaderText("Camera")
                    Spacer()
                    Button(action:{}){
                        Image(systemName:"chevron.right")
                            .foregroundColor(Color.gray.opacity(0.75))
                    }
                }
                HStack{
                    WorkoutSelectionHeaderText("Sound & Music")
                    Spacer()
                    Button(action:{}){
                        Image(systemName:"chevron.right")
                            .foregroundColor(Color.gray.opacity(0.75))
                    }
                    
                }
                
                Spacer()
                NavigationLink(destination:WorkoutHomeView()) {
                    HorizontalButton(text: "Start",color:Constant.workoutYellow,textColor: .white)
                        .padding()
                }
                

            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .offset(y:-20)
        }
        
//        .padding(.top)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct HomeWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        HomeWorkoutDetailView()
    }
}
