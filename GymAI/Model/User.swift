//
//  User.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-07-03.
//

import SwiftUI

struct User:Hashable{
    var name,userId,email,avatarUrl:String?
//    var age,height:Int?
    var registerType,avatar:String?
    var defaultTimeSection:Int? = 25
    

    init(dictionary:[String:Any]) {
//        self.timeCreated = dictionary["timeCreated"] as? Timestamp
        self.avatarUrl = dictionary["avatarUrl"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.registerType = dictionary["registerType"] as? String
        self.defaultTimeSection = dictionary["defaultTimeSection"] as? Int
        self.avatar = dictionary["avatar"] as? String
        self.userId = dictionary["userId"] as? String
    }
}

//enum Intensity


struct Excercise:Hashable{
    //basic
    var date:Date
    var intensity:Int?
    var calories:Int? = 0
    var duration:Int = 0
    var avgHeartRate:Double? = 0
    var points:Int?

    init(dictionary:[String:Any]) {
        //toggle
        self.points = dictionary["points"] as? Int
        self.intensity = dictionary["intensity"] as? Int
        self.calories = dictionary["calories"] as? Int
        
        self.avgHeartRate = dictionary["avgHeartRate"] as? Double
        let timeDouble = dictionary["duration"] as! Double
        self.duration = Int(timeDouble)
        let dateString = dictionary["date"] as? String
        self.date = dateString!.toDate()
    }
}
