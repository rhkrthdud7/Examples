//
//  ViewController.swift
//  TargetExample
//
//  Created by Soso on 2020/07/24.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelVersion: UILabel!
    @IBOutlet weak var labelBuild: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let dic = Bundle.main.infoDictionary else { return }
        if let version = dic["CFBundleShortVersionString"] as? String {
            labelVersion.text = "Version: \(version)"
        }
        if let build = dic["CFBundleVersion"] as? String {
            labelBuild.text = "Build: \(build)"
        }
    }
}
