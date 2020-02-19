//
//  ViewController.swift
//  PlaneDetection
//
//  Created by Cyan DeVeaux on 1/30/20.
//  Copyright © 2020 Cyan DeVeaux. All rights reserved.
//

import UIKit

import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    let session = ARSession()
    var buildingBlockArray : [SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session = session
        sceneView.delegate = self
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse(sender:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(configuration)
    }
    
    @objc func tapResponse(sender: UITapGestureRecognizer){
        let scene = sender.view as! ARSCNView
        let location = scene.center
        guard let hitTestNode = scene.hitTest(location,options: nil).first?.node else { return }
        for item in buildingBlockArray{
            if hitTestNode == item{
                print("user tapped on object")
            }
        }
        //let hitTestCenter = scene.hitTest(location, types: .existingPlaneUsingExtent)
        guard let hitTestCenter = scene.hitTest(location, types: .existingPlaneUsingExtent).first else { return }
        addObject(hitResult: hitTestCenter)
//        let tapLocation = sender.location(in: scene)
//        let hitTestRes = scene.hitTest(location, options: [:])
//        let hitTestCenter = scene.hitTest(location, types: .existingPlaneUsingExtent)
//        if hitTestCenter.isEmpty == false {
//            guard let hitTestCenter = hitTestCenter.first else { return }
//            for item in buildingBlockArray{
//                for hitResult in hitTestRes{
//                    if (item == hitResult.node){
//                        print ("hit object")
//                    }
//                }
//
//            }
//            addObject(hitResult: hitTestCenter)
//        }
    }
    
    func addObject(hitResult:ARHitTestResult){
        let objectNode = SCNNode()
        objectNode.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        objectNode.geometry?.firstMaterial?.diffuse.contents = UIColor.purple
        objectNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y,hitResult.worldTransform.columns.3.z)
        objectNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        sceneView.scene.rootNode.addChildNode(objectNode)
        buildingBlockArray.append(objectNode)
    }
    
  
    
    //runs each time ARKit identifies a horizontal plane and identifies it as a plane anchor called ARPlane anchor, which defines the position and orientation of the flat surface
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        guard anchor is ARPlaneAnchor else { return }
        let planeNode = displayTexture(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
        print ("plane detected")
    }
    
    //realizes when horizontal may need to be larger
    func renderer(_renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor){
        guard anchor is ARPlaneAnchor else { return }
        node.enumerateChildNodes{ (childNode, _) in
            childNode.removeFromParentNode()
        }
        let planeNode = displayTexture(anchor: anchor as! ARPlaneAnchor)
        node.addChildNode(planeNode)
        print ("updating plane anchor")
    }
    
    func displayTexture(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        //planeNode.geometry=SCNPlane(width: 0.5, height: 0.5)
        planeNode.geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Locator_Grid.png")
        planeNode.position = SCNVector3(0,0,0)
        let ninetyDegrees = GLKMathDegreesToRadians(90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planeNode.geometry?.firstMaterial?.isDoubleSided = true
        return planeNode
    }

    //OLD CODE
    //        let hitTest = scene.hitTest(tapLocation, types: .existingPlaneUsingExtent)
    //        if hitTest.isEmpty{
    //            print ("no plane detected")
    //        }
    //        else {
    //            print ("found a horizontal plane")
    //            guard let hitResult = hitTest.first else { return }
    //            addObject(hitResult: hitResult)
    //        }

        
    //    @objc func handleTap(sender: UITapGestureRecognizer){
    //        let areaTapped = sender.view as! SCNView
    //        let tappedCoordinates = sender.location(in: areaTapped)
    //        let hitTest = areaTapped.hitTest(tappedCoordinates)
    //        if hitTest.isEmpty{
    //            print ("Nothing")
    //        }
    //        else{
    //            let results = hitTest.first!
    //            let name = results.node.name
    //            print(name ?? "background")
    //        }
    //    }
}

