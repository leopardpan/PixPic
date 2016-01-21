//
//  ProfileViewController.swift
//  P-effect
//
//  Created by Illya on 1/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var profileSettingsButton: UIBarButtonItem!
    @IBOutlet private weak var userAvatar: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var tableViewFooter: UIView!
    
    var model: ProfileViewModel!
    private var activityShown: Bool?
    private var dataSource: PostDataSource? {
        didSet {
            dataSource?.tableView = tableView
            dataSource?.fetchData(nil)
            self.view.makeToastActivity(CSToastPositionCenter)
            activityShown = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    // MARK: - Inner func 
    func setupController() {
        dataSource = PostDataSource()
        tableView.dataSource = dataSource
        self.tableView.registerNib(PostViewCell.nib, forCellReuseIdentifier: kPostViewCellIdentifier)
        userAvatar.layer.cornerRadius = Constants.Profile.AvatarImageCornerRadius
        setupTableViewFooter()
        applyUser()
        if (model!.userIsCurrentUser()) {
            profileSettingsButton.enabled = true
        }
    }
    
    func setupTableViewFooter() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var frame: CGRect = tableViewFooter.frame
// uncomment this wen transitions will work as planed
//        frame.size.height = (screenSize.height - Constants.Profile.HeaderHeight - (navigationController?.navigationBar.frame.size.height)!)
        tableViewFooter.frame = frame
        tableView.tableFooterView = tableViewFooter;
    }
    
    func applyUser() {
        userAvatar.image = UIImage(named: Constants.Profile.AvatarImagePlaceholderName)
        userName.text = model?.userName
        model?.userAvatar({[weak self] (image, error) -> () in
            if error == nil {
                self?.userAvatar.image = image
            } else {
                self?.view.makeToast(error?.localizedDescription)
            }
        })
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (activityShown == true) {
                view.hideToastActivity()
                tableView.tableFooterView = nil
                tableView.scrollEnabled = true
        }
    }
    
    // MARK: - IBActions
    @IBAction func profileSettings(sender: AnyObject) {

    }

}
