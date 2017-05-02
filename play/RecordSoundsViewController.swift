//
//  RecordSoundsViewController.swift
//  play
//
//  Created by Sam Hammer on 4/27/17.
//  Copyright © 2017 Sam Hammer. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordlabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("WORKS")
        stopRecordingButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func record(_ sender: AnyObject) {
     
        recordingUI(recording: true)
      let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
      let recordingName = "recordedVoice.wav"
      let pathArray = [dirPath, recordingName]
      let filePath = URL(string: pathArray.joined(separator: "/"))
      print(filePath)

      let session = AVAudioSession.sharedInstance()
      try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)

      try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
      audioRecorder.isMeteringEnabled = true
      audioRecorder.prepareToRecord()
      audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        recordingUI(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func recordingUI(recording: Bool) {
        if recording {
            recordlabel.text = "recording in progress"
        } else {
            recordlabel.text = "Tap to Record"
        }
        stopRecordingButton.isEnabled = recording
        recordButton.isEnabled = !recording
    }


    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
      if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        
      } else {
        print(" recording was not successful")
      }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
