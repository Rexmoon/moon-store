//
//  AreaChart.swift
//  moon-store-mac-os
//
//  Created by Steven Santeliz on 10/1/25.
//

import SwiftUI
import Charts

private enum Constants {
    static let colorOpacity: CGFloat = 0.4
}

struct AreaChart: View {
    private let title: String?
    private let data: [ChartData]
    private let color: Color
    private let titleAlignment: HorizontalAlignment
    
    init(title: String? = nil,
         data: [ChartData],
         color: Color = .accentColor,
         titleAlignment: HorizontalAlignment = .leading) {
        self.title = title
        self.data = data
        self.color = color
        self.titleAlignment = titleAlignment
    }
    
    var body: some View {
        VStack(alignment: titleAlignment) {
            if let title, data.isNotEmpty {
                Text(title).bold()
            }
            
            Chart {
                ForEach(data) { item in
                    LineMark(x: .value("Name", item.name),
                             y: .value("Value", item.value))
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(color)
                .symbol(by: .value("Name", "Value"))
                
                ForEach(data) { item in
                    AreaMark(x: .value("Name", item.name),
                             y: .value("Value", item.value))
                }
                .interpolationMethod(.cardinal)
                .foregroundStyle(linearGradient)
            }
            .chartLegend(.hidden)
        }
    }
    
    private var linearGradient: LinearGradient {
        LinearGradient(
            colors: [color.opacity(Constants.colorOpacity), .clear],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
