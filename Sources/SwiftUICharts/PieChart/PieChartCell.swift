//
//  PieChartCell.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

struct PieSlice: Identifiable {
    var id = UUID()
    var startDeg: Double
    var endDeg: Double
    var value: Double
    var normalizedValue: Double
}

public struct PieChartCell: View {
    @State private var show: Bool = false
    @State var data: PieSliceData
    @State var showLabel = false
    @State var showValue = false
    @State var valueFormat: String
    var rect: CGRect
    var radius: CGFloat {
        min(rect.width, rect.height) / (showLabel ? 3.5 : 2)
    }
    var bisector: Angle {
        Angle(degrees: (self.startDeg + self.endDeg) / 2)
    }
    var startDeg: Double
    var endDeg: Double
    var path: Path {
        var path = Path()
        path.addArc(center: rect.mid, radius: self.radius, startAngle: Angle(degrees: self.startDeg), endAngle: Angle(degrees: self.endDeg), clockwise: false)
        path.addLine(to: rect.mid)
        path.closeSubpath()
        return path
    }
    var labelLine: Path {
        var path = Path()
        path.move(to: getPointOnBisector(distanceFromCenter: radius))
        path.addLine(to: getPointOnBisector(distanceFromCenter: 1.3 * radius))
        return path
    }
    var index: Int
    var backgroundColor: Color

    public var body: some View {
        path
                .fill()
                .foregroundColor(Color(data.color))
                .overlay(path.stroke(self.backgroundColor, lineWidth: 1))
                .scaleEffect(show ? 1 : 0)
                .animation(Animation.spring().delay(Double(self.index) * 0.04))
                .onAppear() {
                    self.show = true
                }
        if showLabel || showValue {
            labelLine
                    .foregroundColor(.clear)
                    .overlay(labelLine.stroke(.white, lineWidth: 1))

                    .scaleEffect(show ? 1 : 0)
                    .animation(Animation.spring().delay(Double(self.index) * 0.04))
                    .onAppear() {
                        self.show = true
                    }
            VStack {
                if showLabel {
                    Text(data.label)
                }
                if showValue {
                    Text(String(format: valueFormat, data.value))
                }
            }
                    .animation(.none)
                    .position(getPointOnBisector(distanceFromCenter: 1.3 * radius + 25.0))

        }
    }

    private func getPointOnBisector(distanceFromCenter: Double) -> CGPoint {
        CGPoint(x: Double(distanceFromCenter) * cos(bisector.radians) + rect.mid.x,
                y: Double(distanceFromCenter) * sin(bisector.radians) + rect.mid.y)
    }
}

extension CGRect {
    var mid: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

#if DEBUG
struct PieChartCell_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PieChartCell(data: PreviewData.getPieSliceData()[0], showValue: true, valueFormat: "%.2f", rect: geometry.frame(in: .local), startDeg: 0.0, endDeg: 90.0, index: 0, backgroundColor: Color(red: 252.0 / 255.0, green: 236.0 / 255.0, blue: 234.0 / 255.0))
        }

    }
}
#endif
