//
//  UIViewController+Extension.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 5/5/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
