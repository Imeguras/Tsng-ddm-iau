//
//  ViewController.swift
//  FacialRecognition
//

import UIKit
import SwiftUI
import Vision
import AVFoundation
import CoreLocation
import CoreML
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: VARIABLES
    
    // Store
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var managedObjectContext: NSManagedObjectContext {
        return context
    }
    
    var items:[Location]?
    
    //var managedObjectContext: NSManagedObjectContext? {
      //  let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //return appDelegate?.persistentContainer.viewContext
   // }
    // Store
    
    private var locationManager:CLLocationManager?
    
    /*private var latLngLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemFill
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26)
        return label
    } ()*/
    
    @IBOutlet var FacesCount: UILabel!
    
    // Create view data output var, used for the data we will be analyzing using Vision
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    // Create capture session from AVFoundation
    private let captureSession = AVCaptureSession()
    
    //Create a preview layer to see the preview of the camera feed
    // Using the `lazy` keywords because the `captureSession` needs to be loaded before we use the preview layer
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    //The CoreML model we use for emotion classification.
    // private let model = try! VNCoreMLModel(for: CNNEmotions().model)
    private let model = try! VNCoreMLModel(for: CNNEmotions(configuration: MLModelConfiguration()).model)

    
    // MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        //addCameraInput()
        //showCameraFeed()
        
        //getCameraFrames()
        
        // Start capturing from the camera
        captureSession.startRunning()
        
        /*latLngLabel.frame = CGRect(x: 20, y: view.bounds.height / 2 - 50, width: view.bounds.width - 40, height: 100)
        view.addSubview(latLngLabel)*/
        
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        
        // tableView.dataSource = self
        // tableView.delegate = self
        
        // Get items from Core Data
        fetchCoordinates()
        
        //login()
    }
    
    func fetchCoordinates() {
        // Fetch the data from Core Data
        do {
            self.items = try context.fetch(Location.fetchRequest())
            
            //DispatchQueue.main.async {
              //  self.tableView.reloadData()
            //}
        }
        catch {
            print("Error fetching coordinates from Core Data: (error)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            /*latLngLabel.text =  "Lat: \(location.coordinate.latitude) \nLng: \(location.coordinate.longitude)"*/
            
            // Criar uma instância da entidade Location
            let newLocation = Location(context: managedObjectContext)
            newLocation.latitude = location.coordinate.latitude
            newLocation.longitude = location.coordinate.longitude

             // Salvar a instância no Core Data
            do {
                try managedObjectContext.save()
                print("Localização guardada no Core Data")
            } catch {
                print("Erro ao salvar a localização no Core Data: (error)")
            }
        }
    }
    
    // Adjust when the frame is changed
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.frame
    }
    
    // MARK: HELPER FUNCTIONS
    
    // Add camera input from the user's front camera
    /*private func addCameraInput() {
        
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
    }*/
    
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
