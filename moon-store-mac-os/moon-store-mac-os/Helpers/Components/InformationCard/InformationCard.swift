//
//  InformationCard.swift
//  moon-store-mac-os
//
// Created by Jose Luna on 6/1/25.
//

import SwiftUI

struct InformationCard: View {
    private typealias Constants = InformationCardConstants
    private let info: CardGraphicModel
    
    init(info: CardGraphicModel) {
        self.info = info
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.titleSpacing) {
            header
            
            Text(info.description)
                .font(.caption)
        }
        .padding()
        .background(backgroundShapes)
        .background(info.color)
        .foregroundStyle(.msWhite)
        .clipShape(.rect(cornerRadius: Constants.cornerRadius))
    }
    
    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: Constants.headerSpacing) {
                Text(info.title)
                    .font(.headline)
                
                Text(info.count.description)
                    .font(.title.bold())
            }
            .leadingInfinity()
            
            Image(systemName: info.iconName)
                .resizable()
                .scaledToFit()
                .frame(square: Constants.iconSize)
                .padding(Constants.iconPadding)
                .background(
                    LinearGradient(
                        colors: [.clear, .msWhite.opacity(Constants.gradientOpacity)],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                    .clipShape(.rect(cornerRadius: Constants.cornerRadius))
                )
                .overlay {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(.msWhite)
                }
        }
    }
    
    var backgroundShapes: some View {
        ZStack(alignment: .bottomLeading) {
            Circle()
                .fill(.msGray.opacity(Constants.smallCircleOpacity))
                .frame(square: Constants.smallCircleSize)
                .offset(x: Constants.smallCircleOffsetX, y: Constants.smallCircleOffsetY)
            
            Circle()
                .fill(.msGray.opacity(Constants.largeCircleOpacity))
                .frame(square: Constants.largeCircleSize)
                .offset(x: Constants.largeCircleOffsetX, y: Constants.largeCircleOffsetY)
        }
        .leadingInfinity()
    }
}
