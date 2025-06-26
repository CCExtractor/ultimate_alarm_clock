//
//  RefreshTask.swift
//  Runner
//
//  Created by Kush Choudhary on 10/03/25.
//

import Foundation
import AVFoundation

class RefreshAppContentsOperation: Operation {
    override func main() {
        if isCancelled {
            NSLog("Log:BGTASK CANCELLED")
            return
        } // Ensure task isn't canceled

        NSLog("Log:Running background refresh task...")

        self.fetchDataAndUpdate()

        if isCancelled {
            NSLog("Log:BGTASK SUCCESSFULLY COMPLETED")
            return
        } // Check again before finishing
    }

    private func fetchDataAndUpdate() {
        
        NSLog("Log:Fetching new data...")
        // self.playDefaultAlarm()
        NSLog("Log:Data updated successfully!")
    }
    
    private func playDefaultAlarm() {
        var audioPlayer: AVAudioPlayer?
        guard let soundURL = Bundle.main.url(forResource: "digialarm", withExtension: "wav") else {
            NSLog("Log:Alarm sound file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            NSLog("Log:Error playing alarm sound: \(error.localizedDescription)")
        }
        NSLog("Log:TIMER ALERT PLAYING")
    }
}

