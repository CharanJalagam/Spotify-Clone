//
//  WelcomeViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let imageView  :UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "coverBG")
        return image
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    
    private let logoImageView  :UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "icon")
        return image
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.text = "Listen to Millions of Songs on the go."
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        title = "Spotify"
        
        signInButton.addTarget(self, action: #selector(SignIn), for: .touchUpInside)
        view.addSubview(imageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
        view.addSubview(label)
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
        overlayView.frame = view.bounds
        signInButton.frame = CGRect(x: 20, y: view.height - 50 - view.safeAreaInsets.bottom, width: view.width - 40, height: 50)
        logoImageView.frame = CGRect(x: Int(view.width)/2 - 100, y: Int(view.height)/2 - 160, width: 200, height: 200)
        label.frame = CGRect(x: 30, y: Int(logoImageView.bottom) , width: Int(view.width) - 60, height: 150)
    }

    @objc func SignIn() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success : success)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
  
    func handleSignIn(success : Bool){
        guard success else{
            let alert = UIAlertController(title: "Oosp", message: "Something went wrong!!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let mainVC = TabBarViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true)
    }

}
