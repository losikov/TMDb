//
//  UIImageView_Caches.swift 
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>() // to store downloaded images

extension UIImageView {
    
    func loadImageWithUrl(string urlString: String,
                          placeholder: UIImage?,
                          startedHandler: () -> Void,
                          completionHandler: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }

        startedHandler()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Failed to load image for '\(urlString)': \(error)")
                DispatchQueue.main.async {
                    completionHandler(placeholder)
                }
                return
            }

            guard
                let data = data,
                let image = UIImage(data: data)
                else {
                    print("Invalid image for '\(urlString)'")
                    DispatchQueue.main.async {
                        completionHandler(placeholder)
                    }
                    return
            }
            
            DispatchQueue.main.async {
                completionHandler(image)
            }
        
            imageCache.setObject(image, forKey: NSString(string: urlString))
        }.resume()
    }
    
}
