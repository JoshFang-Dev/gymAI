//
//  LottieView.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-08-09.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    func updateUIView(_ uiView: AnimationView, context: Context) {
        
    }
    
    var animationName:String
    func makeUIView(context:Context) -> AnimationView{
        let view = AnimationView(name:animationName, bundle:Bundle.main)
        view.loopMode = .loop
        view.play()
        return view
    }
}



struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(animationName: "workout")
            .environmentObject(HomeViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
    }
}
