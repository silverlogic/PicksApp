//
//  ForgotPasswordRequestViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling interaction
    from the forgot password view when the user enters an email.
*/
final class ForgotPasswordRequestViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var emailTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var forgotPasswordViewModel: ForgotPasswordViewModel? {
        didSet {
            setup()
        }
    }
}


// MARK: - Lifecycle
extension ForgotPasswordRequestViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        enableKeyboardManagement(false)
    }
}


// MARK: - IBActions
fileprivate extension ForgotPasswordRequestViewController {
    @IBAction private func submitButtonTapped(_ sender: BaseButton) {
        forgotPasswordRequest()
    }
}


// MARK: - UITextFieldDelegate
extension ForgotPasswordRequestViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        forgotPasswordRequest()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        forgotPasswordViewModel?.email = textField.text!
    }
}


// MARK: - Public Instance Methods
extension ForgotPasswordRequestViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
fileprivate extension ForgotPasswordRequestViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = forgotPasswordViewModel else { return }
        viewModel.forgotPasswordError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let forgotPasswordError = error else { return }
            if forgotPasswordError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                strongSelf.emailTextField.performShakeAnimation()
                return
            }
            strongSelf.dismissProgressHudWithMessage(forgotPasswordError.errorDescription, iconType: .error, duration: nil)
        }
        viewModel.forgotPasswordRequestSuccess.bind { [weak self] (success: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
            _ = strongSelf.navigationController?.popViewController(animated: true)
        }
        emailTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    /// Sends a forgot password request to the email.
    fileprivate func forgotPasswordRequest () {
        view.endEditing(true)
        showProgresHud()
        forgotPasswordViewModel?.forgotPasswordRequest()
    }
}
