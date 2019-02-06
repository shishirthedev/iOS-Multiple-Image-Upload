//
//  ViewController.swift
//  ImageUpload
//
//  Created by Developer Shishir on 2/5/19.
//  Copyright © 2019 Shishir. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBtnClicked(_ sender: UIButton){
        
        if sender.tag == 1 { // Photo Gallery...
            PermissionManager.shared.requestAccess(vc: self, .photoLibraryUsage) { (isGranted) in
                if isGranted{
                    self.selectImageFrom(.photoLibrary)
                }
            }
            
        }else if sender.tag == 2 { // CAMERA...
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                PermissionManager.shared.requestAccess(vc: self, .cameraUsage) { (isGranted) in
                    self.selectImageFrom(.camera)
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "You have no camera to capture image.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else if (sender.tag == 3){   // Save Image to Photo Library
            guard let image = imageView.image else { return}
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }else if (sender.tag == 4){
            let dataDic = NSMutableDictionary()
            dataDic.setValue([imageView.image], forKey: "images")
            NetwrokController().uploadImage(endUrl: "kfjkdjfkj", params: dataDic)
        }
    }
    
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }else{
            print("Image not found")
        }
    }
}

