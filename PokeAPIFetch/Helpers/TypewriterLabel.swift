//
//  TypewriterLabel.swift
//  PokeAPIFetch
//
//  Created by Space Wizard on 7/27/24.
//

import Foundation
import UIKit

class TypewriterLabel: UILabel {
    
    var fullText: String = "" {
        didSet {
          text = ""
            typeNextCharacter(after: 0)
        }
    }
    
    var typingSpeed: TimeInterval = 0.08
    var isAnimating: Bool = false
    
    func typeNextCharacter(after delay: TimeInterval) {
        guard !fullText.isEmpty else { return }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            let index = self.fullText.index(self.fullText.startIndex, offsetBy: self.text?.count ?? 0)
            if index < self.fullText.endIndex {
                isAnimating = true
                self.text?.append(self.fullText[index])
                self.typeNextCharacter(after: typingSpeed)
            } else {
                isAnimating = false // If we are the end of the text we are no longer animating
            }
        }
    }
}
