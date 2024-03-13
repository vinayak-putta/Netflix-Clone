//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Vinayak Putta on 13/01/24.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
