//
//  PieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

public struct PieChartView: View {
    public var data: [PieSliceData]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var formSize: CGSize
    public var dropShadow: Bool
    public var valueSpecifier: String

    @State private var highlightedIdx: Int = -1 {
        didSet {
            if (oldValue != self.highlightedIdx && self.highlightedIdx == -1) {
                HapticFeedback.playSelection()
            }
        }
    }

    public init(data: [PieSliceData], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.medium, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f") {
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
    }

    public var body: some View {
        ZStack {
            Rectangle()
                    .fill(self.style.backgroundColor)
                    .cornerRadius(20)
                    .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 12 : 0)
            VStack(alignment: .leading) {
                HStack {
                    if (highlightedIdx == -1) {
                        Text(self.title)
                                .font(.headline)
                                .foregroundColor(self.style.textColor)
                    } else {
                        Text("\(data[highlightedIdx].value, specifier: self.valueSpecifier)")
                                .font(.headline)
                                .foregroundColor(self.style.textColor)
                    }
                    Spacer()
                    Image(systemName: "chart.pie.fill")
                            .imageScale(.large)
                            .foregroundColor(self.style.legendTextColor)
                }.padding()
                PieChartRow(data: data, backgroundColor: self.style.backgroundColor, accentColor: self.style.accentColor, highlightedIdx: $highlightedIdx)
                        .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y: self.legend != nil ? 0 : -10)
                if (self.legend != nil) {
                    Text(self.legend!)
                            .font(.headline)
                            .foregroundColor(self.style.legendTextColor)
                            .padding()
                }

            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#if DEBUG
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(data: PreviewData.getPieSliceData(), title: "Title", legend: "Legend")
    }
}
#endif
