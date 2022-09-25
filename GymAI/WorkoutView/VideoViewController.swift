//
//  VideoViewController.swift
//  GymAI
//
//  Created by Josh Fang on 2022-09-23.
//

import Foundation
import AVFoundation
import UIKit
class VideoViewController:UIViewController{
    var previewLayer:AVCaptureVideoPreviewLayer?
    let videoCapture = VideoCaptureWorkout()
//    var isPlankDetect = false
    var predictor = Predictor()
    var pointsLayer = CAShapeLayer()
    override func viewDidLoad() {
        setupVideoPreview()
        videoCapture.predictor = predictor
        videoCapture.predictor?.delegate = self
    }
    
    private func setupVideoPreview(){
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        guard let previewLayer = previewLayer else {return}
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
}

extension VideoViewController:PredictorDelegate{
    
    //MARK: ML prediction
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
        if action == "plank" && confidence > 0.95{
            
        }
//        homeVM.action = action
//        homeVM.confidence = confidence
        DispatchQueue.main.async {
            AudioServicesPlayAlertSound(SystemSoundID(1322))
        }
        print("action: \(action) confidence \(confidence)")
    }
    
    //MARK: for change label position
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint],combinedPath:CGMutablePath) {
        guard let previewLayer = previewLayer else {return}
        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
//        let combinedPath = CGMutablePath()
        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        pointsLayer.path = combinedPath
        DispatchQueue.main.async {
            self.pointsLayer.setNeedsLayout()
            self.pointsLayer.setNeedsDisplay()
        }
    }
}
