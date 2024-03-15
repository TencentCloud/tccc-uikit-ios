//
//  TCCCCallKit.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

@objc
public class TCCCCallKit: NSObject {
  /**
    * Create a TUICallKit instance
    */
    @objc
    public static func createInstance() -> TCCCCallKit {
        return TCCCCallKitImpl.instance
    }
    
    @objc
    public func login(userId: String,sdkAppId: Int64,token: String,succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        return TCCCCallKitImpl.instance.login(userId: userId,sdkAppId: sdkAppId,token: token,succ: succ,fail: fail)
    }
    
    @objc
    public func logout(succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        return TCCCCallKitImpl.instance.logout(succ: succ,fail: fail)
    }
    
    @objc
    public func isUserLogin(succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        return TCCCCallKitImpl.instance.isUserLogin(succ:succ,fail: fail)
    }
    
    @objc
    public func call(to: String, displayNumber: String, remark: String?, succ: @escaping TUICallSucc, fail: @escaping TUICallFail) {
        return TCCCCallKitImpl.instance.call(to: to,displayNumber: displayNumber,remark: remark, succ: succ,fail: fail)
    }
    
    @objc
    public func setCallingBell(filePath: String) {
        return TCCCCallKitImpl.instance.setCallingBell(filePath: filePath)
    }
    
    @objc public func enableMuteMode(enable: Bool) {
        return TCCCCallKitImpl.instance.enableMuteMode(enable: enable)
    }
    
    @objc
    public func enableFloatWindow(enable: Bool) {
        return TCCCCallKitImpl.instance.enableFloatWindow(enable: enable)
    }
    
    @objc
    public func getCallViewController() -> UIViewController {
        return TCCCCallKitImpl.instance.getCallViewController()
    }
    
    @objc
    public func setCallStatusListener(callStatusListener: TUICallStatusListener) {
        return TCCCCallKitImpl.instance.setCallStatusListener(callStatusListener: callStatusListener)
    }

    @objc
    public func setUserStatusListener(userStatusListener: TUIUserStatusListener) {
        return TCCCCallKitImpl.instance.setUserStatusListener(userStatusListener: userStatusListener)
    }
}
