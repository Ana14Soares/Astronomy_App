//
//  UIFontExtesion.swift
//  Astronomy App
//
//  Created by Ana Soares on 11/11/26.
//

import Foundation
import UIKit

extension UIFont {
    
    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        
        let base = UIFont.preferredFont(forTextStyle: style)
        let descriptor = base.fontDescriptor.addingAttributes([.traits : [UIFontDescriptor.TraitKey.weight: weight]
            ])
        
        return UIFont(descriptor: descriptor, size: base.pointSize)
    }
    
}
