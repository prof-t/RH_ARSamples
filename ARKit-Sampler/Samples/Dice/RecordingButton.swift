//
//  RecordingButton.swift
//  ARKit-Sampler
//
//  Created by 平山亮 on 2018/05/22.
//  Copyright © 2018年 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import ReplayKit

class RecordingButton: UIButton {
    
    var isRecording = false
    let height: CGFloat = 50.0
    let width: CGFloat = 100.0
    let viewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ viewController: UIViewController) {
        self.viewController = viewController
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        layer.position = CGPoint(x: width / 2, y: viewController.view.frame.height - height)
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        setTitleColor(UIColor.white, for: .normal)
        
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        self.setAppearance()
        viewController.view.addSubview(self)
    }
    
    @objc func tapped() {
        if !isRecording {
            isRecording = true
            RPScreenRecorder.shared().startRecording { error in
                print(error as Any)
            }
        } else {
            isRecording = false
            RPScreenRecorder.shared().stopRecording { (previewViewController, error) in
                previewViewController?.previewControllerDelegate = self
                self.viewController.present(previewViewController!, animated: true, completion: nil)
            }
        }
        self.setAppearance()
    }
    
    func setAppearance() {
        var alpha: CGFloat = 1.0
        var title = "REC"
        if isRecording {
            title = ""
            alpha = 0
        }
        self.setTitle(title, for: .normal)
        self.backgroundColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: alpha)
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha).cgColor
    }
}

extension RecordingButton: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        DispatchQueue.main.async { [unowned previewController] in
            previewController.dismiss(animated: true, completion: nil)
        }
    }
}

