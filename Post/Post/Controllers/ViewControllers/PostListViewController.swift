//
//  PostListViewController.swift
//  Post
//
//  Created by Travis Wheeler on 9/30/19.
//  Copyright © 2019 Travis Wheeler. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    var postController = PostController()
    var refreshControl = UIRefreshControl()
    
    //MARK: - Outlets
    @IBOutlet weak var postsTableView: UITableView!
    
    
    //MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.estimatedRowHeight = 45
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
            
        }
    }
    
    //MARK: - Actions
    @IBAction func addPostButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new post", message: "people want to hear what you have to say", preferredStyle: .alert)
        var usernameText: UITextField?
        var messageBodyText: UITextField?
        alert.addTextField { (usernameTextField) in
            usernameText = usernameTextField
            usernameText?.placeholder = "Enter your Username"
        }
        alert.addTextField { (bodyTextField) in
            messageBodyText = bodyTextField
            messageBodyText?.placeholder = "Enter your post"
        }
        
        
        let postAction = UIAlertAction(title: "Add Post", style: .default) { (_) in
            guard let username = usernameText?.text, !username.isEmpty,
                let text = messageBodyText?.text, !text.isEmpty else {return}
            self.postController.addNewPostWith(username: username, Text: text, completion: self.reloadTableView)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(postAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.postsTableView.reloadData()
        }
    }
    
    func presentErrorAlert() {
        let alertError = UIAlertController(title: "Missing Info", message: "Fill in all text fields", preferredStyle: .alert)
        alertError.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        self.present(alertError, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) - \(Date(timeIntervalSince1970: post.timestamp))"
        
        return cell
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        postController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
}
