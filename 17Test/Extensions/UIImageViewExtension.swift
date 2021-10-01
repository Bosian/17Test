//
//  UIImageViewExtension.swift
//  17Test
//
//  Created by 劉柏賢 on 2021/9/25.
//

import UIKit

// MARK: - Associated Object
private var urlKey: Void?

extension UIImageView {

    var urlString: String? {
        get {
            return objc_getAssociatedObject(self, &urlKey) as? String
        }

        set {
            objc_setAssociatedObject(self, &urlKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// DispatchQueue version
    func setImage(urlString: String, placeholder: UIImage?) {
        
        if let cacheImage = UIImage.getImageFromCache(urlString: urlString) {
            self.image = cacheImage
            self.urlString = urlString
            return
        } else {
            self.image = placeholder
        }
        
        guard !urlString.isEmpty else {
//            assertionFailure("urlString is empty")
            return
        }
        
        guard let url = URL(string: urlString) else {
//            assertionFailure("url is nil")
            return
        }
        
        guard urlString != self.urlString else { return }
        
        self.urlString = urlString
        
        DispatchQueue.global().async { [weak self] in
            
            let dataTask = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                DispatchQueue.main.async {
                    
                    let image: UIImage? = data?.image
                    image?.saveToCache(urlString: urlString)
                    
                    guard urlString == self?.urlString else { return }
                    self?.image = image
                }
            }
            
            dataTask.resume()
        }
    }
}
