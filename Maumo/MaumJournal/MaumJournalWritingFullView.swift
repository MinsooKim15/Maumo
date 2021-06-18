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
    @State var choosingFeeling: Bool = true
    @State var feeling: MaumJournalFeelingEnum?{
        didSet{
            if feeling != nil{
                self.saveAble = true
            }
        }
    }
    @State var showPurchaseView = false
    @State var date : Date = Date()
    @State var saveAble:Bool = false
    @State var showCalendarView:Bool = true
    var editingJournalItemId: String?
    @State var dateNotSet:Bool = false
    public func appearCheck(){
//        Appear했을 때 체크한다.
        self.showPurchaseView = self.modelView.checkNeedPurchase()
    }
    public func chooseDateFromCalendar(_ date:Date)->Void{
        self.showCalendarView = false
        self.date = date
        self.dateNotSet = false
    }
    init(modelView:MaumJournalModelView){
        self.modelView = modelView
        UITextView.appearance().backgroundColor = .clear
        self._title = State(initialValue: self.modelView.editingJournalItemTitle)
        self._content = State(initialValue: self.modelView.editingJournalItemContent)
        self._feeling = State(initialValue: self.modelView.editingJournalItemFeeling ?? nil)
        if let feelingDate = self.modelView.editingJournalItemFeelingDate{
            
            self._date = State(initialValue:feelingDate)
            self._showCalendarView = State(initialValue: false)
            self._dateNotSet = State(initialValue: false)
        }else{
            self._showCalendarView = State(initialValue: true)
            self._dateNotSet = State(initialValue: true)
        }
        
        self.editingJournalItemId = self.modelView.editingJournalItemId
        if let feeling_ = self.feeling{
            self._choosingFeeling = State(initialValue: false)
            self._saveAble = State(initialValue: true)
        }else{
            self._choosingFeeling = State(initialValue: true)
            self._saveAble = State(initialValue: false)
        }
        //MARK : - 같은 방식으로 이미지도 modelView에서 가져올 수 있다. 현재 사용하고 있지는 않음.
    }
    init(modelView:MaumJournalModelView,
         contentLimitTo contentCharacterLimit:Int,
         titleLimitTo titleCharacterLimit : Int){
        self.modelView = modelView
        self.contentCharacterLimit = contentCharacterLimit
        self.titleCharacterLimit = titleCharacterLimit
        self._title = State(initialValue: self.modelView.editingJournalItemTitle)
        self._content = State(initialValue: self.modelView.editingJournalItemContent)
        self._feeling = State(initialValue: self.modelView.editingJournalItemFeeling ?? nil)
        if let feelingDate = self.modelView.editingJournalItemFeelingDate{
            self._date = State(initialValue:feelingDate)
            self.showCalendarView = false
            self._dateNotSet = State(initialValue: false)
        }else{
            self.showCalendarView = true
            self._dateNotSet = State(initialValue: true)
        }
        self.editingJournalItemId = self.modelView.editingJournalItemId
        UITextView.appearance().backgroundColor = .clear
        if let feeling_ = self.feeling{
            self._choosingFeeling = State(initialValue: false)
            self._saveAble = State(initialValue: true)
        }else{
            self._choosingFeeling = State(initialValue: true)
            self._saveAble = State(initialValue: false)
        }
    }
    var dateInString:String{
        let cal = Calendar(identifier: .gregorian)
        let comps = cal.dateComponents([.weekday,.day], from: self.date)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd D"
//        dateFormatter.string(from: self.date)
        return "\(comps.day!)(\(DateUtil.getWeekDayInKorean(of:comps.weekday ?? 1, inFull:false)))"
    }
    var saveButtonColor:Color{
        if self.saveAble{
            return Color.salmon
        }else{
            return Color.whiteGray
        }
    }
//    MARK:- Consoles for UI
    let imageWidth :CGFloat = 88.0
    let imageHeight :CGFloat = 80.0
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
            self.title = oldValue
        }
    }
    func checkContentCount(oldValue:String, newValue:String){
        if newValue.count > contentCharacterLimit && oldValue.count <= contentCharacterLimit {
            self.content = oldValue
        }
    }
    func saveJournal(){
        if self.saveAble{
            if let feelingEnum = self.feeling{
                self.modelView.saveJournal(
                    title: self.title,
                    content: self.content,
                    targetDate: self.date,
                    feeling: feelingEnum,
                    feelingImage: "empty",
                    id: self.editingJournalItemId
                )
            }
        }
        print(self.editingJournalItemId)
        self.presentationMode.wrappedValue.dismiss()
    }
    private func closeCalendar(){
        if !self.dateNotSet{
            self.showCalendarView = false
        }
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
                                                        .foregroundColor(self.saveButtonColor))},
                        customButtonAction : {self.saveJournal()}
                    )
                    VStack{
                        Group{
                            if self.feeling != nil{
                                Image(self.feeling!.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: self.imageWidth, height: self.imageHeight)
                                    .onTapGesture {
                                        self.choosingFeeling = true
                                        hideKeyboard()
                                    }
                            }
                            if self.feeling == nil{
                                Spacer().frame(width: self.imageWidth, height: self.imageHeight)
                            }
                        }
                        if !self.dateNotSet{
                            Text(self.dateInString)
                                .adjustFont(fontSetting: self.targetDateFontSetting)
                                .onTapGesture{
                                    self.showCalendarView = true
                                }
                        }
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
                    Spacer()
                    Group{
                        if self.choosingFeeling == true{
                            MaumChooseView(backgroundColor: .beigeWhite, closure: {maum in
                                self.choosingFeeling = false
                                self.feeling = maum
                            })
                        }
                    }
                    
                }
                if self.showCalendarView{
                    VStack{
                        Spacer()
                        ZStack{
                            Color.white
                            VStack{
                                
                                    HStack{
                                        Spacer()
                                        Image(systemName:"xmark")
                                            .foregroundColor(.salmon)
                                            .onTapGesture {
                                                self.closeCalendar()
                                        }
                                        Spacer().frame(width:40)
                                    }
                                    .frame(height:40)
                                Divider().foregroundColor(.salmon)
                                    CalendarMainView(
                                        calendar: Calendar(identifier: .gregorian),
                                        modelView: self.modelView,
                                        clickClosure: self.chooseDateFromCalendar
                                    ).frame(height:300)
                            }
                        }.frame(height:340)
                    }
                    
                }
            }
            
            if self.showPurchaseView{
                Color.black.opacity(0.6).ignoresSafeArea(.all)
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        PurchaseMaumJournalView(closeClosure: {self.showPurchaseView = false})
                        Spacer()
                    }
                    Spacer()
                }

            }
        }.onAppear{
            self.appearCheck()
        }
        .onTapGesture {
            if self.feeling != nil{
                self.choosingFeeling = false
            }
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard,edges:.all)
    }
}
