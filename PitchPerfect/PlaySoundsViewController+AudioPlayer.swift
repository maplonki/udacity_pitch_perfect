//
//  PlaySoundsViewController+AudioPlayer.swift
//  PitchPerfect
//
//  Created by Hugo Murillo on 4/23/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import Foundation
import AVFoundation

extension PlaySoundsViewController {
    
    struct AudioError {
        static let AudioFileError = "Audio File Error"
        static let AudioPlayingError = "Audio Playing Error"
    }
    
    //Sets up the audio file using the url
    func setupAudio() {
        do {
            audioFile = try AVAudioFile(forReading: audioUrl)
        } catch {
            showAlert(AudioError.AudioFileError, message: error as! String)
        }
    }
    
    //Plays the audio file with the given specs
    func playSound(rate rate: Float? = nil, pitch: Float? = nil, echo: Bool? = false, reverb: Bool? = false) {
        
        audioEngine = AVAudioEngine()
        
        //Node for playing audio
        audioPlayingNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayingNode)
        
        
        //Node for Pitch and Rate
        let pitchAndRateNode = AVAudioUnitTimePitch()
        if rate != nil {
            pitchAndRateNode.rate = rate!
        }
        
        if pitch != nil {
            pitchAndRateNode.pitch = pitch!
        }
        audioEngine.attachNode(pitchAndRateNode)
        
        //Node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.MultiEcho1)
        audioEngine.attachNode(echoNode)
        
        //Node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.Cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attachNode(reverbNode)
        
        //Connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayingNode, pitchAndRateNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayingNode, pitchAndRateNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayingNode, pitchAndRateNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayingNode, pitchAndRateNode, audioEngine.outputNode)
        }
        
        //Schedule to play and start the engine
        audioPlayingNode.stop()
        audioPlayingNode.scheduleFile(audioFile, atTime: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayingNode.lastRenderTime, let playerTime = self.audioPlayingNode.playerTimeForNodeTime(lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            //Schedule a stop timer for when audio finishes playing
            self.timer = NSTimer(timeInterval: delayInSeconds, target: self, selector: self.stopSelector, userInfo: nil, repeats: false)
            NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSDefaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(AudioError.AudioPlayingError, message: error as! String)
            return
        }
        
        //Play the recording
        audioPlayingNode.play()
        
    }
    
    //Connects all of the previously set audio nodes
    func connectAudioNodes(nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    //Stops the audio from playing
    func stopAudio() {
        
        if let stopTimer = timer {
            stopTimer.invalidate()
        }
        
        //We update the buttons to enable all 
        //the effect buttons and disable the stop button
        updateButtons(false)
        
        if let audioPlayingNode = audioPlayingNode {
            audioPlayingNode.stop()
        }
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
}
