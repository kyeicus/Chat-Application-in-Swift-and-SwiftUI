//
//  AccountCreation.swift
//  AccountCreation
//
//  Created by Mister Okine on 30/07/2021.
//

import SwiftUI
import Firebase

struct AccountCreation : View {
    @Binding var show : Bool
    @State var name = ""
    @State var about = ""
    @State var picker = false
    @State var loading = false
    @State var imagedata : Data = .init(count: 0)
    @State var alert = false
    @AppStorage("log_Status") var status = false


    
    var body : some View{
        NavigationView{
            ZStack{
                    LinearGradient(gradient: Gradient(colors: [.red, .red,]), startPoint: .topTrailing, endPoint: .bottomTrailing).opacity(0.4)
                    .navigationTitle("Profile")
                    
                    VStack(alignment: .leading, spacing: 15){
                        HStack{
                                            
                            Button(action: {
                                
                                self.picker.toggle()
                                
                            }) {
                                
                                if self.imagedata.count == 0{
                                    
                                    LottieView(name: "avatar", loopMode: .loop)
                                        .frame(width: 150, height: 150, alignment: .center)
                                    
                                    Text("Click to add a Profile Picture")
                                        .font(.caption2)
                                        .foregroundColor(.black).opacity(0.6)
                                    Image(systemName: "camera.circle")
                                        .foregroundColor(.teal)
                                }
                                else{
                                    
                                    Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 150, height: 150, alignment: .center).clipShape(Circle()).padding()
                                        
                                    
                                }
                                
                                
                            }
                        }
                        
                        
                        Text("Enter Username")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.leading)

                        TextField("Username", text: self.$name)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width:UIScreen.main.bounds.width - 35,height: 45, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                            .padding(.leading,20)

                            

                        Text("About Yourself")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.leading)


                        TextField("About...", text: self.$about)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .frame(width:UIScreen.main.bounds.width - 35 ,height: 50, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
                            .padding(.leading)


                        if self.loading{
                            HStack{
                                Spacer()
                                Loading()
                                Spacer()
                            }
                        }
                        else{
                            
                            Button(action: {
                                
                                if self.name != "" && self.about != "" && self.imagedata.count != 0{
                                    
                                    self.loading.toggle()
                                    CreateUser(name: self.name, about: self.about, imagedata: self.imagedata) { (status) in
                                        
                                        if status{

                                            self.show.toggle()

                                        }
                                        print("success @updating Profile")
                                        withAnimation{self.status = true}

                                    }
                                }
                                else{

                                    self.alert.toggle()
                                }
                            }) {
                                

                            Text("Update Profile").frame(width: UIScreen.main.bounds.width - 50,height: 50)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 100, alignment: .center)
                            .foregroundColor(.white)
                            .background(Color.red).opacity(0.9)
                            .cornerRadius(10)
                            .padding(.bottom,15)
                            .shadow(radius: 1.0)
                            .padding(.leading, 41)
                        }
                        
                    }
                    .background(.thinMaterial)
                    .sheet(isPresented: self.$picker, content: {
                        
                        ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
                    })
                    .alert(isPresented: self.$alert) {
                        Alert(title: Text("Message"), message: Text("Please Fill All Fields"), dismissButton: .default(Text("Okay")))
                    }
                
                
            
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}





