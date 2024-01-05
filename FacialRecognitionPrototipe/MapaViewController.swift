//
//  ViewController.swift
//  FacialRecognition
//

import UIKit
import Vision
import SwiftUI
import AVFoundation
import UserNotifications
import UserNotificationsUI

class ViewController: UIViewController {

    // MARK: VARIABLES
    @IBOutlet var UserEmotion: UILabel!
    
    @IBOutlet var ExploreScrollView: UIScrollView!
    
    @IBOutlet var ExploreArea: UIView!
    
    @IBOutlet var BottomNav: UIView!
    
    private var selectedDate = Date()
    let notify = NotificationHandler()
    
    @IBSegueAction func embedSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SwiftUIView())
    }
    // Create view data output var, used for the data we will be analyzing using Vision
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    // Create capture session from AVFoundation
    private let captureSession = AVCaptureSession()
    
    //Create a preview layer to see the preview of the camera feed
    // Using the `lazy` keywords because the `captureSession` needs to be loaded before we use the preview layer
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    //The CoreML model we use for emotion classification.
    private let model = try! VNCoreMLModel(for: CNNEmotions(configuration: MLModelConfiguration()).model)
    
    // MARK: HELPER FUNCTIONS
    
    
    // Add camera input from the user's front camera
//    private func addCameraInput() {
//        
//        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera], mediaType: .video, position: .front).devices.first else {
//                fatalError("No camera detected. Please use a real camera.")
//            }
//        
//        // This should be wraped in a 'do-catch block'
//        let cameraInput = try! AVCaptureDeviceInput(device: device)
//        captureSession.addInput(cameraInput)
//    }
    
    // Geats every individual camera frame
//    private func getCameraFrames() {
//        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString): NSNumber(value: kCVPixelFormatType_32BGRA)] as [String: Any]
//                                         
//        videoDataOutput.alwaysDiscardsLateVideoFrames = true
//        if #available(iOS 17.0, *) {
//            videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
//        } else {
//            // Fallback on earlier versions
//        }
//                                         
//        captureSession.addOutput(videoDataOutput)
//        
//        guard let connection = videoDataOutput.connection(with: .video), connection.isVideoOrientationSupported else {
//            return
//        }
//        
//        connection.videoOrientation = .portrait
//    }
    
//    private func detectFace(image: CVPixelBuffer) {
//        // This is where we are going to detect a face and place a box around it
//        let faceDetectionRequest = VNDetectFaceLandmarksRequest { vnRequest, error in
//        DispatchQueue.main.async {
//            if let results = vnRequest.results as? [VNFaceObservation], results.count > 0 {
//                self.FacesCount.text = "✅ Detected \(results.count) face(s)."
//            } else {
//                self.FacesCount.text = "❌ No face was detected."
//            }
//        }
//    }
//        
//        // Perform the request on the image
//        let imageResultHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
//        try? imageResultHandler.perform([faceDetectionRequest])
//    }
    
//    private func detectEmotion(image: CVPixelBuffer) {
//        //Creates Vision Image Request Handler using the current frame and performs an MLRequest.
//        try? VNImageRequestHandler(cvPixelBuffer: image, orientation: .right, options: [:]).perform([VNCoreMLRequest(model: model) { [weak self] request, error in
//          //Here we get the first result of the Classification Observation result.
//          guard let firstResult = (request.results as? [VNClassificationObservation])?.first else { return }
//          DispatchQueue.main.async {
//            //Check if the confidence is high enough - used an arbitrary value here - and update the text to display the resulted emotion.
//            if firstResult.confidence > 0.92 {
//              let resultIdentifier = firstResult.identifier
//                self?.UserEmotion.text =  resultIdentifier
//            }
//          }
//        }])
//    }
//}
    
    @IBAction func addNotification(_ sender: Any) {
        print("pressed")
        self.notify.sendNotification(
            timeInterval: 1,
            title: "Be Careful!",
            body: "Your current state can negatively impact your driving abilities.")
    }
    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notify.askPermission()
        
        // Do any additional setup after loading the view
        
        //addCameraInput()
        
        //getCameraFrames()
        
        // Start capturing from the camera
        //DispatchQueue.global(qos: .background).async{
        //    self.captureSession.startRunning()
        }
    }
    
    // Adjust when the frame is changed
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        previewLayer.frame = view.frame
//    }

    //MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // This is where we are going to process each frame
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        
//        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            debugPrint("Unable to get image from the sample buffer.")
//            return
//        }
//        
//        detectFace(image: frame)
//        detectEmotion(image: frame)
//    }
}
