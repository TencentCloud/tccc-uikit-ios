//
//  TUICallState.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation
import AVFoundation
import TCCCSDK

class TUICallState: NSObject {
    static let instance = TUICallState()
    
    let remoteUser: Observable<User> = Observable(User())
    let selfUser: Observable<User> = Observable(User())
    
    let timeCount: Observable<Int> = Observable(0)
    let event: Observable<TUICallEvent> = Observable(TUICallEvent(eventType: .UNKNOWN, event: .UNKNOWN, param: Dictionary()))
    
    let isMicMute: Observable<Bool> = Observable(false)
    let audioDevice: Observable<TUIAudioPlaybackDevice> = Observable(TUIAudioPlaybackDevice.earpiece)
    let isShowFullScreen: Observable<Bool> = Observable(false)
    let networkQualityTips: Observable<String> = Observable(TUICallKitLocalize(key: "TUICallKit.Network.excellent_unknown") ?? "")
    
    var enableMuteMode: Bool = {
        let enable = UserDefaults.standard.bool(forKey: ENABLE_MUTEMODE_USERDEFAULT)
        return enable
    }()
    
    var enableFloatWindow: Bool = false
    
    private var timerName: String = ""
    
    func accept() {
        TUICallState.instance.selfUser.value.callRole.value = .called
        TUICallState.instance.selfUser.value.callStatus.value = TUICallStatus.accept
        
        timerName = GCDTimer.start(interval: 1, repeats: true, async: true) {
            TUICallState.instance.timeCount.value += 1
        }
        
        CallingBellFeature.instance.stopPlayMusic()
        CallEngineManager.instance.setAudioPlaybackDevice(device: TUICallState.instance.audioDevice.value)
        if TUICallState.instance.isMicMute.value == false {
            CallEngineManager.instance.openMicrophone()
        } else {
            CallEngineManager.instance.closeMicrophone()
        }
        
        TUICallState.instance.remoteUser.value.callStatus.value = .accept
    }
    
    private var callStatusListener: TUICallStatusListener? = nil
    
    private var userStatusListener: TUIUserStatusListener? = nil
    
    func setCallStatusListener(callStatusListener: TUICallStatusListener) {
        self.callStatusListener = callStatusListener
    }
    
    func setUserStatusListener(userStatusListener: TUIUserStatusListener) {
        self.userStatusListener = userStatusListener
    }
}

// MARK: CallObserver
extension TUICallState:  TCCCDelegate {
    func onError(_ errCode: TCCCErrorCode, errMsg: String, extInfo: [AnyHashable : Any]?) {
        var param: [String: Any] = [:]
        param[EVENT_KEY_CODE] = errCode.rawValue
        var copyMsg = errMsg;
        if (errCode == TCCCErrorCode.ERR_SIP_FORBIDDEN) {
            copyMsg = TUICallKitLocalize(key: "TUICallKit.ErrorLoginElseWhere") ?? ""
            selfUser.value.phoneNumber.value = ""
            userStatusListener?.onKickedOffline();
        }
        param[EVENT_KEY_MESSAGE] = copyMsg
        let callEvent = TUICallEvent(eventType: .ERROR, event: .ERROR_COMMON, param: param)
        TUICallState.instance.event.value = callEvent
    }
    
    func onNewSession(_ info: TXSessionInfo) {
        if (self.callStatusListener != nil) {
            let tuiInfo = TUISessionInfo()
            tuiInfo.sessionDirection = TUISessionDirection(rawValue: info.sessionDirection.rawValue) ?? .CallOut
            tuiInfo.sessionId = info.sessionID
            tuiInfo.customHeaderJson = info.customHeaderJson
            tuiInfo.fromUserId = info.fromUserID
            tuiInfo.toUserId = info.toUserID
            self.callStatusListener?.onNewSession(info: tuiInfo)
        }
        if (info.sessionDirection == .CallIn) {
            if TUICallKitCommon.checkAuthorizationStatusIsDenied() {
                showAuthorizationAlert()
                return
            }
            TUICallState.instance.remoteUser.value.callStatus.value = .waiting
            TUICallState.instance.remoteUser.value.callRole.value = TUICallRole.call
            TUICallState.instance.remoteUser.value.phoneNumber.value = info.fromUserID
            TUICallState.instance.remoteUser.value.remark.value = info.fromUserID
            TUICallState.instance.remoteUser.value.displayNumber.value = info.fromUserID
            
            TUICallState.instance.selfUser.value.callRole.value = TUICallRole.called
            
            DispatchQueue.main.async {
                TUICallState.instance.selfUser.value.callStatus.value = TUICallStatus.waiting
                TUICallState.instance.audioDevice.value = TUIAudioPlaybackDevice.earpiece
            }
            
            let _ = CallingBellFeature.instance.startPlayMusic()
        }
    }
    
