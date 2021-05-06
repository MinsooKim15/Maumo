//
//  SignUpSmallView.swift
//  Maumo
//
//  Created by minsoo kim on 2021/04/28.
//

import SwiftUI

struct SignUpSmallView: View {
    @EnvironmentObject var session: SessionStore
    @State var emailAddress:String = ""
    @State var firstName:String = ""
    @State var lastName:String = ""
    @State var password:String = ""
    @State var willMoveToSignInView: Bool = false
    var signUpSuccessClousure : () -> Void
//    var signUpFailureClousure : () -> Void
    let titleTextSetting = FontSetting(fontWeight: .bold,
                                       fontSize: .medium20)
    let signUpMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    let signUpErrorMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    func signUp(){
        session.signUp(email: emailAddress, password: password,firstName:firstName, lastName: lastName){(result,error) in
            if error == nil{
                self.signUpSuccessClousure()
            }
        }
    }
    func moveToSignIn(){
        self.willMoveToSignInView = true
        self.session.cleanErrorMessage()
    }
    var body:some View{
        ZStack{
            Color.beigeWhite.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading,spacing:0){
                
                ZStack(alignment:.leading){
                    SmallCloud().padding([.leading], 0)
                    HStack{
                        Text("회원 가입")
                            .padding([.leading], 30)
                            .adjustFont(fontSetting: self.titleTextSetting)
                        Spacer()

                    }
                }
                .frame(width:140, height:70)
                .padding([.top], 20)
                .padding([.bottom], 40)
                .padding([.leading], 46)
                Group{
                    Group{
                        HStack{
                            LoginTextField(
                                placeHolder: "성",
                                text: $lastName)
                                .frame(width: 100)
                            LoginTextField(
                                placeHolder: "이름",
                                text: $firstName)
                            
                        }
                        .padding([.bottom], 16)
                        LoginTextField(
                            placeHolder: "메일 주소",
                            text: $emailAddress)
                            .padding([.bottom], 16)
                         LoginSecureField(
                            placeHolder : "비밀 번호",
                            text: $password
                        )
                        Text(self.session.signUpErrorMessage)
                            .padding([.leading], 16)
                            .adjustFont(fontSetting: self.signUpErrorMessageSetting)
                            .foregroundColor(.salmon)
                    }
                    .padding([.bottom], 20)
                    
                    SignUpInfoView().padding([.leading],  8)
                    .padding([.bottom], 34)
                    Text("기존 회원 로그인하기")
                        .padding([.leading],  16)
                        .adjustFont(fontSetting: self.signUpMessageSetting)
                        .onTapGesture {
                            self.moveToSignIn()
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
                        self.signUp()
                    }
                    Spacer()
                }
                .padding([.bottom], 74)
            }
        }.navigate(to: SignInView(), when: $willMoveToSignInView)
    }
}
struct CloseButton:View{
    var body: some View{
        Group{
            ZStack{
                Circle()
                    .frame(width:48, height:48)
                    .foregroundColor(.white)
                Image(systemName: "xmark")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            .frame(width:80, height:80)
            .shadow(radius: 5)
        }
    }
}

