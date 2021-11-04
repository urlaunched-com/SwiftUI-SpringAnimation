//
//  CardView.swift
//  AwardSeason1YuriiSameliuk
//
//  Created by Yurii Sameliuk on 29/09/2021.
//

import SwiftUI
import AVKit

struct CardView: View {
    let model: Model
    var nameSpace: Namespace.ID
    var player: AVPlayer?
    @Binding var isShow: Bool
    
    @State private var showPlayIcon: Bool = false
    @State private var isMuted: Bool = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if let player = self.player {
                    VideoView(previewLength: 10, player: player)
                        //.matchedGeometryEffect(id: "video\(model.id)", in: nameSpace)
                        .frame(minWidth: 300, minHeight: 400)
                }
                
                if let image = model.image {
                    Image(image)
                        .resizable()
                        //.matchedGeometryEffect(id: "image\(model.id)", in: nameSpace)
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 300, minHeight: 400)
                }
            }
            .matchedGeometryEffect(id: "image\(model.id)", in: nameSpace)
            //.scaleEffect(CGSize(width: isShow ? 10 : 1, height: isShow ? 10 : 1.0), anchor: .center)
           // .frame(minWidth: isShow ? UIScreen.main.bounds.width : 300, minHeight: isShow ? UIScreen.main.bounds.height : 400)
            
            VStack(spacing: 40) {
                headerView
                
                titleAndDescriptionView
                
                Spacer()
                
                controlView
            }
            .padding(20)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: Color.black.opacity(0.7), radius: 3, x: 0, y: 2)
        .onAppear(perform: {
            player?.play()
           if isShow {
                player?.pause()
            }
        })
        .onDisappear(perform: {
            player?.pause()
        })
    }
}

private extension CardView {
    var headerView: some View {
        HStack(spacing: 10) {
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
            
            VStack(alignment: .leading, spacing: 2) {
                Text(model.name)
                    .fontWeight(.bold)
                    .matchedGeometryEffect(id: "name\(model.id)", in: nameSpace)
                Text(model.date)
                    .font(.caption2)
                    .fontWeight(.light)
                    .matchedGeometryEffect(id: "date\(model.id)", in: nameSpace)
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: {}) {
                Image.plusCircle
                    .font(.system(size: 35, weight: .bold))
                    .matchedGeometryEffect(id: "plus\(model.id)", in: nameSpace)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .font(.caption)
        .foregroundColor(.white)
    }
}

private extension CardView {
    var titleAndDescriptionView: some View {
        VStack(spacing: 10) {
            Text(model.title)
                .font(.title)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
            HStack(alignment: .lastTextBaseline ,spacing: 10) {
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

private extension CardView {
    var controlView: some View {
        ZStack(alignment:.trailing) {
            HStack(spacing: 15) {
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
            }
            .frame(maxWidth: .infinity)
            
            if model.video != nil {
                Button(action: {
                    isMuted.toggle()
                    isMuted ? (player?.isMuted = true) : (player?.isMuted  = false)
                }) {
                    Group {
                        isMuted ? Image.speakerSlash : Image.speakerWave
                    }
                    .foregroundColor(.white.opacity(0.6))
                    .background(Color.white.opacity(0.01))
                    .frame(width: 44, height: 44)
                }
                .background(Color.white.opacity(0.01))
                .frame(width: 44, height: 44)
            }
            
        }
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.white)
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).edgesIgnoringSafeArea(.all)
            CardView(model: Model(id: 2,
                                  avatar: "mode2",
                                  image: "model3",
                                  title: "HOTTEST BIKINI",
                                  date: "22.01.2020",
                                  name: "Designer Fashion",
                                  like: "1890",
                                  duration: 0,
                                  description: "Boldest Bikini, Swimwear, and Bathing Suits Compilatio.! Runway Models in the most beautiful bathing suits of the latest Miami Fashion Week shows. This is a selection of designer swimwear curated from many shows. You'll be able to spot with your clever eye changes in trends from 2019 to 2020 collections. Enjoy the show!",
                                  video: nil),
                     nameSpace: Namespace().wrappedValue,
                     player: AVPlayer(), isShow: .constant(false))
        }
    }
}
