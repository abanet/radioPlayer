//
//  ViewController.swift
//  ondafuenlabrada
//
//  Created by Alberto Banet Masa on 25/5/16.
//  Copyright © 2016 abanet. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

  @IBOutlet weak var viewSlide: UIView!
  @IBOutlet weak var slider: UISlider!
  
  
  let radioPlayer = Player.radio
  var mpVolumeSlider = UISlider()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configuración de la radio
    radioPlayer.rate = 1.0
    setupVolumeSlider()
  }
  
  
  override func viewWillAppear(animated: Bool) {
    // Dibujamos el volumen actual al entrar en la app.
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  // MARK:  Botones de radio
  @IBAction func playRadio(sender: AnyObject) {
    print("play")
    radioPlayer.play()

  }
  
  
  @IBAction func stopRadio(sender: AnyObject) {
    radioPlayer.pause()
  }
  
  
  @IBAction func cambiarVolumen(sender: UISlider) {
    mpVolumeSlider.value = sender.value
  }
  
  
  // MARK: Setup del volumen
  func setupVolumeSlider() {
    // Note: This slider implementation uses a MPVolumeView
    // The volume slider only works in devices, not the simulator.
    viewSlide.backgroundColor = UIColor.clearColor()
    let volumeView = MPVolumeView(frame: viewSlide.bounds)
    for view in volumeView.subviews {
      let uiview: UIView = view as UIView
      if (uiview.description as NSString).rangeOfString("MPVolumeSlider").location != NSNotFound {
        mpVolumeSlider = (uiview as! UISlider)
      }
    }
    
  // let thumbImageNormal = UIImage(named: "slider-ball")
   // slider?.setThumbImage(thumbImageNormal, forState: .Normal)
    
  }
  

  
}

