//
//  ViewController.swift
//  ShadowExample
//
//  Created by Soso on 2020/09/03.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var viewRed: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewRed.layer.cornerRadius = 10
        viewRed.layer.masksToBounds = true
        viewRed.layer.shadowColor = UIColor.black.cgColor
//        viewRed.layer.shadowOffset = .zero
//        viewRed.layer.shadowRadius = 5
        viewRed.layer.shadowPath = UIBezierPath(
            roundedRect: .init(
                origin: .zero,
                size: .init(width: 240, height: 128)
            ),
            cornerRadius: 10).cgPath
    }
}
