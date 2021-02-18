//
//  Context.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//


import Foundation
struct Context:Codable{
    var name: String
    var lifespanCount:Int
    var parameters:Dictionary<String,CustomParameters>?
//    init(dictionary: Dictionary<String,Any>){
//        name = dictionary["name"] as! String
//        lifeSpanCount = dictionary["lifeSpanCount"] as! Int
//        parameters = dictionary["parameters"] as! Dictionary<String,Any>
//    }
}
