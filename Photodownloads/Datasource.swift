//
//  Datasource.swift
//  Photodownloads
//
//  Created by Matt Sanford on 7/22/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import Foundation

class Datasource {
    private let baseURLString = "https://picsum.photos/id/"
    

    var imageURLs = [URL]()
    var imageData = [Data]()
    
    init() {
        imageURLs = generateImageURLS()
    }
    
    private func generateImageURLS() -> [URL] {
        var urlString = [String]()
        for i in 100...500 {
            urlString.append("\(baseURLString)\(i)/1000/1000")
        }
        return urlString.compactMap(URL.init(string:))
    }
    
    func getPhotos(completion: @escaping (Result<[Data], Error>) -> Void) {
        let _ = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        DispatchQueue.concurrentPerform(iterations: imageURLs.count) { (index) in
            let url = imageURLs[index]
            group.enter()
            do {
                let data = try Data(contentsOf: url)
                imageData.append(data)
            } catch {
                print("failed to load \(url)")
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(.success(self.imageData))
        }
    }
    
}
