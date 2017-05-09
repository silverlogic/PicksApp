//
//  GroupListViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import PureLayout

/**
    A `BaseViewController` responsible for
    managing a list of groups.
*/
final class GroupListViewController: BaseViewController {
    
    // MARK: - Private Instance Attributes
    fileprivate var tableView: UITableView!
    fileprivate var refreshControl: UIRefreshControl!
    
    
    // MARK: - Public Instance Attributes
    // @TODO: Add binders for notifying parent view
    
    
    // MARK: - Initializers
    // @TODO: - Implement initializer once view model exists.
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - UITableViewDataSource
extension GroupListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // @TODO: Get value from view model
        return 6
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
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let listCell = cell as? GroupTableViewCell else { return }
        let color = indexPath.row % 2 == 0 ? UIColor.lightGreenField : UIColor.darkGreenField
        listCell.configure(groupName: "Biffs Bombers", numberOfMembers: 10, backgroundColor: color)
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


// MARK: - Private Instance Attributes
fileprivate extension GroupListViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        if !isViewLoaded { return }
        // @TODO: Add binders from view model
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        tableView = UITableView(frame: frame, style: .plain)
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.register(GroupTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
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
        tableView.reloadData()
    }
    
    /// Performs intial fetch of results.
    @objc fileprivate func initialFetch() {
        refreshControl.endRefreshing()
    }
}
