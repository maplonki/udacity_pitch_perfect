//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Hugo Murillo on 4/18/16.
//  Copyright © 2016 Maplonki. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    let stopRecordingSegue = "stopRecordingSegue"
    
    struct RecordingLabel {
        static let IsRecordingLabel = "Recording in Progress"
        static let RecordLabel = "Start Recording"
    }
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    //MARK: Life cycle
    override func viewWillAppear(animated: Bool) {
        updateButtons(false)
    }
    
    //MARK: IBAction methods
    @IBAction func onRecordButton(sender: AnyObject) {
        updateButtons(true)
        prepareAudioRecorder(self)
        recordAudio()
    }
    @IBAction func onStopButton(sender: AnyObject) {
        updateButtons(false)
        stopRecording()
    }
    
    //MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.performSegueWithIdentifier(stopRecordingSegue, sender: audioRecorder.url)
        }
    }
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == stopRecordingSegue {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let audioUrl = sender as! NSURL
            playSoundsVC.audioUrl = audioUrl
        }
    }
    
    //MARK: Utility functions
    func updateButtons(isRecording: Bool) {
        recordButton.enabled = !isRecording
        stopButton.enabled = isRecording
        
        recordLabel.text =
            (isRecording ? RecordingLabel.IsRecordingLabel : RecordingLabel.RecordLabel)
    }
}

