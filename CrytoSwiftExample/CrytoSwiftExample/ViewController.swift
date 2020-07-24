//
//  ViewController.swift
//  CrytoSwiftExample
//
//  Created by Soso on 2020/05/07.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import CryptoSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let password: Array<UInt8> = Array("asdfqwer1234!@#$".utf8)
        let salt: Array<UInt8> = Array("asd@gmail.com".utf8)

        if let key = try? PKCS5.PBKDF2(password: password, salt: salt, iterations: 1024, keyLength: 64, variant: .sha1).calculate() {
            print(key)
            print(key.toHexString())
            let temp: [UInt8] = [255]
            print(temp.toHexString())
        }
    }
}
