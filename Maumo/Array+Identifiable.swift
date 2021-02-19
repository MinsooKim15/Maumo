//
//  Array+Identifiable.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/18.
//

import Foundation
extension Array where Element: Identifiable{
    func firstIndex(matching: Element)-> Int?{
        for index in 0..<self.count {
            if self[index].id == matching.id{
                return index
            }
        }
        return nil
    }
}
