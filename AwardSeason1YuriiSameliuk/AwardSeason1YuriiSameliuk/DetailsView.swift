//
//  DetailsView.swift
//  AwardSeason1YuriiSameliuk
//
//  Created by Yurii Sameliuk on 29/09/2021.
//

import SwiftUI
import AVKit

struct DetailsView: View {
    let model: Model
    var nameSpace: Namespace.ID
    var player: AVPlayer?
    @Binding var isShowDetails: Bool
    
    @State private var isMuted: Bool = true
    @State private var showPlayIcon: Bool = false
    @State private var appearDescription: Bool = false
    @State private var isFavorite: Int = 0
    @State private var offset: CGFloat = 0
    
    let maxHeight = UIScreen.main.bounds.height / 1.3
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                GeometryReader { proxy  in
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            headerView
                            titleAndDescriptionView
                                .padding(.bottom, 10)
                            if appearDescription {
                                descriptionView
                                    .transition(.scale)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal, 20)
                        ZStack(alignment: .bottom) {
                            Group {
                                if let image = model.image {
                                    Image(image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(minWidth: 200, minHeight: 300,alignment: .top)
                                } else {
                                    VideoView(previewLength: Double(model.duration), player: player!)
                                        .frame(minWidth: 200, minHeight: 300)
                                }
                            }
                            .matchedGeometryEffect(id: "image\(model.id)", in: nameSpace)
                            .overlay(
                                controlView
                                    .padding(.bottom, 10)
                                , alignment: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .clipped()
                        }
                    }
                    .background(Color.black)
                }
                .frame(height: maxHeight)
                
                VStack(spacing: 0) {
                    ForEach(0..<15, id: \.self) { i in
                        HStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: 45, height: 45)
                            
                            VStack(alignment: .leading,spacing: 0) {
                                Text("Test")
                                    .foregroundColor(.white)
                                Text("Test Test Test")
                                    .lineLimit(1)
                            }
                            .frame(width: 140)
                            
                            Spacer()
                            Button(action: {
                                
                                isFavorite = i
                                
                            }
                            ) {
                                Image.heart
                                    .renderingMode(.template)
                                    .foregroundColor(isFavorite == i ? .red : .gray)
                            }
                            
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                Image.threeDot
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                .foregroundColor(Color.gray)
            }
            .modifier(OffsetModifier(offset: $offset))
        }
        .coordinateSpace(name: "Scroll")
        .foregroundColor(.white)
        .background(
            Color.black.edgesIgnoringSafeArea(.all)
        )
        .onAppear(perform: {
            player?.play()
            withAnimation(.hero) {
                appearDescription.toggle()
            }
        })
        .onDisappear(perform: {
            player?.pause()
        })
    }
}

private extension DetailsView {
    var headerView: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowDetails.toggle()
                    }
                } ) {
                    Image.chevron
                        .font(.title3)
                        .background(Color.white.opacity(0.01))
                        .frame(width: 44, height: 44,alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())
                .background(Color.white.opacity(0.01))
                .frame(width: 44, height: 44,alignment: .leading)
                Spacer()
            }
            .padding(.top, 10)
            
            VStack(spacing: 0) {
                Image(model.avatar)
                    .resizable()
                    .matchedGeometryEffect(id: "avatar\(model.id)", in: nameSpace)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(3)
                    .background(
                        Circle()
                            .stroke(Color.white,lineWidth: 0.5)
                    )
                    .overlay(
                        Image.plusCircle
                            .matchedGeometryEffect(id: "plus\(model.id)", in: nameSpace)
                        , alignment: .bottomTrailing)
                    .padding(.bottom, 6)
                
                Text(model.name)
                    .fontWeight(.bold)
                    .matchedGeometryEffect(id: "name\(model.id)", in: nameSpace)
                    .padding(.bottom, 2)
                
                Text(model.date)
                    .font(.caption2)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .matchedGeometryEffect(id: "date\(model.id)", in: nameSpace)
            }
        }
        .font(.caption)
        .foregroundColor(.white)
    }
}

private extension DetailsView {
    var titleAndDescriptionView: some View {
        VStack(spacing: 10) {
            Text(model.title)
                .font(.title)
                .fontWeight(.black)
            HStack(spacing: 10) {
                Label(
                    title: { Text(model.like) },
                    icon: { Image.handThumbsup })
                if model.image == nil {
                    Circle()
                        .frame(width: 4, height: 4)
                    
                    Label(
                        title: { Text("\(model.duration) sec") },
                        icon: { Image.stopwatch })
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
        }
        .foregroundColor(.white)
    }
}

private extension DetailsView {
    var descriptionView: some View {
        Text(model.description)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private extension DetailsView {
    var controlView: some View {
        ZStack {
            VStack(alignment: .trailing,spacing: 0) {
                if model.video != nil {
                    Button(action: {
                        isMuted.toggle()
                        isMuted ? (player?.isMuted = true) : (player?.isMuted  = false)
                    }) {
                        Group {
                            isMuted ? Image.speakerSlash : Image.speakerWave
                        }
                        .foregroundColor(.white.opacity(0.8))
                        .background(Color.white.opacity(0.01))
                        .frame(width: 44, height: 44, alignment: .bottomTrailing)
                    }
                    .background(Color.white.opacity(0.01))
                    .frame(width: 44, height: 44, alignment: .bottomTrailing)
                    .padding(.trailing, 5)
                }
                HStack(spacing: 15) {
                    ControlButtonView(image: .arrowDown, action: {})
                    ControlButtonView(image: .slashCircle, action: {})
                    
                    if model.video != nil {
                        Button(action: {
                            withAnimation {
                                showPlayIcon.toggle()
                            }
                            
                            if showPlayIcon {
                                player?.pause()
                            } else {
                                player?.play()
                            }
                            
                        }) {
                            Group {
                                showPlayIcon ? Image.playCircle : Image.pauseCircle
                            }
                            .font(.system(size: 50, weight: .thin))
                        }
                    }
                    
                    ControlButtonView(image: .handThumbsup, action: {})
                    
                    ControlButtonView(image: .threeDot, action: {})
                }
                
            }
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.white)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).edgesIgnoringSafeArea(.all)
            DetailsView(model:  Model(id: 1,
                                      avatar: "mode2",
                                      image: "model4",
                                      title: "HOTTEST BIKINI",
                                      date: "22.01.2020",
                                      name: "Designer Fashion",
                                      like: "1890",
                                      duration: 0,
                                      description: "Boldest Bikini, Swimwear, and Bathing Suits Compilatio.! Runway Models in the most beautiful bathing suits of the latest Miami Fashion Week shows. This is a selection of designer swimwear curated from many shows. You'll be able to spot with your clever eye changes in trends from 2019 to 2020 collections. Enjoy the show!",
                                      video: URL(fileURLWithPath: "")) ,
                        nameSpace: Namespace().wrappedValue,
                        isShowDetails: .constant(false))
        }
    }
}
