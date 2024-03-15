//
//  TCCCCallKitImpl.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation
import AVFoundation

class TCCCCallKitImpl: TCCCCallKit {
    static let instance = TCCCCallKitImpl()
    let selfUserCallStatusObserver = Observer()
    let callEventObserver = Observer()
    
    override init() {
       super.init()
       registerNotifications()
       registerObserveState()
    }
    
    deinit {
        CallEngineManager.instance.removeObserver(TUICallState.instance)
        TUICallState.instance.event.removeObserver(callEventObserver)
        NotificationCenter.default.removeObserver(self)
    }
    
    func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showViewControllerNotification),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    func registerObserveState() {
        TUICallState.instance.selfUser.value.callStatus.addObserver(selfUserCallStatusObserver, closure: { newValue, _ in
            if TUICallState.instance.selfUser.value.callRole.value != TUICallRole.none &&
                TUICallState.instance.selfUser.value.callStatus.value == TUICallStatus.waiting {
                TUICallState.instance.audioDevice.value = TUIAudioPlaybackDevice.earpiece
                CallEngineManager.instance.setAudioPlaybackDevice(device: TUIAudioPlaybackDevice.earpiece)
                WindowManager.instance.showCallWindow()
            }
            
            if TUICallState.instance.selfUser.value.callRole.value == TUICallRole.none &&
                TUICallState.instance.selfUser.value.callStatus.value == TUICallStatus.none {
                WindowManager.instance.closeCallWindow()
                WindowManager.instance.closeFloatWindow()
            }
        })
        CallEngineManager.instance.addObserver(TUICallState.instance)
        TUICallState.instance.event.addObserver(callEventObserver) { newValue, _ in
            if newValue.eventType == .ERROR {
                guard let errorCode = newValue.param[EVENT_KEY_CODE] as? NSInteger else { return }
                guard let errorMessage = newValue.param[EVENT_KEY_MESSAGE] as? String else { return }
                TUITool.makeToast("error:\(errorCode), \(errorMessage)")
            }
        }
    }
    
    override func login(userId: String,sdkAppId: Int64,token: String,succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        CallEngineManager.instance.login(userId: userId, sdkAppId: sdkAppId, token: token,succ: succ,fail: fail)

    }
    
    override func logout(succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        CallEngineManager.instance.logout(succ: succ,fail: fail)
    }
    
    override func isUserLogin(succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        CallEngineManager.instance.isUserLogin(succ: succ,fail: fail)
    }
    
    override func call(to: String, displayNumber: String, remark: String?,succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        if WindowManager.instance.isFloating {
            fail(ERROR_REQUEST_REPEATED, "call failed, Unable to restart the call")
            TUITool.makeToast(TUICallKitLocalize(key: "TUICallKit.UnableToRestartTheCall"))
            return
        }
        if TUICallKitCommon.checkAuthorizationStatusIsDenied() {
            showAuthorizationAlert()
            fail(ERROR_PERMISSION_DENIED, "call failed, authorization status is denied")
            return
        }
        CallEngineManager.instance.call(to: to, displayNumber: displayNumber,remark: remark) {
           succ()
        } fail: { code, message in
            self.handleAbilityFailErrorMessage(code: code, message: message)
            fail(code, message)
        }
    }
    
    override func setCallingBell(filePath: String) {
        if filePath.hasPrefix("http") {
            let session = URLSession.shared
            guard let url = URL(string: filePath) else { return }
            let downloadTask = session.downloadTask(with: url) { location, response, error in
                if error != nil {
                    return
                }
                
                if location != nil {
                    if let oldBellFilePath = UserDefaults.standard.object(forKey: TUI_CALLING_BELL_KEY) as? String {
                        do {
                            try FileManager.default.removeItem(atPath: oldBellFilePath)
                        } catch let error {
                            debugPrint("FileManager Error: \(error)")
                        }
                    }
                    guard let location = location else { return }
                    guard let dstDocPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last else { return }
                    let dstPath = dstDocPath + "/" + location.lastPathComponent
                    do {
                        try FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: dstPath))
                    } catch let error {
                        debugPrint("FileManager Error: \(error)")
                    }
                    UserDefaults.standard.set(dstPath, forKey: TUI_CALLING_BELL_KEY)
                    UserDefaults.standard.synchronize()
                }
            }
            downloadTask.resume()
        } else {
            UserDefaults.standard.set(filePath, forKey: TUI_CALLING_BELL_KEY)
            UserDefaults.standard.synchronize()
        }
    }
    
    override func enableMuteMode(enable: Bool) {
        UserDefaults.standard.set(enable, forKey: ENABLE_MUTEMODE_USERDEFAULT)
        TUICallState.instance.enableMuteMode = enable
    }
    
    override func enableFloatWindow(enable: Bool) {
        TUICallState.instance.enableFloatWindow = enable
    }
    
    override func getCallViewController() -> UIViewController {
        if let callWindowVC = WindowManager.instance.callWindow.rootViewController {
            return callWindowVC
        }
        
        if let floatingWindowVC = WindowManager.instance.floatWindow.rootViewController {
            return floatingWindowVC
        }
        
        return UIViewController()
    }
    
    override func setCallStatusListener(callStatusListener: TUICallStatusListener) {
        TUICallState.instance.setCallStatusListener(callStatusListener: callStatusListener)
    }

    override func setUserStatusListener(userStatusListener: TUIUserStatusListener) {
        TUICallState.instance.setUserStatusListener(userStatusListener: userStatusListener)
    }
    
    func showAuthorizationAlert() {
        let deniedType: AuthorizationDeniedType = AuthorizationDeniedType.audio
        
        TUICallKitCommon.showAuthorizationAlert(deniedType: deniedType) {
            CallEngineManager.instance.hangup()
        } cancelHandler: {
            CallEngineManager.instance.hangup()
        }
    }
    
    @objc func showViewControllerNotification(noti: Notification) {
        if TUICallState.instance.selfUser.value.callRole.value != TUICallRole.none &&
            TUICallState.instance.selfUser.value.callStatus.value == TUICallStatus.waiting {
            TUICallState.instance.audioDevice.value = .earpiece
            CallEngineManager.instance.setAudioPlaybackDevice(device: .earpiece)
            WindowManager.instance.showCallWindow()
        }
    }
    
    func convertCallKitError(code: Int32, message: String?) -> String {
        var errorMessage: String? = message
        if code == ERROR_PERMISSION_DENIED {
            errorMessage = TUICallKitLocalize(key: "TUICallKit.ErrorReqmissionDenied")
        } else if code == ERROR_REQUEST_REPEATED {
            errorMessage = TUICallKitLocalize(key: "TUICallKit.UnableToRestartTheCall")
        }
        return errorMessage ?? ""
    }
    
    func handleAbilityFailErrorMessage(code: Int32, message: String?) {
        let errorMessage = TUITool.convertIMError(Int(code), msg: convertCallKitError(code: code, message: message))
        TUITool.makeToast(errorMessage ?? "", duration: 4)
    }
}
