////
////  SIgnInVIew.swift
////  Maumo
////
////  Created by minsoo kim on 2021/02/01.
////
//
import SwiftUI
//import GoogleSignIn
//import Firebase

struct SignUpView:View{
    @EnvironmentObject var session: SessionStore
    @State var emailAddress:String = ""
    @State var firstName:String = ""
    @State var lastName:String = ""
    @State var password:String = ""
    @State var willMoveToSignInView: Bool = false
    let titleTextSetting = FontSetting(fontWeight: .regular, fontSize: .large40)
    let signUpMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    let signUpErrorMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    func signUp(){
        session.signUp(email: emailAddress, password: password,firstName:firstName, lastName: lastName){(result,error) in
            print(result)
            print(error)
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
                    Text("계정")
                        .padding([.leading], 30)
                        .adjustFont(fontSetting: self.titleTextSetting)
                }
                .frame(width:140, height:70)
                .padding([.top], 10)
                .padding([.bottom], 40)
                .padding([.leading], 46)
                
                Group{
                    Group{
                        HStack{
                            LoginTextField(
                                placeHolder: "성",
                                text: $firstName)
                                .frame(width: 100)
                            LoginTextField(
                                placeHolder: "이름",
                                text: $lastName)
                            
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
struct SignUpInfoView: View{
    let termsOfServiceLink  = "http://www.google.com"
    let privacyPolicyLink = "http://www.naver.com"
    let linkedTextSetting = FontSetting(fontWeight: .bold, fontSize: .verySmall12)
    let plainTextSetting = FontSetting(fontWeight: .regular, fontSize: .verySmall12)
    var body : some View{
        VStack(alignment: .leading, spacing: 0){
            HStack(spacing:0){
                Text("회원가입시 Maumo의 ")
                    .adjustFont(fontSetting: self.plainTextSetting)
                Text("이용약관 및")
                    .adjustFont(fontSetting: self.linkedTextSetting)
                    .onTapGesture{
                    if let encoded  = self.termsOfServiceLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let myURL = URL(string: encoded){
                          UIApplication.shared.open(myURL)
                    }
                }
                
            }
            HStack(spacing:0){
                Text("개인정보 처리방침")
                    .onTapGesture{
                        if let encoded  = self.termsOfServiceLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let myURL = URL(string: encoded){
                            UIApplication.shared.open(myURL)
                        }
                    }
                    .adjustFont(fontSetting: self.linkedTextSetting)
                    
                Text("에 동의하는 것으로 간주됩니다.")
                    .adjustFont(fontSetting: self.plainTextSetting)
            }
        }.frame(width: 260, height : 40)
    }
}


struct LoginSecureField: View{
    var placeHolder : String
    @Binding var text: String
    let textFieldFontSetting = FontSetting(
        fontWeight: .regular,
        fontSize: .medium20)
    var body: some View{
        VStack(alignment: .leading, spacing:0){
            Group{
                SecureField(placeHolder, text:$text)
            }
            .padding([.leading], 16)
            .padding([.bottom],9)
            .adjustFont(fontSetting: textFieldFontSetting)
            HorizontalLine(color: .beige)
        }.frame(height:30)
    }
}
