//
//  MusicPlayerVC.swift
//  Animations
//
//  Created by Luka Gujejiani on 10.05.24.
//

import UIKit

class MusicPlayerVC: UIViewController {
    
    private var viewModel: MusicPlayerVM = MusicPlayerVM()
    
    internal var sliderTimer: Timer?
    private var selectedIcon: UIButton?
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "FiraGO-Regular", size: 12)
        label.text = "Liked Songs"
        return label
    }()
    
    private let albumImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "MC")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 22
        image.layer.masksToBounds = true
        return image
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "FiraGO-Bold", size: 24)
        label.text = "Kickstart My Heart"
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "FiraGO-Regular", size: 18)
        label.text = "Mötley Crüe"
        return label
    }()
    
    internal lazy var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor.white
        slider.minimumValue = 0
        slider.maximumValue = 282 //4 min 42 sec in seconds
        slider.addAction(UIAction(handler: { [weak self] _ in
            self?.sliderValueChanged(slider)
        }), for: .touchUpInside)
    
        let configuration = UIImage.SymbolConfiguration(pointSize: 12)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
        let whiteImage = image?.withTintColor(.white, renderingMode: .alwaysOriginal)
        slider.setThumbImage(whiteImage, for: .normal)
        
        return slider
    }()
    
    private let timeElapsedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "FiraGO-Regular", size: 10)
        label.text = "00:00"
        return label
    }()
    
    private let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "FiraGO-Regular", size: 10)
        label.text = "4:42"
        return label
    }()

    //Controls
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle.fill")
        button.createButton(with: image!)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.playButtonTapped(button)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "forward.end.fill")
        button.createButton(with: image!)
        return button
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "backward.end.fill")
        button.createButton(with: image!)
        return button
    }()
    
    private lazy var repeatbutton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "repeat")
        button.createButton(with: image!)
        return button
    }()
    
    private lazy var shuffleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "shuffle")
        button.createButton(with: image!)
        return button
    }()
    
    //Dockview and Buttons
    private let dockView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "637E61")
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
     internal lazy var homeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "house")
        button.setImage(image, for: .normal)
        button.createButton(with: image!)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleIconButtonTap(sender: button)
        }), for: .touchUpInside)
        return button
    }()
    
    internal lazy var musicButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "music.note")
        button.setImage(image, for: .normal)
        button.createButton(with: image!)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleIconButtonTap(sender: button)
        }), for: .touchUpInside)
        return button
    }()
    
    internal lazy var loveButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.createButton(with: image!)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.handleIconButtonTap(sender: button)
        }), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.isNavigationBarHidden = true
        albumImageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        handleIconButtonTap(sender: musicButton)
        viewModel.setUpdateImageClosure { [weak self] transform in
            self?.albumImageView.transform = transform
        }
    }
    
    // MARK: - Setup UIs
    func setupUI() {
        setupDockView()
        
        let views = [categoryLabel, albumImageView, songNameLabel, albumNameLabel, timeSlider, playButton, timeElapsedLabel, timeLeftLabel, forwardButton, backwardButton, repeatbutton, shuffleButton, dockView]
        
        views.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        view.backgroundColor = UIColor(hex: "4C604D")
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            
            timeElapsedLabel.leadingAnchor.constraint(equalTo: timeSlider.leadingAnchor, constant: 2),
            timeElapsedLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 5),
            
            timeLeftLabel.trailingAnchor.constraint(equalTo: timeSlider.trailingAnchor, constant: -2),
            timeLeftLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 5),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 20),
            playButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            
            forwardButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20),
            forwardButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            forwardButton.heightAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 0.45),
            forwardButton.widthAnchor.constraint(equalTo: forwardButton.heightAnchor),
            
            backwardButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -20),
            backwardButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            backwardButton.heightAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 0.45),
            backwardButton.widthAnchor.constraint(equalTo: backwardButton.heightAnchor),
            
            shuffleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            shuffleButton.heightAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 0.35),
            shuffleButton.widthAnchor.constraint(equalTo: shuffleButton.heightAnchor),
            shuffleButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            
            repeatbutton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repeatbutton.heightAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 0.35),
            repeatbutton.widthAnchor.constraint(equalTo: repeatbutton.heightAnchor),
            repeatbutton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            
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
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -15)
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
    
    //MARK: - Choosing Icon Buttons
    func handleIconButtonTap(sender: UIButton) {
        print("Dock icon tapped")
        deselectAllButtons(except: sender)
        sender.isSelected = true
        sender.tintColor = .yellow
        
        UIView.animate(withDuration: 0.2) {
            let scaleFactor: CGFloat = 1.5
            sender.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
    }
    
    // MARK: - Slider values and Label
    func sliderValueChanged(_ slider: UISlider) {
        let elapsedSeconds = Int(slider.value)
        timeElapsedLabel.text = viewModel.formatSecondsToString(elapsedSeconds)
        
        let totalSeconds = Int(slider.maximumValue)
        let secondsLeft = totalSeconds - elapsedSeconds
        timeLeftLabel.text = viewModel.formatSecondsToString(secondsLeft)
    }

    // MARK: - Play button Functions
    func playButtonTapped(_ sender: UIButton) {
      viewModel.playButtonTapped()
      print(viewModel.isMusicPlaying)
      if viewModel.isMusicPlaying {
        print("LETS PLAY DA MUSICCC YEEEEEEEEEEEEEEAH")
        playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        toggleSliderTimer()
        setupActivityIndicator()
      } else {
        print("OKAY EVERYONE PARTY IS OVER GO HOME")
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        stopSliderTimer()
        UIView.animate(withDuration: 0.2) {
          self.albumImageView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
        }
      }
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
