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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBtnClicked(_ sender: UIButton){
        if sender.tag == 0 {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true, completion: nil)
            
        }else if sender.tag == 1{
            let params = NSMutableDictionary()
            params.setValue([imageView.image, imageView.image], forKey: "images")
            NetwrokController().uploadImage(endUrl: "http://localhost:8888/test-folder/upload-image.php", params: params)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
}
