//
//  ImageViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
  
  @IBOutlet weak public var logoImageView: UIImageView!
  
  var logoImage: UIImage?
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    logoImageView.image = logoImage
  }
  
  // MARK: - Public
  
  func setupElements(image: UIImage) {
    logoImage = image
  }
  
}
