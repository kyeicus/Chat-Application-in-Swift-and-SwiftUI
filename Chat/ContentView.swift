//
//  ContentView.swift
//  Chat
//
//  Created by Mister Okine on 27/07/2021.
//

import SwiftUI
import Combine
import Firebase

struct ContentView: View {

@AppStorage("log_Status") var status = false

    var body: some View {
        if status{
            
            Home()
                .environmentObject(MainObservable())

        }
        else{
            NavigationView{
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.red, .red, ]), startPoint: .topTrailing, endPoint: .bottomTrailing).opacity(0.9)
                        
                    
                    VStack(spacing: 100){
                        LottieView(name: "welcome", loopMode: .loop)
                            .frame(width: UIScreen.main.bounds.width - 50, height: 250)
                            .opacity(0.7)
                            .clipShape(Capsule())
                            
                            NavigationLink(
                                destination: Login(),
                                label: {
                                    HStack{
                                        Text("Login")
                                            .fontWeight(.bold)
                                            .padding(.trailing, 25)
                                            .font(.system(size: 24))
                                    }
                                    .foregroundColor(Color.red)
                                    .frame(width: 250, height: 50, alignment: .center)
                                    .background(Color.white).opacity(0.87)
                                    .clipShape(Capsule())


                                    
                                    
                                })
                                .padding()
                            
                        
                        
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    NavigationLink(destination: About(), label: {
                        Image(systemName: "info.circle")
                            
                    })
                        .frame(width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-30, alignment: .bottomLeading)
                        .foregroundColor(.white).opacity(0.7)
                    .font(.system(size: 20))
                    .shadow(color: .gray, radius: 5.0, x: 1.0, y: 5)
                    .padding(.bottom,30)

                
                    
                }.edgesIgnoringSafeArea(.all)

            }

        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Loading: View {
    @State var animate = false
    var body: some View {
            ZStack{
                    Circle()
                        .trim(from: 0, to: 0.8)
                        .stroke(AngularGradient(gradient: .init(colors: [.blue,.yellow]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 35, height: 35)
                        .rotationEffect(.init(degrees: animate ? 360 : 0))
                        .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false) , value: self.animate )
                }
                .padding()
                .onAppear(perform: {
                    withAnimation(Animation.linear.speed(0.7)){
                        self.animate.toggle()
                    }
                })
            }
}

class MainObservable : ObservableObject{
    
    @Published var recents = [Recent]()
    @Published var norecents = false
    
    init() {
        
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("Users").document(uid!).collection("Recents").order(by: "date", descending: true).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.norecents = true
                return
            }
            
            if snap!.isEmpty{
                
                self.norecents = true
                
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    let id = i.document.documentID
                    let name = i.document.get("name") as! String
                    let pic = i.document.get("pic") as! String
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                    
                    self.recents.append(Recent(id: id, name: name, pic: pic, lastmsg: lastmsg, time: time, date: date, stamp: stamp.dateValue()))
                }
                
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yy"
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = "hh:mm a"
                    let time = formatter.string(from: stamp.dateValue())
                    
                    
                    for j in 0..<self.recents.count{
                        
                        if self.recents[j].id == id{
                            
                            self.recents[j].lastmsg = lastmsg
                            self.recents[j].time = time
                            self.recents[j].date = date
                            self.recents[j].stamp = stamp.dateValue()
                        }
                    }
                }
            }
        }
    }
}
