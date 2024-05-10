//
//  MusicPlayerVC.swift
//  Animations
//
//  Created by Luka Gujejiani on 10.05.24.
//

import UIKit

class MusicPlayerVC: UIViewController {
    
    var viewModel: MusicPlayerVM = MusicPlayerVM()
    
    private var sliderTimer: Timer?
//    private var isMusicPlaying: Bool = true
    var selectedIcon: UIButton?
    
    private let albumImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "MC")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .secondarySystemBackground
        image.layer.cornerRadius = 21
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.text = "Kickstart My Heart"
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "Mötley Crüe"
        return label
    }()
    
    private lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 282 //4 min 42 sec in seconds
        slider.addAction(UIAction(handler: { [weak self] _ in
            self?.sliderValueChanged(slider)
        }), for: .touchUpInside)
        return slider
    }()
    
    private let timeElapsedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.text = "---"
        return label
    }()
    
    private let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.text = "---"
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle.fill")
        button.createButton(with: image!)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.playButtonTapped(button)
        }), for: .touchUpInside)
        return button
    }()
    
    private let dockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "637E61")
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "house")
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white // Adjust the color as needed
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleIconButtonTap(sender: button)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var musicButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "music.note")
        button.setImage(image, for: .normal)
        button.isSelected = true
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleIconButtonTap(sender: button)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var loveButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleIconButtonTap(sender: button)
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.setUpdateImageClosure { [weak self] transform in
            self?.albumImageView.transform = transform
        }
    }
    
    // MARK: - Setup UI
    func setupUI() {
        setupDockView()
        
        let views = [albumImageView, songNameLabel, albumNameLabel, timeSlider, playButton, timeElapsedLabel, timeLeftLabel, dockView]
        
        views.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.backgroundColor = UIColor(hex: "4C604D")
        
        NSLayoutConstraint.activate([
            albumImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            albumImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 6),
            albumImageView.widthAnchor.constraint(equalTo: view.widthAnchor , multiplier: 0.88),
            albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor),
            
            songNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            songNameLabel.topAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 20),
            
            albumNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 1),
            albumNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            timeSlider.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            timeSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            timeElapsedLabel.leadingAnchor.constraint(equalTo: timeSlider.leadingAnchor),
            timeElapsedLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 1),
            
            timeLeftLabel.trailingAnchor.constraint(equalTo: timeSlider.trailingAnchor),
            timeLeftLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 1),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 10),
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            
            dockView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dockView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            dockView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            dockView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupDockView() {
        [homeButton, musicButton, loveButton].forEach { button in
            dockView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalTo: dockView.heightAnchor, multiplier: 0.4).isActive = true
            button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: dockView.centerYAnchor, constant: -5).isActive = true
        }
        
        NSLayoutConstraint.activate([
            homeButton.leadingAnchor.constraint(equalTo: dockView.leadingAnchor, constant: 30),
            musicButton.centerXAnchor.constraint(equalTo: dockView.centerXAnchor),
            loveButton.trailingAnchor.constraint(equalTo: dockView.trailingAnchor, constant: -30),
        ])
    }
    
    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 15)
        ])
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            UIView.animate(withDuration: 0.2) {
                self.albumImageView.transform = .identity
            }
        }
    }
    
    //MARK: - Choosing Icon Buttons Logic
    func handleIconButtonTap(sender: UIButton) {
        print("Icon button tapped")
        deselectAllButtons(except: sender)
        sender.isSelected = true
        sender.tintColor = .yellow
        
        let scaleFactor: CGFloat = 1.3
        sender.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
    }
    
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
        button.transform = .identity
        button.tintColor = .white
    }
    
    // MARK: - Slider values and Label
    func sliderValueChanged(_ slider: UISlider) {
        let elapsedSeconds = Int(slider.value)
        timeElapsedLabel.text = viewModel.formatSecondsToString(elapsedSeconds)
        
        let totalSeconds = Int(slider.maximumValue)
        let secondsLeft = totalSeconds - elapsedSeconds
        timeLeftLabel.text = viewModel.formatSecondsToString(secondsLeft)
    }
    
//    func formatSecondsToString(_ seconds: Int) -> String {
//        let minutes = seconds / 60
//        let remainingSeconds = seconds % 60
//        return String(format: "%02d:%02d", minutes, remainingSeconds)
//    }
    
    // MARK: - Play button Functions
    
    func playButtonTapped(_ sender: UIButton) {
      viewModel.playButtonTapped()
      print(viewModel.isMusicPlaying)
      if viewModel.isMusicPlaying {
        print("Hello I'm in MUSIC IS PLAYING!")
        playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        toggleSliderTimer()
        setupActivityIndicator()
      } else {
        print("Hello I'm in !isMusicPlaying")
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        stopSliderTimer()
        UIView.animate(withDuration: 0.2) {
          self.albumImageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        }
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

// MARK: - Updating Labels
extension MusicPlayerVC {
    func updateLabelsForMusicPlaying() {
        let elapsedSeconds = Int(timeSlider.value)
        timeElapsedLabel.text = viewModel.formatSecondsToString(elapsedSeconds)
        
        let totalSeconds = Int(timeSlider.maximumValue)
        let secondsLeft = totalSeconds - elapsedSeconds
        timeLeftLabel.text = viewModel.formatSecondsToString(secondsLeft)
    }
}


#Preview {
    MusicPlayerVC()
}


//func playButtonTapped(_ sender: UIButton) {
////        viewModel.playButtonTapped()
//    print(isMusicPlaying)
//    if isMusicPlaying {
//        print("Hello I'm in MUSIC IS PLAYING!")
//        playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
//        toggleSliderTimer()
//        isMusicPlaying = false
//        
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(activityIndicator)
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
//            activityIndicator.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 15)
//        ])
//        activityIndicator.startAnimating()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            activityIndicator.stopAnimating()
//            activityIndicator.removeFromSuperview()
//            
//            UIView.animate(withDuration: 0.2) {
//                self.albumImageView.transform = .identity
//            }
//        }
//    
//    } else {
//        print("Hello I'm in !isMusicPlaying")
//        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
//        stopSliderTimer()
//        isMusicPlaying = true
//        
//        UIView.animate(withDuration: 0.2) {
//            self.albumImageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
//        }
//    }
//}



//    func playButtonTapped(_ sender: UIButton) {
//        viewModel.playButtonTapped()
//        print(viewModel.isMusicPlaying)
//        if viewModel.isMusicPlaying {
//            print("Hello I'm in MUSIC IS PLAYING!")
//            playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
//            toggleSliderTimer()
//
//            let activityIndicator = UIActivityIndicatorView(style: .medium)
//            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(activityIndicator)
//            NSLayoutConstraint.activate([
//                activityIndicator.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
//                activityIndicator.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: 15)
//            ])
//            activityIndicator.startAnimating()
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                activityIndicator.stopAnimating()
//                activityIndicator.removeFromSuperview()
//
//                UIView.animate(withDuration: 0.2) {
//                    self.albumImageView.transform = .identity
//                }
//            }
//
//        } else {
//            print("Hello I'm in !isMusicPlaying")
//            playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
//            stopSliderTimer()
//
//            UIView.animate(withDuration: 0.2) {
//                self.albumImageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
//            }
//        }
//    }
    
