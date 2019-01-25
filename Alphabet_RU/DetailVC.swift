//
//  DetailVC.swift
//  Alphabet_RU
//
//  Created by Svetlana Lesik on 14/12/2018.
//  Copyright © 2018 Svetlana Lesik. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class DetailVC: UIViewController {
    
    var index: Int = -1
    var audioPlayer: AVAudioPlayer?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    } ()
    
    let labelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textColor = UIColor(rgb: 0x834652, a: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        return (label)
    } ()

    convenience init() {
        self.init(index: -1)
    }
    
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve // type of VC animation
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.colors = [UIColor(rgb: 0xA1D6E2, a: 0.4).cgColor, UIColor(rgb: 0x1995AD, a: 0.4).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        showLetter()
        addBackButton()
        addSoundButton()
        addAnimalButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // add a save areas' origin (by its tag) to Y top position of buttons
    override func viewSafeAreaInsetsDidChange() {
        if let backButton: UIButton = self.view.viewWithTag(42) as? UIButton {
            backButton.frame.origin.y += self.view.safeAreaInsets.top
        }
        if let soundButton: UIButton = self.view.viewWithTag(21) as? UIButton {
            soundButton.frame.origin.y -= self.view.safeAreaInsets.bottom
        }
        if let animalButton: UIButton = self.view.viewWithTag(1) as? UIButton {
            animalButton.frame.origin.y -= self.view.safeAreaInsets.bottom
        }
        if let animalLabel: UIButton = self.view.viewWithTag(2) as? UIButton {
            animalLabel.frame.origin.y -= self.view.safeAreaInsets.bottom
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.backgroundColor = .white
    }
    
    func setImage(_ imageView: UIImageView) {
        let width = UIScreen.main.bounds.width * 0.80
        let height = UIScreen.main.bounds.height * 0.80
        let x = UIScreen.main.bounds.origin.x + ((UIScreen.main.bounds.width - width) / 2)
        let y = UIScreen.main.bounds.origin.y + ((UIScreen.main.bounds.height - height) / 2.5)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)

        view.addSubview(imageView)
    }
    
    func setLabel(_ labelView: UILabel) {
        let height = UIScreen.main.bounds.height * 0.90
        
        labelView.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: UIScreen.main.bounds.size)
        labelView.font = UIFont(name: "Nord-Bold", size: height - (height * 0.65))
        
        view.addSubview(labelView)
    }
    
    func showAnimalName() {
        let animalLabel: UILabel = {
            let height = view.bounds.height * 0.08
            let y = view.bounds.height - (height * 2.80)
            let label = UILabel(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height))
            
            label.tag = 2
            label.textColor = UIColor(rgb: 0xF78733, a: 0.7)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont(name: "Nord-Regular", size: (label.frame.size.height - (height * 0.09)))
            label.text = "\(animalNamesRu[self.index])"
            
            // Change 1st letters' color
            accentColor(label)
            return label
        }()
        self.view.addSubview(animalLabel)
    }
    
    func showLetter() {
        labelView.text = lettersMax[index]
        setLabel(_: labelView)
    }
    
    func accentColor(_ label: UILabel){
        var accentLetter = NSMutableAttributedString()
        let height = view.bounds.height * 0.08
        
        accentLetter = NSMutableAttributedString(string: label.text!, attributes: [NSAttributedString.Key.font:UIFont(name: "Nord-Regular", size:(label.frame.size.height - (height * 0.09)))!])
        
        // condition for letters "ъ", "ы" & "ь"
        if (30 > self.index) && (self.index > 26) {
            if self.index == 27 {
                accentLetter.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(rgb: 0x76323F, a: 0.7), range: NSRange(location: 2, length: 1))
            } else if self.index == 28 {
                accentLetter.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(rgb: 0x76323F, a: 0.7), range: NSRange(location: 1, length: 1))
            } else if self.index == 29 {
                accentLetter.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(rgb: 0x76323F, a: 0.7), range: NSRange(location: 6, length: 1))
            }
        } else {
            accentLetter.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(rgb: 0x76323F, a: 0.7), range: NSRange(location: 0, length: 1))
        }
        label.attributedText = accentLetter
    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func soundButtonTapped() {
        guard let url = Bundle.main.url(forResource: "\(self.index)", withExtension: "mp3", subdirectory: "Sounds/ListenIt") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let audioPlayer = audioPlayer else { return }

            audioPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func animalButtonTapped() {
        labelView.isHidden = true
        
        // show an animal image
        imageView.image = UIImage(named: "SeeIt/\(self.index)")
        setImage(_: imageView)
        
        // show an animal name
        showAnimalName()
        
        // Start word pronunciation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { // delay of sound
            guard let url = Bundle.main.url(forResource: "\(self.index)", withExtension: "mp3", subdirectory: "Sounds/TryIt") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
                
                self.audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                guard let audioPlayer = self.audioPlayer else { return }
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addBackButton() {
        let backButton: UIButton = UIButton(type: .custom)
        let width = view.bounds.width * 0.30
        let height = view.bounds.height * 0.07
        
        backButton.tag = 42
        backButton.translatesAutoresizingMaskIntoConstraints = true
        backButton.frame = CGRect(x: 20, y: 20, width: width, height: height)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Beautiful Things", size: backButton.frame.height)
        backButton.backgroundColor = UIColor(red: 0/255, green: 156/255, blue: 204/255, alpha: 0.5)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.cornerRadius = backButton.frame.height * 0.25
        backButton.layer.masksToBounds = true
        backButton.addTarget(self, action: #selector(DetailVC.backButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(backButton)
    }
    
    func addSoundButton(){
        let soundButton: UIButton = UIButton(type: .custom)
        let width = view.bounds.width * 0.40
        let height = view.bounds.height * 0.08
        
        soundButton.tag = 21
        soundButton.translatesAutoresizingMaskIntoConstraints = true
        soundButton.frame = CGRect(x: 20, y: (view.bounds.height - height) - 20, width: width, height: height)
        soundButton.setTitle("Listen it", for: .normal)
        soundButton.titleLabel?.font = UIFont(name: "Beautiful Things", size: soundButton.frame.height)
        soundButton.contentVerticalAlignment = .center
        soundButton.contentHorizontalAlignment = .center
        soundButton.backgroundColor = UIColor(rgb: 0x4ABDAC, a: 0.7)
        soundButton.setTitleColor(UIColor(rgb: 0x76323F, a: 1.0), for: .normal)
        soundButton.layer.cornerRadius = soundButton.frame.height * 0.25
        soundButton.layer.masksToBounds = true
        soundButton.addTarget(self, action: #selector(DetailVC.soundButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(soundButton)
    }
    
    func addAnimalButton(){
        let animalButton: UIButton = UIButton(type: .custom)
        let width = view.bounds.width * 0.40
        let height = view.bounds.height * 0.08
        let x = (view.bounds.width - width) - 20
        let y = (view.bounds.height - height) - 20
        
        animalButton.tag = 1
        animalButton.translatesAutoresizingMaskIntoConstraints = true
        animalButton.frame = CGRect(x: x, y: y, width: width, height: height)
        animalButton.setTitle("Try it", for: .normal)
        animalButton.titleLabel?.font = UIFont(name: "Beautiful Things", size: animalButton.frame.height)
        animalButton.contentVerticalAlignment = .center
        animalButton.contentHorizontalAlignment = .center
        animalButton.backgroundColor = UIColor(rgb: 0xF78733, a: 0.7)
        animalButton.setTitleColor(UIColor(rgb: 0x76323F, a: 1.0), for: .normal)
        animalButton.layer.cornerRadius = animalButton.frame.height * 0.25
        animalButton.layer.masksToBounds = true
        animalButton.addTarget(self, action: #selector(DetailVC.animalButtonTapped), for: .touchUpInside)
        self.view.addSubview(animalButton)
    }
    
}
