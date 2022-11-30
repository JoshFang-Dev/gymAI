//
//  VideoViewController.swift
//  GymAI
//
//  Created by Josh Fang on 2022-09-23.
//

import Foundation
import AVFoundation
import UIKit
import Vision
class VideoViewController:UIViewController{
    var previewLayer:AVCaptureVideoPreviewLayer?
    let videoCapture = VideoCaptureWorkout()
    //    var isPlankDetect = false
    var predictor = Predictor()
    var pointsLayer = CAShapeLayer()
    var readyCheck = true
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
        //        previewLayer.videoGravity = .resizeAspectFill
        //        previewLayer.connection?.videoOrientation = .landscapeLeft
        
        view.layer.addSublayer(pointsLayer)
        pointsLayer.frame = view.frame
        pointsLayer.strokeColor = UIColor.green.cgColor
    }
}

extension VideoViewController:PredictorDelegate{
    
    //MARK: ML prediction
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double, bodyParts:[VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
//            (action == predictor.currentExcercise.rawValue ||  action == ExcerciseEnum.highknee.rawValue) && confidence > 0.65{
//        if (action == ExcerciseEnum.squadDown.rawValue || action == ExcerciseEnum.highknee.rawValue) && confidence > 0.75 && self.readyCheck == true{
//        if action == ExcerciseEnum.squadDown.rawValue && confidence > 0.75 && self.readyCheck == true{
        if action == ExcerciseEnum.squadDown.rawValue && confidence > 0.75 && self.readyCheck == true{
            let rightKnee = bodyParts[.rightKnee]!.location
            let leftKnee = bodyParts[.rightKnee]!.location
            let rightHip = bodyParts[.rightHip]!.location
            let rightAnkle = bodyParts[.rightAnkle]!.location
            let leftAnkle = bodyParts[.leftAnkle]!.location
            let firstAngle = atan2(rightHip.y - rightKnee.y, rightHip.x - rightKnee.x)
            let secondAngle = atan2(rightAnkle.y - rightKnee.y, rightAnkle.x - rightKnee.x)
            var angleDiffRadians = firstAngle - secondAngle
            while angleDiffRadians < 0 {
                angleDiffRadians += CGFloat(2 * Double.pi)
            }
            let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
            let hipHeight = rightHip.y
            let kneeHeight = rightKnee.y
            guard hipHeight != kneeHeight else {return}
            Logger.log(.other, "angleDiffDegrees :\(angleDiffDegrees)")
            if angleDiffDegrees > 50 {return}
            self.readyCheck = false
            print("hip:\(hipHeight),knee \(kneeHeight) action \(action)")
            if (hipHeight - kneeHeight) < 0.1{
                DispatchQueue.main.async {
                    predictor.count += 1
                    AudioServicesPlayAlertSound(SystemSoundID(1320))
                }
            }else{
                DispatchQueue.main.async {
                    predictor.warningMessage = "Lower Down Hip"
                    predictor.notProperCount += 1
                    AudioServicesPlayAlertSound(SystemSoundID(1073))
                }
            }
            DispatchQueue.main.asyncAfter(deadline:.now()+1.25) {
                predictor.warningMessage = ""
                self.readyCheck = true
            }
        }
        else if action == ExcerciseEnum.squadDown.rawValue && confidence > 0.75{
            DispatchQueue.main.async {
                predictor.warningMessage = "Slow Down"
//                predictor.notProperCount += 1
//                AudioServicesPlayAlertSound(SystemSoundID(1319))
            }
        }
    }
    
    //MARK: for change label position
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint],combinedPath:CGMutablePath, joineNameAll:VNHumanBodyPoseObservation) {
        guard let previewLayer = previewLayer else {return}
        let convertedPoints = points.map {
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        let combinedPath = CGMutablePath()
        for point in convertedPoints {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        pointsLayer.path = combinedPath
        DispatchQueue.main.async {
//            self.pointsLayer.setNeedsLayout()
            self.pointsLayer.setNeedsDisplay()
//            self.pointsLayer.didChangeValue(for: \.path)
        }
    }
}
