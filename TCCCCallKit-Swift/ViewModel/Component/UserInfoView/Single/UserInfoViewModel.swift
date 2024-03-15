//
//  UserInfoViewModel.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class UserInfoViewModel {
    let callStatusObserver = Observer()
    let remoteUserObserver = Observer()
    let networkQuality: Observable<String> = Observable(TUICallKitLocalize(key: "TUICallKit.Network.excellent_quality") ?? "")
    
    let remoteUser: Observable<User> = Observable(User())
    let selfCallStatus: Observable<TUICallStatus> = Observable(.none)
    
    
    init() {
        remoteUser.value = TUICallState.instance.remoteUser.value
        selfCallStatus.value = TUICallState.instance.selfUser.value.callStatus.value
        networkQuality.value = TUICallState.instance.networkQualityTips.value
        registerObserve()
    }
    
    deinit {
        TUICallState.instance.selfUser.value.callStatus.removeObserver(callStatusObserver)
        TUICallState.instance.remoteUser.removeObserver(remoteUserObserver)
        TUICallState.instance.networkQualityTips.removeObserver(networkQuality)
    }
    
    func registerObserve() {
        TUICallState.instance.selfUser.value.callStatus.addObserver(callStatusObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.selfCallStatus.value = newValue
        })
        
        TUICallState.instance.remoteUser.addObserver(remoteUserObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.remoteUser.value = newValue
        })
        
        TUICallState.instance.networkQualityTips.addObserver(networkQuality, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.networkQuality.value = newValue
        })
    }
    
    func getCurrentWaitingText() -> String {
        var waitingText = String()
        if TUICallState.instance.selfUser.value.callRole.value == .call {
            waitingText = TUICallKitLocalize(key: "TUICallKit.waitAccept") ?? ""
        } else {
            waitingText = TUICallKitLocalize(key: "TUICallKit.inviteToAudioCall") ?? ""
        }
        return waitingText
    }
    
}
