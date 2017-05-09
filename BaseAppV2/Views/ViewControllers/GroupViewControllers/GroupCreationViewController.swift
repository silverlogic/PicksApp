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
    @IBOutlet fileprivate weak var numberOfPeopleTextField: ToolBarTextField!
    
    
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
        createGroup()
    }
    
    @IBAction private func cancelButtonTapped(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITextFieldDelegate
extension GroupCreationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              let number = Int(text) else { return }
        groupCreationViewModel?.numberOfPeople = number
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
                if strongSelf.numberOfPeopleTextField.text == "" {
                    strongSelf.dismissProgressHud()
                    strongSelf.numberOfPeopleTextField.performShakeAnimation()
                }
            } else if creationError.statusCode == 112 {
                strongSelf.showErrorAlert(title: NSLocalizedString("CreateGroup.NumberOfCharactersExceeded", comment: "alert title"), subTitle: creationError.errorDescription)
            } else {
                strongSelf.dismissProgressHudWithMessage(creationError.errorDescription, iconType: .error, duration: nil)
            }
        }
        viewModel.creationSuccess.bind { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
        groupNameTextField.didReturn = { [weak self] (text) in
            guard let strongSelf = self else { return }
            strongSelf.groupCreationViewModel?.groupName = text
            strongSelf.numberOfPeopleTextField.becomeFirstResponder()
        }
        numberOfPeopleTextField.delegate = self
        numberOfPeopleTextField.nextButtonTapped = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.createGroup()
        }
        numberOfPeopleTextField.previousButtonTapped = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.endEditing(true)
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
        groupCreationViewModel?.createGroup()
    }
}
