//
//  SNPKeybordHeightConstraint.swift
//  Pods-SNPUtilities_Example
//
//  Created by farhad jebelli on 7/31/18.
//

import Foundation
@IBDesignable
class SNPKeybordHeightConstraint: NSLayoutConstraint {
    
    @IBInspectable var useSafeArea: Bool = true
    @IBInspectable var margin: CGFloat = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(keybordFrameChanged), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: HandleKeyBord
    var isKeybordHide:Bool = true
    @objc func keybordFrameChanged(notification: Notification) {
        setKeybordHeigth(notification: notification)
    }
    @objc func keybordShow(notification: Notification) {
        isKeybordHide = false
        setKeybordHeigth(notification: notification)
        
    }
    @objc func keybordHide(notification: Notification) {
        isKeybordHide = true
        let time = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CFTimeInterval) ?? 3.0
        CATransaction.begin()
        CATransaction.setAnimationDuration(time)
        self.constant = self.margin
        CATransaction.commit()
        CATransaction.flush()
    }
    func setKeybordHeigth(notification: Notification){
        if !isKeybordHide {
            guard let userInfo = notification.userInfo, let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else{
                return
            }
            guard let view = UIApplication.shared.keyWindow?.rootViewController?.view else {
                return
            }
            let convertedFrame = view.convert(frame, from: UIScreen.main.coordinateSpace)
            let intersectedKeyboardHeight = view.frame.intersection(convertedFrame).height
            
            var height = intersectedKeyboardHeight
            if useSafeArea {
                let bottom: CGFloat
                if #available(iOS 11.0, *) {
                    bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                } else {
                    bottom = UIApplication.shared.keyWindow?.layoutMargins.bottom ?? 0
                }
                if height > bottom {
                    height -= bottom
                }
            }
            
            let time = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? CFTimeInterval) ?? 3.0
            CATransaction.begin()
            CATransaction.setAnimationDuration(time)
            self.constant = height + self.margin
            CATransaction.commit()
            CATransaction.flush()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
