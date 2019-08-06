//
//  PhotoDetailViewController.swift
//  Photodownloads
//
//  Created by Matthew Sanford on 8/6/19.
//  Copyright © 2019 Matt Sanford. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {


    var image: UIImage?
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        // Do any additional setup after loading the view.
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
