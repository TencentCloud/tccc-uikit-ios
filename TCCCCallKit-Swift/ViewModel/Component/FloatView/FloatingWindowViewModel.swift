//
//  FloatWindowViewModel.swift
//  TUICallKit
//
//  Created by vincepzhang on 2023/2/27.
//

import Foundation

class FloatingWindowViewModel {
    
    let callStatusObserver = Observer()
    let remoteUserObserver = Observer()
    let timeCountObserver = Observer()
    let selfPlayoutVolumeObserver = Observer()
    let remotePlayoutVolumeObserver = Observer()
    
    let callTime: Observable<Int> = Observable(0)
    let selfCallStatus: Observable<TUICallStatus> = Observable(.none)
    let remoteUser: Observable<User> = Observable(User())
    let selfUser: Observable<User> = Observable(User())
    let currentSpeakUser: Observable<User> = Observable(User())
    
    init() {
        callTime.value = TUICallState.instance.timeCount.value
        selfCallStatus.value = TUICallState.instance.selfUser.value.callStatus.value
        remoteUser.value = TUICallState.instance.remoteUser.value
        selfUser.value = TUICallState.instance.selfUser.value

        registerObserve()
    }
    
    deinit {
        TUICallState.instance.selfUser.value.callStatus.removeObserver(callStatusObserver)
        TUICallState.instance.remoteUser.removeObserver(remoteUserObserver)
        TUICallState.instance.timeCount.removeObserver(timeCountObserver)
        TUICallState.instance.selfUser.value.playoutVolume.removeObserver(selfPlayoutVolumeObserver)
        
        TUICallState.instance.remoteUser.value.playoutVolume.removeObserver(remotePlayoutVolumeObserver)
        
    }
    
    func registerObserve() {
        registerCallStatusObserver()
        registerRemoteUserObserver()
        registerTimeCountObserver()
        registerVolumeObserver()
    }
    
    func registerCallStatusObserver() {
        TUICallState.instance.selfUser.value.callStatus.addObserver(callStatusObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.selfCallStatus.value = newValue
        })
    }
    
    
    func registerRemoteUserObserver() {
        TUICallState.instance.remoteUser.addObserver(remoteUserObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.remoteUser.value = newValue
            self.updateCurrentSpeakUser(user: TUICallState.instance.selfUser.value)
        })
    }
    
    func registerTimeCountObserver() {
        TUICallState.instance.timeCount.addObserver(timeCountObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.callTime.value = newValue
        })
    }
    
    func registerVolumeObserver() {
        TUICallState.instance.selfUser.value.playoutVolume.addObserver(selfPlayoutVolumeObserver) { [weak self] newValue, _ in
            guard let self = self else { return }
            if newValue > 30 {
                self.updateCurrentSpeakUser(user: TUICallState.instance.selfUser.value)
            }
        }
        
        let user = TUICallState.instance.remoteUser.value
        TUICallState.instance.remoteUser.value.playoutVolume.addObserver(remotePlayoutVolumeObserver) { [weak self] newValue, _ in
            guard let self = self else { return }
            if newValue > 30 {
                self.updateCurrentSpeakUser(user: user)
            }
        }
    }
    
    func updateCurrentSpeakUser(user: User) {
        if user.phoneNumber.value.count > 0 && currentSpeakUser.value.phoneNumber.value != user.phoneNumber.value {
            self.currentSpeakUser.value = user
        }
    }
    
    func getCallTimeString() -> String {
        return GCDTimer.secondToHMSString(second: callTime.value)
    }
    
}
