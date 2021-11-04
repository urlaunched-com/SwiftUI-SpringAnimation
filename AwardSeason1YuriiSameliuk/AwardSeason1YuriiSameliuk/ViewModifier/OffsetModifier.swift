//
//  OffsetModifier.swift
//  AwardSeason1YuriiSameliuk
//
//  Created by Yurii Sameliuk on 01/10/2021.
//

import SwiftUI

struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .named("Scroll")).minY
                    DispatchQueue.main.async {
                        print(minY)
                        self.offset = minY
                    }
                    return Color.clear
                }
                , alignment: .top)
    }
}
