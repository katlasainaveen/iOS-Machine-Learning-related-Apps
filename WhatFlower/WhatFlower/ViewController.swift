//
//  ViewController.swift
//  WhatFlower
//
//  Created by Sai Naveen Katla on 26/09/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    var wikiData = GetWikiData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        selectedImageView.contentMode = .scaleAspectFill
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        if let infos = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageView.image = infos
            
            if let ciimage = CIImage(image: infos) {
                detect(image: ciimage)
            }
        }
        
    }

    @IBAction func cameraPressd(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        do {
            let model = try VNCoreMLModel(for: FlowerClassifier().model)
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if error == nil {
                    guard let results = request.results as? [VNClassificationObservation] else {
                        fatalError("here3")
                    }
                    if let firstresult = results.first {
                        self.navigationItem.title = firstresult.identifier.capitalized
                        let extract = self.wikiData.getDetails(for: firstresult.identifier)
                        self.label.text = extract
                    }
                }
                else {
                    print("here2 \(error)")
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            }
            catch {
                print(error)
            }
        }
        catch {
            print("here1 " + "\(error)")
        }
    }
    
}

