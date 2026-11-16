//
//  ImageLoader.swift
//  Astronomy App
//
//  Created by Ana Soares on 12/11/26.
//

import Foundation
import UIKit

struct ImageLoader {
    
    func loadImage(from url: URL) async throws -> UIImage {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {throw NetworkError.invalidResponse}
        guard (200...299).contains(http.statusCode) else { throw NetworkError.badStatus(http.statusCode) }
        
        guard let image = UIImage(data: data) else { throw NetworkError.invalidImage }
        return image
        
    }
}
