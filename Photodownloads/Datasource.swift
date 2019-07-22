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
    
    // TODO - create buffer of images that will be flushed once the datasource is finished updating
    

    var imageURLs = [URL]()
    var imageData = [Data?]()
    
    init() {
        imageURLs = generateImageURLS()
        imageData = Array<Data?>(repeating: nil, count: imageURLs.count)
    }
    
    private func generateImageURLS() -> [URL] {
        var urlString = [String]()
        for i in 100...500 {
            urlString.append("\(baseURLString)\(i)/200/200")
        }
        return urlString.compactMap(URL.init(string:))
    }
    
    struct DatasourceError: Error {
        let indexToRemove: Int
    }
    
    /// This function will load the images into a datasource concurrently
    ///
    /// - Parameter completion: Will return Result<Int, Error> where Int is an index that can be used
    /// to access image data via imageData[index]
    func getPhotosIndividually(completion: @escaping (Result<Int, DatasourceError>) -> Void) {
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: imageURLs.count) { (index) in
            let url = imageURLs[index]
            do {
                let data = try Data(contentsOf: url)
                imageData[index] = data
                DispatchQueue.main.async {
                    completion(.success(index))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(DatasourceError(indexToRemove: index)))
                }
            }
        }
    }
    
}
