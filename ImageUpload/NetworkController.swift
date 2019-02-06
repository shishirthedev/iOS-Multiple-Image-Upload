//
//  NetworkController.swift
//  ImageUpload
//
//  Created by Developer Shishir on 2/5/19.
//  Copyright © 2019 Shishir. All rights reserved.
//

import UIKit
class NetwrokController: NSObject {
    
    
    func uploadImage(endUrl:String,
                     params: NSMutableDictionary){
        
        guard let request = createRequest(endUrl: endUrl, param: params) else { return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
        }
        task.resume()
    }
    
    // Creating Request for multi part
    func createRequest (endUrl : String,
                        param : NSMutableDictionary) -> URLRequest? {
        
        guard let urlToRequest = URL(string: endUrl) else { return nil}
        var request: URLRequest = URLRequest(url: urlToRequest)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBodyForMultipleImage(parameters: param, boundary: boundary, mimeType: "image/jpg")
        return request
    }
    
    // Creating multipart body for multipart request
    func createBodyForMultipleImage(parameters: NSMutableDictionary?,
                                    boundary: String,
                                    mimeType: String) -> Data {
        
        let body = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        
        if let params = parameters{
            for (key, value) in params {
                
                if(value is String || value is NSString){
                    body.appendString(boundaryPrefix)
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }
                    
                else if(value is [UIImage]){
                    print("I am here")
                    var i: Int = 0;
                    for image in value as! [UIImage]{
                        let filename = "\(key)\(i).jpg"
                        print(filename)
                        if let data = image.jpegData(compressionQuality: 1){
                            body.appendString(boundaryPrefix)
                            body.appendString("Content-Disposition: form-data; name=\"\(key)[]\"; filename=\"\(filename)\"\r\n")
                            body.appendString("Content-Type: \(mimeType)\r\n\r\n")
                            body.append(data)
                            body.appendString("\r\n")
                            i = i + 1
                        }
                    }
                }
            }
            body.appendString("--".appending(boundary.appending("--")))
        }
        return body as Data
    }
}


extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
