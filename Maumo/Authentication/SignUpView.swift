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
    func SignUp(){
        session.signUp(email: emailAddress, password: password,firstName:firstName, lastName: lastName){(result,error) in
            print(result)
            print(error)
        }
    }
    var body:some View{
        VStack{
//            TextField("이메일 주소", text:$emailAddress)
//        아래 Group 안은 입력 필드만
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
                LoginTextField(
                    placeHolder: "메일 주소",
                    text: $emailAddress)
                LoginSecureField(
                    placeHolder : "비밀 번호",
                    text: $password
                )
            }
            SignUpInfoView()

        }
    }
}
struct SignUpInfoView: View{
    let termsOfServiceLink  = "http://www.google.com"
    let privacyPolicyLink = "http://www.naver.com"
    let linkedTextSetting = FontSetting(fontWeight: .bold, fontSize: .verySmall12)
    let plainTextSetting = FontSetting(fontWeight: .regular, fontSize: .verySmall12)
    var body : some View{
        VStack{
            HStack{
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
            HStack{
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
        }
    }
}
struct LoginTextField: View{
    var placeHolder : String
    @Binding var text: String
    let textFieldFontSetting = FontSetting(
        fontWeight: .regular,
        fontSize: .medium20)
    var body: some View{
        VStack(alignment: .leading){
            Group{
                TextField(placeHolder, text:$text)
            }
            .padding([.leading], 16)
            .adjustFont(fontSetting: textFieldFontSetting)
            HorizontalLine(color: .beige)
        }
    }
}

struct LoginSecureField: View{
    var placeHolder : String
    @Binding var text: String
    let textFieldFontSetting = FontSetting(
        fontWeight: .regular,
        fontSize: .medium20)
    var body: some View{
        VStack(alignment: .leading){
            Group{
                SecureField(placeHolder, text:$text)
            }
            .padding([.leading], 16)
            .adjustFont(fontSetting: textFieldFontSetting)
            HorizontalLine(color: .beige)
        }
    }
}
