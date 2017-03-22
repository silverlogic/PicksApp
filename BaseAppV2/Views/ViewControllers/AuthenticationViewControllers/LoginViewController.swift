//
//  LoginViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling interaction
    from the login view.
*/
final class LoginViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: BaseTextField!
    @IBOutlet weak var passwordTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var loginViewModel: LoginViewModel? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate enum LoginButtons: Int, CaseCount {
        case login
        case facebook
        case twitter
        case createAccount
        case forgotPassword
        static let caseCount = LoginButtons.numberOfCases()
    }
}


// MARK: - Lifecycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let signupEmailViewController = segue.destination as? SignupEmailViewController else { return }
        signupEmailViewController.signUpViewModel = SignUpViewModel()
    }
}


// MARK: - IBActions
fileprivate extension LoginViewController {
    @IBAction private func baseButtonTapped(_ sender: BaseButton) {
        guard let tag = LoginButtons(rawValue: sender.tag) else { return }
        switch tag {
        case .login:
            loginWithEmail()
            break
        case .facebook:
            let socialAuthWebViewController = SocialAuthWebViewController(redirectUri: (loginViewModel?.facebookRedirectUri)!, oauthUrl: (loginViewModel?.facebookOAuthUrl)!)
            socialAuthWebViewController.redirectUrlWithQueryParametersRecievedClosure = { [weak self] (redirectUrlWithQueryParameters: URL) in
                guard let strongSelf = self else { return }
                strongSelf.loginViewModel?.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
                strongSelf.showProgresHud()
                strongSelf.loginViewModel?.loginWithFacebook(email: nil)
            }
            let baseNavigationController = BaseNavigationController(rootViewController: socialAuthWebViewController)
            present(baseNavigationController, animated: true, completion: nil)
            break
        case .twitter:
            break
        case .createAccount:
            performSegue(withIdentifier: UIStoryboardSegue.goToSignupEmailSegue, sender: nil)
            break
        case .forgotPassword:
            break
        }
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            loginWithEmail()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            loginViewModel?.email = textField.text!
        } else {
            loginViewModel?.password = textField.text!
        }
    }
}


// MARK: - Public Instance Methods
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
fileprivate extension LoginViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = loginViewModel else { return }
        viewModel.loginError.bindAndFire { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let loginError = error else { return }
            if loginError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                if (strongSelf.emailTextField.text?.isEmpty)! {
                    strongSelf.emailTextField.performShakeAnimation()
                }
                if (strongSelf.passwordTextField.text?.isEmpty)! {
                    strongSelf.passwordTextField.performShakeAnimation()
                }
            } else if loginError.statusCode == 103 {
            } else {
                strongSelf.dismissProgressHudWithMessage(loginError.errorDescription, iconType: .error, duration: nil)
            }
        }
        viewModel.loginSuccess.bindAndFire { [weak self] (loginSuccesful: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
        }
        emailTextField.delegate = self
        passwordTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    /// Logs in the user with email.
    fileprivate func loginWithEmail() {
        view.endEditing(true)
        showProgresHud()
        loginViewModel?.loginWithEmail()
    }
}
