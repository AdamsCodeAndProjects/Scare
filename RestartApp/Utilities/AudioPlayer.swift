//
//  AudioPlayer.swift
//  RestartApp
//
//  Created by adam janusewski on 5/3/22.
//

import Foundation
import AVFoundation // Audio Visual for the audio

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not play the audio file.")
        }
    }
        
}
