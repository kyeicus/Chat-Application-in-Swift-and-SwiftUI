//
//  Login.swift
//  Login
//
//  Created by Mister Okine on 29/07/2021.
//

import SwiftUI
import Firebase
import Lottie

struct Login: View {

    @State var loading = false
    @AppStorage("log_Status") var status = false
    @State var CODE = ""
    @State var error = false
    @State var phoneNumber = ""
    @State var errorMessage = ""
    @State var gotoVerify = false
    
    @State var isSmall = UIScreen.main.bounds.height < 750
    
        var body: some View {
            
            ZStack{
                LinearGradient(gradient: Gradient(colors: [.red, .red, ]), startPoint: .topTrailing, endPoint: .bottomTrailing).opacity(0.9)


                VStack{
                    
                    VStack{
                        
                        Text("Continue With Phone")
                            .font(.title2)
                            .fontWeight(.ultraLight)
                            .foregroundColor(.black)
                            .padding(.top,70)
                        
                        
                        LottieView(name: "otp", loopMode: .loop)
                            .frame(width: UIScreen.main.bounds.width-100, height: 200, alignment: .center)
                            .padding(.top,50)
                
                        // Mobile Number Field....
                        
                        HStack{
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("Enter Your Number")
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    .fontWeight(.light)
                                
                                
                                Text("+ \(self.getCountryCode()) \(self.phoneNumber)")
                                    .font(.title2)
                                    .fontWeight(.light)
                                    .foregroundColor(.black)
                                
                            }
                            
                            
                            Spacer(minLength: 0)
                            
                            NavigationLink(destination: Verification(CODE: $CODE,phoneNumber: $phoneNumber,gotoVerify: $gotoVerify) ,isActive: self.$gotoVerify) {
                                
                                Text("")
                                    .hidden()
                            }
                            if self.loading{
                                
                                HStack{
                                    
                                    Spacer()
//                                    LottieView(name: "concentric-snakes-loader", loopMode: .loop)
                                    Loading().onTapGesture {
                                        self.loading.toggle()
                                    }
                                    
                                    Spacer()
                                }
                            }
                            else{

                                Button( action: {
                                    self.sendCode()
                                    self.loading.toggle()
                                })
                                {
                                    Text("Continue")
                                        .foregroundColor(.white)
                                        .padding(.vertical,18)
                                        .padding(.horizontal,38)
                                        .background(Color.red).opacity(0.9)
                                        .cornerRadius(15)
                                        
                                }
                                .disabled(self.phoneNumber == "" || self.phoneNumber.count < 9 || self.phoneNumber.count > 12 ? true: false)
                            }
                            

                        }
                        .padding()
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                    }
                    .frame(height: UIScreen.main.bounds.height / 1.8)
                    .cornerRadius(20)
                    
                    .background(.thinMaterial)


                    // Custom Number Pad....
                    
                    CustomNumberPad(value: self.$phoneNumber, isVerify: false)
                        .background(.thinMaterial)

                }
                
                if self.error{
                    
                    AlertView(msg: self.errorMessage, show: self.$error)
                    
                }
              
            }
            .edgesIgnoringSafeArea(.all)
        }
    func getCountryCode()->String{
        
        let regionCode = Locale.current.regionCode ?? ""
        
        return countries[regionCode] ?? ""
    }
    func sendCode(){
        
        // enabling testing code...
        // disable when you need to test with real device...
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        
        let number = "+\(getCountryCode()) \(phoneNumber)"
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { (CODE, err) in
            
            if let error = err{
                
                self.errorMessage = error.localizedDescription
                withAnimation{ self.error.toggle()}
                return
            }
            print("Code sent to  \(number)")
            self.gotoVerify = true
            self.CODE = CODE ?? ""
        }
    }
        
    }

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
