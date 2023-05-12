//
//  ViewController.swift
//  TryOnSpecs
//
//  Created by Vahida on 11/05/2023.
//
import ARKit
import Vision



class SceneViewController: UIViewController, ARSessionDelegate {
    var arSession: ARSession!
    var faceBorderLayer: CAShapeLayer?

    @IBOutlet weak var arSceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arSession = ARSession()
        arSession.delegate = self
        
        
        arSceneView.session = arSession

        
      
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        arSession.run(configuration)
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
         let pixelBuffer = frame.capturedImage
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest { request, error in
            guard let results = request.results as? [VNFaceObservation], let firstResult = results.first else { return }
            
            // Do something with the face observation
            // Create a rectangle based on the detected face's bounds
            // Create a rectangle based on the detected face's bounds
                   let faceBounds = firstResult.boundingBox
                   let arViewBounds = self.view.bounds
                   let rect = CGRect(x: faceBounds.origin.x * arViewBounds.width,
                                     y: (1 - faceBounds.origin.y - faceBounds.height) * arViewBounds.height,
                                     width: faceBounds.width * arViewBounds.width,
                                     height: faceBounds.height * arViewBounds.height)
                   
                   // Create a red border rectangle to overlay on top of the ARKit camera view
                   if let borderLayer = self.faceBorderLayer {
                       // If the border layer already exists, update its path
                       borderLayer.path = UIBezierPath(rect: rect).cgPath
                   } else {
                       // If the border layer does not exist, create it
                       let borderLayer = CAShapeLayer()
                       borderLayer.path = UIBezierPath(rect: rect).cgPath
                       borderLayer.fillColor = UIColor.clear.cgColor
                       borderLayer.strokeColor = UIColor.red.cgColor
                       borderLayer.lineWidth = 2.0
                       self.view.layer.addSublayer(borderLayer)
                       self.faceBorderLayer = borderLayer
                   }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        try? handler.perform([faceDetectionRequest])
    }


}





