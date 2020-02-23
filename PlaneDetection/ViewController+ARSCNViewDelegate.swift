//
//  ViewController+ARSCNViewDelegate.swift
//  PlaneDetection
//
//  Created by Cyan DeVeaux on 2/22/20.
//  Copyright © 2020 Cyan DeVeaux. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        let planeAnchor = anchor as! ARPlaneAnchor
        let planeNode = createPlane(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
        
        //generates focus square
        guard focusSquare == nil else {return}
        let focusSquareLocal = FocusSquare()
        self.sceneView.scene.rootNode.addChildNode(focusSquareLocal)
        self.focusSquare = focusSquareLocal
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        //print("Horizontal surface updated")
        let planeAnchor = anchor as! ARPlaneAnchor
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = createPlane(planeAnchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {return}
        //print("Horizontal surface removed")
        node.enumerateChildNodes { (childNode, _) in
        childNode.removeFromParentNode()
        }
    }
    
    //make focus square shift as we go
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let focusSquareLocal = focusSquare else {return}
        let hitTest = sceneView.hitTest(screenCenter, types: .existingPlane)
        let hitTestResult = hitTest.first
        guard let worldTransform = hitTestResult?.worldTransform else {return}
        let worldTransformColumn3 = worldTransform.columns.3
        
        //let nodeHitTest =  sceneView.hitTest(screenCenter, options: nil).first?

        //https://stackoverflow.com/questions/49506946/unable-to-differentiate-between-plane-detected-by-arkit-and-a-digital-object-to
        
        //focusSquareLocal.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        for item in buildingBlockArray{
            let upperBoundX = item.position.x + 0.05
            let lowerBoundX = item.position.x - 0.05
            let upperBoundY = item.position.y + 0.05
            let lowerBoundY = item.position.y - 0.05
            let upperBoundZ = item.position.z + 0.05
            let lowerBoundZ = item.position.z - 0.05
            
            if ((lowerBoundX <= worldTransformColumn3.x) && (worldTransformColumn3.x <= upperBoundX)) && ((lowerBoundY <= worldTransformColumn3.y) && (worldTransformColumn3.y <= upperBoundY)) && ((lowerBoundZ <= worldTransformColumn3.z) && (worldTransformColumn3.z <= upperBoundZ)){
                print ("overlapping with virtual object")
                
                focusSquareLocal.position = SCNVector3(item.position.x, item.position.y + 0.1, item.position.z)
                
                
            }
            else {
                 focusSquareLocal.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
            }
        }
        
         DispatchQueue.main.async {self.updateFocusSquare()}
    }

    func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.firstMaterial?.diffuse.contents = UIImage(named: "whitegrid.png")
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        planeNode.eulerAngles.x = GLKMathDegreesToRadians(-90)
        plane.firstMaterial?.isDoubleSided = true
        return planeNode
    }
}
