//
//  ViewController.swift
//  ondafuenlabrada
//
//  Created by Alberto Banet Masa on 25/5/16.
//  Copyright © 2016 abanet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let radioPlayer = Player.radio
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    radioPlayer.rate = 1.0
  }
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBAction func playRadio(sender: AnyObject) {
    radioPlayer.play()
    
  }
  
  
  @IBAction func stopRadio(sender: AnyObject) {
    radioPlayer.pause()
  }
}

