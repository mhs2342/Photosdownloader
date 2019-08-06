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
    private var imageURLs = [(thumbnail: URL, fullSize: URL)]()

    var thumbnailImageData = [Data?]()
    var fullSizeImageData = [Data?]()
    
    init() {
        imageURLs = generateImageURLS()
        thumbnailImageData = Array<Data?>(repeating: nil, count: imageURLs.count)
        fullSizeImageData = Array<Data?>(repeating: nil, count: imageURLs.count)
    }
    
    private func generateImageURLS() -> [(URL, URL)] {
        var urlString = [(String, String)]()
        for i in 100...1100 {
            urlString.append(("\(baseURLString)\(i)/100/100", "\(baseURLString)\(i)/1000/1000"))
        }
        return urlString.compactMap({ (URL.init(string: $0.0)!, URL.init(string: $0.1)!) })
    }
    
    struct DatasourceError: Error {
        let indexToRemove: Int
    }

    func getFullSizeImageData() {
        let _ = DispatchQueue.global(qos: .background)
        DispatchQueue.concurrentPerform(iterations: imageURLs.count) { (index) in
            let url = imageURLs[index]
            do {
                let fullSizeData = try Data(contentsOf: url.fullSize)
                fullSizeImageData[index] = fullSizeData
            } catch {
                print("Unable to load full size image")
            }
        }
    }
    
    /// This function will load the images into a datasource concurrently
    ///
    /// - Parameter completion: Will return Result<Int, Error> where Int is an index that can be used
    /// to access image data via imageData[index]
    func getThumbnails(completion: @escaping (Result<Int, DatasourceError>) -> Void) {
        let _ = DispatchQueue.global(qos: .userInitiated)
        DispatchQueue.concurrentPerform(iterations: imageURLs.count) { (index) in
            let url = imageURLs[index]
            do {
                let thumbnailData = try Data(contentsOf: url.thumbnail)
                thumbnailImageData[index] = thumbnailData

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
