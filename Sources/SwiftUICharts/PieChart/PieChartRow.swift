//
//  PieChartRow.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

public struct PieChartRow: View {
    @State var data: [PieSliceData]
    var backgroundColor: Color
    var accentColor: Color
    var slices: [PieSlice] {
        var tempSlices: [PieSlice] = []
        var lastEndDeg: Double = 0
        let maxValue = data.map {
            $0.value
        }.reduce(0, +)
        for slice in data {
            let normalized: Double = Double(slice.value) / Double(maxValue)
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice.value, normalizedValue: normalized))
        }
        return tempSlices
    }

    var showLabels: Bool
    var showValue: Bool
    var valueFormat: String
    var highlightedIdx: Binding<Int>?

    @State private var highlighted = false
    @State private var currentTouchedIndex = -1 {
        didSet {
            if oldValue != currentTouchedIndex {
                highlightedIdx?.wrappedValue = currentTouchedIndex
            }
        }
    }

    public init(data: [PieSliceData], backgroundColor: Color, accentColor: Color, showLabels: Bool = false,
                showValue: Bool = false,
                valueFormat: String = "%.2f",
                highlightedIdx: Binding<Int>? = nil) {
        self.data = data
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
        self.showLabels = showLabels
        self.showValue = showValue
        self.valueFormat = valueFormat
        self.highlightedIdx = highlightedIdx
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(data.indices) { i in
                    PieChartCell(data: data[i], showLabel: showLabels, showValue: showValue, valueFormat: valueFormat, rect: geometry.frame(in: .local), startDeg: self.slices[i].startDeg, endDeg: self.slices[i].endDeg, index: i, backgroundColor: self.backgroundColor)
                            .scaleEffect(self.currentTouchedIndex == i ? 1.1 : 1)
                            .animation(Animation.spring())
                }
            }
                    #if os(macOS)
                    .onAppear {
                        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
                            if highlighted && $0.window != nil {
                                let rectified = CGPoint(x: $0.locationInWindow.x, y: $0.window!.frame.size.height - $0.locationInWindow.y)
                                setCurrentTouchedIndex(rect: geometry.frame(in: .global), value: rectified)
                            }
                            return $0
                        }
                    }
                    #endif

                    .gesture(DragGesture()
                            .onChanged({ value in
                                setCurrentTouchedIndex(rect: geometry.frame(in: .local), value: value.location)
                            })
                            .onEnded({ value in
                                self.currentTouchedIndex = -1
                            }))
                    .onHover { hover in
                        highlighted = hover
                        if !hover {
                            currentTouchedIndex = -1
                        }
                    }
        }
    }

    private func setCurrentTouchedIndex(rect: CGRect, value: CGPoint) {
        let isTouchInPie = isPointInCircle(point: value, circleRect: rect)
        if isTouchInPie {
            let touchDegree = degree(for: value, inCircleRect: rect)
            self.currentTouchedIndex = self.slices.firstIndex(where: { $0.startDeg < touchDegree && $0.endDeg > touchDegree }) ?? -1
        } else {
            self.currentTouchedIndex = -1
        }
    }
}

#if DEBUG
struct PieChartRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PieChartRow(data: PreviewData.getPieSliceData(), backgroundColor: Color(red: 252.0 / 255.0, green: 236.0 / 255.0, blue: 234.0 / 255.0), accentColor: Color(red: 225.0 / 255.0, green: 97.0 / 255.0, blue: 76.0 / 255.0), showValue: false, highlightedIdx: Binding.constant(0))
                    .frame(width: 100, height: 100)
            PieChartRow(data: [PreviewData.getPieSliceData()[0]], backgroundColor: Color(red: 252.0 / 255.0, green: 236.0 / 255.0, blue: 234.0 / 255.0), accentColor: Color(red: 225.0 / 255.0, green: 97.0 / 255.0, blue: 76.0 / 255.0), showValue: false, highlightedIdx: Binding.constant(0))
                    .frame(width: 100, height: 100)
        }
    }
}
#endif
