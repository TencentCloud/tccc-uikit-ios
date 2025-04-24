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
    public var sessionId: String = ""
    public var toUserId: String = ""
    public var fromUserId: String = ""
    public var sessionDirection: TUISessionDirection = .CallOut
    public var customHeaderJson: String = ""
    
    @objc
    public override init() {
        super.init()
    }
    
    @objc
    public init(sessionId: String, toUserId: String, fromUserId: String, sessionDirection: TUISessionDirection, customHeaderJson: String) {
       self.sessionId = sessionId
       self.toUserId = toUserId
       self.fromUserId = fromUserId
       self.sessionDirection = sessionDirection
       self.customHeaderJson = customHeaderJson
   }
}

@objc
public class TUIQualityInfo: NSObject {
    public var userId: String = ""
    public var quality:TUIQuality = .Unknown
    
    @objc
    public override init() {
        super.init()
    }
    
    @objc
    public init(userId: String, quality: TUIQuality) {
       self.userId = userId
       self.quality = quality
   }
}

@objc
public class TUIVolumeInfo: NSObject {
    public var userId: String = ""
    public var volume: Int32 = 0
    
    @objc
    public override init() {
        super.init()
    }
    
    @objc
    public init(userId: String, volume: Int32) {
       self.userId = userId
       self.volume = volume
   }
}
