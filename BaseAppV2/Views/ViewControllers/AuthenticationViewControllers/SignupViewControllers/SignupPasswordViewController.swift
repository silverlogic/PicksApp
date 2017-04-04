//
//  SignupPasswordViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling
    interaction from the sign up view for entering
    a password.
*/
final class SignupPasswordViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var passwordTextField: BaseTextField!
    @IBOutlet weak var confirmPasswordTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var signUpViewModel: SignUpViewModel? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (navigationController?.isBeingDismissed)! {
            enableKeyboardManagement(false)
        }
    }
}


// MARK: - Navigation
extension SignupPasswordViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let signupOptionalInfoViewController = segue.destination as? SignupOptionalInfoViewController else { return }
        signupOptionalInfoViewController.signUpViewModel = signUpViewModel!
    }
}


// MARK: - IBActions
fileprivate extension SignupPasswordViewController {
    @IBAction private func nextButtonTapped(_ sender: BaseButton) {
        continueSignup()
    }
}


// MARK: - UITextFieldDelegate
extension SignupPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else {
            continueSignup()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            signUpViewModel?.password = textField.text!
        } else {
            signUpViewModel?.confirmPassword = textField.text!
        }
    }
}


// MARK: - Public Instance Methods
extension SignupPasswordViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
fileprivate extension SignupPasswordViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = signUpViewModel else { return }
        viewModel.signUpError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let passwordError = error else { return }
            if passwordError.statusCode == 101 {
                if (strongSelf.passwordTextField.text?.isEmpty)! {
                    strongSelf.passwordTextField.performShakeAnimation()
                }
                if (strongSelf.confirmPasswordTextField.text?.isEmpty)! {
                    strongSelf.confirmPasswordTextField.performShakeAnimation()
                }
            } else {
                strongSelf.showDodoAlert(message: passwordError.errorDescription, alertType: .error)
            }
        }
        viewModel.signUpSuccess.bind { [weak self] (success: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: UIStoryboardSegue.goToSignupOptionalInfoSegue, sender: nil)
        }
        passwordTextField.text = viewModel.password
        confirmPasswordTextField.text = viewModel.confirmPassword
    }
    
    /// Checks if password info entered is correct.
    fileprivate func continueSignup() {
        view.endEditing(true)
        signUpViewModel?.validatePassword()
    }
}
