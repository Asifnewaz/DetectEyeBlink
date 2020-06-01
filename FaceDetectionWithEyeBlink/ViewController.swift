//
//  ViewController.swift
//  FaceDetectionWithEyeBlink
//
//  Created by Asif Newaz on 1/6/20.
//  Copyright © 2020 Asif Newaz. All rights reserved.
//

import UIKit
import Gifu


class ViewController: UIViewController {
    
    
    var faceDetectorFilter: FaceDetectorFilter!
    lazy var faceDetector: FaceDetector = {
        var detector = FaceDetector()
        self.faceDetectorFilter = FaceDetectorFilter(faceDetector: detector, delegate: self)
        detector.delegate = self.faceDetectorFilter
        return detector
    }()
    
    
    lazy var helpImage: UIImageView = {
        var temp = UIImageView(frame: CGRect(x: 0,
                                             y: 0,
                                             width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height))
        temp.contentMode = .scaleAspectFit
        temp.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        temp.alpha = 0.0
        temp.image = UIImage(named: "Ready.png")
        return temp
    }()
    
    lazy var rightEyeGif: GIFImageView = {
        let temp = GIFImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2.1, height: UIScreen.main.bounds.height / 7.1))  //150x80
        temp.alpha = 0.0
        temp.animate(withGIFNamed: "rightEye_Opening.gif", loopCount: 1)
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    lazy var leftEyeGif: GIFImageView = {
        let temp = GIFImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2.1, height: UIScreen.main.bounds.height / 7.1)) //150x80
        temp.alpha = 0.0
        temp.animate(withGIFNamed: "leftEye_Opening.gif", loopCount: 1)
        temp.contentMode = .scaleAspectFit
        return temp
    }()
    
    
    internal func spaceString(_ string: String) -> String {
        return string.uppercased().map({ c in "\(c) " }).joined()
    }
    
    var blinkingNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        faceDetector.beginFaceDetection()
        let cameraView = faceDetector.cameraView
        view.addSubview(cameraView)
        view.addSubview(leftEyeGif)
        view.addSubview(rightEyeGif)
        view.addSubview(helpImage)
    }
    
    
}


extension ViewController: FaceDetectorFilterDelegate {
    //MARK: FaceDetectorFilter Delegate
    func faceDetected() {
        cancel()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.leftEyeGif.alpha = 1.0
                self.rightEyeGif.alpha = 1.0
            })
        }
    }
    
    func faceUnDetected() {
        cancel()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.leftEyeGif.alpha = 0
                self.rightEyeGif.alpha = 0
            })
        }
    }
    
    func faceEyePosition(left: CGPoint, right: CGPoint) {
        if let leftPos = self.faceDetector.leftEyePosition, let rightPos = self.faceDetector.rightEyePosition {
            DispatchQueue.main.async {
                self.leftEyeGif.center = leftPos
                self.rightEyeGif.center = rightPos
                
                //better center eyes position based on gif file
                self.leftEyeGif.frame.origin.y -= 4
                self.rightEyeGif.frame.origin.y -= 4
            }
        }
    }
    
    func cancel() {
        rightEyeGif.animate(withGIFNamed: "rightEye_Opening.gif", loopCount: 1)
        leftEyeGif.animate(withGIFNamed: "leftEye_Opening.gif", loopCount: 1)
        
    }
    
    //MARK: Eye distance should be CGFloat(70.0)
    //MARK: if bliking is true then this method will trigger and you will receive an image here
    // Here
    func blinking(image: UIImage?) {
        if blinkingNumber == 0 {
            blinkingNumber += 1
            showBlinkNumber(helpString: "Ready.png")
        } else if blinkingNumber == 1 {
            blinkingNumber += 1
            showBlinkNumber(helpString: "Ready1.png")
        } else {
            blinkingNumber += 1
            showBlinkNumber(helpString: "Ready3.png")
        }
    }
    
    func showBlinkNumber(helpString: String){
        UIView.animate(withDuration: 0.8, animations: {
            self.helpImage.image = UIImage(named: helpString)
            self.helpImage.alpha = 1.0
            self.helpImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: {(_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.helpImage.alpha = 0.0
                self.helpImage.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_) in
                self.helpImage.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            })
        })
    }
}
