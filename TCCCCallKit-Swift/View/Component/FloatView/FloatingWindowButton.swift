//
//  FloatingWindowButton.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class FloatingWindowButton: UIView {
    
    let floatButton: FloatingWindowCustomButton = {
        let floatButton = FloatingWindowCustomButton(type: .system)
        return floatButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateImage()
        registerObserveState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    // MARK: UI Specification Processing
    private var isViewReady: Bool = false
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if isViewReady { return }
        constructViewHierarchy()
        activateConstraints()
        bindInteraction()
        isViewReady = true
    }
    
    func constructViewHierarchy() {
        addSubview(floatButton)
    }
    
    func activateConstraints() {
        floatButton.snp.makeConstraints { make in
            make.center.equalTo(self).offset(5)
            make.width.height.equalTo(32)
        }
    }
    
    func bindInteraction() {
        floatButton.addTarget(self, action: #selector(clickFloatButton(sender: )), for: .touchUpInside)
    }
    
    // MARK:  Action Event
    @objc func clickFloatButton(sender: UIButton) {
        WindowManager.instance.showFloatWindow()
    }
    
    // MARK: Register TUICallState Observer && Update UI
    func registerObserveState() {
       
    }
    
    func updateImage() {
        // ic_min_window_dark
        // ic_min_window_white
        if let image = TUICallKitCommon.getBundleImage(name: "ic_min_window_dark") {
            floatButton.setBackgroundImage(image, for: .normal)
        }
    }
}

class FloatingWindowCustomButton: UIButton {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let expandedBounds = bounds.insetBy(dx: -6, dy: -6)
        return expandedBounds.contains(point) ? self : nil
    }
}
