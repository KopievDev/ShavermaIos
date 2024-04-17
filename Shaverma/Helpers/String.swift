//
//  String.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import Foundation

extension String {
    ///Not implement
    static let notImplememt = "Not implement"

    func formattedText(format: String = "+# (###) ###-##-##") -> String {
        let cleanText = self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        let mask = format
        var result = ""
        var index = cleanText.startIndex
        for ch in mask where index < cleanText.endIndex {
            if ch == "#" {
                result.append(cleanText[index])
                index = cleanText.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

}
