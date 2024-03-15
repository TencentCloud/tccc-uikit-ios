//
//  TUICallKitCommon.swift
//  TUICallKit
//
//  Created by vincepzhang on 2023/8/14.
//

import Foundation
import AVFoundation

enum AuthorizationDeniedType {
    case audio
}

class TUICallKitCommon {
    
    static func getTUICallKitBundle() -> Bundle? {
        guard let url: URL = Bundle.main.url(forResource: "TCCCCallKitBundle", withExtension: "bundle") else { return nil }
        return Bundle(url: url)
    }
    
    static func getBundleImage(name: String) -> UIImage? {
        return UIImage(named: name, in: self.getTUICallKitBundle(), compatibleWith: nil)
    }
    
    static func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter({ $0.isKeyWindow }).last
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    static func checkAuthorizationStatusIsDenied() -> Bool {
        let statusAudio: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        if statusAudio == .denied {
            return true
        }
        
        return false
    }
    
    static func showAuthorizationAlert(deniedType: AuthorizationDeniedType,
                                       openSettingHandler: @escaping () -> Void,
                                       cancelHandler: @escaping () -> Void) {
        var title: String
        var message: String
        var laterMessage: String
        var openSettingMessage: String
        
        switch deniedType {
        case .audio:
            title = TUICallKitLocalize(key: "TUICallKit.FailedToGetMicrophonePermission.Title") ?? ""
            message = TUICallKitLocalize(key: "TUICallKit.FailedToGetMicrophonePermission.Tips") ?? ""
            laterMessage = TUICallKitLocalize(key: "TUICallKit.FailedToGetMicrophonePermission.Later") ?? ""
            openSettingMessage = TUICallKitLocalize(key: "TUICallKit.FailedToGetMicrophonePermission.Enable") ?? ""
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert )
        
        alertController.addAction(UIAlertAction(title: laterMessage, style: .cancel, handler:  { action in
            cancelHandler()
        }))
        
        alertController.addAction(UIAlertAction(title: openSettingMessage, style: .default, handler: { action in
            openSettingHandler()
            let app = UIApplication.shared
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if app.canOpenURL(url) {
                app.openURL(url)
            }
        }))
        
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true)
        }
    }
}
