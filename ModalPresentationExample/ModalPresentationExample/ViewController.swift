//
//  ViewController.swift
//  ModalPresentationExample
//
//  Created by Soso on 2020/07/24.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func clickButton(_ sender: UIButton) {
        let next = RandomViewController(count: 10)
        next.modalPresentationStyle = .fullScreen
        present(next, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

class RandomViewController: UIViewController {
    var count: Int
    
    init(count: Int) {
        self.count = count
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard count > 0 else { return }
        let next = RandomViewController(count: count - 1)
        if count == 5 {
            next.modalPresentationStyle = .fullScreen
        }
        present(next, animated: true, completion: nil)
    }
}
