//
//  HomeViewController.swift
//  Snap
//
//  Created by Amitabha Saha on 01/05/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [[String: Any]]? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureTableView()
        fetchData()
    }
    
    func fetchData() {
        
        self.showSpinner()
        if let postPath = FirebaseHelper.getBasePath(for: "globalPost") {
            postPath.observe(.value) { (snapShot) in
                self.hideSpinner()
                if let snapShots = snapShot.value as? [String: Any] {
                    
                    if self.dataSource == nil {
                        self.dataSource = [[String: Any]]()
                    }
                    
                    var allPosts = snapShots.map { (key, value) -> [String: Any] in
                        
                        var dic = value as! [String: Any]
                        dic["key"] = key
                        return dic
                        
                    }
                    
                    allPosts.sort { (first, second) -> Bool in
                        if let fkey = first["key"] as? String, let lkey = second["key"] as? String {
                            return fkey > lkey
                        } else {
                            return false
                        }
                    }
                    
                    self.dataSource = allPosts
                }
            }
        }
    }
    
    func configureTableView() {
        // HomeTableViewCell
        
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource, HomeTableViewCellDelegate {
    
    func bookMarkTapped() {
        
    }
    
    func commentTapped() {
        
    }
    
    func sendMessageTapped(with message: String, for indexPath: IndexPath) {
        
        if message.isEmpty {
            return
        }
        
        if let post = dataSource?[indexPath.row], let key = post["key"] as? String {
            if let lastComemntPath = FirebaseHelper.getBasePath(for: "globalPost")?.child(key).child("lastComment") {
                lastComemntPath.setValue(message)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 475.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell {
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.indexPath = indexPath
            
            if let dataSource = dataSource {
                cell.loadCell(with: dataSource[indexPath.row])
            }
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
}
