//
//  HorizontalButton.swift
//  Calender
//
//  Created by Yilei Huang on 2021-11-29.
//

import SwiftUI

struct HorizontalButton:View{
    var image:String?
    var isSystem:Bool = false
    var textSize:Font = .body
    var text:String
    var color:Color? = Constant.mainTopColor
    var textColor:Color? = Constant.confirmColor
    var cornerRadius:CGFloat = 40
    var borderColor:Color = .clear
    //  var onClick: ()->()
    var body: some View{
        HStack{
            if let image = image{
                if isSystem{
                    Image(systemName: image)
                        .font(textSize.bold())
                }else{
                    Image(image)
                        .resizable()
                        .frame(width: 15, height: 15)
                }
                
            }
            Text(LocalizedStringKey(text))
                .foregroundColor(textColor)
                .fontWeight(.semibold)
                .font(textSize)
                .fixedSize(horizontal: true, vertical: false)
                
            
            
        }
        .frame(maxWidth:.infinity,alignment: .center)
        .foregroundColor(.white)
        .padding(.vertical,Constant.height10/5)
        .padding(.horizontal,40)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor,lineWidth: 2)
//            Capsule().stroke(borderColor,lineWidth: 2)
        )
    }
}
