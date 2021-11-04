//
//  PlayerView.swift
//  AwardSeason1YuriiSameliuk
//
//  Created by Yurii Sameliuk on 01/10/2021.
//

import SwiftUI
import UIKit
import AVFoundation
import AVKit

class PlayerView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var previewTimer: Timer?
    private var player: AVPlayer?
    var previewLength:Double
    
    init(frame: CGRect, previewLength:Double, player: AVPlayer) {
        self.previewLength = previewLength
        super.init(frame: frame)
        self.player = player
        player.isMuted = true
        player.volume = 20
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.backgroundColor = UIColor.black.cgColor
        
        previewTimer = Timer.scheduledTimer(withTimeInterval: previewLength, repeats: true, block: { (timer) in
            player.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(1)))
        })
        
        layer.addSublayer(playerLayer)
    }
    required init?(coder: NSCoder) {
        self.previewLength = 15
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}


struct VideoView: UIViewRepresentable {
    var previewLength: Double?
    var player: AVPlayer
    
    func makeUIView(context: Context) -> UIView {
        return PlayerView(frame: .zero, previewLength: previewLength ?? 15, player: player)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

