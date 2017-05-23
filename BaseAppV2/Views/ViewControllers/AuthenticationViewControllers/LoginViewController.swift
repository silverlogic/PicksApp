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
    @IBOutlet fileprivate weak var facebookButton: BaseButton!
    @IBOutlet fileprivate weak var welcomeLabel: UILabel!

    
    // MARK: - Public Instance Attributes
    var loginViewModel: LoginViewModelProtocol? {
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
        super.viewWillDisappear(true)
        if (navigationController?.isBeingDismissed)! {
            enableKeyboardManagement(false)
        }
    }


    // MARK: - IBActions
    @IBAction func facebookLoginTapped(_ sender: BaseButton) {
        loginWithFacebook()
    }
}


// MARK: - Navigation
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        if segueIdentifier == UIStoryboardSegue.goToSignupEmailSegue {
            guard let signupEmailViewController = segue.destination as? SignupEmailViewController else { return }
            signupEmailViewController.signUpViewModel =  ViewModelsManager.signUpViewModel()
        } else {
            guard let forgotPasswordRequestViewController = segue.destination as? ForgotPasswordRequestViewController else { return }
            forgotPasswordRequestViewController.forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: nil)
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
        welcomeLabel.text = NSLocalizedString("Miscellaneous.WelcomeToXtraPoints", comment: "get string for welcome label")
        guard let viewModel = loginViewModel else { return }
        viewModel.loginError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let loginError = error else { return }
            if loginError.statusCode == 105 {
                strongSelf.dismissProgressHud()
                strongSelf.showEditAlert(title: NSLocalizedString("Miscellaneous.EmailMissing", comment: "alert title"), subtitle: loginError.errorDescription, textFieldAttributes: [AlertTextFieldAttributes(placeholder: NSLocalizedString("Miscellaneous.Email", comment: "placeholder"), isSecureTextEntry: false, keyboardType: .emailAddress, autocorrectionType: .no, autocapitalizationType: .none, spellCheckingType: .no, returnKeyType: .done)], submitButtonTapped: { [weak self] (enteredValues: [String : String]) in
                    guard let strongSelf = self else { return }
                    let email = enteredValues[NSLocalizedString("Miscellaneous.Email", comment: "alert title")]
                    strongSelf.showProgresHud()
                    viewModel.loginWithFacebook(email: email)
                })
            } else if loginError.statusCode == 107 {
                strongSelf.dismissProgressHud()
                strongSelf.showEditAlert(title: NSLocalizedString("Miscellaneous.EmailMissing", comment: "alert title"), subtitle: loginError.errorDescription, textFieldAttributes: [AlertTextFieldAttributes(placeholder: NSLocalizedString("Miscellaneous.Email", comment: "placeholder"), isSecureTextEntry: false, keyboardType: .emailAddress, autocorrectionType: .no, autocapitalizationType: .none, spellCheckingType: .no, returnKeyType: .done)], submitButtonTapped: { [weak self] (enteredValues: [String : String]) in
                    guard let strongSelf = self else { return }
                    let email = enteredValues[NSLocalizedString("Miscellaneous.Email", comment: "alert title")]
                    strongSelf.showProgresHud()
                    viewModel.loginWithTwitter(email: email)
                })
            } else {
                strongSelf.dismissProgressHudWithMessage(loginError.errorDescription, iconType: .error, duration: nil)
            }
        }
        viewModel.loginSuccess.bind { [weak self] (loginSuccesful: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
        }
        viewModel.oauthStep1Error.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let step1Error = error else { return }
            strongSelf.dismissProgressHudWithMessage(step1Error.errorDescription, iconType: .error, duration: nil)
        }
        viewModel.twitterOAuthUrl.bind { [weak self] (url: URL?) in
            guard let strongSelf = self,
                  let oauthUrl = url else { return }
            strongSelf.dismissProgressHud()
            let socialAuthWebViewController = SocialAuthWebViewController(redirectUri: viewModel.twitterRedirectUri, oauthUrl: oauthUrl)
            socialAuthWebViewController.redirectUrlWithQueryParametersRecievedClosure = { [weak self] (redirectUrlWithQueryParameters: URL) in
                guard let strongSelf = self else { return }
                viewModel.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
                strongSelf.showProgresHud()
                viewModel.loginWithTwitter(email: nil)
            }
            let baseNavigationController = BaseNavigationController(rootViewController: socialAuthWebViewController)
            strongSelf.present(baseNavigationController, animated: true, completion: nil)
        }
        viewModel.loginBegan.bind { [weak self] (began) in
            guard let strongSelf = self else { return }
            strongSelf.showProgresHud()
        }
        viewModel.facebookPermissionsDenied.bind { [weak self] (denied) in
            guard let strongSelf = self else { return }
            strongSelf.showErrorAlert(title: NSLocalizedString("Miscellaneous.FacebookError", comment: "get string for title"), subTitle: NSLocalizedString("Miscellaneous.FacebookErrorBody", comment: "get string for body"))
        }
        enableKeyboardManagement(true)
    }

    /// Initiates the facebook login process
    fileprivate func loginWithFacebook() {
        view.endEditing(true)
        loginViewModel?.loginToFacebook(viewController: self)
    }
}
