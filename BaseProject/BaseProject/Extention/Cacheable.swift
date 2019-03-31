//
//  Cacheable.swift
//  BaseProject
//
//  Created by Bao Nguyen on 3/31/19.
//  Copyright © 2019 Bao Nguyen. All rights reserved.
//

import UIKit

protocol Cacheable {}

fileprivate let cacheImage = NSCache<NSString, UIImage>()

extension UIImageView: Cacheable {}

extension Cacheable where Self: UIImageView {
    typealias Completion = (Bool) -> Void
    
    func loadImage(_ urlString: String, placeHolder: UIImage, completion: (Completion)?) {
        if let image = cacheImage.object(forKey: urlString as NSString) {
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion?(true)
                return
            }
        }
        self.image = placeHolder
        guard let url = URL(string: urlString) else {
            completion?(false)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil || (response as? HTTPURLResponse)?.statusCode != 200 {
                completion?(false)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion?(false)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
                completion?(true)
            }
        }
        task.resume()
    }
}
