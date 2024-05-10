//
//  MusicPlayerVM.swift
//  Animations
//
//  Created by Luka Gujejiani on 10.05.24.
//

import Foundation

class MusicPlayerVM {
    var isMusicPlaying: Bool = false
    
    func playButtonTapped() {
        isMusicPlaying.toggle()
    }
    
    func updateImageTransform(isExpanded: Bool) {
        let scaleFactor = isExpanded ? 0.65 : 1.0
        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        updateImageClosure?(transform)
    }
    
    private var updateImageClosure: ((CGAffineTransform) -> Void)?
    
    func setUpdateImageClosure(_ closure: @escaping (CGAffineTransform) -> Void) {
        updateImageClosure = closure
    }
    
    func formatSecondsToString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
