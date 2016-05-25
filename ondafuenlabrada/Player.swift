//
//  Player.swift
//  ondafuenlabrada
//
//  Created by Alberto Banet Masa on 25/5/16.
//  Copyright © 2016 abanet. All rights reserved.
//

// la radio va a estar en una estructura siguiendo el patrón singleton.


import AVFoundation


struct Player {
  static let urlString = "http://radioserver3.profesionalhosting.com:8024/;stream.mp3"
  static let radio = AVPlayer(URL: NSURL(string: urlString)!)
  
}