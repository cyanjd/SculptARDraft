//
//  GridMaterial.swift
//  PlaneDetection
//
//  Created by Cyan DeVeaux on 1/30/20.
//  Copyright © 2020 Cyan DeVeaux. All rights reserved.
//

import Foundation
import UIKit

import SceneKit
import ARKit

class GridMaterial: SCNMaterial {

    override init() {
        super.init()
        // 1
        let image = UIImage(named: "Grid")

        // 2
        diffuse.contents = image
        diffuse.wrapS = .repeat
        diffuse.wrapT = .repeat
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
