//
//  CallEngineManager.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation
import TCCCSDK

class CallEngineManager {
    static let instance = CallEngineManager()
   
    func addObserver(_ observer: TCCCDelegate) {
        self.getTCCCSDKInstance().callExperimentalAPI("setUserAgentStr", jsonStr: "TCCCCallKit")
        self.getTCCCSDKInstance().addTcccListener(observer)
    }
    
    func removeObserver(_ observer: TCCCDelegate) {
        self.getTCCCSDKInstance().removeTCCCListener(observer)
    }
    
    func login(userId: String,sdkAppId: Int64,token: String,succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        let params = TXLoginParams()
        params.sdkAppId = UInt32(sdkAppId)
        params.userId = userId
        params.token = token
        params.type = .Agent
        self.getTCCCSDKInstance().login(params) { info in
            TUICallState.instance.selfUser.value.phoneNumber.value = info.userId
            succ()
        } fail: { code, message in
            TUICallState.instance.selfUser.value.phoneNumber.value = ""
            fail(code,message)
        }
    }
    
    func isUserLogin(succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        self.getTCCCSDKInstance().checkLogin {
            succ()
        } fail: { code, msg in
            TUICallState.instance.selfUser.value.phoneNumber.value = ""
            fail(code,msg)
        }
    }
    
    func logout(succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        self.getTCCCSDKInstance().logout {
            TUICallState.instance.selfUser.value.phoneNumber.value = ""
            succ()
        } fail: { code, message in
            fail(code,message)
        }
    }
    
    func call(to: String, displayNumber: String, remark: String?, succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        TUICallState.instance.remoteUser.value.callStatus.value = TUICallStatus.waiting
        TUICallState.instance.remoteUser.value.callRole.value = TUICallRole.called
        TUICallState.instance.remoteUser.value.phoneNumber.value = to
        TUICallState.instance.remoteUser.value.displayNumber.value = displayNumber
        TUICallState.instance.remoteUser.value.remark.value = remark ?? ""
        
        TUICallState.instance.selfUser.value.callRole.value = TUICallRole.call
        TUICallState.instance.selfUser.value.callStatus.value = TUICallStatus.waiting
        
        TUICallState.instance.audioDevice.value = TUIAudioPlaybackDevice.earpiece
        
        let param = TXStartCallParams()
        param.to = to
        param.remark = remark ?? ""
        self.getTCCCSDKInstance().call(param) {
            succ()
        } fail: { code, message in
            fail(code,message)
        }
    }
    
    func hangup() {
        self.getTCCCSDKInstance().terminate()
        TUICallState.instance.cleanState()
    }
    
    func accept() {
        self.getTCCCSDKInstance().answer {
            TUICallState.instance.accept();
            print("answer success")
        } fail: { code, msg in
            print("answer error,"+msg)
            TUICallState.instance.cleanState()
        }
    }
    
    func reject() {
        self.getTCCCSDKInstance().terminate()
        TUICallState.instance.cleanState()
    }
    
    func muteMic() {
        if TUICallState.instance.isMicMute.value == true {
            TUICallState.instance.isMicMute.value = false
            self.getTCCCSDKInstance().unmute()
            TUIEventManager.shareInstance().notifyEvent(TUICore_TUICallKitVoIPExtensionNotify,
                                subKey: TUICore_TUICore_TUICallKitVoIPExtensionNotify_OpenMicrophoneSubKey,
                                object: nil,
                                param: nil)
            
        } else {
            TUICallState.instance.isMicMute.value = true
            self.getTCCCSDKInstance().mute()
            TUIEventManager.shareInstance().notifyEvent(TUICore_TUICallKitVoIPExtensionNotify,
                                subKey: TUICore_TUICore_TUICallKitVoIPExtensionNotify_CloseMicrophoneSubKey,
                                object: nil,
                                param: nil)
        }
    }
    
    func openMicrophone() {
        TUICallState.instance.isMicMute.value = false
        self.getTCCCSDKInstance().unmute()
        TUIEventManager.shareInstance().notifyEvent(TUICore_TUICallKitVoIPExtensionNotify,
                            subKey: TUICore_TUICore_TUICallKitVoIPExtensionNotify_OpenMicrophoneSubKey,
                            object: nil,
                            param: nil)
    }
    
    func closeMicrophone() {
        self.getTCCCSDKInstance().mute()
        TUICallState.instance.isMicMute.value = true
        TUIEventManager.shareInstance().notifyEvent(TUICore_TUICallKitVoIPExtensionNotify,
                            subKey: TUICore_TUICore_TUICallKitVoIPExtensionNotify_CloseMicrophoneSubKey,
                            object: nil,
                            param: nil)
    }
    
    func changeSpeaker() {
        if TUICallState.instance.audioDevice.value == TUIAudioPlaybackDevice.speakerphone {
            TUICallState.instance.audioDevice.value = .earpiece
            self.getTCCCSDKInstance().getDeviceManager().setAudioRoute(.TCCCAudioRouteEarpiece)
        } else {
            TUICallState.instance.audioDevice.value = .speakerphone
            self.getTCCCSDKInstance().getDeviceManager().setAudioRoute(.TCCCAudioRouteSpeakerphone)
        }
    }
    
    func setAudioPlaybackDevice(device: TUIAudioPlaybackDevice) {
        if device == .earpiece {
            self.getTCCCSDKInstance().getDeviceManager().setAudioRoute(.TCCCAudioRouteEarpiece)
        } else {
            self.getTCCCSDKInstance().getDeviceManager().setAudioRoute(.TCCCAudioRouteSpeakerphone)
        }
    }
    
    func getTCCCSDKInstance() -> TCCCWorkstation {
        return TCCCWorkstation.sharedInstance()
    }
    
}
