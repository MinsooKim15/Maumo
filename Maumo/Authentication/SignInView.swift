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
    @State var errorMessage = ""
    let titleTextSetting = FontSetting(fontWeight: .regular, fontSize: .large40)
    let signUpMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    let signUpErrorMessageSetting = FontSetting(fontWeight: .bold, fontSize : .small14)
    
    func signIn(){
        print("SignIn")
        self.session.signIn(email: self.emailAddress, password: self.password){result, error in
            if let authError = error{
                self.errorMessage = self.session.getErrorMessage(authError: authError)
            }
        }
    }
    func moveToSignUp(){
        self.willMoveToSignUpView = true
    }
    var body:some View{
        GeometryReader{_ in
            ZStack{
                Color.beigeWhite.edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer().frame(maxHeight:0.0)
                    CustomNavigationBar(hasTitleText: false, titleText: "",backgroundColor: Color.beigeWhite)
                    Spacer()
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
                                    Text(self.errorMessage)
                                        .padding([.leading], 8)
                                        .adjustFont(fontSetting: self.signUpErrorMessageSetting)
                                        .foregroundColor(.salmon)
                                    
                                }
                                .padding([.bottom], 20)
    //                            MARK: - 14.5.1에서 튕기는 현상 해결이 되지 않아 주석 처리함.
                                Text("회원가입")
                                    .padding([.leading], 16)
                                    .adjustFont(fontSetting: self.signUpMessageSetting)
                                    .onTapGesture {
                                        self.moveToSignUp()
                                    }
                                NavigationLink(destination: EmptyView(), label: {})
                                NavigationLink(destination: EmptyView(), label: {})
                            }
                            .padding([.leading], 65)
                            .padding([.trailing], 58)
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
                                    self.signIn()
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        NavigationLink(destination: SignUpView().navigationBarTitle("")
                                        .navigationBarHidden(true),
                                       isActive: $willMoveToSignUpView,
                                       label: {})
                        NavigationLink(destination: EmptyView(), label: {})
                        Spacer()
                    }
    //                .navigate(to: SignUpView(), when: $willMoveToSignUpView)
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .ignoresSafeArea(.keyboard,edges:.all)
    }
}
