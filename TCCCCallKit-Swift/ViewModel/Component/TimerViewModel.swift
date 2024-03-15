//
//  TimerViewModel.swift
//  TUICallKit
//
//  Created by vincepzhang on 2023/2/24.
//

import Foundation

class TimerViewModel {

    let timeCountObserver = Observer()

    let timeCount: Observable<Int> = Observable(0)
    
    init() {
        timeCount.value = TUICallState.instance.timeCount.value
        registerObserve()
    }
    
    deinit {
        TUICallState.instance.timeCount.removeObserver(timeCountObserver)
    }
    
    func registerObserve() {
        TUICallState.instance.timeCount.addObserver(timeCountObserver, closure: { [weak self] newValue, _ in
            guard let self = self else { return }
            self.timeCount.value = newValue

        })
        
    }
    
    func getCallTimeString() -> String {
        return GCDTimer.secondToHMSString(second: timeCount.value)
    }
}
