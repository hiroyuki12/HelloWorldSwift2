//
//  ViewController.swift
//  HelloWorldSwift2
//
//  Created by hiroyuki on 2020/09/26.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var labelHello: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func tapButton(_ sender: Any) {
    labelHello.text = "Tap!"
  }
}

