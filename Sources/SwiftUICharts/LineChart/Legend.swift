//
//  Legend.swift
//  LineChart
//
//  Created by András Samu on 2019. 09. 02..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

struct Legend: View {
    @ObservedObject var data: ChartData
    @State var labels: [String]?
    @Binding var frame: CGRect
    @Binding var hideHorizontalLines: Bool
    @Binding var minDataValue: Double?
    @Binding var maxDataValue: Double?
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var specifier: String = "%.2f"
    let padding:CGFloat = 30
    private let lineOffset = CGFloat(60)

    var stepWidth: CGFloat {
        if data.points.count < 2 {
            return 0
        }
        return (frame.size.width - lineOffset/2) / CGFloat(data.points.count-1)
    }
    var stepHeight: CGFloat {
        if min != max {
            if (min < 0){
                return (frame.size.height-padding) / CGFloat(max - min)
            }else{
                return (frame.size.height-padding) / CGFloat(max - min)
            }
        }
        return 0
    }

    var min: CGFloat {
        let points = self.data.onlyPoints()
        return CGFloat(self.minDataValue ?? points.min() ?? 0)
    }

    var max: CGFloat {
        let points = self.data.onlyPoints()
        return CGFloat(self.maxDataValue ?? points.max() ?? 0)
    }

    var body: some View {
        ZStack(alignment: .topLeading){
            ForEach((0...4), id: \.self) { height in
                HStack(alignment: .center){
                    Text("\(self.getYLegendSafe(height: height), specifier: specifier)").offset(x: 0, y: self.getYposition(height: height) )
                        .foregroundColor(Colors.LegendText)
                        .font(.caption)
                    self.xLine(atHeight: self.getYLegendSafe(height: height), width: self.frame.width)
                        .stroke(self.colorScheme == .dark ? Colors.LegendDarkColor : Colors.LegendColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5,height == 0 ? 0 : 10]))
                        .opacity((self.hideHorizontalLines && height != 0) ? 0 : 1)
                        .rotationEffect(.degrees(180), anchor: .center)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeOut(duration: 0.2))
                        .clipped()
                }
                if let labels = labels {
                    ForEach(labels.indices) { width in
                        VStack(alignment: .center) {
                            self.yLine(atWidth: CGFloat(width), height: self.frame.height)
                                .stroke(self.colorScheme == .dark ? Colors.LegendDarkColor : Colors.LegendColor, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, dash: [5, 10]))
                                .animation(.easeOut(duration: 0.2))
                                .clipped()
                            Text(labels[width]).offset(x: getXposition(width: CGFloat(width) * stepWidth), y: 15)
                                               .foregroundColor(Colors.LegendText)
                                               .font(.caption)
                        }.frame(height: frame.height)
                    }
                }

            }

        }
    }

    func getYLegendSafe(height:Int)->CGFloat{
        if let legend = getYLegend() {
            return CGFloat(legend[height])
        }
        return 0
    }

    func getYposition(height: Int)-> CGFloat {
        if let legend = getYLegend() {
            return (self.frame.height-((CGFloat(legend[height]) - min)*self.stepHeight))-(self.frame.height/2)
        }
        return 0

    }

    func getXposition(width: CGFloat)-> CGFloat {
        -(self.frame.width - lineOffset) + width+((self.frame.width - lineOffset)/2)
    }

    func xLine(atHeight: CGFloat, width: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x:5, y: (atHeight-min)*stepHeight))
        hLine.addLine(to: CGPoint(x: width, y: (atHeight-min)*stepHeight))
        return hLine
    }

    func yLine(atWidth: CGFloat, height: CGFloat) -> Path {
        var hLine = Path()
        hLine.move(to: CGPoint(x: atWidth * stepWidth + lineOffset/2, y: padding))
        hLine.addLine(to: CGPoint(x: atWidth * stepWidth + lineOffset/2, y: height))
        return hLine
    }

    func getYLegend() -> [Double]? {
        let step = Double(max - min)/4
        return [min+step * 0, min+step * 1, min+step * 2, min+step * 3, min+step * 4]
    }
}

struct Legend_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            Legend(data: ChartData(points: [0,1,1,3]), labels: ["fd", "sfd", "dsd", "dsds"], frame: .constant(geometry.frame(in: .local)), hideHorizontalLines: .constant(false), minDataValue: .constant(0), maxDataValue: .constant(nil))
        }.frame(width: 320, height: 200)
    }
}
