//
//  GroupListViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import PureLayout
import DZNEmptyDataSet

/**
    A `BaseViewController` responsible for
    managing a list of groups.
*/
final class GroupListViewController: BaseViewController {
    
    // MARK: - Private Instance Attributes
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate var groupSelectedBinder: DynamicBinder<GroupDetailViewModelProtocol?>!


    // MARK: - Public Instance Attributes
    var groupSelected: DynamicBinderInterface<GroupDetailViewModelProtocol?> {
        return groupSelectedBinder.interface
    }
    var groupQueryViewModel: GroupQueryViewModelProtocol? {
        didSet {
            setup()
        }
    }
    

    // MARK: - Initializers

    /// Initializes an instance of `GroupListViewController`.
    init() {
        super.init(nibName: nil, bundle: nil)
        groupSelectedBinder = DynamicBinder(nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialFetch()
    }
}


// MARK: - UITableViewDataSource
extension GroupListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupQueryViewModel?.numberOfGroups() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupTableViewCell = tableView.dequeueCell()
        return cell
    }
}


// MARK: - UITableViewDelegate
extension GroupListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let groupViewModel = groupQueryViewModel?.groupForIndex(indexPath.row) else { return }
        groupSelectedBinder.value = groupViewModel
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let groupCell = cell as? GroupTableViewCell,
              let groupViewModel = groupQueryViewModel?.groupForIndex(indexPath.row) else { return }
        let color = indexPath.row % 2 == 0 ? UIColor.lightGreenField : UIColor.darkGreenField
        groupCell.configure(name: groupViewModel.name, number: groupViewModel.numberOfParticipants(), backgroundColor: color)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = GroupSectionHeader.instantiate()
        sectionHeader.configure(columnOneText: NSLocalizedString("GroupList.GroupName", comment: "column text"), columnTwoText: NSLocalizedString("GroupList.Members", comment: "column text"))
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GroupTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}


// MARK: - DZNEmptyDataSetSource
extension GroupListViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: NSLocalizedString("EmptyState.GroupDetails.Title", comment: "get string for empty state title"))
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string:NSLocalizedString("EmptyState.GroupList.Body", comment: "get string for empty body"))
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "icon-empty-state")
    }
}


// MARK: - Private Instance Methods
fileprivate extension GroupListViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tableView = UITableView(frame: frame, style: .plain)
        view.addSubview(tableView)
        tableView.alpha = 0.0
        if !isViewLoaded { return }
        guard let viewModel = groupQueryViewModel else { return }
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 45, right: 0)
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.register(GroupTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        automaticallyAdjustsScrollViewInsets = false
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .teritary
        refreshControl.addTarget(self, action: #selector(initialFetch), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        viewModel.groupsFetched.bind { [weak self] (fetched) in
            guard let strongSelf = self else { return }
            strongSelf.dismissActivityIndicator()
            strongSelf.tableView.reloadData()
            strongSelf.refreshControl.endRefreshing()
            strongSelf.tableView.animateShow()
        }
        viewModel.fetchGroupsError.bind { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.refreshControl.endRefreshing()
            strongSelf.dismissActivityIndicator()
        }
        showActivityIndicator()
        initialFetch()
    }

    /// Performs intial fetch of results.
    @objc fileprivate func initialFetch() {
        groupQueryViewModel?.fetchGroups()
    }
}
