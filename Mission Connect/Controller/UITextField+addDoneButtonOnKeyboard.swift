//
//  UITextField+addDoneButtonOnKeyboard.swift
//  Mission Connect
//
//  Created by Anirudh Valiveru on 5/7/20.
//  Copyright © 2020 Anirudh Valiveru. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

   func addDoneButtonOnKeyboard() {
       let keyboardToolbar = UIToolbar()
       keyboardToolbar.sizeToFit()
       let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
           target: nil, action: nil)
       let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
           target: self, action: #selector(resignFirstResponder))
       keyboardToolbar.items = [flexibleSpace, doneButton]
       self.inputAccessoryView = keyboardToolbar
   }
}
