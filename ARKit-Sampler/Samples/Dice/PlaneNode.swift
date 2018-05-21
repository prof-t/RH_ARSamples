//
//  PlaneNode.swift
//  ARKit-Sampler
//
//  Created by 平山亮 on 2018/05/22.
//  Copyright © 2018年 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlaneNode: SCNNode {
    
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        self.setPhysicsBody()
    }
    
    func update(anchor: ARPlaneAnchor) {
        guard let geo = geometry as? SCNPlane else {
            fatalError("geometryがない")
        }
        geo.width = CGFloat(anchor.extent.x)
        geo.height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geo, options: nil))
        self.setPhysicsBody()
    }
    
    func setPhysicsBody() {
        physicsBody?.categoryBitMask = 2
        physicsBody?.friction = 1 // 摩擦　0.0~1.0 default = 0.5
        physicsBody?.restitution = 0 // 弾み具合 0:弾まない 3:超弾む
    }
    
    var isDisplay: Bool = false {
        didSet {
            let planeMaterial = SCNMaterial()
            if isDisplay {
                planeMaterial.diffuse.contents = UIImage(named: "mesh")
            } else {
                planeMaterial.diffuse.contents = UIColor.white.withAlphaComponent(0.0)
            }
            geometry?.materials = [planeMaterial]
        }
    }
}

