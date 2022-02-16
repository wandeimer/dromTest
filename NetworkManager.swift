//
//  NetworkManager.swift
//  dromTest
//
//  Created by Artem Yurchenko on 16.02.2022.
//

import Foundation

enum NetworkManagerError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}

class NetworkManager{
    
    static var networkManager = NetworkManager()
    let session: URLSession
    private var images = NSCache<NSString, NSData>()
    
    init() {
      let config = URLSessionConfiguration.default
      session = URLSession(configuration: config)
    }
    
    func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {
        
        // check "is we have cached image data for this url"
      if let imageData = images.object(forKey: imageURL.absoluteString as NSString) {
        completion(imageData as Data, nil)
        return
      }
      
      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
        if let error = error {
          completion(nil, error)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          completion(nil, NetworkManagerError.badResponse(response))
          return
        }
        
        guard let localUrl = localUrl else {
          completion(nil, NetworkManagerError.badLocalUrl)
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
            // add image to cache
          self.images.setObject(data as NSData, forKey: imageURL.absoluteString as NSString)
          completion(data, nil)
        } catch let error {
          completion(nil, error)
        }
      }
      
      task.resume()
    }
}
