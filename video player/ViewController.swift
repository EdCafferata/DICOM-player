//
//  ViewController.swift
//  Dicom video player
//  Created by Ed Cafferata on 31/01/2021
//  Copyright © 2021 Utrecht/Holland. All rights reserved.
//
import UIKit
import AVKit

class ViewController: UIViewController {
    @IBAction func buttonAction(_ sender: Any)
    {
        //declaring the variable for AvPlayer and specifing the url
        if let path = Bundle.main.path(forResource: "video", ofType: "mp4")
        {
            //define the exact path of the video since i draaged and dropped the video
            let video = AVPlayer(url: URL(fileURLWithPath: path))
            //View Controller for the Class 
            let videoPlayer = AVPlayerViewController()
            videoPlayer.player = video
            
            //to load the video on the Screen
            present(videoPlayer, animated: true, completion:
            {
                video.play()
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

