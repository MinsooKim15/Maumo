//
//  CustomNavigationBar.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/19.
//

import SwiftUI
struct CustomNavigationBar : View{
    let navBarPaddingToLead = CGFloat(20)
    let navBarPaddingToTop = CGFloat(20)
    let navBarMaxHeight = CGFloat(50)
    let navBarBackButtonSize = CGFloat(23)
    let titleFontColor = Color.black
    let titleFontSetting = FontSetting(fontWeight: .bold, fontSize: .medium20)
    var hasTitleText : Bool
    var titleText : String
    var backgroundColor : Color = Color.white.opacity(0.95)
    var showCustomTitle:Bool = false
    
    var showCustomButton : Bool = false
    var customButtonLabel: ()->AnyView = {AnyView(Image(systemName: "check.mark"))}
    var customButtonAction: ()->Void = {print("done")}
    var computedRightSide : AnyView{
        if self.showCustomButton{
            return AnyView(Button(action: self.customButtonAction, label: self.customButtonLabel))
                
        }else{
            return AnyView(Spacer())
        }
    }
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body : some View{
        ZStack{
            self.backgroundColor
                .edgesIgnoringSafeArea(.all)
          VStack(spacing:0){
              HStack(){
                Image(systemName: "chevron.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.salmon)
                    .frame(width:self.navBarBackButtonSize, height:self.navBarBackButtonSize)
                    .padding([.leading], self.navBarPaddingToLead)
                    .padding([.top], self.navBarPaddingToTop)
                    .onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                  Spacer()
                NavigationLink(destination: EmptyView(), label: {})
                Group{
                    if hasTitleText{
                        Text(self.titleText)
                        .adjustFont(fontSetting: titleFontSetting)
                        .foregroundColor(self.titleFontColor)
                        .multilineTextAlignment(TextAlignment.center)
                        .padding([.top], self.navBarPaddingToTop)
                    }
                }
              Spacer()
              computedRightSide.frame(width:self.navBarBackButtonSize, height:self.navBarBackButtonSize).padding([.trailing], self.navBarPaddingToLead)
              .padding([.top], self.navBarPaddingToTop)
            }
            Spacer()
        }
        }
        .frame(maxHeight: self.navBarMaxHeight)
    }
}
