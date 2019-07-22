//
//  CollectionViewController.swift
//  Photodownloads
//
//  Created by Anthony Guella on 7/22/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    
    private var dataSource = DataSource()
    private var photos = [UIImage]()
    
    // MARK: Properties
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 30.0,
                                             left: 30.0,
                                             bottom: 30.0,
                                             right: 30.0)
    private let reuseIdentifier = "PhotoCell"
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        
    }
    
    @objc func refreshView() {
        dataSource?.getPhotos(completionHandler: { result in
            switch result {
            case .success(let data):
                photos = data.map { UIImage(data: $0 )}.compactMap { $0 }
            case .failure(let error):
                print(error.localizedDescription)
            }
            refreshControl.endRefreshing()
            collectionView.reloadData()
        })
    }
}

extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .black
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
