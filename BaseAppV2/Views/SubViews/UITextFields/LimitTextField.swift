//
//  LimitTextField.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/11/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A subclass of `BaseTextField`. This type can
    be used for limiting the number of characters
    a user can supply. It also provides it's own
    binders for notifying when the user hits the
    return key on the keyboard.
*/
@IBDesignable final class LimitTextField: BaseTextField {
    
    // MARK: - Private Instance Attributes
    fileprivate var maximumNumberOfCharacters = 0
    
    
    // MARK: - Public Instance Attributes
    
    /**
        Optional closure that gets invoked when the return button gets tapped.
     
        - Parameter text: A `String` representing the text entered.
    */
    var didReturn: ((_ text: String) -> Void)?
    
    
    // MARK: - IBInspectable
    @IBInspectable var maxNumberOfCharacters: Int = 0 {
        didSet {
            maximumNumberOfCharacters = maxNumberOfCharacters
        }
    }
}


// MARK: - Lifecycle
extension LimitTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
    }
}


// MARK: - UITextFieldDelegate
extension LimitTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let closure = didReturn else { return true }
        closure(textField.text ?? "")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let textLength = (textField.text?.characters.count)! + string.characters.count
        if textLength > maximumNumberOfCharacters {
            return false
        }
        return true
    }
}
