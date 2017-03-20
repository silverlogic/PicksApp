//
//  ProfileViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseViewController` responsible for handling
    interaction from the profile view of a user.
*/
final class ProfileViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    
    // MARK: - Public Instance Attributes
    var profileViewModel: ProfileViewModel? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate enum Profile: Int, CaseCount {
        case image
        case info
        static let caseCount = Profile.numberOfCases()
    }
}


// MARK: - Lifecycle
extension ProfileViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}


// MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Profile.caseCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Profile(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .image:
            let profileImageCell: ProfileImageTableViewCell = tableView.dequeueCell()
            return profileImageCell
        case .info:
            let profileInfoCell: ProfileInfoTableViewCell = tableView.dequeueCell()
            profileInfoCell.configure(fullName: (profileViewModel?.fullName)!, email: (profileViewModel?.email)!)
            return profileInfoCell
        }
    }
}


// MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Profile(rawValue: indexPath.section), section == .image,
              let url = profileViewModel?.avatar.value,
              let profileImageCell = cell as? ProfileImageTableViewCell else { return }
        profileImageCell.setImageWithUrl(url)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Profile(rawValue: indexPath.section), section == .image,
              let profileImageCell = cell as? ProfileImageTableViewCell else { return }
        profileImageCell.cancelImageDownload()
    }
}


// MARK: - Private Instance Methods
fileprivate extension ProfileViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = profileViewModel else { return }
        viewModel.avatar.bindAndFire { [weak self] (url: URL?) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.beginUpdates()
            let indexPath = IndexPath(row: 0, section: Profile.image.rawValue)
            strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
            strongSelf.tableView.endUpdates()
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
}
