//
//  PurcahseMaumJournalView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/16.
//

import Foundation
import SwiftUI
import StoreKit
struct PurchaseMaumJournalView:View{
    init(closeClosure:@escaping ()->Void){
        self.closeClosure = closeClosure
        self.storeManager = StoreManager()
        SKPaymentQueue.default().add(self.storeManager)
    }
    @ObservedObject var storeManager : StoreManager
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var allDone:Bool = false
    let notBuyTitle:String = "마음일기 열기"
    let notBuyDescription1:String = "결제 후에는 마음일기를 무제한으로 \n 사용할 수 있어요. \n지금 결제하고, 매일매일의 소중한 마음을 남겨보세요."
    let notBuyDescription2:String = "마음일기는 5일만 무료로 사용해볼 수 있어요. "
    let buyDescription:String = "이제 MAUMO와 함께 \n매일의 마음을 기록해 보세요."
    let descriptionFontSetting : FontSetting = FontSetting(fontWeight: .regular, fontSize: .small14)
    let titleFontSetting:FontSetting = FontSetting(fontWeight: .bold, fontSize: .medium22)
    var purchased:Bool{
        return UserDefaults.standard.bool(forKey:"JournalService.MaumDiary")
    }
    var buttonTitle:String{
        return self.purchased ? "완료":"마음일기 무제한 ₩1,500"
    }
    var foregroundColor:Color{
        return Color.white
    }
    var backgroundColor:Color{
        return self.purchased ? Color.gray:Color.salmon
    }
    //    화면 위에 겹쳐 띄워야 해서, Dismiss를 사용하지 않고 외부에서 값을 바꾼다.
    var closeClosure:()->Void
    func purchaseButtonAction()->Void{
        // 원래는 App시작시에 띄워야 한다. 이후에 Transaction Problem이 생기면 얘를 옮겨보자
        
        if !self.purchased, self.storeManager.myProducts.count > 0{
            let product = self.storeManager.myProducts[0]
            self.storeManager.purchaseProduct(product: product,with:self.completePurchase)
        }
    }
    func completePurchase()->Void{
        print("Complete Purchase!!")
        self.allDone = true
        let seconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.closeClosure()
        }
    }
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
                .shadow(radius: 10)
            VStack{
                Spacer()
                    .frame(height:20)
                HStack{
                    Spacer()
                    CloseButton(closeClosure: {return})
                    Spacer().frame(width:20)
                }
                PurchaseMaumJournalBackgroundView(storeManager: self.storeManager, purchaseDone:$allDone)
                Spacer()
            }
            VStack{
                Spacer().frame(height:320)
                if purchased{
                    Text("구매 완료")
                        .multilineTextAlignment(.center)
                            .adjustFont(fontSetting: self.titleFontSetting)
                }
                if !purchased{
                    Text(notBuyTitle)
                        .multilineTextAlignment(.center)
                            .adjustFont(fontSetting: self.titleFontSetting)
                }
                if purchased{
                    Spacer().frame(height:40)
                    Text(buyDescription).multilineTextAlignment(.center)
                        .adjustFont(fontSetting: self.descriptionFontSetting)
                }
                if !purchased{
                    Spacer().frame(height:40)
                    Text(notBuyDescription1).multilineTextAlignment(.center)
                        .adjustFont(fontSetting: self.descriptionFontSetting)
                    Spacer().frame(height:20)
                    Text(notBuyDescription2).multilineTextAlignment(.center)
                        .adjustFont(fontSetting: self.descriptionFontSetting)
                        .foregroundColor(.gray)
                }

                Spacer()
                HStack{
                    Spacer()
                    PurchaseActionButton(title:self.buttonTitle, backgroundColor: self.backgroundColor , foregroundColor:self.foregroundColor, completion: {
                        purchaseButtonAction()
                    })
                    Spacer()
                }
                Spacer().frame(height:10)
            }
        }
        .onAppear{
            print("APPEAR!")
            
//            self.storeManager.getProducts(productIDs: ["JournalService.MaumDiary"])
        }
        .onTapGesture{
            self.storeManager.restoreProducts()
            print(UserDefaults.standard.bool(forKey:self.storeManager.myProducts[0].productIdentifier))
            print(self.storeManager.myProducts[0].productIdentifier)
        }
        .frame(width:260, height:640)
    }
}

struct PurchaseMaumJournalBackgroundView:View{
    @ObservedObject var storeManager : StoreManager
    @Binding var purchaseDone:Bool
    var purchased:Bool{
        return self.storeManager.transactionState == .purchased
    }
    var maumCircleHeight:CGFloat{
        self.purchaseDone ? 210:0
    }
    var maumJournalImageHeight :CGFloat{
//        self.purchased ? 100:89
        return 89
    }
    var maumJournalImageWidth :CGFloat{
//        self.purchased ? 100:89
        return 89
    }
    var body: some View{
        ZStack{
            Color.white
            VStack{
                Spacer()
                    .frame(height:60)
                ZStack{
                    Circle().foregroundColor(.whiteGreen.opacity(0.6))
                        .frame(width:self.maumCircleHeight, height:self.maumCircleHeight)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 100.0))
                    Circle().foregroundColor(.whiteGreen)
                        .frame(width:self.maumCircleHeight*0.6,height:self.maumCircleHeight*0.6)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 100.0))
                    Image("MaumJournalIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: self.maumJournalImageWidth, height: self.maumJournalImageHeight)
                        .scaleEffect(self.purchaseDone ? 1.2 : 1.0)
    //                    .animation(.interpolatingSpring(stiffness: 350, damping: 1))
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 100.0))
                }
                Spacer().frame(height:100)
            }
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Image("MiniPebbleA").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 31)
                        Spacer().frame(height:20)
                    }
                    Spacer().frame(width:100)
                    VStack{
                        Spacer()
                        Image("MiniPebbleB").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 58, height: 54)
                    }
                    Spacer()
                }
                Spacer().frame(height:2)
                Spacer().frame(width:80, height:80)
                
                Spacer().frame(height:4)
                HStack{
                    Spacer()
                    VStack{
                        Image("MiniPebbleC").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 42)
                        Spacer()
                    }
                    Spacer().frame(width:140)
                    VStack{
                        Image("MiniPebbleD").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 54, height: 95)
                    }
                    Spacer()
                }
            }
        }
        .frame(height:220)
    }
}

struct PurcahseMaumJournalView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.red
//            PurcahseMaumJournalView()
        }

    }
}
struct PurchaseActionButton:View{
    var title : String
    var backgroundColor :Color
    var foregroundColor: Color
    var completion : () -> Void
    let buttonWidth : CGFloat =  330
    let buttonHeight :CGFloat = 48
    let buttonRadius :CGFloat = 10.0

    var body : some View{
        Button(action:completion){
            ZStack{
                RoundedRectangle(cornerRadius: buttonRadius).foregroundColor(self.backgroundColor)
                Text(title).foregroundColor(self.foregroundColor)
            }
        }
        .shadow(radius: 10)
        .frame(width : buttonWidth, height : buttonHeight)
    }
}
