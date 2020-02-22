//
//  FocusSquare.swift
//  PlaneDetection
//
//  Created by Cyan DeVeaux on 2/22/20.
//  Copyright © 2020 Cyan DeVeaux. All rights reserved.
//

import SceneKit

class FocusSquare: SCNNode {
    override init() {
        super.init()
        let plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = UIImage(named: "FocusSquare/close")
        plane.firstMaterial?.isDoubleSided = true

        geometry = plane
        eulerAngles.x = GLKMathDegreesToRadians(-90)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
