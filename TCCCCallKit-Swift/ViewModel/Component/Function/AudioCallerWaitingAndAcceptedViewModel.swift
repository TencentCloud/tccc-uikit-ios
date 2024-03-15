//
//  AudioCallerWaitingAndAcceptedViewModel.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class AudioCallerWaitingAndAcceptedViewModel {
    
    let isMicMuteObserver = Observer()
    let audioDeviceObserver = Observer()
    
    let isMicMute: Observable<Bool> = Observable(false)
    let audioDevice: Observable<TUIAudioPlaybackDevice> = Observable(.earpiece)
    let selfUser: Observable<User> = Observable(User())
  
    init() {
        isMicMute.value = TUICallState.instance.isMicMute.value
        audioDevice.value = TUICallState.instance.audioDevice.value
        selfUser.value = TUICallState.instance.selfUser.value

        registerObserve()
    }
    
    deinit {
        TUICallState.instance.isMicMute.removeObserver(isMicMuteObserver)
        TUICallState.instance.audioDevice.removeObserver(audioDeviceObserver)
    }
    
    func registerObserve() {
        TUICallState.instance.isMicMute.addObserver(isMicMuteObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.isMicMute.value = newValue
        })
        
        TUICallState.instance.audioDevice.addObserver(audioDeviceObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.audioDevice.value = newValue
        })
        
    }

    // MARK: CallEngine Method
    func accept() {
        CallEngineManager.instance.accept()
    }
    
    func hangup() {
        CallEngineManager.instance.hangup()
    }
    
    func reject() {
        CallEngineManager.instance.reject()
    }
    
    func muteMic() {
        CallEngineManager.instance.muteMic()
    }
    
    func changeSpeaker() {
        CallEngineManager.instance.changeSpeaker()
    }
}