    func onEnded(_ reason: TXEndedReason, reasonMessage: String, sessionId: String) {
        self.callStatusListener?.onEnded(reason: TUIEndedReason(rawValue: reason.rawValue) ?? .Error, reasonMessage: reasonMessage, sessionId: sessionId)
        var msg: String = ""
        switch(reason) {
        case .Error:
            // 外呼规则如下：
            // https://cloud.tencent.com/document/product/679/79155
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.error") ?? ""
            msg = msg + reasonMessage
        case .Timeout:
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.timeout") ?? ""
        case .LocalBye:
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.local_bye") ?? ""
        case .RemoteBye:
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.remote_bye") ?? ""
        case .LocalCancel:
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.local_cancel") ?? ""
        case .RemoteCancel:
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.remote_cancel") ?? ""
        case .Rejected:
            msg = TUICallKitLocalize(key: "TUICallKit.EndedReason.rejected") ?? ""
        case .Replaced: break
        case .Referred: break
        @unknown default: break
        }
        CallingBellFeature.instance.stopPlayMusic()
        cleanState()
        if (!msg.isEmpty) {
            TUITool.makeToast(msg,duration: 5,idposition: TUICSToastPositionCenter)
        }
    }
    
    func onAccepted(_ sessionId: String) {
        self.callStatusListener?.onAccepted(sessionId: sessionId)
        TUICallState.instance.selfUser.value.callRole.value = .call
        TUICallState.instance.selfUser.value.callStatus.value = TUICallStatus.accept
        
        timerName = GCDTimer.start(interval: 1, repeats: true, async: true) {
            TUICallState.instance.timeCount.value += 1
        }
        CallingBellFeature.instance.stopPlayMusic()
        CallEngineManager.instance.setAudioPlaybackDevice(device: TUICallState.instance.audioDevice.value)
        if TUICallState.instance.isMicMute.value == false {
            CallEngineManager.instance.openMicrophone()
        } else {
            CallEngineManager.instance.closeMicrophone()
        }
    }
    
    func onAudioVolume(_ volumeInfo: [TXVolumeInfo]) {
//        self.callStatusListener?.onAudioVolume(volumeInfo: volumeInfo[])
        for volume in volumeInfo {
            if volume.userId == TUICallState.instance.selfUser.value.phoneNumber.value {
                TUICallState.instance.selfUser.value.playoutVolume.value = Float(volume.volume)
            } else {
                TUICallState.instance.remoteUser.value.playoutVolume.value = Float(volume.volume)
            }
        }
    }
    
    func onNetworkQuality(_ localQuality: TXQualityInfo, remoteQuality: [TXQualityInfo]) {
        var tips = "";
        switch(localQuality.quality) {
        case .TCCCQuality_Bad:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.bad_quality") ?? ""
            break
        case .TCCCQuality_Unknown:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.excellent_unknown") ?? ""
            break
        case .TCCCQuality_Excellent:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.excellent_quality") ?? ""
            break
        case .TCCCQuality_Good:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.good_quality") ?? ""
            break
        case .TCCCQuality_Poor:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.poor_quality") ?? ""
            break
        case .TCCCQuality_Vbad:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.vbad_quality") ?? ""
            break
        case .TCCCQuality_Down:
            tips = TUICallKitLocalize(key: "TUICallKit.Network.offline_quality") ?? ""
            break
        @unknown default:
            break
        }
        if (!tips.isEmpty) {
            TUICallState.instance.networkQualityTips.value = tips
        }
        let lq = TUIQualityInfo()
        lq.userId = localQuality.userId
        lq.quality = TUIQuality(rawValue: localQuality.quality.rawValue) ?? .Unknown
        
        let rq = TUIQualityInfo()
        if (!remoteQuality.isEmpty) {
            rq.userId = remoteQuality[0].userId
            rq.quality = TUIQuality(rawValue: remoteQuality[0].quality.rawValue) ?? .Unknown
        }
        self.callStatusListener?.onNetworkQuality(localQuality: lq, remoteQuality: rq)
    }
}

// MARK: private method
extension TUICallState {
    func cleanState() {
        TUICallState.instance.isMicMute.value = false
        
        TUICallState.instance.remoteUser.value.callRole.value = TUICallRole.none
        TUICallState.instance.remoteUser.value.callStatus.value = TUICallStatus.none
        
        TUICallState.instance.timeCount.value = 0
        
        TUICallState.instance.selfUser.value.callRole.value = TUICallRole.none
        TUICallState.instance.selfUser.value.callStatus.value = TUICallStatus.none
        
        TUICallState.instance.timeCount.value = 0
        TUICallState.instance.audioDevice.value = .earpiece
        TUICallState.instance.isShowFullScreen.value = false
        TUICallState.instance.networkQualityTips.value = TUICallKitLocalize(key: "TUICallKit.Network.excellent_quality") ?? ""
        
        GCDTimer.cancel(timerName: timerName) { return }
        
    }

    func showAuthorizationAlert() {
        let deniedType: AuthorizationDeniedType = AuthorizationDeniedType.audio
        
        TUICallKitCommon.showAuthorizationAlert(deniedType: deniedType) {
            CallEngineManager.instance.hangup()
        } cancelHandler: {
            CallEngineManager.instance.hangup()
        }
    }
}
