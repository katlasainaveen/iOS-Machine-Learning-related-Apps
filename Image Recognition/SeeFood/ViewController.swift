//
//  ViewController.swift
//  SeeFood
//
//  Created by Sai Naveen Katla on 25/09/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        selectedImageView.contentMode = .scaleAspectFill
    }

    @IBAction func cameraPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let info = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageView.image = info
            
            guard let ciImage = CIImage(image: info) else {
                fatalError("Could not convert to CIImage")
            }
            detect(image: ciImage)
        }
        
    }
    
    func detect(image: CIImage) {
        do {
            let model = try VNCoreMLModel(for: Inceptionv3().model)
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if error == nil {
                    guard let results = request.results as? [VNClassificationObservation] else {
                        fatalError("Model failed to process image")
                    }
                    if let firstresult = results.first {
                        print(firstresult.identifier)
                        self.navigationItem.title = "\(firstresult.identifier)"
                    }
                }
                else {
                    print("error in request in detect: \(String(describing: error))")
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
                try handler.perform([request])
            }
            catch {
                print("error in handler: \(error)")
            }
        }
        catch {
            print("error in detect function: \(error)")
        }
        
    }
    
}

