//
//  ViewController.swift
//  FacialRecognition
//

import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    var container: NSPersistentContainer!
    
    // MARK: VARIABLES
    
    @IBOutlet var FacesCount: UILabel!
    
    // Create view data output var, used for the data we will be analyzing using Vision
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    // Create capture session from AVFoundation
    private let captureSession = AVCaptureSession()
    
    //Create a preview layer to see the preview of the camera feed
    // Using the `lazy` keywords because the `captureSession` needs to be loaded before we use the preview layer
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    //The CoreML model we use for emotion classification.
    private let model = try! VNCoreMLModel(for: CNNEmotions().model)
    
    
   //THIS SHOULD BE IN EVERY CONTROLLER
   /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if let nextVC = segue.destination as? NextViewController {
           nextVC.container = container
       }
   }*/
   
    // MARK: LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        
        // The persistent
        }

        // Do any additional setup after loading the view
        
        addCameraInput()
        //showCameraFeed()
        
        getCameraFrames()
        
        // Start capturing from the camera
        captureSession.startRunning()
    }
    
    // Adjust when the frame is changed
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.frame
    }
    
    // MARK: HELPER FUNCTIONS
    
    // Add camera input from the user's front camera
    private func addCameraInput() {
        
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
                fatalError("No camera detected. Please use a real camera.")
            }
        
        // This should be wraped in a 'do-catch block'
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        captureSession.addInput(cameraInput)
    }
           
    private func showCameraFeed() {
        // Create preview layer to see the preview of the camera feed
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    
    // Geats every individual camera frame
    private func getCameraFrames() {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
                                         
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
                                         
        captureSession.addOutput(videoDataOutput)
        
        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
            return
        }
        
        connection.videoOrientation = .portrait
    }
    
    private func detectFade(image: CVPixelBuffer) {
        // This is where we are going to detect a face and place a box around it
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { vnRequest, error in
        DispatchQueue.main.async {
            if let results = vnRequest.results as? [VNFaceObservation], results.count > 0 {
                self.FacesCount.text = "✅ Detected \(results.count) face(s)."
                //print("✅ Detected \(results.count) face(s).")
            } else {
                self.FacesCount.text = "❌ No face was detected."
                //print("❌ No face was detected.")
            }
        }
    }
        
        // Perform the request on the image
        let imageResultHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageResultHandler.perform([faceDetectionRequest])
    }
}

    //MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // This is where we are going to process each frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("Unable to get image from the sample buffer.")
            return
        }
        
        detectFade(image: frame)
    }
}
