//
//  Constants.swift
//  TUICallKit
//
//  Created by vincepzhang on 2022/12/30.
//

// MARK: 屏幕尺寸相关
let ScreenSize = UIScreen.main.bounds.size
let Screen_Width = UIScreen.main.bounds.size.width
let Screen_Height = UIScreen.main.bounds.size.height
let StatusBar_Height: CGFloat = {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}()
let Bottom_SafeHeight = {var bottomSafeHeight: CGFloat = 0
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows.first
        bottomSafeHeight = window?.safeAreaInsets.bottom ?? 0
    }
    return bottomSafeHeight
}()

// MARK: FloatWindow UI Param

let kMicroAudioViewWidth = 88.scaleWidth()
let kMicroAudioViewHeight = 88.scaleWidth()

let kMicroAudioViewRect = CGRect(x: Screen_Width - kMicroAudioViewWidth, 
                                 y: 150.scaleHeight(),
                                 width: kMicroAudioViewWidth,
                                 height: kMicroAudioViewHeight)

// MARK: UI Size Param
let kFloatWindowButtonSize = CGSize(width: 30, height: 30)

let TUI_CALLING_BELL_KEY = "CallingBell"
let ENABLE_MUTEMODE_USERDEFAULT = "ENABLE_MUTEMODE_USERDEFAULT"

let kControlBtnSize = CGSize(width: 100.scaleWidth(), height: 94.scaleWidth())
let kBtnLargeSize = CGSize(width: 64.scaleWidth(), height: 64.scaleWidth())
let kBtnSmallSize = CGSize(width: 60.scaleWidth(), height: 60.scaleWidth())

/// 获取权限失败，当前未授权音 / 视频权限，请查看是否开启设备权限
let ERROR_PERMISSION_DENIED: Int32 = -1101;

/// 当前方法正在执行中，请勿重复调用
let ERROR_REQUEST_REPEATED: Int32 = -1204;

