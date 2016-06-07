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
  
  
  let urlString = "http://radioserver3.profesionalhosting.com:8024/;stream.mp3"
  var radioPlayer = AVPlayer(URL: NSURL(string: "http://radioserver3.profesionalhosting.com:8024/;stream.mp3")!)
  var estaSonando = true
  
  // Apple: An audio session is a singleton object that you employ to set the audio context for your app and to express to the system your intentions for your app’s audio behavior.
  let session: AVAudioSession = AVAudioSession.sharedInstance()

  var mpVolumeSlider = UISlider()
  
  // Detección de red
  var reachability: Reachability?

  
  override func viewDidLoad() {
    super.viewDidLoad()
      }
  
  
  override func viewWillAppear(animated: Bool) {
    
    radioPlayer.rate = 1.0
    radioPlayer.play()

    // Detección de red
    do {
      reachability = try Reachability.reachabilityForInternetConnection()
    } catch {
      print("no se puede crear reachability")
      return
    }
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
    do {
      try reachability?.startNotifier()
    } catch {
      print("no se ha podido iniciar el comienzo de las notificaciones")
    }
    
    if reachability!.isReachable() {
      print("viewVillAppear: hay red")
      if !estaSonando {
        print("Creando y lanzando radio")
        //radioPlayer = AVPlayer(URL: NSURL(string: urlString)!)
        //radioPlayer!.rate = 1.0
        playRadio(btnPlay)
      }
    } else {
      print("viewVillAppear: NO hay red")
    }
    
    print("entrando en willAppear. Avplayer: \(radioPlayer)")
    
    
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
    estaSonando = true

    
  }
  
  override func viewWillDisappear(animated: Bool) {
    // Dejamos de escuchar para saber si tenemos red
    reachability?.stopNotifier()
    NSNotificationCenter.defaultCenter().removeObserver(self,
                                                        name: ReachabilityChangedNotification,
                                                        object: reachability)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  



  // MARK:  Botones de radio
  @IBAction func playRadio(sender: AnyObject) {
    print("Play pulsado: \(radioPlayer.status.rawValue)")
    print("AVPlayer en el momento de pulsar Play: \(radioPlayer)")
    radioPlayer.play()
    startNowPlayingAnimation()
    btnPlay.enabled = false
    btnPausa.enabled = true
    estaSonando = true
  }
  
  
  @IBAction func stopRadio(sender: AnyObject) {
    stopNowPlayingAnimation()
    radioPlayer.pause()
    radioPlayer.cancelPendingPrerolls() // no parece tener efecto.
    btnPlay.enabled = true
    btnPausa.enabled = false
    estaSonando = false

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
  
  // MARK: reachabilityChanged
  func reachabilityChanged(note: NSNotification) {
    
    let reachability = note.object as! Reachability
    
    if reachability.isReachable() {
      if reachability.isReachableViaWiFi() {
        print("Reachable via WiFi")
      } else {
        print("Reachable via Cellular")
      }
    } else {
      print("Network not reachable")
      stopRadio(btnPausa)
    }
  }
  
}

