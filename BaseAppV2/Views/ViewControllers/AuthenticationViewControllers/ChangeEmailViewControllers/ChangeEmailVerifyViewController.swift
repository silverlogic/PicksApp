//
//  ChangeEmailVerifyViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling interaction
    from the change email verify view.
*/
final class ChangeEmailVerifyViewController: BaseViewController {
    
    // MARK: - Public Instance Attributes
    var changeEmailVerifyViewModel: ChangeEmailVerifyViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - IBActions
fileprivate extension ChangeEmailVerifyViewController {
    @IBAction private func verifyEmailButtonTapped(_ sender: BaseButton) {
        showProgresHud()
        changeEmailVerifyViewModel?.changeEmailVerify()
    }
}


// MARK: - Private Instance Methods
fileprivate extension ChangeEmailVerifyViewController {
    
    /// Sets up the default logic for the view
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = changeEmailVerifyViewModel else { return }
        viewModel.changeEmailVerifyError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let changeEmailError = error else { return }
            strongSelf.dismissProgressHudWithMessage(changeEmailError.errorDescription, iconType: .error, duration: nil)
        }
        viewModel.changeEmailVerifySuccess.bind { [weak self] (success: Bool) in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Miscellaneous.Cancel", comment: "button"), style: .plain, target: self, action: #selector(cancelChangeEmail))
    }
    
    /// Cancels change email.
    @objc fileprivate func cancelChangeEmail() {
        changeEmailVerifyViewModel?.cancelChangeEmail()
    }
}
