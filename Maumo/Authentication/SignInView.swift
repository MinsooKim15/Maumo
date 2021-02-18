//
//  SignInView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/02/18.
//

import SwiftUI
struct SignInView:View{
    @EnvironmentObject var session: SessionStore
    @State var emailAddress:String = ""
    @State var password:String = ""
    @State var willMoveToSignUpView: Bool = false
    let titleTextSetting = FontSetting(fontWeight: .regular, fontSize: .large40)
    let signUpMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    let signUpErrorMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    func signIn(){
        self.session.signIn(email: self.emailAddress, password: self.password){result, error in
            print(result)
            print(error)
        }
    }
    var body:some View{
        ZStack{
            Color.beigeWhite.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading,spacing:0){
                
                ZStack(alignment:.leading){
                    SmallCloud().padding([.leading], 0)
                    Text("로그인")
                        .padding([.leading], 30)
                        .adjustFont(fontSetting: self.titleTextSetting)
                }
                .frame(width:140, height:70)
                .padding([.top], 10)
                .padding([.bottom], 40)
                .padding([.leading], 46)
                
                Group{
                    Group{
                        LoginTextField(
                            placeHolder: "메일 주소",
                            text: $emailAddress)
                            .padding([.bottom], 16)
                         LoginSecureField(
                            placeHolder : "비밀 번호",
                            text: $password
                        )
                        Text(self.session.signUpErrorMessage)
                            .padding([.leading], 8)
                            .adjustFont(fontSetting: self.signUpErrorMessageSetting)
                            .foregroundColor(.salmon)
                        
                    }
                    .padding([.bottom], 20)
                    Text("회원가입")
                        .padding([.leading], 16)
                        .adjustFont(fontSetting: self.signUpMessageSetting)
                        .onTapGesture {
                            self.willMoveToSignUpView = true
                        }
                }
                .padding([.leading], 65)
                .padding([.trailing], 58)
                
                Spacer()
                HStack{
                    Spacer()
                    ZStack{
                        SmallCloud2()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .frame(width:82, height:88)
                    .onTapGesture {
                        self.signIn()
                    }
                    Spacer()
                }
                .padding([.bottom], 74)
            }
        }.navigate(to: SignUpView(), when: $willMoveToSignUpView)
    }
}
