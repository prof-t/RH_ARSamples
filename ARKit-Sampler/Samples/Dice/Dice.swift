//
//  Dice.swift
//  ARKit-Sampler
//
//  Created by 平山亮 on 2018/05/22.
//  Copyright © 2018年 Shuichi Tsutsumi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Dice: SCNNode {
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGFloat, hitResult: ARHitTestResult) {
        super.init()
        
        geometry = SCNBox(width: size, height: size, length: size, chamferRadius: 0.01)
        let imageNames = ["dice1","dice2","dice6","dice5","dice3","dice4"]
        geometry?.materials = []
        for imageName in imageNames {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: imageName)
            geometry?.materials.append(material)
        }
        physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry!, options: [:]))
        physicsBody?.categoryBitMask = 1
        physicsBody?.restitution = 1.5 // 弾み具合 0:弾みなし　3:超弾む
        physicsBody?.rollingFriction = 1 // 回転に対する摩擦
        physicsBody?.damping = 0.1 // 空気の摩擦抵抗 1でゆっくり落ちる
        physicsBody?.angularDamping = 1 // 回転に関する空気抵抗 0.0~1.0 default=0.1
        physicsBody?.friction = 1 // 接地面の摩擦の値 0.0~1.0 default=0.5
        // タップした位置よりサイコロのサイズのx倍の高さから落下させる
        position = SCNVector3(hitResult.worldTransform.columns.3.x + Float(size * CGFloat(arc4random() & 3)), hitResult.worldTransform.columns.3.y + Float(size * CGFloat(arc4random() % 3 + 5)), hitResult.worldTransform.columns.3.z)
        
        // 出目が変わるようにランダムに回転させる
        rotation = SCNVector4(1,1,1, Double(arc4random() % 10) * Double.pi)
    }
}
