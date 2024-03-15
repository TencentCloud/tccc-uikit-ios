//
//  User.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class User {
    
    let phoneNumber: Observable<String> = Observable("")
    let displayNumber: Observable<String> = Observable("")
    let remark: Observable<String> = Observable("")
    
    let callRole: Observable<TUICallRole> = Observable(.none)
    let callStatus: Observable<TUICallStatus> = Observable(.none)
    
    let audioAvailable: Observable<Bool> = Observable(false)
    let playoutVolume: Observable<Float> = Observable(0)
    
    static func getUserDisplayName(user: User) -> String {
        if !user.displayNumber.value.isEmpty {
            return user.displayNumber.value
        }
        
        return user.phoneNumber.value
    }
    
    
}
