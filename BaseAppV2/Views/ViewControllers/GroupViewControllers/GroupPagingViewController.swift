//
//  GroupPagingViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import Tabman
import Pageboy

/**
    A `TabmanViewController` responsible for managing and
    responding to events from its child view controllers
*/
final class GroupPagingViewController: TabmanViewController {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var tabmanView: UIView!
    
    
    // MARK: - Private Instance Attributes
    // @TODO: - Hold references to child views for responding to events
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - Navigation
extension GroupPagingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        if segueIdentifier == UIStoryboardSegue.goToNewGroupSegue {
            guard let navigationController = segue.destination as? BaseNavigationController,
                  let createGroupViewController = navigationController.topViewController as? GroupCreationViewController else { return }
            createGroupViewController.groupCreationViewModel = ViewModelsManager.groupCreationViewModel()
        } else {
            // @TODO: - Go to group detail view. Pass view model for group.
        }
    }
}


// MARK: - IBActions
fileprivate extension GroupPagingViewController {
    @IBAction private func createGroupButtonTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: UIStoryboardSegue.goToNewGroupSegue, sender: nil)
    }
}


// MARK: - PageboyViewControllerDataSource
extension GroupPagingViewController: PageboyViewControllerDataSource {
    func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
        // @TODO: - Add custom views from nib
        let viewControllers = [GroupListViewController(), GroupListViewController()]
        bar.items = [TabmanBarItem(title: NSLocalizedString("GroupPaging.MyGroups", comment: "tab title").uppercased()),
                     TabmanBarItem(title: NSLocalizedString("GroupPaging.Public", comment: "tab title").uppercased())]
        return viewControllers
    }
    
    func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex? {
        return nil
    }
}


// MARK: - Private Instance Methods
fileprivate extension GroupPagingViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        // @TODO: - Initialize child views and view models
        dataSource = self
        bar.style = .blockTabBar
        bar.appearance = TabmanBar.Appearance({ (apperance) in
            apperance.indicator.preferredStyle = .clear
            apperance.indicator.color = .teritary
            apperance.state.selectedColor = .secondary
            apperance.state.color = .teritary
            apperance.text.font = .mainBoldMedium
            apperance.layout.height = .explicit(value: 45.0)
            apperance.layout.edgeInset = 0.0
            apperance.style.background = .solid(color: .secondary)
            apperance.style.bottomSeparatorColor = .lightGray
        })
        embedBar(inView: tabmanView)
        let titleView = NavigationView.instantiate()
        titleView.titleText = NSLocalizedString("GroupPaging.Groups", comment: "navigation title")
        navigationController?.navigationBar.topItem?.titleView = titleView
    }
}
