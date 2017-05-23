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
    fileprivate var joinedGroupBinder = DynamicBinder(false)

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
        guard let listCell = cell as? GroupTableViewCell,
              let participant = groupDetailViewModel?.participantForIndex(indexPath.row) else { return }
        let color = indexPath.row % 2 == 0 ? UIColor.lightGreenField : UIColor.darkGreenField
        listCell.configure(name: participant.name, number: participant.score, backgroundColor: color)
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
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tableView = UITableView(frame: frame, style: .plain)
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.register(GroupTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        addNavBarTitle(viewModel: viewModel)
        tableView.reloadData()
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
        viewModel.joinSuccess.bind { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.reloadData()
            strongSelf.dismissActivityIndicator()
            strongSelf.tableView.animateShow()
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
        }
    }

    private func addNavBarTitle(viewModel: GroupDetailViewModelProtocol) {
        let navBarTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 77.0))
        navBarTitle.font = UIFont.main(DefaultFonts.bold, DefaultFontSizes.large)
        navBarTitle.textColor = UIColor.white
        let title = NSMutableAttributedString()
        let starAttachment = NSTextAttachment()
        starAttachment.image = #imageLiteral(resourceName: "icon-star")
        let starImage = NSAttributedString(attachment: starAttachment)
        title.append(starImage)
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: viewModel.name))
        title.append(NSAttributedString(string: " "))
        title.append(starImage)
        navBarTitle.textAlignment = .center
        navBarTitle.attributedText = title
        navigationItem.titleView = navBarTitle
    }

    @objc fileprivate func joinGroup() {
        view.endEditing(true)
        showProgresHud()
        groupDetailViewModel?.joinGroup(groupId: (groupDetailViewModel?.groupId)!)
    }
}
