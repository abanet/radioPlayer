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
  @IBOutlet weak var nowPlayingImageView: UIImageView!
  
  @IBOutlet weak var logoOndoFuenlabrada: UIImageView!
  
  @IBOutlet weak var btnPlay: UIButton!
  @IBOutlet weak var btnPausa: UIButton!
  
  
  let radioPlayer = Player.radio
  
  // Apple: An audio session is a singleton object that you employ to set the audio context for your app and to express to the system your intentions for your app’s audio behavior.
  let session: AVAudioSession = AVAudioSession.sharedInstance()

  var mpVolumeSlider = UISlider()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
        radioPlayer.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
    
  }
  
  
  override func viewWillAppear(animated: Bool) {
    // Configuración de la radio
    radioPlayer.rate = 1.0
    
    // Inicialmente la radio está encendida
    btnPlay.enabled = false
    btnPausa.enabled = true
    

    // Apple: When using this category, your app audio continues with the Silent switch set to silent or when the screen locks. (The switch is called the Ring/Silent switch on iPhone.) To continue playing audio when your app transitions to the background (for example, when the screen locks), add the audio value to the UIBackgroundModes key in your information property list file.
    do {
      try session.setCategory(AVAudioSessionCategoryPlayback)
    } catch {
      // error
    }
    
    // Establecemos el slider para el volumen
    setupVolumeSlider()
    // Creamos y lanzamos la animación (al arrancar la app se escuchará la radio por defecto)
    createNowPlayingAnimation()
    startNowPlayingAnimation()

    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  deinit {
    radioPlayer.removeObserver(self, forKeyPath: "status", context: nil)
  }

  // OBSERVADORES
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    
    if object as! NSObject == radioPlayer {
        print("observador dice estado = \(radioPlayer.status.rawValue)")
    }
    
    
  }

  // MARK:  Botones de radio
  @IBAction func playRadio(sender: AnyObject) {
    print("Play pulsado: \(radioPlayer.status.rawValue)")
    radioPlayer.play()
    startNowPlayingAnimation()
    btnPlay.enabled = false
    btnPausa.enabled = true
  }
  
  
  @IBAction func stopRadio(sender: AnyObject) {
    stopNowPlayingAnimation()
    radioPlayer.pause()
    btnPlay.enabled = true
    btnPausa.enabled = false

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
  
  // Animación 
  func createNowPlayingAnimation() {

    // Create Animation
    nowPlayingImageView.animationImages = AnimationFrames.createFrames()
    nowPlayingImageView.animationDuration = 0.7
    
  }
  
  func startNowPlayingAnimation() {
    nowPlayingImageView.startAnimating()
  }
  
  func stopNowPlayingAnimation() {
    nowPlayingImageView.stopAnimating()
  }
  
  // MARK: Share
  
  @IBAction func shareRadio(sender: AnyObject) {
    let songToShare = "¡Escuchando ondaFuenlabrada a través de su app de radio para iPhone!"
  // let activityViewController = UIActivityViewController(activityItems: [songToShare, track.artworkImage!], applicationActivities: nil)
    let activityViewController = UIActivityViewController(activityItems: [songToShare, logoOndoFuenlabrada.image!], applicationActivities: nil)
    presentViewController(activityViewController, animated: true, completion: nil)
  }
  
}

