//
//  UIViewController.swift
//  Snapp
//
//  Created by Behdad Keynejad on 3/30/1397 AP.
//  Copyright © 1397 AP Snapp. All rights reserved.
//
import UIKit

extension UIViewController {
    @objc open func embed(childViewController: UIViewController, in containerView: UIView) {
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        containerView.addExpletiveSubView(view: childViewController.view)
    }
}
