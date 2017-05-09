//
//  ToolBarTextField.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A subclass of `BaseTextField`. This
    type can be used for textfields that
    display some kind of number pad. This solves
    the issue of not having a previous and next
    button avaliable in the keyboard.
*/
@IBDesignable final class ToolBarTextField: BaseTextField {
    
    // MARK: - Private Instance Attributes
    fileprivate var backButtonString = ""
    fileprivate var nextButtonString = ""
    
    
    // MARK: - Public Instance Attributes
    
    /// Optional closure that gets invoked when the next button gets tapped.
    var nextButtonTapped: (() -> Void)?
    
    /// Optional closure that gets invoked when the previous button gets tapped.
    var previousButtonTapped: (() -> Void)?
    
    
    // MARK: - IBInspectable
    @IBInspectable var backButtonText: String = "" {
        didSet {
            backButtonString = backButtonText
        }
    }
    
    @IBInspectable var nextButtonText: String = "" {
        didSet {
            nextButtonString = nextButtonText
        }
    }
}


// MARK: - Lifecycle
extension ToolBarTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}


// MARK: - Private Instance Methods
fileprivate extension ToolBarTextField {
    
    /// Initializes the view and adds a toolbar.
    fileprivate func setup() {
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.barTintColor = .main
        let nextButton = UIBarButtonItem(title: nextButtonString, style: .done, target: self, action: #selector(nextTapped))
        let previousButton = UIBarButtonItem(title: backButtonString, style: .plain, target: self, action: #selector(previousTapped))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([previousButton, flexible, nextButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    /// Method for handling the user tapping the next button.
    @objc private func nextTapped() {
        guard let closure = nextButtonTapped else { return }
        closure()
    }
    
    /// Method for handling the user tapping the previous button.
    @objc private func previousTapped() {
        guard let closure = previousButtonTapped else { return }
        closure()
    }
}
