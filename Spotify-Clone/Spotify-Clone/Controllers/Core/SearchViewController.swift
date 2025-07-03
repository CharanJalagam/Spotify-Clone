//
//  SearchViewController.swift
//  Spotify-Clone
//
//  Created by apple on 18/01/25.
//

import UIKit


class SearchViewController: UIViewController, UISearchResultsUpdating {

    let searchController : UISearchController = {
       
        let vc = UISearchController(searchResultsController: SearchResultViewController())
        vc.searchBar.placeholder = "Songs, Albums, Artists"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    let collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)), subitem: item, count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)

        return NSCollectionLayoutSection(group: group)
    }))
    
    var categories : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)
        
        ApiCallers.shared.getAllCategories { [weak self]  result in
            DispatchQueue.main.async {
                switch result{
                case .success(let allCategories):
                    allCategories.categories.items.forEach { self?.categories.append($0) }
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("error \(error)")
                    break
                }
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultController = searchController.searchResultsController as?  SearchResultViewController, let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        resultController.delegate = self
       
        ApiCallers.shared.search(with: query) { result in
            switch result {
            case .success(let SearchResult):
                DispatchQueue.main.async {
                    resultController.update(with: SearchResult)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        print(query)
    }
    

}
extension SearchViewController : SearchResultDelegate{
    func didSelect(_ vc: UIViewController) {
        HapticManager.shared.vibrateForSelection()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath) as? GenreCollectionViewCell ?? GenreCollectionViewCell()
        let genre = categories[indexPath.row].name
        cell.configure(with: genre)
        return cell
    }
    
    
}
