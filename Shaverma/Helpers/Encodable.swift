//
//  Encodable.swift
//  VeLo Player
//
//  Created by Иван Копиев on 12.03.2024.
//

import Foundation

extension Encodable {
    var json: String? {
        try? JSONEncoder().encode(self).prettyPrintedJSONString
    }
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
              let prettyJSON = String(data: data, encoding: .utf8) else { return nil }
        return prettyJSON
    }
}
