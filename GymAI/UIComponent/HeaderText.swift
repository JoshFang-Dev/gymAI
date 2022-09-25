//
//  HeaderText.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-06-29.
//

import SwiftUI

struct HeaderText: View {
    var text:String
    var textColor:Color
    var size:CGFloat
    init(_ text:String,_ textColor:Color = Color.headerText, size:CGFloat = 20){
        self.text = text
        self.textColor = textColor
        self.size = size
    }
    var body: some View {
        Text(LocalizedStringKey(text))
//            .font(.system(size: 16))
            .fontWeight(.bold)
            .font(.system(size: size))
            .foregroundColor(textColor)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat", size: 24))
    }
}

struct TagText: View {
    var text:String
    var textColor:Color
    var size:CGFloat
    init(_ text:String,_ textColor:Color = Color.gray.opacity(0.75), size:CGFloat = 16){
        self.text = text
        self.textColor = textColor
        self.size = size
    }
    var body: some View {
        Text(LocalizedStringKey(text))
//            .font(.system(size: 16))
            .fontWeight(.bold)
            .font(.system(size: size))
            .foregroundColor(textColor)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat", size: 24))
    }
}

struct WorkoutWeeklyText: View {
    var text:String
    var textColor:Color
    init(_ text:String,_ textColor:Color = Color.headerText){
        self.text = text
        self.textColor = textColor
    }
    var body: some View {
        Text(LocalizedStringKey(text))
//            .font(.system(size: 16))
            .fontWeight(.bold)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat", size: 24))
    }
}

struct WorkoutSelectionHeaderText: View {
    var text:String
    var textColor:Color
    init(_ text:String,_ textColor:Color = Color.black){
        self.text = text
        self.textColor = textColor
    }
    var body: some View {
        Text(LocalizedStringKey(text))
//            .font(.system(size: 16))
            .fontWeight(.semibold)
            .font(.system(size: 15))
            .foregroundColor(textColor)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat", size: 24))
    }
}

struct DateText: View {
    var text:String
    var textColor:Color
    var size:CGFloat
    init(_ text:String,_ textColor:Color = Color.headerText, size:CGFloat = 20){
        self.text = text
        self.textColor = textColor
        self.size = size
    }
    var body: some View {
        Text(LocalizedStringKey(text))
//            .font(.system(size: 16))
            .fontWeight(.regular)
            .font(.system(size: size))
            .foregroundColor(.gray.opacity(0.75))
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat", size: 24))
    }
}

struct PlanTitleText:View{
    var text:String
    var textColor:Color
    init(_ text:String,_ textColor:Color = Color.headerText){
        self.text = text
        self.textColor = textColor
    }
    var body: some View {
        Text(LocalizedStringKey(text))
            .fontWeight(.bold)
            .font(.system(size: 27))
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat", size: 24))
    }
}

struct RegularText:View{
    var text:String
    var textColor:Color
    var size:CGFloat
    init(_ text:String,_ textColor:Color = Color.white, size:CGFloat = 15){
        self.text = text
        self.textColor = textColor
        self.size = size
    }
    var body: some View {
        Text(LocalizedStringKey(text))
            .fontWeight(.regular)
            .font(.system(size: size))
            .foregroundColor(textColor)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct BodyTitleText: View {
    var text:String
    var textColor:Color
    init(_ text:String,_ textColor:Color = Color.headerText){
        self.text = text
        self.textColor = textColor
    }
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.system(size: 24))
            .fontWeight(.bold)
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat-Bold", size: 24))
    }
}

struct BodyText: View {
    var text:String
    var textColor:Color
    var fontSize:CGFloat
    init(_ text:String,_ textColor:Color = Color.headerText,_ fontSize:CGFloat = 14){
        self.text = text
        self.textColor = textColor
        self.fontSize = fontSize
    }
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.system(size: fontSize))
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat-Regular", size: 20))
    }
}



struct BoldBodyText: View {
    var text:String
    var textColor:Color
    var fontSize:CGFloat
    init(_ text:String,_ textColor:Color = Color.black,_ fontSize:CGFloat = 16){
        self.text = text
        self.textColor = textColor
        self.fontSize = fontSize
    }
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(.system(size: fontSize).bold())
            .foregroundColor(textColor)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
//            .font(.custom("Montserrat-Regular", size: 20))
    }
}



