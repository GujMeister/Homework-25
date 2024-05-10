//
//  MusicPlayerVC + Helper Functions.swift
//  Animations
//
//  Created by Luka Gujejiani on 11.05.24.
//

import UIKit

// MARK: - Helper functions that NEED UIKit like water
extension MusicPlayerVC {
    func deselectAllButtons(except selectedButton: UIButton) {
        homeButton.isSelected = false
        resetButtonSize(homeButton)
        
        musicButton.isSelected = false
        resetButtonSize(musicButton)
        
        loveButton.isSelected = false
        resetButtonSize(loveButton)
    }
    
    func resetButtonSize(_ button: UIButton?) {
        guard let button = button else { return }
        UIView.animate(withDuration: 0.3) {
            button.transform = .identity
            button.tintColor = .white
        }
    }

    func toggleSliderTimer() {
        sliderTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeSlider.value < self.timeSlider.maximumValue {
                self.timeSlider.value += 1.0
                self.updateLabelsForMusicPlaying()
            }
        }
    }

    func stopSliderTimer() {
        sliderTimer?.invalidate()
        sliderTimer = nil
    }
}
