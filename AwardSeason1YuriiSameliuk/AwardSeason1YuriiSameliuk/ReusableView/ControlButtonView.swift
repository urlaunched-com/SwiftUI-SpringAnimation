//
//  ControlButtonView.swift
//  AwardSeason1YuriiSameliuk
//
//  Created by Yurii Sameliuk on 01/10/2021.
//

import SwiftUI

struct ControlButtonView: View {
    let image: Image
    let action: () -> ()
    
    var body: some View {
        Button(action: action) {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.black)
                        .opacity(0.5)
                )
        }
        .foregroundColor(.white)
        .buttonStyle(PlainButtonStyle())
    }
}

struct ControlButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ControlButtonView(image: Image(""), action: {})
        }
    }
}
