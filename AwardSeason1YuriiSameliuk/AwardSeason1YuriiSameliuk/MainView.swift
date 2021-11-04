//
//  MainView.swift
//  AwardSeason1YuriiSameliuk
//
//  Created by Yurii Sameliuk on 29/09/2021.
//

import SwiftUI
import AVKit

struct MainView: View {
    @State private var gridLayout: [GridItem]  = [GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 10)]
    @State private var gridColumn: Int = 1
    @State private var isDetailsShow: Bool = false
    @State private var isPortrait: Bool?
    @State var isPresented = false
    @State private var selectedItem: Model? = nil
    @State private var isDetails: Bool = false
    
    @Namespace private var nameSpace
    
    var body: some View {
        ZStack {
           // if !isDetailsShow {
            VStack {
                navBarView
                    
                    .padding(.top, 20)
                Spacer()
        
               ScrollView(.vertical, showsIndicators: false) {
                ScrollViewReader { reader in
                    LazyVGrid(columns: gridLayout, alignment: .center, spacing: 10) {
                        ForEach(dataModel) { model in
                            CardView(model: model, nameSpace: nameSpace, player: AVPlayer(url: model.video ?? URL(fileURLWithPath: "")), isShow: $isDetailsShow)
                                    .id(model.id)
                                    .onTapGesture(perform: {
                                        tapThumbnail(model)
                                
                                    })
                                .padding(.vertical, 10)
                        }
                    }
               }
                }
            }
            .padding(.horizontal, 20)
           
           // }
            
            if isDetailsShow {
                Color.clear.overlay(
                    DetailsView(model: selectedItem!, nameSpace: nameSpace, player: AVPlayer(url: selectedItem?.video ?? URL(fileURLWithPath: "")), isShowDetails: $isDetailsShow.animation(.spring()))
               )
                .zIndex(3)
                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                //.ignoresSafeArea(.all, edges: .top)
            }
        }
    }
    
    func tapThumbnail(_ item: Model) {
        //withAnimation(.easeOut) {
        withAnimation(.spring()) {
                self.selectedItem = item
                isDetailsShow.toggle()
        }
    }
}

private extension MainView {
    var navBarView: some View {
        HStack {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Image.lineHorizontal
                    .font(.system(size: 25))
            }
            .padding(.trailing, 20)
            
            HStack(alignment: .center,spacing: 2) {
                Text("Featured")
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .bold()
                
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/)  {
                    Image.arrowtriangleDown
                        .font(.system(size: 7))
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                HStack(spacing: 0) {
                    Image.rectangleGrid
                        .foregroundColor(.gray)
                    Image.rectanglePortrait
                }
            }
            
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Image.magnifyingglass
                    .font(.system(size: 18, weight: .semibold))
            }
        }
        .foregroundColor(.white)
        .buttonStyle(PlainButtonStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension Animation {
    
    static var hero: Animation { .interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.25)
    }
}
