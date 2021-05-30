//
//  MaumJournalWritingFullView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/05/24.
//

import SwiftUI
struct MaumJournalWritingFullView: View {
    @ObservedObject var modelView : MaumJournalModelView
//    MARK: - 작성되는 문구(길이 제한을 건다.)
    @State var title: String = ""
    @State var content: String = ""
    
    init(modelView:MaumJournalModelView){
        self.modelView = modelView
        UITextView.appearance().backgroundColor = .clear
    }
    init(modelView:MaumJournalModelView,
         contentLimitTo contentCharacterLimit:Int,
         titleLimitTo titleCharacterLimit : Int){
        self.modelView = modelView
        self.contentCharacterLimit = contentCharacterLimit
        self.titleCharacterLimit = titleCharacterLimit
        UITextView.appearance().backgroundColor = .clear
    }
//    MARK:- Consoles for UI
    let imageWidth :CGFloat = 48.0
    let imageHeight :CGFloat = 48.0
    let targetDateFontSetting : FontSetting = FontSetting(fontWeight: .regular, fontSize: .medium18)
    let titleFontSetting: FontSetting = FontSetting(fontWeight: .regular, fontSize: .medium20)
    let contentFontSetting: FontSetting = FontSetting(fontWeight: .regular, fontSize: .small14)
    let contentPaddingToLeading:CGFloat = 40.0
    let contentPaddingToTrailing:CGFloat = 40.0
    let contentPaddingToBottom:CGFloat = 40.0
    let contentPaddingToTop:CGFloat = 20.0
    let titlePaddingToTop:CGFloat = 20.0
    let titleHeight:CGFloat = 24.0
    var contentCharacterLimit:Int = 500
    var titleCharacterLimit:Int = 14
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    func checkTitleCount(oldValue:String, newValue:String){
        if newValue.count > titleCharacterLimit && oldValue.count <= titleCharacterLimit {
            print("제목 한계")
            self.title = oldValue
        }
    }
    func checkContentCount(oldValue:String, newValue:String){
        if newValue.count > contentCharacterLimit && oldValue.count <= contentCharacterLimit {
            print("제목 한계")
            self.content = oldValue
        }
    }
    func saveJournal(){
        print("Save Journal")
        self.modelView.saveJournal(
            title: self.title,
            content: self.content,
            targetDate: Date(),
            feeling: .happy,
            feelingImage: "A"
        )
        self.presentationMode.wrappedValue.dismiss()
    }
    var body: some View {
        GeometryReader{_ in
            ZStack{
                Color.beigeWhite.ignoresSafeArea(.all)
                VStack{
                    CustomNavigationBar(
                        hasTitleText: false,
                        titleText: "",
                        backgroundColor: .beigeWhite,
                        showCustomButton: true,
                        customButtonLabel : {AnyView(Image(systemName: "checkmark")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .foregroundColor(.salmon))},
                        customButtonAction : {self.saveJournal()}
                    )
                    VStack{
                        Image("SmallCloud2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: self.imageWidth, height: self.imageHeight)
                        Text("날짜의 위치")
                            .adjustFont(fontSetting: self.targetDateFontSetting)
                        TextEditor(text:$title)
                            .onChange(of: self.title, perform: {[title] (newValue) in
                                checkTitleCount(oldValue:title, newValue:newValue)
                            })
                            .background(Color.beigeWhite)
                            .adjustFont(fontSetting: self.titleFontSetting)
                            .frame(height:self.titleHeight)
                            .multilineTextAlignment(.center)
                            .padding([.top], self.titlePaddingToTop)
                            .padding([.leading],self.contentPaddingToLeading)
                            .padding([.trailing],self.contentPaddingToTrailing)
                        TextEditor(text:$content)
                            .onChange(of: self.content, perform: {[content] (newValue) in
                            checkContentCount(oldValue:content, newValue:newValue)
                        })
                            .background(Color.beigeWhite)
                            .multilineTextAlignment(.center)
                            .adjustFont(fontSetting: self.contentFontSetting).padding([.leading],self.contentPaddingToLeading)
                            .padding([.trailing],self.contentPaddingToTrailing)
                            .padding([.bottom],self.contentPaddingToBottom)
                            .padding([.top],self.contentPaddingToTop)
                    }
                    
                }
            }
        }.ignoresSafeArea(.keyboard,edges:.all)
    }
}
