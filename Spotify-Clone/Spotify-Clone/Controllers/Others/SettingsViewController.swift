//
//  SettingsViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var sections : [Section] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureModals()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func ConfigureModals(){
        sections.append(Section(title: "Profile", options: [Option(title: "View your profile", handler: { [weak self] in
            DispatchQueue.main.async{
                self?.goToProfile()
            }
        })]))
        sections.append(Section(title: "Account", options: [Option(title: "Sign out", handler: { [weak self] in
            DispatchQueue.main.async{
                self?.signOutTapped()
            }
        })]))
    }
    func signOutTapped(){
        
        let alert  = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] _ in
                DispatchQueue.main.async{
                    let navVC = UINavigationController(rootViewController: WelcomeViewController())
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true) {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    func goToProfile(){
        let profileVC = ProfileViewController()
        profileVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(profileVC, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let modal = sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = modal.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HapticManager.shared.vibrateForSelection()
        tableView.deselectRow(at: indexPath, animated: true)
        let modal = sections[indexPath.section].options[indexPath.row]
        modal.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let modal = sections[section]
        return modal.title
    }
   
}
