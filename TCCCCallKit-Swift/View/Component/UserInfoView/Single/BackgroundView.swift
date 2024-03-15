//
//  AvatarBackgroundView.swift
//  TUICallKit
//
//  Created by noah on 2023/11/2.
//

import Foundation

class BackgroundView: UIView {
    
    let viewModel = UserInfoViewModel()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.65
        return blurEffectView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // F2F2F2  // 白色
        // 303132  // 灰色
        backgroundColor = UIColor.t_colorWithHexString(color: "#F2F2F2")
                
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
        isViewReady = true
    }
    
    func constructViewHierarchy() {
        addSubview(blurEffectView)
    }
    
    func activateConstraints() {
        self.blurEffectView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
