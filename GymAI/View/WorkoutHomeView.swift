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
struct WorkoutHomeView: View {
    @StateObject var predictor = Predictor()
    var pointsLayer = CAShapeLayer()
    @State var action = ""
    @State var confidence:Double = 0
    @State var labelText = ""
    var videoController = VideoViewController()
//    @EnvironmentObject var homeVM:HomeViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
//            HStack{
//                Button(action:{presentationMode.wrappedValue.dismiss()}){
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.gray)
//                }
//
//                Spacer()
//                Button(action:{videoController.videoCapture.flipCamera(){error in
//                    if let error = error {
//                        print("Failed to flip camera with error \(error)")
//                    }
//                }}){
//                Image("camera")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.top,Constant.height10)
            ZStack(alignment:.topLeading){
//                CameraViewWrapper(predictor: predictor, videoController: videoController)
//                    .ignoresSafeArea(.all,edges: .all)
                
                PoseViewCameraWrapper()
                    .ignoresSafeArea(.all,edges: .all)
                    
                Button(action:{presentationMode.wrappedValue.dismiss()}){
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.white)
                                }
                .padding(.top,Constant.height10)
                .padding(.leading)
//                VStack{
//                    Text("action: \(predictor.action)")
//                    Text("confidence: \(predictor.confidence)")
                }
//            .frame(height:Constant.height10*9)
            Spacer()
            VStack{
                                Text("action: \(labelText)")
            }
            .onAppear(){
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    labelText = "squad"
                    DispatchQueue.main.asyncAfter(deadline: .now()+3){
                        labelText = "Lower down legs"
                    }
                    
                    
                }
            }
        }
        
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .ignoresSafeArea(.all, edges: .top)
       

    }
}

struct WorkoutHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHomeView()
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
