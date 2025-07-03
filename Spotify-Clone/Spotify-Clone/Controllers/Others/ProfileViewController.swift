//
//  ProfileViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    var modals : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        title = "Profile"
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        fetchProfile()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchProfile(){
        ApiCallers.shared.getCurrentUserProfile { [weak self] (result) in
            DispatchQueue.main.async {
                switch result{
                case .success(let modal) :
                    self?.updateUI(with : modal)
                case.failure(let error):
                    self?.failedToGetData()
                }
            }
        }
    }
    private func updateUI(with modal : UserProfile){
        tableView.isHidden = false
        modals.append("Full Name : \(modal.display_name)")
        modals.append("User ID : \(modal.id)")
        modals.append("Plan : \(modal.product)")
        createTableHeader(with: modal.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with string : String?){
        guard let urlString = string, let url = URL(string: urlString) else { return }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: headerView.height/2, height: headerView.height/2))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url)
        
        tableView.tableHeaderView = headerView
        
    }
    
    private func failedToGetData(){
        let label = UILabel(frame: .zero)
        label.text = "Failed to load Data"
        label.textColor = .secondaryLabel
        label.sizeToFit()
        view.addSubview(label)
        label.center = view.center
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = modals[indexPath.row]
        return cell
    }
}
