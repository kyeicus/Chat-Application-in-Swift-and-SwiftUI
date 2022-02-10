//
//  Verification.swift
//  Verification
//
//  Created by Mister Okine on 29/07/2021.
//

import Firebase
import SwiftUI
import SDWebImage
import LocalAuthentication


struct Verification: View {
    
    @State var loading = false
    @State var msg = ""
    @State var alert = false
    @State var creation = false
    @State var code = ""
    // storing CODE for verification...
    @Binding var CODE : String
    @State var error = false
    @Binding var phoneNumber : String
    @State var errorMessage = ""
    @Binding var gotoVerify : Bool
    @AppStorage("log_Status") var status = false

    
    @Environment(\.presentationMode) var present

    var body: some View {
            ZStack(){
                GeometryReader{_ in
                LinearGradient(gradient: Gradient(colors: [.red, .red, ]), startPoint: .topTrailing, endPoint: .bottomTrailing).opacity(0.9)
                    ZStack(alignment: .topLeading){
                    
                    VStack{
                    
                        VStack{
                            
                            HStack{
                                // This code generally dismisses the view and takes user back to the previous view.. I commented that because i wouldn't need that
        //                        Button(action: {present.wrappedValue.dismiss()}) {
        //
        //                            Image(systemName: "arrow.left")
        //                                .font(.title2)
        //                                .foregroundColor(.black)
        //                        }
                                
                                Spacer()
                                
                                Text("Verify Phone Number")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
        //                       if loginData.loading{ProgressView()}
                            }
                            .padding()
                            
                            Text("Code sent to +\(getCountryCode()) \(phoneNumber)")
                                .foregroundColor(.gray)
                                .padding(.bottom)
                            
                            Spacer(minLength: 0)
                            
                            LottieView(name: "verification", loopMode: .loop)
                                .frame(width: UIScreen.main.bounds.width-100 , height: 170, alignment: .center)
                            
                            HStack(spacing: 15){
                                
                                ForEach(0..<6,id: \.self){index in
                                    
                                    // displaying code....
                                    
                                    CodeView(code: getCodeAtIndex(index: index))
                                }
                            }
                            .padding()
                            .padding(.horizontal,20)
                            
                            Spacer(minLength: 0)
                            
                            HStack(spacing: 6){
                                
                                Text("Didn't receive code?")
                                    .foregroundColor(.teal)
                                    
                                
                                Button(action: self.requestCode) {
                                    
                                    Text("Request Again")
                                        .fontWeight(.regular)
                                        .foregroundColor(.red)
                                        .italic()
                                }
                            }
                          
                            if self.loading{
                                Spacer()
                                LottieView(name: "concentric-snakes-loader", loopMode: .loop)
                                    .frame(width: 150, height: 100)
                                Spacer()
                                
                            }
                            
                            else {
                                Button(action: {
                                    self.loading.toggle()
                                    
                                    let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: code)
                                    
                                    
                                    self.loading = true
                                   
                                    Auth.auth().signIn(with: credential) {(result, err) in

                                   
                                        self.loading = false
                                        
                                        if let error = err{
                                            self.errorMessage = error.localizedDescription
                                            self.error.toggle()
                                            return
                                                
                                        }
                                        checkUser { (exists, user,uid,pic,about) in
                                            
                                            if exists{
                                                
                                                UserDefaults.standard.set(true, forKey: "status")
                                                
                                                UserDefaults.standard.set(user, forKey: "Username")
                                               
                                                UserDefaults.standard.set(about, forKey: "About")
                                                
                                                UserDefaults.standard.set(pic, forKey: "Profilepic")

                                                UserDefaults.standard.set(uid, forKey: "uid")
                                               
                                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                                
                                                withAnimation{self.status = true}

                                            }
                                            
                                            else{
                                                
                                                self.loading.toggle()
                                                self.creation.toggle()
                                            }
                                        }
                        //                 else user logged in Successfully ....
                                    }
                                })
                                {
                                    Text("Verify and Continue")
                                        .foregroundColor(.white)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 30)
                                        .background(Color.red)
                                        .cornerRadius(15)
                                }
                                
                                .padding()
                            }
                        }
                        .background(.thinMaterial)
                        .frame(height: UIScreen.main.bounds.height / 1.8)

                        CustomNumberPad(value: self.$code, isVerify: true)
                            .background(.thinMaterial)
                        
                    }
                    .background(.thinMaterial)
                    .ignoresSafeArea(.all, edges: .bottom)
                
                if self.error{
                    
                    AlertView(msg: self.errorMessage, show: self.$error)
                    
                }
                    
                }
                    .padding(.top,40)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        .sheet(isPresented: self.$creation) {
            
            AccountCreation(show: self.$creation)
        }

    }
    
    // getting Code At Each Index....
    
    func getCodeAtIndex(index: Int)->String{
        
        if self.code.count > index{
            
            let start = self.code.startIndex
            
            let current = self.code.index(start, offsetBy: index)
            
            return String(self.code[current])
        }
        
        return ""
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
            
            self.CODE = CODE ?? ""
        }
    }
    func requestCode(){
        
        sendCode()
        withAnimation{
            
            self.errorMessage = "Code Has Been Sent !"
            self.error.toggle()
        }
    }
    
    
    

}


//Structure that displays the code user is entering into the Verification section
struct CodeView: View {
    
    var code: String
    
    var body: some View{
        
        VStack(spacing: 10){
            
            Text(code)
                .foregroundColor(.black)
                .fontWeight(.light)
                .font(.title2)
            // default frame...
                .frame(height: 45)
            
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(height: 4)
        }
    }
}


