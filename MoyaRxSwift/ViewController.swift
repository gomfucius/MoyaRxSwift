//
//  ViewController.swift
//  MoyaRxSwift
//
//  Created by Genki Mine on 7/28/17.
//  Copyright © 2017 Genki. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let provider = MoyaProvider<MyService>()

        provider.request(.hello) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                print(data)
                print(statusCode)
                let json = try? moyaResponse.mapJSON()
                if let jsonDict = json as? [String: String] {
                    if let helloWorld = jsonDict["hello"] {
                        print(helloWorld)
                    }
                }

            case let .failure(error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

