//
//  ViewController.swift
//  streamlove
//
//  Created by Neo Ighodaro on 22/07/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import PusherSwift
import Alamofire

class ViewController: VideoSplashViewController {
    
    @IBOutlet weak var floaterView: Floater!
    
    static let API_ENDPOINT = "http://localhost:4000";
    
    var pusher : Pusher!
    
    let deviceUuid : String = UIDevice.current.identifierForVendor!.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideoStreamSample()
        listenForNewLikes()
    }
    
    @IBAction func hearted(_ sender: Any) {
        postLike()
        startEndAnimation()
    }
    
    private func startEndAnimation() {
        floaterView.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.floaterView.stopAnimation()
        })
    }
    
    private func listenForNewLikes() {
        pusher = Pusher(key: "PUSHER_KEY", options: PusherClientOptions(host: .cluster("PUSHER_CLUSTER")))
        
        let channel = pusher.subscribe("likes")
        let _ = channel.bind(eventName: "like", callback: { (data: Any?) -> Void in
            if let data = data as? [String: AnyObject] {
                let uuid = data["uuid"] as! String
                
                if uuid != self.deviceUuid {
                    self.startEndAnimation()
                }
            }
        })
        pusher.connect()
    }
    
    private func postLike() {
        let params: Parameters = ["uuid": deviceUuid]
        
        Alamofire.request(ViewController.API_ENDPOINT + "/like", method: .post, parameters: params).validate().responseJSON { response in
            switch response.result {
                
            case .success:
                print("Liked")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadVideoStreamSample() {
        let url = NSURL.fileURL(withPath: Bundle.main.path(forResource: "video", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .resizeAspectFill
        self.alwaysRepeat = true
        self.sound = true
        self.startTime = 0.0
        self.duration = 10.0
        self.alpha = 0.7
        self.backgroundColor = UIColor.black
        self.contentURL = url
        self.restartForeground = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }  
}

