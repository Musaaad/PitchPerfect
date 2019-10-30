//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Musaad on 9/14/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var AudioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var RecordingLabel: UILabel!
    @IBOutlet weak var RecordButton: UIButton!
    @IBOutlet weak var StopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view
    }
    
    func setButtons(forRecording recording: Bool) {
        StopRecordingButton.isEnabled = recording
        RecordButton.isEnabled = !recording
        RecordingLabel.text = recording ? "Recording..." : "Tap to record"
    }
    
    
    @IBAction func RecordAudio(_ sender: Any) {
        
        setButtons(forRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! AudioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        AudioRecorder.delegate = self
        AudioRecorder.isMeteringEnabled = true
        AudioRecorder.prepareToRecord()
        AudioRecorder.record()
        
    }
    
    
    @IBAction func StopRecording(_ sender: Any) {
        
        RecordButton.isEnabled = true
        StopRecordingButton.isEnabled = false
        RecordingLabel.text = "Tap to Record"
        
        AudioRecorder.stop()
        setButtons(forRecording: true)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "StopRecording", sender: AudioRecorder.url)
        } else {
            print("Recording was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StopRecording"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let RecordedAudioURL = sender as! URL
            playSoundsVC.RecordedAudioURL = RecordedAudioURL
        }
    }
    
    
    
}
    

