//
//  PurchaseListView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/06/19.
//

import SwiftUI
import StoreKit

struct PurchaseListView: View {
    @ObservedObject var storeManager:StoreManager
    init() {
        self.storeManager = StoreManager()
       UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .none
       UITableView.appearance().backgroundColor = .none
        SKPaymentQueue.default().add(self.storeManager)
    }
    var restoreButtonView:AnyView{
        return AnyView(Image(systemName:"square.and.arrow.down").resizable()
            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20).foregroundColor(.salmon))
            
    }
    let purchaseTitleFont : FontSetting = FontSetting(fontWeight: .regular, fontSize: .small16)
    let purchaseSubTitleFont : FontSetting = FontSetting(fontWeight: .regular, fontSize: .small16)
    func restoreButtonTapped(){
        print(self.storeManager.myProducts[0].localizedDescription)
        self.storeManager.restoreProducts()
    }
    var body: some View {
        ZStack{
            Color.beigeWhite.ignoresSafeArea(.all)
            VStack{
                CustomNavigationBar(hasTitleText: true, titleText: "구매",backgroundColor:Color.beigeWhite,showCustomButton : true, customButtonLabel: {restoreButtonView}, customButtonAction: {self.restoreButtonTapped()})
                ForEach(storeManager.myProducts, id: \.self) { product in
                    HStack {
                        Spacer().frame(width:20)
                        VStack(alignment: .leading) {
                            Text("마음일기")
                                .adjustFont(fontSetting: purchaseTitleFont).foregroundColor(.purplishGrey)
                        }
                        Spacer()
                        if UserDefaults.standard.bool(forKey: product.productIdentifier) {
                            Text("구매 완료")
                                .foregroundColor(.cloudyBlue)
                        } else {
                            Button(action: {
                                storeManager.purchaseProduct(product: product)
                            }) {
                                Text("구매 \(product.price) 원")
                            }
                            .foregroundColor(.salmon)
                        }
                        Spacer().frame(width:20)
                    }
                    Divider()
                }
                Spacer()
            }
        }.dragToDismiss()
        
        
    }
}

struct PurchaseListView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseListView()
    }
}
