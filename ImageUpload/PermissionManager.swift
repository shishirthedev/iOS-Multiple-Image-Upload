//
//  PermissionManager.swift
//  ImageUpload
//
//  Created by Developer Shishir on 2/6/19.
//  Copyright © 2019 Shishir. All rights reserved.
//

import UIKit
import Contacts
import AVFoundation
import Photos

enum Permission {
    case cameraUsage
    case contactUsage
    case photoLibraryUsage
    case microphoneUsage
}


class PermissionManager {
    
    private init(){}
    public static let shared = PermissionManager()
    
    let PHOTO_LIBRARY_PERMISSION: String = "Require access to Photo library to proceed. Would you like to open settings and grant permission to photo library?"
    let CAMERA_USAGE_PERMISSION: String = "Require access to Camera to proceed. Would you like to open settings and grant permission to camera ?"
    let CONTACT_USAGE_ALERT: String = "Require access to Contact to proceed. Would you like to open Settings and grant permission to Contact?"
    let MICROPHONE_USAGE_ALERT: String = "Require access to microphone to proceed. Would you like to open Settings and grant permissiont to Microphone?"
    
    
    
    func requestAccess(vc: UIViewController,
                       _ permission: Permission,
                       completionHandler: @escaping (_ accessGranted: Bool) -> Void){
        
        switch permission {
            
        case .cameraUsage: ////////////////// Camera
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                completionHandler(true)
            case .denied:
                showSettingsAlert(controller: vc, msg: CAMERA_USAGE_PERMISSION, completionHandler)
            case .restricted, .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        completionHandler(true)
                    } else {
                        DispatchQueue.main.async {
                            self.showSettingsAlert(controller: vc, msg: self.CAMERA_USAGE_PERMISSION, completionHandler)
                        }
                    }
                }
            }
            break
            
            
        case .contactUsage: ///////////////////// Contact
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                completionHandler(true)
            case .denied:
                showSettingsAlert(controller: vc, msg: CONTACT_USAGE_ALERT, completionHandler)
            case .restricted, .notDetermined:
                CNContactStore.init().requestAccess(for: .contacts) { granted, error in
                    if granted {
                        completionHandler(true)
                    } else {
                        DispatchQueue.main.async {
                            self.showSettingsAlert(controller: vc, msg: self.CONTACT_USAGE_ALERT, completionHandler)
                        }
                    }
                }
            }
            break
            
            
        case .photoLibraryUsage: ///////////////////// Photo library
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                completionHandler(true)
            case .denied:
                showSettingsAlert(controller: vc, msg: PHOTO_LIBRARY_PERMISSION, completionHandler)
            case .restricted, .notDetermined:
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized{
                        completionHandler(true)
                    }else{
                        DispatchQueue.main.async {
                            self.showSettingsAlert(controller: vc, msg: self.PHOTO_LIBRARY_PERMISSION, completionHandler)
                        }
                    }
                }
            }
            break
            
        case .microphoneUsage:  //////////////////////// Microphone usage
            switch AVAudioSession.sharedInstance().recordPermission{
            case .granted:
                completionHandler(true)
                break
            case .denied:
                showSettingsAlert(controller: vc, msg: MICROPHONE_USAGE_ALERT, completionHandler)
                break
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                    if granted{
                        completionHandler(true)
                    }else{
                        DispatchQueue.main.async {
                            self.showSettingsAlert(controller: vc, msg: self.MICROPHONE_USAGE_ALERT, completionHandler)
                        }
                    }
                })
                break
            }
        }
    }
    
    
    
    private func showSettingsAlert(controller: UIViewController ,
                                   msg: String,
                                   _ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsUrl){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl)
                    } else {
                        UIApplication.shared.openURL(settingsUrl)
                    }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        controller.present(alert, animated: true)
    }
}


/////////////////////////////////////////////////////////////////////////
/////// Don't forget to add permission in info.plist from privacy ///////
/////////////////////////////////////////////////////////////////////////
