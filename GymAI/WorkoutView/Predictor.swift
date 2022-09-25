//
//  Predictor.swift
//  GymAI
//
//  Created by Josh Fang on 2022-09-18.
//

import Foundation
import Vision
import SwiftUI

typealias ThorwingClassifier = MyActionClassifierGymAI_1

protocol PredictorDelegate:AnyObject{
    func predictor(_ predictor:Predictor, didFindNewRecognizedPoints points:[CGPoint], combinedPath:CGMutablePath)
    func predictor(_ predictor:Predictor, didLabelAction action: String, with confidence:Double)
}


class Predictor:ObservableObject{
    weak var delegate:PredictorDelegate?
    let predictionWindowSize = 60
    var posesWindow:[VNHumanBodyPoseObservation] = []
    @Published var action:String = ""
    @Published var confidence:Double = 0
    init(){
        posesWindow.reserveCapacity(predictionWindowSize)
    }
    func estimation(sampleBuffer: CMSampleBuffer){
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPostHandler)
        
        do{
            try requestHandler.perform([request])
        }
        catch{
            print("unable to perform the request: with \(error)")
        }
    }
    
    func bodyPostHandler(request:VNRequest,error:Error?){
        guard let observations = request.results as? [VNHumanBodyPoseObservation] else {return}
        
        observations.forEach {
            processObservation($0)
        }
        if let result = observations.first{
            storeObservation(result)
            labelActionType()
        }
    }
    func labelActionType(){
        guard let throwingClassifer = try? ThorwingClassifier(configuration: MLModelConfiguration()),
              let poseMultiArray = prepareInputWithObservations(posesWindow),
              let predictions = try? throwingClassifer.prediction(poses: poseMultiArray) else {return}
        
//        let label = predictions.label
//        let confidence = predictions.labelProbabilities[label] ?? 0
//        DataService.instance.action = label
//        DataService.instance.confidence = confidence
        DispatchQueue.main.async {
            self.action = predictions.label
            self.confidence = predictions.labelProbabilities[self.action] ?? 0
        }
        
        delegate?.predictor(self,didLabelAction:action, with: confidence)
    }
    
    func prepareInputWithObservations(_ observations:[VNHumanBodyPoseObservation]) -> MLMultiArray?{
        let numAvailable = observations.count
        let observationNeeed = 60
        var multiArrayBuffer = [MLMultiArray]()
        
        for frameIndex in 0 ..< min(numAvailable,observationNeeed){
            let pose = observations[frameIndex]
            do{
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            }
            catch{
                continue
            }
        }
        if numAvailable < observationNeeed{
            for _ in 0 ..< (observationNeeed - numAvailable){
                do{
                    let oneFrameMultiArray = try MLMultiArray(shape: [1,3,18], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                }catch{
                    continue
                }
            }
        }
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray(_ predictionWindow:MLMultiArray, with value:Double = 0.0) throws{
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    func storeObservation(_ observation:VNHumanBodyPoseObservation){
        if posesWindow.count >= predictionWindowSize{
            posesWindow.removeFirst()
        }
    }
    
    func processObservation(_ observation:VNHumanBodyPoseObservation){
        let rightKnee = try? observation.recognizedPoint(.rightKnee)
        let leftHip = try? observation.recognizedPoint(.leftHip)
        let leftShoulder = try? observation.recognizedPoint(.leftShoulder)
        let leftElbow = try? observation.recognizedPoint(.leftElbow)
//        let rightKnee = try? observation.recognizedPoint(.rightKnee)
//        let rightKnee = try? observation.recognizedPoint(.rightKnee)
//        let rightKnee = try? observation.recognizedPoint(.rightKnee)
//        let rightKnee = try? observation.recognizedPoint(.rightKnee)
//        let rightKnee = try? observation.recognizedPoint(.rightKnee)
//        let rightKnee = try? observation.recognizedPoint(.rightKnee)
        print("rightKnee \(rightKnee)")
        let combinedPath = CGMutablePath()
        
        var path = Path()
        path.move(to:leftShoulder!.location)
        path.addLine(to: leftElbow!.location)
        path.fill(Color.blue)
        path.stroke(lineWidth: 3.0)
        combinedPath.addPath(path.cgPath)
        do{
            let recognizedPoints = try observation.recognizedPoints(forGroupKey: .all)
            var displayedPoints = recognizedPoints.map{
                CGPoint(x: $0.value.x, y: 1-$0.value.y)
            }
            delegate?.predictor(self, didFindNewRecognizedPoints: displayedPoints, combinedPath: combinedPath)
        }catch{
            print("error finding recognizedPoints")
        }
    }
    
    
}

struct Stick: Shape {
    var points: [CGPoint]
    var size: CGSize
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: points[0])
        for point in points {
            path.addLine(to: point)
        }
        return path.applying(CGAffineTransform.identity.scaledBy(x: size.width, y: size.height))
            .applying(CGAffineTransform(scaleX: -1, y: -1).translatedBy(x: -size.width, y: -size.height))
    }
}
