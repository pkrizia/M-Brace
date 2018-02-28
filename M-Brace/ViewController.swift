//
//  ViewController.swift
//  M-Brace
//
//  Created by Princess Macanlalay on 2/27/18.
//  Copyright © 2018 Princess Macanlalay. All rights reserved.
//

import UIKit
import SwiftSocket

class ViewController: UIViewController {
    @IBOutlet weak var dataOutput: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTapButton(_ sender: UIButton) {
        let client = TCPClient(address: "www.apple.com", port: 80)
        switch client.connect(timeout: 1){
        case .success:
            switch client.send(string: "GET / HTTP/1.0\n\n"){
            case .success:
                guard let data = client.read(1024*10) else {return}
                if let response = String(bytes: data, encoding: .utf8){
                    dataOutput.text = response
                }
            case .failure(_):
                dataOutput.text = "Error: failed to obtain response."
            }
        case .failure(_):
            dataOutput.text = "Error: failed to connect."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

}

