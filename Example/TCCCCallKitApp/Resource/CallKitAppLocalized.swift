//
//  CallKitAppLocalized.swift
//  TCCCCallKitApp
//
//  Created by gavinwjwang on 2024/3/7.
//

import Foundation
let TUICallKitLocalizeTableName = "Localizable"

func localizeFromTable(key: String, table: String) -> String {
    return Bundle.main.localizedString(forKey: key, value: "", table: table)
}

func CallKitAppLocalize(_ key: String) -> String {
    return localizeFromTable(key: key, table: TUICallKitLocalizeTableName)
}
