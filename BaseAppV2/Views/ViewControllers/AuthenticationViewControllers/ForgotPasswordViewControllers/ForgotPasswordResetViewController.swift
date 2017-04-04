//
//  ForgotPasswordResetViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling interaction
    from the forgot password view when the user enters a new
    password.
*/
final class ForgotPasswordResetViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var newPasswordTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var forgotPasswordViewModel: ForgotPasswordViewModel? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (navigationController?.isBeingDismissed)! {
            enableKeyboardManagement(false)
        }
    }
}


// MARK: - IBActions
fileprivate extension ForgotPasswordResetViewController {
    @IBAction private func resetButtonTapped(_ sender: BaseButton) {
        forgotPasswordReset()
    }
    
    @IBAction private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        forgotPasswordViewModel?.cancelResetPassword()
    }
}


// MARK: - UITextFieldDelegate
extension ForgotPasswordResetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        forgotPasswordReset()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        forgotPasswordViewModel?.newPassword = textField.text!
    }
}


// MARK: - Public Instance Methods
extension ForgotPasswordResetViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
fileprivate extension ForgotPasswordResetViewController {
    
    /// Sets up the default logic for the view
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = forgotPasswordViewModel else { return }
        viewModel.forgotPasswordError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let forgotPasswordError = error else { return }
            if forgotPasswordError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                strongSelf.newPasswordTextField.performShakeAnimation()
                return
            }
            strongSelf.dismissProgressHudWithMessage(forgotPasswordError.errorDescription, iconType: .error, duration: nil)
        }
        viewModel.forgotPasswordResetSuccess.bind { [weak self] (success: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
        }
        newPasswordTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    /// Resets the password of the user.
    fileprivate func forgotPasswordReset() {
        view.endEditing(true)
        showProgresHud()
        forgotPasswordViewModel?.forgotPasswordReset()
    }
}
