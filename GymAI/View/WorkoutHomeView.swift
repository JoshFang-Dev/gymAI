//
//  ContentView.swift
//  GymAI
//
//  Created by Josh Fang on 2022-09-11.
//

import SwiftUI
import Vision
import CoreML
import AVFoundation
import Foundation
import AudioToolbox


class DataService {
    static let instance = DataService()
    var action:String = ""
    var confidence:Double = 0.0
}

//MARK: 1.1
enum ExcerciseEnum:String{
    case highknee,squadDown,squadUp,standing
}

//MARK: 1.2
//enum ExcerciseEnum:String{
//    case highknee, squadDown, squadUp, standing
//}



struct WorkoutHomeView: View {
    @StateObject var predictor = Predictor()
    var pointsLayer = CAShapeLayer()
    @State var action = ""
    @State var confidence:Double = 0
    @State var labelText = ""
    var videoController = VideoViewController()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack(spacing:0){
            
            //            ZStack(alignment:.topLeading){
            ZStack(alignment:.bottom){
                CameraViewWrapper(predictor: predictor, videoController: videoController)
//                    .ignoresSafeArea()
                VStack{
                    HStack{
                        Button(action:{presentationMode.wrappedValue.dismiss()}){
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                            //                            .background(Color.white)
                        }
                        Spacer()
                        Button(action:{videoController.videoCapture.flipCamera { err in
                            print(err?.localizedDescription)
                        }}){
                            Image("camera")
                        }
                    }
                    
//                    .frame(maxWidth:.infinity,alignment: .leading)
                    
                    .padding(.top, Constant.height10/2)
                    .padding(.horizontal)
                    .background(Color.white)
                    
                    Spacer()
//                    VStack{
//                        Text("action: \(predictor.action)")
//                            .foregroundColor(.white)
//                        Text("confidence: \(predictor.confidence)")
//                            .foregroundColor(.white)
//                        Text("hint: \(predictor.warningMessage)")
//                            .foregroundColor(.white)
//                        Text("count: \(predictor.count)")
//                            .font(.system(size: 20))
//                            .foregroundColor(.red)
//                        Text("NotProper count: \(predictor.notProperCount)")
//                            .font(.system(size: 20))
//                            .foregroundColor(.red)
//                    }
                    HStack{
                        Image("music")
                        Spacer()
                        VStack{
                            Text("count: \(predictor.count)")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Text("NotProper count: \(predictor.notProperCount)")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image("more")
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                }
                if predictor.warningMessage != ""{
                    withAnimation{
                        HStack{
                            Image("volume")
                                .resizable()
                                .frame(width:20,height:20)
                            HeaderText(predictor.warningMessage,Color.white,size:14)
                        }
                        .padding()
                        .background(Color.lightYellow)
                        .cornerRadius(10)
                        .padding(.bottom,Constant.height10)
                        .padding(.leading,Constant.width10)
                        .transition(.opacity)
                    }
                    
                    
                }
                
                
                
            }
            
            //            Color.red
            //                    .ignoresSafeArea(.all,edges: .all)
            //                    .frame(height:Constant.width10*5)
            //                .rotationEffect(.degrees(-90))
            //
            
            
            //                PoseViewCameraWrapper()
            //                    .ignoresSafeArea(.all,edges: .all)
            
            //                Button(action:{presentationMode.wrappedValue.dismiss()}){
            //                                    Image(systemName: "chevron.left")
            //                                        .foregroundColor(.white)
            //                                }
            //                .padding(.top,Constant.height10)
            //                .padding(.leading)
            //            Spacer()
            
            
            
        }
        .onAppear{
            predictor.currentExcercise = .squadDown
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                    predictor.count += 1
//                    AudioServicesPlayAlertSound(SystemSoundID(1320))
//                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                    predictor.warningMessage = "Lower Down Hip"
//                    predictor.notProperCount += 1
//                    AudioServicesPlayAlertSound(SystemSoundID(1073))
//                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                        predictor.warningMessage = ""
//                        predictor.count += 1
//                        AudioServicesPlayAlertSound(SystemSoundID(1320))
//
//                    }
//                }
//            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .top)
        
        
    }
}

struct WorkoutHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHomeView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
    }
}


struct CameraViewWrapper: UIViewControllerRepresentable {
    var predictor: Predictor
    var videoController:VideoViewController
    func makeUIViewController(context: Context) -> some UIViewController {
        //        let cvc = videoController
        videoController.predictor = predictor
        return videoController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}


struct PoseViewCameraWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    //    var predictor: Predictor
    //    var videoController:VideoViewController
    func makeUIViewController(context: Context) -> ViewController{
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(identifier: "ViewController") as! ViewController
        return viewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
