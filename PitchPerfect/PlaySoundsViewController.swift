//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Hugo Murillo on 4/23/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioUrl: NSURL!
    var audioFile: AVAudioFile!
    
    var audioEngine: AVAudioEngine!
    var audioPlayingNode: AVAudioPlayerNode!
    var timer: NSTimer!
    
    var isPLayingAudio: Bool!
    let stopSelector: Selector = "stopAudio"
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    enum ButtonType: Int {
        case SnailButton = 0,
        RabbitButton,
        ChipmunkButton,
        VaderButton,
        EchoButton,
        ReverbButton
    }
    
    override func viewWillAppear(animated: Bool) {
        updateButtons(false)
        setupAudio()
    }
    
    //MARK: IBAction methods
    @IBAction func playSoundPressed(sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .SnailButton:
            playSound(rate: 0.5)
        case .RabbitButton:
            playSound(rate: 1.5)
        case .ChipmunkButton:
            playSound(pitch: 1000)
        case .VaderButton:
            playSound(pitch: -1000)
        case .EchoButton:
            playSound(echo: true)
        case .ReverbButton:
            playSound(reverb: true)
        }
        updateButtons(true)
    }
    
    @IBAction func stopSoundPressed(sender: UIButton) {
        stopAudio()
    }
    
    //MARK: Utility functions
    func updateButtons(isPlaying: Bool) {
        updateButtons(
            isPlaying,
            stopButton:stopButton,
            buttons:snailButton,rabbitButton,chipmunkButton,vaderButton,echoButton,reverbButton
        )
    }
    
    func updateButtons(isPlaying: Bool, stopButton: UIButton, buttons:UIButton...) {
        stopButton.enabled = isPlaying
        for button in buttons {
            button.enabled = !isPlaying
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
