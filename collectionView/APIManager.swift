//
//  APIManager.swift
//  collectionView
//
//  Created by Nurmukhanbet Sertay on 06.05.2023.
//

import Foundation
import UIKit

protocol MyApiManagerDelegate: AnyObject {
    func test()
}

class APIManager {
    
    func loadImages(id: Int, completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlString + "\(id)")
        
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let image = try? JSONDecoder().decode(ImageElement.self, from: data) {
                self.loadImageContent(url: image.url, completion: completion)
            } else {
                print("error")
            }
        }
        
        task.resume()
    }
    
    func loadImageContent(url: String, completion: @escaping (UIImage?) -> ()) {
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { data, response, error in
            if let data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Image didn't loaded")
            }
        }
        task.resume()
    }
    
    private let urlString = "https://jsonplaceholder.typicode.com/photos/"
    
   
}

extension APIManager: MyApiManagerDelegate  {
    func test() {
        print("test started")
    }
}
