//
//  GymAIApp.swift
//  GymAI
//
//  Created by Josh Fang on 2022-09-11.
//

import SwiftUI
import Firebase
import GoogleSignIn
@main
struct GymAIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var predictor = Predictor()
    var videoController = VideoViewController()
    var body: some Scene {
        WindowGroup {
//            CameraViewWrapper(predictor: predictor, videoController: videoController)
//                .ignoresSafeArea(.all,edges: .all)
//            PoseViewCameraWrapper()
//                .ignoresSafeArea(.all,edges: .all)
            ContentView()
                .environmentObject(HomeViewModel())
        }
    }
}

class AppDelegate:NSObject, UIApplicationDelegate{

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//      UITabBar.appearance().barTintColor = UIColor(Constant.appBackground)
    FirebaseApp.configure()
    return true
  }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }

}

