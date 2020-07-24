//
//  ViewController.swift
//  ResponderChainExample
//
//  Created by Soso on 2020/07/24.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

class ViewCustom: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let event = event {
            print(#function, event)
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let event = event {
            print(#function, event)
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let event = event {
            print(#function, event)
        }
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let event = event {
            print(#function, event)
        }
        super.touchesCancelled(touches, with: event)
    }
}
