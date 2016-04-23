//
//  RecordSoundsViewController+AudioRecorder.swift
//  PitchPerfect
//
//  Created by Hugo Murillo on 4/23/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import Foundation
import AVFoundation

extension RecordSoundsViewController {
    
    func prepareAudioRecorder(recorderDelegate: AVAudioRecorderDelegate){
        
        //We get path for the user documents directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
        //Create an array for our audio, formed by the
        //directory path and our file name
        let pathArray = [dirPath, recordingName]
        
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //Setup the AudioRecorder to Play and Record audio, via AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = recorderDelegate
        audioRecorder.meteringEnabled = true    }
    
    func recordAudio() {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
    }
    
}
