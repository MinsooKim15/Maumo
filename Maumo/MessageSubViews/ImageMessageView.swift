//
//  ImageMessageView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/01/31.
//
// TODO: - init을 없애자
import SwiftUI
struct ImageMessageView: View {
    var url: String
    var isCurrentUser: Bool
    init(withUrl url:String, isCurrentUser:Bool){
        self.url = url
        self.isCurrentUser = isCurrentUser
    }
    
    var body: some View {
        ImageView(withUrl: url)
            .frame(width:200, height:200)
            .cornerRadius(20)

    }
}
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
