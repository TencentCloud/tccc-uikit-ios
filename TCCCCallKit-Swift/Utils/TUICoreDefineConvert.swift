//
//  TUICoreDefineConvert.swift
//  TUICallKit
//
//  Created by vincepzhang on 2023/8/14.
//

import Foundation


class TUICoreDefineConvert {
    
    static func getTUIKitLocalizableString(key: String) -> String {
        return TUIGlobalization.getLocalizedString(forKey: key, bundle: TUIKitLocalizableBundle)
    }
    
    static func getTUIDynamicImage(imageKey: String, module: TUIThemeModule, defaultImage: UIImage) -> UIImage? {
        return TUITheme.dynamicImage(imageKey, module: module, defaultImage: defaultImage)
    }
    
    static func getTUICallKitDynamicColor(colorKey: String, defaultHex: String) -> UIColor? {
        return TUITheme.dynamicColor(colorKey, module: TUIThemeModule.calling, defaultColor: defaultHex)
    }
    
    static func getTUICoreDynamicColor(colorKey: String, defaultHex: String) -> UIColor? {
        return TUITheme.dynamicColor(colorKey, module: TUIThemeModule.core, defaultColor: defaultHex)
    }
    
    static func getIsRTL() -> Bool {
        return TUIGlobalization.getRTLOption()
    }
    
}
