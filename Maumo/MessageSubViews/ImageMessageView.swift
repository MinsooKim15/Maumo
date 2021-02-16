//
//  ImageMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//

import SwiftUI
struct ImageMessageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    
    var isCurrentUser: Bool
    init(withUrl url:String, isCurrentUser:Bool){
        imageLoader = ImageLoader(urlString:url)
        self.isCurrentUser = isCurrentUser
    }
    
    var body: some View {
        Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:100, height:100)
                        .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                }
    }
}

