//
//  CallingBellFeature.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation
import AVFAudio


class CallingBellFeature: NSObject, AVAudioPlayerDelegate {
    
    static let instance = CallingBellFeature()
    var player: AVAudioPlayer?
    var loop: Bool = true
    
    func startPlayMusic() -> Bool {
        guard let bundle = TUICallKitCommon.getTUICallKitBundle() else { return false }
        if TUICallState.instance.enableMuteMode {
            return false
        }
        var path = bundle.bundlePath + "/AudioFile" + "/phone_ringing.mp3"
        
        if let value = UserDefaults.standard.object(forKey: TUI_CALLING_BELL_KEY) as? String {
            path = value
        }
        let url = URL(fileURLWithPath: path)
        return startPlayMusicBySystemPlayer(url: url)
    }
    
    // MARK: System AVAudio Player
    private func startPlayMusicBySystemPlayer(url: URL, loop: Bool = true) -> Bool {
        self.loop = loop
        
        if player != nil {
            stopPlayMusicBySystemPlayer()
        }
        
        do {
            try player = AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            print("err: \(error.localizedDescription)")
            return false
        }
                
        guard let prepare = player?.prepareToPlay() else { return false }
        if !prepare {
            return false
        }
        
        setAudioSessionPlayback()
        
        player?.delegate = self
        guard let res = player?.play() else { return false }

        return res
    }
    
    private func stopPlayMusicBySystemPlayer() {
        if player == nil {
            return
        }
        player?.stop()
        player = nil
    }
    
    // MARK: AVAudioPlayerDelegate
    internal func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if loop {
            player.play()
        } else {
            stopPlayMusicBySystemPlayer()
        }
    }
    
    internal func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if error != nil {
            stopPlayMusicBySystemPlayer()
        }
    }
    
    private func setAudioSessionPlayback() {
        let audioSession = AVAudioSession()
        try? audioSession.setCategory(.soloAmbient)
        try? audioSession.setActive(true)
    }
    
    func stopPlayMusic() {
        stopPlayMusicBySystemPlayer()
    }
}
