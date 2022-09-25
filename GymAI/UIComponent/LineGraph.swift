//
//  LineGraph.swift
//  TreignMe
//
//  Created by Josh Fang on 2022-07-03.
//

import SwiftUI

struct LineGraph:View{
    var data:[CGFloat]
    @State var currentPlot = ""
    var title = "Week"
    var isImage = true
    @State var offset:CGSize = .zero
    @State var showPlot = false
    @State var translation:CGFloat = 0
    @State var excercises:[Excercise] = []
    var body: some View{
//        let today
        let f = DateFormatter()
        let k = f.weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]
        GeometryReader{proxy in
            let width = proxy.size.width / CGFloat(data.count - 1)
            let height = proxy.size.height
            
            
            let maxPoint = (data.max() ?? 0) + 100
            
            let points = data.enumerated().compactMap { item -> CGPoint in
                let progress = item.element / maxPoint
                let pathHeight = progress * height
                let pathWidth = width * CGFloat(item.offset)
                return CGPoint(x:pathWidth,y:-pathHeight + height)
            }
            ZStack{
                
                //Converting plot as points
                //path...
                Path{path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLines(points)
                }
                .strokedPath(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                             
                    .fill(
                        .white
//                        LinearGradient(colors:[Color.red,Color.blue],startPoint: .leading,endPoint: .trailing
//                                      )
                    )
//               FillBG()
//                .clipShape( Path{path in
//                    path.move(to: CGPoint(x: 0, y: 0))
//                    path.addLines(points)
//                    path.addLine(to: CGPoint(x:proxy.size.width,y:height))
//                    path.addLine(to: CGPoint(x:0,y:height))
//                })
                
            }
            .overlay(
                VStack(spacing:0){
                    Text(currentPlot)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .background(Color.red,in:Capsule())
                        .offset(x:translation < 10 ? 30:0)
                        .offset(x:translation > (proxy.size.width-60) ? -30:0)
                    Rectangle()
                        .fill(Color.red)
                        .frame(width:1,height:40)
                        .padding(.top)
                    Circle()
                        .fill(Color.red)
                        .frame(width:22,height:22)
                        .overlay(
                            Circle()
                                .fill(.white)
                                .frame(width:10,height:10)
                        )
                            
                    Rectangle()
                        .fill(Color.red)
                        .frame(width:1,height:50)
                }
                    .frame(width:80,height:170)
                //170/2-15 = circle ring size
                    .offset(y:70)
                    .offset(offset)
                    .opacity(showPlot ? 1:0),
                alignment:.bottomLeading
            )
            .contentShape(Rectangle())
            .gesture(DragGesture().onChanged({ value in
                withAnimation {
                    showPlot = true
                    let translation = value.location.x - 40
                    //Getting index ...
                    let index = max(min(Int((translation/width).rounded()+1),data.count - 1),0)
                    currentPlot = "\(data[index])"
                    
                    self.translation = translation
                    //removing half width
                    offset = CGSize(width: points[index].x-40, height: points[index].y - height)
                }
            }).onEnded({ value in
                withAnimation{showPlot = false}
            })
            
            )
        }
        .overlay(
            VStack(alignment:.leading){
                ZStack{
                    if isImage{
                        Button(action:{}){
                            Image(systemName: "calendar")
                                .frame(maxWidth:.infinity,alignment: .trailing)
                                .foregroundColor(.white)
                        }
                       
                    }
                    BodyText(title,Color.white,18)
                        .frame(maxWidth:.infinity,alignment: .center)
                }
                
                Spacer()
                
                HStack{
                    let days = ["Mo","Tu","We","Th","Fr","Sa","Su"]
                    ForEach(days,id:\.self){ day in
                        VStack{
                            Image("reportLine")
                            BodyText(day,k.contains(day) ? Color.yellow:.white,12)
                        }
                        
                        if day != "Su"{
                            Spacer()
                        }
                        
                    }
                }
                
                
            }
                .frame(maxWidth:.infinity,alignment: .leading)
        )
        .padding(.horizontal,10)
        
    }
    
    @ViewBuilder
    func FillBG()->some View{
        LinearGradient(colors: [Color.red.opacity(0.3),Color.blue.opacity(0.2),Color.yellow.opacity(0.1)], startPoint: .top, endPoint: .bottom)
//        + Array(repeating: Color.red.opacity(0.3), count: 4) + Array(repeating: Color.clear, count: 2)
    }
}

struct LineGraph_Previews: PreviewProvider {
    static var previews: some View {
        LineGraph(data: [989,1200,750,790,650,950,1200,600,500,600,890])
            .frame(height:250)
            .environmentObject(HomeViewModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
    }
}
