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
        var request = URLRequest(url: url)
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {throw NetworkError.invalidResponse}
        guard (200...299).contains(http.statusCode) else { throw NetworkError.badStatus(http.statusCode) }
        
        guard let image = UIImage(data: data) else { throw NetworkError.invalidImage }
        return image
        
    }
    
    func loadData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {throw NetworkError.invalidResponse}
        guard (200...299).contains(http.statusCode) else { throw NetworkError.badStatus(http.statusCode) }
        
        guard UIImage(data: data) != nil else { throw NetworkError.invalidImage }
        return data
        
    }
}
