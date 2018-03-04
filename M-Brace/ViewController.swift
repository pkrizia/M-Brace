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
        var response = ""
        let client = TCPClient(address: "127.0.0.1", port: 12000)
        switch client.connect(timeout: 10){
        case .success:
            switch client.send(string: "hello world\n"){
            case .success:
                // timeout is necessary
                guard let data = client.read(1024*10, timeout: 1) else {
                    print("here")
                    return
                }
                if let response = String(bytes: data, encoding: .utf8){
                    dataOutput.text = response
                    print(response)
                }
            case .failure(_):
                response = "Error: failed to obtain response."
                dataOutput.text = response
                print(response)
            }
        case .failure(_):
            response = "Error: failed to connect."
            dataOutput.text = response
            print(response)
        }
        client.close()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	//TEST

}

