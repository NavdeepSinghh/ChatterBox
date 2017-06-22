//
//  ViewHelper.swift
//  ChatterBox
//
//  Created by Navdeep  Singh on 6/6/17.
//  Copyright © 2017 Navdeep. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIColor {
    convenience init (red : CGFloat, green : CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


extension UIImageView {
    func loadImageusingCacheWithURLString( urlString  : String){
        self.image = nil
        // Check if the images are present in the imageCache 
        if let cachedimage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedimage
            return
        }
        // If image not in cache.. fire the data task to get the image
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let error = error {
                print (error)
                return
            }
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                self.image = UIImage(data: data!)
            }
            
        }).resume()

    }
}
