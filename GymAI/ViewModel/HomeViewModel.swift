//
//  HomeViewModel.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-07-03.
//

import SwiftUI
import HealthKit


let WIDTH10 = UIScreen.main.bounds.width/10
final class HomeViewModel: ObservableObject {
    //workout page
    @Published var homeSelectedTab:TabSelection = .home
    @Published var planSelected = "My Plan"
    @Published var isLogin = false
    @Published var lastestWorkout:HKWorkout? = nil
    @Published var excercise:[Excercise] = []
    @Published var user:User?
    @Published var isShowVisionModel = false
    let store = HKHealthStore()

    func requestPermission () async -> Bool {
        let write: Set<HKSampleType> = [.workoutType()]
        let read: Set = [
            .workoutType(),
            HKSeriesType.activitySummaryType(),
            HKSeriesType.workoutRoute(),
            HKSeriesType.workoutType()
        ]

        let res: ()? = try? await store.requestAuthorization(toShare: write, read: read)
        guard res != nil else {
            return false
        }

        return true
    }
    func fetchData(){
        FireBase.shared.fetchAllTask { excercises in
            self.excercise = excercises.sorted{$0.date > $1.date}
        }
        FireBase.shared.fetchUserData { user in
            self.user = user
        }
    }
    
    func readWorkouts() async {
        let cycling = HKQuery.predicateForWorkouts(with: .coreTraining)

        let samples = try! await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKSample], Error>) in
            store.execute(HKSampleQuery(sampleType: .workoutType(), predicate: cycling, limit: HKObjectQueryNoLimit,sortDescriptors: [.init(keyPath: \HKSample.startDate, ascending: false)], resultsHandler: { query, samples, error in
                if let hasError = error {
                    continuation.resume(throwing: hasError)
                    return
                }

                guard let samples = samples else {
                    fatalError("*** Invalid State: This can only fail if there was an error. ***")
                }

                continuation.resume(returning: samples)
            }))
        }

        guard let workouts = samples as? [HKWorkout] else {
            return
        }
        DispatchQueue.main.async{
            self.lastestWorkout = workouts.first
        }
        
//        return workouts.first
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


