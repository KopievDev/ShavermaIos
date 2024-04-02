//
//  UIPasteboard.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import UIKit

extension UIPasteboard {
    class func copyMarkdown<T:Encodable>(jsonModel: T) {
        UIPasteboard.general.string =
"""
```json
\(jsonModel.json ?? "Error")
```
"""
    }
}
