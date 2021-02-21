//
//  CustomParameters.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//
// Dialogflow의 패러미터(Context, event 등)의 값이 복합적이고 예측할 수 없음. 그러한 것들을 Codable하게 입력하게 해주는 자료형임.

import Foundation

enum CustomParameters : Codable, Equatable,Hashable {
     case int(Int)
     case string(String)
     case list([CustomParameters])
     case dictionary([String : CustomParameters])

     public init(from decoder: Decoder) throws {
         // Can be made prettier, but as a simple example:
         let container = try decoder.singleValueContainer()
         do {
             self = .int(try container.decode(Int.self))
         } catch DecodingError.typeMismatch {
             do {
                 self = .string(try container.decode(String.self))
             } catch DecodingError.typeMismatch {
                 do {
                     self = .list(try container.decode([CustomParameters].self))
                 } catch DecodingError.typeMismatch {
                     self = .dictionary(try container.decode([String : CustomParameters].self))
                 }
             }
         }
     }

     public func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         switch self {
         case .int(let int): try container.encode(int)
         case .string(let string): try container.encode(string)
         case .list(let list): try container.encode(list)
         case .dictionary(let dictionary): try container.encode(dictionary)
         }
     }

     static func ==(_ lhs: CustomParameters, _ rhs: CustomParameters) -> Bool {
         switch (lhs, rhs) {
         case (.int(let int1), .int(let int2)): return int1 == int2
         case (.string(let string1), .string(let string2)): return string1 == string2
         case (.list(let list1), .list(let list2)): return list1 == list2
         case (.dictionary(let dict1), .dictionary(let dict2)): return dict1 == dict2
         default: return false
         }
     }
}
