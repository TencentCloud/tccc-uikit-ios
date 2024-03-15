//
//  TUICallDefine.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/3/4.
//

import Foundation

public typealias TUICallSucc = () -> Void
public typealias TUICallFail = (Int32, String?) -> Void


/// 通话角色：未知、主叫、被叫
enum TUICallRole: Int {
    case none
    case call
    case called
}

/// 通话状态：空闲、等待中、接听中
enum TUICallStatus: Int {
    case none
    case waiting
    case accept
}

/// 播放设备：听筒 或 麦克风
enum TUIAudioPlaybackDevice: Int {
    case speakerphone
    case earpiece
}

@objc
public enum TUIEndedReason: Int {
    case Error
    case Timeout
    case Replaced
    case LocalBye
    case RemoteBye
    case LocalCancel
    case RemoteCancel
    case Rejected
    case Referred
}

@objc
public enum TUIQuality: Int {
    case Unknown
    case Excellent
    case Good
    case Poor
    case Bad
    case Vbad
    case Down
}

@objc
public enum TUISessionDirection: Int {
    case CallIn
    case CallOut
}

@objc
public protocol TUIUserStatusListener {
    func onKickedOffline()
}

@objc
public protocol TUICallStatusListener {
    func onNewSession(info: TUISessionInfo)
    func onEnded(reason: TUIEndedReason, reasonMessage: String, sessionId: String)
    func onAccepted(sessionId: String)
// 暂时不支持
//    func onAudioVolume(volumeInfo: TUIVolumeInfo)
    func onNetworkQuality(localQuality: TUIQualityInfo, remoteQuality: TUIQualityInfo)
}

@objc
public class TUISessionInfo: NSObject {
    var sessionId: String = ""
    var toUserId: String = ""
    var fromUserId: String = ""
    var sessionDirection: TUISessionDirection = .CallOut
    var customHeaderJson: String = ""
}

@objc
public class TUIQualityInfo: NSObject {
    var userId: String = ""
    var quality:TUIQuality = .Unknown
}

@objc
public class TUIVolumeInfo: NSObject {
    var userId: String = ""
    var volume: Int32 = 0
}
