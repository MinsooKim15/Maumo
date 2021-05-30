//
//  ImageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/23.
//

import SwiftUI
struct ImageView:View{
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    init(withUrl url:String){
        imageLoader = ImageLoader(urlString:url)
    }
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
            }
    }
}
