//
//  LoadStatus.swift
//  Astronomy App
//
//  Created by Ana Soares on 17/11/26.
//

import Foundation
import UIKit

enum LoadStatus {
    case loading
    case loaded(StoredArticle, UIImage?)
    case failed(String)
}
