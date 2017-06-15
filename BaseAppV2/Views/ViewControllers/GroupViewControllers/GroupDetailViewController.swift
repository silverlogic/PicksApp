//
//  GroupDetailViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/11/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import PureLayout
import DZNEmptyDataSet

/**
    A `BaseViewController` responsible for
    managing the view of the details of a group.
*/
final class GroupDetailViewController: BaseViewController {
    
    // MARK: - Private Instance Attributes
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var joinedGroupBinder = DynamicBinder(false)
    fileprivate var currentUser: User?

    // MARK: - Public Instance Attributes
    var joinedGroup: DynamicBinderInterface<Bool> {
        return joinedGroupBinder.interface
    }


    // MARK: - Initializers
    var groupDetailViewModel: GroupDetailViewModelProtocol? {
        didSet {
            setup()
        }
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = SessionManager.shared.currentUser.value {
            currentUser = user
        } else {
            showInfoAlert(title: NSLocalizedString("User.NoLogIn.Title", comment: "get string for no user title"), subTitle: NSLocalizedString("User.NoLogIn.Body", comment: "get string for no log in body"))
        }
        view.backgroundColor = .white
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tableView = UITableView(frame: frame, style: .plain)
        view.addSubview(tableView)
        tableView.alpha = 0
        setup()
    }
}


// MARK: - UITableViewDataSource
extension GroupDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupDetailViewModel?.numberOfParticipants() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupTableViewCell = tableView.dequeueCell()
        return cell
    }
}


// MARK: - UITableViewDelegate
extension GroupDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color = indexPath.row % 2 == 0 ? UIColor.lightGreenField : UIColor.darkGreenField
        guard let listCell = cell as? GroupTableViewCell,
              let participant = groupDetailViewModel?.participantForIndex(indexPath.row),
              let participantName = participant.name,
              let participantScore = participant.score else { return }
        listCell.configure(name: participantName, number: participantScore, backgroundColor: color)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = GroupSectionHeader.instantiate()
        sectionHeader.configure(columnOneText: NSLocalizedString("GroupDetails.MemberName", comment: "column text"), columnTwoText: NSLocalizedString("GroupDetails.Points", comment: "column text"))
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GroupTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


// MARK: - DZNEmptyDataSetSource
extension GroupDetailViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:NSLocalizedString("EmptyState.GroupDetails.Title", comment: "get string for empty state"))
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:NSLocalizedString("EmptyState.GroupDetails.Body", comment: "get string for empty state"))
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "icon-empty-state")
    }
}


// MARK: - Private Instance Methods
fileprivate extension GroupDetailViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        guard let viewModel = groupDetailViewModel else { return }
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.register(GroupTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .teritary
        refreshControl.addTarget(self, action: #selector(fetchGroupDetails), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        let navBarLabel = navigationBarLabel(title: viewModel.name)
        navigationItem.titleView = navBarLabel
        setRightBarButtonItem(viewModel: viewModel)
        viewModel.joinSuccess.bind { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.fetchGroupDetails()
            strongSelf.dismissProgressHudWithMessage(NSLocalizedString("GroupDetails.JoinedGroup", comment: "get string for joined group success"), iconType: .success, duration: nil)
        }
        viewModel.joinError.bind { [weak self] (error) in
            guard let strongSelf = self,
            let joinError = error else { return }
            if joinError.statusCode == 400 {
                strongSelf.dismissProgressHud()
                strongSelf.showErrorAlert(title:NSLocalizedString("GroupDetails.AlreadyInErrorTitle", comment: "get string for already joined"), subTitle:NSLocalizedString("GroupDetails.AlreadyInErrorBody", comment: "get string for error body"))
            } else {
                strongSelf.dismissProgressHudWithMessage(joinError.errorDescription, iconType: .error, duration: nil)
            }
            strongSelf.refreshControl.endRefreshing()
        }
        viewModel.fetchedParticipantsSuccess.bind { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.dismissActivityIndicator()
            strongSelf.tableView.reloadData()
            //@TODO insert the newly created group at the appropriate row
            //let indexPath = IndexPath(item: , section: 0)
            //tableView.reloadRows(at: [indexPath], with: .top)
            strongSelf.refreshControl.endRefreshing()
            strongSelf.tableView.animateShow()
            strongSelf.setRightBarButtonItem(viewModel: viewModel)
        }
        viewModel.fetchedParticipantsError.bind { [weak self] (error) in
            guard let strongSelf = self,
                let error = error else { return }
            if error.statusCode == 400 {
                strongSelf.dismissProgressHud()
            } else {
                strongSelf.dismissProgressHudWithMessage(error.errorDescription, iconType: .error, duration: nil)
            }
            strongSelf.refreshControl.endRefreshing()
        }
        fetchGroupDetails()
    }

    @objc fileprivate func joinGroup() {
        view.endEditing(true)
        showProgresHud()
        guard let viewModel = groupDetailViewModel else { return }
        viewModel.joinGroup(currentUserId: SessionManager.shared.currentUser.value!.userId)
    }

    @objc fileprivate func fetchGroupDetails() {
        guard let viewModel = groupDetailViewModel else { return }
        viewModel.retrieveDetails(currentUser: currentUser!)
    }

    fileprivate func setRightBarButtonItem(viewModel: GroupDetailViewModelProtocol) {
        if viewModel.isUserMember() {
            let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-join-button"), style: .plain, target: self, action: #selector(joinGroup))
            barButton.tintColor = .clear
            barButton.isEnabled = false
            navigationItem.setRightBarButton(barButton, animated: false)
        } else {
            let image = UIImage(named: "icon-join-button")?.withRenderingMode(.alwaysOriginal)
            let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(joinGroup))
            navigationItem.setRightBarButton(barButton, animated: true)
        }
    }
}
