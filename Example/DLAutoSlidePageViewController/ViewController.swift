//
//  ViewController.swift
//  DLAutoSlidePageViewController
//
//  Created by Alonso on 10/16/17.
//  Copyright © 2017 Alonso. All rights reserved.
//

import UIKit
import DLAutoSlidePageViewController

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    let ImageViewControllerIdentifier = "ImageViewController"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }

    // MARK: - Private

    private func setupElements() {
        setupPageViewController()
    }

    private func setupPageViewController() {
        let pages: [UIViewController] = setupPages()

        // Configure default auto slide page configuration
        DefaultAutoSlideConfiguration.shared.timeInterval = 2.0
        DefaultAutoSlideConfiguration.shared.overridesGestureBehavior = true
        let pageViewController = DLAutoSlidePageViewController(pages: pages)
        
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
    }

    private func setupPages() -> [UIViewController] {
        let chromePage = storyboard?.instantiateViewController(withIdentifier: ImageViewControllerIdentifier) as! ImageViewController
        chromePage.setupElements(image: #imageLiteral(resourceName: "ChromeIcon"))

        let safariPage = storyboard?.instantiateViewController(withIdentifier: ImageViewControllerIdentifier) as! ImageViewController
        safariPage.setupElements(image: #imageLiteral(resourceName: "SafariIcon"))

        let operaPage = storyboard?.instantiateViewController(withIdentifier: ImageViewControllerIdentifier) as! ImageViewController
        operaPage.setupElements(image: #imageLiteral(resourceName: "OperaIcon"))

        return [chromePage, safariPage, operaPage]
    }

}

