//
//  WindowManger.swift
//  TCCCCallKit-Swift
//
//  Created by gavinwjwang on 2024/2/19.
//

import Foundation

class WindowManager: NSObject, FloatingWindowViewDelegate {
    
    static let instance = WindowManager()
    
    var isFloating = false
    var floatWindowBeganPoint: CGPoint = .zero
    
    let callWindow = UIWindow()
    let floatWindow: UIWindow = {
        let view = UIWindow()
        view.layer.masksToBounds = true
        return view
    }()
    
    override init() {
        super.init()
    }
    
    deinit {
        
    }
    
    func showCallWindow() {
        closeFloatWindow()
        callWindow.rootViewController =  CallKitNavigationController(rootViewController: CallKitViewController())
        callWindow.isHidden = false
        callWindow.t_makeKeyAndVisible()
    }
    
    func closeCallWindow() {
        callWindow.rootViewController = UIViewController()
        callWindow.isHidden = true
    }
    
    func showFloatWindow() {
        closeCallWindow()
        let floatViewController = FloatWindowViewController()
        floatViewController.delegate = self
        floatWindow.rootViewController = floatViewController
        floatWindow.backgroundColor = UIColor.clear
        floatWindow.isHidden = false
        floatWindow.frame = getFloatWindowFrame()
        updateFloatWindowFrame()
        floatWindow.t_makeKeyAndVisible()
        isFloating = true
    }
    
    func closeFloatWindow() {
        floatWindow.rootViewController = UIViewController()
        floatWindow.isHidden = true
        isFloating = false
    }
    
    func getFloatWindowFrame() -> CGRect {
        return kMicroAudioViewRect
    }
    
    func updateFloatWindowFrame() {
        let originY = floatWindow.frame.origin.y
        
        let dstX = floatWindow.frame.origin.x < (Screen_Width / 2.0) ? 0 : (Screen_Width - kMicroAudioViewWidth)
        floatWindow.frame = CGRect(x: dstX, y: originY, width: kMicroAudioViewWidth, height: kMicroAudioViewHeight)
    }
    
    // MARK: FloatingWindowViewDelegate
    func tapGestureAction(tapGesture: UITapGestureRecognizer) {
        showCallWindow()
    }
    
    func panGestureAction(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            floatWindowBeganPoint = floatWindow.frame.origin
            break
        case.changed:
            let point = panGesture.translation(in: floatWindow)
            var dstX = floatWindowBeganPoint.x + point.x
            var dstY = floatWindowBeganPoint.y + point.y
            
            if dstX < 0 {
                dstX = 0
            } else if dstX > (Screen_Width - floatWindow.frame.size.width) {
                dstX = Screen_Width - floatWindow.frame.size.width
            }
            
            if dstY < 0 {
                dstY = 0
            } else if dstY > (Screen_Height - floatWindow.frame.size.height) {
                dstY = Screen_Height - floatWindow.frame.size.height
                
            }
            
            floatWindow.frame = CGRect(x: dstX,
                                       y: dstY,
                                       width: floatWindow.frame.size.width,
                                       height: floatWindow.frame.size.height)
            break
        case.cancelled:
            break
        case.ended:
            var dstX: CGFloat = 0
            let currentCenterX: CGFloat = floatWindow.frame.origin.x + floatWindow.frame.size.width / 2.0
            
            if currentCenterX < Screen_Width / 2 {
                dstX = CGFloat(0)
            } else if currentCenterX > Screen_Width / 2 {
                dstX = CGFloat(Screen_Width - floatWindow.frame.size.width)
            }
            
            floatWindow.frame = CGRect(x: dstX,
                                       y: floatWindow.frame.origin.y,
                                       width: floatWindow.frame.size.width,
                                       height: floatWindow.frame.size.height)
            break
        default:
            break
        }
    }
}
