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
    
    private var datasource = Datasource()
    
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
        refreshControl.addTarget(self, action: #selector(loadImages), for: .valueChanged)
        loadImages()
    }
    
    @objc func loadImages() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.datasource.getPhotosIndividually { (result) in
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
                switch result {
                case .success(let index):
                    self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                case .failure(let err):
                    print(err)
                    //                self.datasource.imageURLs.remove(at: err.indexToRemove)
                    //                self.collectionView.deleteItems(at: [IndexPath(row: err.indexToRemove, section: 0)])
                }
            }
        }

    }
    
}

extension CollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.imageData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        if let imageData = datasource.imageData[indexPath.row],
            let image = UIImage(data: imageData) {
            cell.setImage(image)
        } else {
            cell.backgroundColor = .red
        }
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
