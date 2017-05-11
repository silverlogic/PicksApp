//
//  GroupCreationViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling
    interaction with the group creation view.
*/
final class GroupCreationViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var groupNameTextField: LimitTextField!

    
    // MARK: - Public Instance Attributes
    var groupCreationViewModel: GroupCreationViewModelProtocol? {
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
        enableKeyboardManagement(false)
    }
}


// MARK: - IBActions
fileprivate extension GroupCreationViewController {
    @IBAction private func createGroupButtonTapped(sender: BaseButton) {
        if (groupNameTextField.text?.hasPrefix(" "))! {
            showInfoAlert(title:NSLocalizedString("CreateGroup.SpaceErrorTitle", comment: "get string for spacing error"), subTitle:NSLocalizedString("CreateGroup.SpaceErrorBody", comment: "get body string for spacinf error"))
            groupNameTextField.text = ""
            return
        }
        createGroup()
    }

    @IBAction private func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Public Instance Methods
extension GroupCreationViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Attributes
fileprivate extension GroupCreationViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = groupCreationViewModel else { return }
        viewModel.creationError.bind { [weak self] (error) in
            guard let strongSelf = self,
                  let creationError = error else { return }
            if creationError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                if strongSelf.groupNameTextField.text == "" {
                    strongSelf.groupNameTextField.performShakeAnimation()
                }
            } else if creationError.statusCode == 112 {
                strongSelf.showErrorAlert(title: NSLocalizedString("CreateGroup.NumberOfCharactersExceeded", comment: "alert title"), subTitle: creationError.errorDescription)
            } else {
                strongSelf.dismissProgressHudWithMessage(creationError.errorDescription, iconType: .error, duration: nil)
            }
        }
        viewModel.creationSuccess.bind { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
            strongSelf.dismiss(animated: true, completion: nil)
        }
        groupNameTextField.didReturn = { [weak self] (text) in
            guard let strongSelf = self else { return }
            strongSelf.groupCreationViewModel?.groupName = text
        }
        let titleView = NavigationView.instantiate()
        titleView.titleText = NSLocalizedString("CreateGroup.NewGroup", comment: "navigation title")
        navigationController?.navigationBar.topItem?.titleView = titleView
        enableKeyboardManagement(true)
    }
    
    /// Creates a new group.
    fileprivate func createGroup() {
        view.endEditing(true)
        showProgresHud()
        groupCreationViewModel?.createGroup(name: groupNameTextField.text!)
    }
}
