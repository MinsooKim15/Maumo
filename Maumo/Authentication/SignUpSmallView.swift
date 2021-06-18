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
    @State var errorMessage = ""
    var signUpSuccessClousure : () -> Void
//    var signUpFailureClousure : () -> Void
    let titleTextSetting = FontSetting(fontWeight: .bold,
                                       fontSize: .medium20)
    let signUpMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    let signUpErrorMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    func signUp(){
        print("signUp Tapped")
        session.signUp(email: emailAddress, password: password,firstName:firstName, lastName: lastName){(result,error) in
            if error == nil{
                self.signUpSuccessClousure()
            }
            if let authError = error{
                self.errorMessage = self.session.getErrorMessage(authError: authError)
            }
        }
    }
    func moveToSignIn(){
        self.willMoveToSignInView = true
    }
    var body:some View{
        GeometryReader{_ in
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
                            Text(self.errorMessage)
                                .padding([.leading], 16)
                                .adjustFont(fontSetting: self.signUpErrorMessageSetting)
                                .foregroundColor(.salmon)
                        }
                        .padding([.bottom], 10)
                        SignUpInfoView().padding([.leading],  8)
                        .padding([.bottom], 10)
//                        Text("기존 회원 로그인하기")
//                            .padding([.leading],  16)
//                            .adjustFont(fontSetting: self.signUpMessageSetting)
//                            .onTapGesture {
//                                self.moveToSignIn()
//                            }
                    }
                    .padding([.leading], 65)
                    .padding([.trailing], 58)
                    
    //               MARK:- 14.5.1에서 Navigation 튕기는 현상 해결을 위한 처리
                    
                    HStack{
                        Spacer()
                        ZStack{
                            Image("SmallCloud2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        .frame(width:77, height:83)
                        .padding(.top, 20)
                        .onTapGesture {
                            self.signUp()
                        }
                        Spacer()
                    }
                    .padding(.top,20)
                    Spacer()
                    NavigationLink(destination: EmptyView(), label: {})
                }
            }
            .navigate(to: SignInView(), when: $willMoveToSignInView)
        }
        .ignoresSafeArea(.keyboard,edges:.all)
    }
}
