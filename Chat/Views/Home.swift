//
//  Home.swift
//  Home
//
//  Created by Mister Okine on 29/07/2021.
//
import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseStorage


struct Home: View {
    
    @State var Username = UserDefaults.standard.value(forKey: "Username") as! String
    @EnvironmentObject var datas : MainObservable

    init() {
              
        UITabBar.appearance().isHidden = false
        UITabBar.appearance().barTintColor = .init(white: 0.9 , alpha: 0)
        UITabBar.appearance().clipsToBounds = true
    }
    
    @State var centerX : CGFloat = 0
    private var db = Firestore.firestore()
    
    var body: some View {
        TabView{
            Hometab()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Searchtab()
                .tabItem{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            Chat_tab()
                .tabItem{
                    Image(systemName: "message")
                    Text("Message")
                }
            Profile()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .accentColor(Color.blue)
    

    }
}


struct PopOver : View {
    @AppStorage("log_Status") var status = false
    

    var body: some View{
        VStack(alignment: .leading, spacing: 10) {
            
            Button(action: {

    
                try? Auth.auth().signOut()
                withAnimation{status = false}

            }){
                HStack(spacing: 10){
                    Text("Log Out")
                        .fontWeight(.light)
                    LottieView(name: "log-out", loopMode: .loop)
                        .frame(width: 50, height: 52, alignment: .center)
                }
            }
        }
        .frame(width: 140)
        .padding(.bottom)
    }
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            let center = rect.width / 2
                
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height-20))


            path.addLine(to: CGPoint(x: center - 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: center, y: rect.height - 5))
            path.addLine(to: CGPoint(x: center + 15, y: rect.height - 20))

            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))

        }
    }

}

//Creating Structures for various Tabs to be presented in our HOME VIEW
struct Hometab : View {
    @ObservedObject var getdata = getAllUsers()
    @State var show = false
    @AppStorage("log_Status") var status = false
    @State var chat = false
    @State var uid = ""
    @EnvironmentObject var datas : MainObservable
    @State var name = ""
    @State var pic = ""
    
    var body: some View{
        ZStack{

                
            ZStack(alignment: .bottomTrailing , content: {
                VStack{
                    HStack{
                        Spacer()
                        
                    }
                    .padding([.horizontal, .bottom])
                    .ignoresSafeArea(.all, edges: .bottom)
                    
                    Spacer()
                }
                
                
                VStack(alignment: .center, spacing: 12){
                    if self.show {
                        PopOver()
                            .clipShape(ArrowShape())
                            .cornerRadius(15)
                    }
                
                    Button(action: {
                
                        withAnimation(.spring()){
                            self.show.toggle()
                        }
                        
                    }) {
                        
                        Image(systemName: self.show ? "xmark" : "hand.point.up.braille")
                            .resizable()
                            .frame(width: 20, height: 22)
                            .padding()
                    }
                    .background(.thinMaterial)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(y: 15)
                    .padding(.bottom, 20)
                }
                .frame(width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height-60, alignment: .bottomTrailing)
                .padding()
            })
        }
    }
}

struct Searchtab : View {
    
    var body: some View{
        
        ZStack{

        }
    }
}

struct Profile : View{
    @State var name = ""
    @State var about = ""
    @State var loading = false
    @State var picker = false
    @State var imagedata : Data = .init(count: 0)
    @State var Username = UserDefaults.standard.value(forKey: "Username") as! String
    @State var About = UserDefaults.standard.value(forKey: "About") as! String
    @State var uid = UserDefaults.standard.value(forKey: "uid") as! String

    @State var imageURL = URL(string: "")
    var body: some View{
            
        ZStack(alignment: .leading){
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 20)

            ZStack{
                AngularGradient(gradient: Gradient(colors: [.white, .white, .white, .white, .white, .white, .white]), center: .center).opacity(0.9)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 450)
                    .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 25)
                
                
                
                    VStack(alignment: .leading, spacing: 5){
                        HStack{
                                            
                            Button(action: {
                                
                                self.picker.toggle()
                                
                            }) {
                                if self.imagedata.count == 0{
                                    LottieView(name: "avatar", loopMode: .loop)
                                        .frame(width: 150, height: 150, alignment: .center)

                                }
                                else{
                                    
                                    Image(uiImage: UIImage(data: self.imagedata)!).resizable().renderingMode(.original).frame(width: 150, height: 150, alignment: .center).clipShape(Circle()).padding()
                                        
                                    
                                }
                                
                                
                            }
                        }
                        Text("Username")
                            .font(.body)
                            .fontWeight(.thin)
                            .foregroundColor(.black)

                        TextField(Username, text: self.$name)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                            .frame(width:280, height: 45, alignment: .leading)
                            .overlay(Rectangle().frame(height: 2).padding(.top, 30))

                            

                        Text("About")
                            .font(.body)
                            .fontWeight(.thin)
                            .foregroundColor(.black)


                        TextField(About, text: self.$about)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .frame(width: 280 ,height: 50, alignment: .leading)
                            .overlay(Rectangle().frame(height: 2).padding(.top, 30))

                        if self.loading{
                            HStack{
                                Spacer()
                                Loading()
                                Spacer()
                            }
                        }
                        else{
                            
                            Button(action: {
                                
                                if self.name != "" || self.about != "" || self.imagedata.count != 0{
                                    
                                    self.loading.toggle()
                                    CreateUser(name: self.name, about: self.about, imagedata: self.imagedata) { (status) in
                                        
                                        if status{
                                            self.loading.toggle()
                                        }
                                        
                                        print("success @updating Profile")
                                      

                                    }
                                }
                                else{

                                }
                            }) {
                                

                                Text("Update Profile").frame(width: 280,height: 50, alignment: .center)
                                
                            }
                            .frame(width: 280, alignment: .leading)
                            .foregroundColor(.white)
                            .background(Color.red).opacity(0.9)
                            .cornerRadius(10)
                            .padding(.bottom,5)
                            .shadow(radius: 2.0)
                            .padding(.top,25)
                            
                        }
                        
                    }
                    .padding(10)
                    .sheet(isPresented: self.$picker, content: {
                        
                        ImagePicker(picker: self.$picker, imagedata: self.$imagedata)
                    })
            }
            .padding(.leading,130)
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.main.bounds.width - 50, height: 450)



            
            
        
        }
        .edgesIgnoringSafeArea(.all)
    
    
    }
    func loadImageFromFirebase() {

             let storageRef = Storage.storage().reference(withPath: uid)
              storageRef.downloadURL { (url, error) in
                     if error != nil {
                         print((error?.localizedDescription)!)
                         return
              }
                    self.imageURL = url!
        }
      }

    
}

struct ChatView : View {
    
    var name : String
    var pic : String
    var uid : String
    @Binding var chat : Bool
    @State var msgs = [Msg]()
    @State var txt = ""
    @State var nomsgs = false
    
    var body : some View{
        
        VStack{
            if msgs.count == 0{
                
                if self.nomsgs{
                    
                    Text("Start Your Conversation !").foregroundColor(Color.black.opacity(0.5)).padding(.top)
                    
                    Spacer()
                }
                else{
                    
                    Spacer()
                    Loading()
                    Spacer()
                }

                
            }
            else{
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 8){
                        
                        ForEach(self.msgs){i in
                            
                            
                            HStack{
                                
                                if i.user == UserDefaults.standard.value(forKey: "uid") as! String{
                                    
                                    Spacer()
                                    
                                    Text(i.msg)
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(ChatBubble(mymsg: true))
                                        .foregroundColor(.white)
                                }
                                else{
                                    
                                    Text(i.msg).padding().background(Color.green).clipShape(ChatBubble(mymsg: false)).foregroundColor(.white)
                                    
                                    Spacer()
                                }
                            }

                        }
                    }
                }
            }
            
            HStack{
                
                TextField("Enter Message", text: self.$txt).textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    
                    sendMsg(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                    
                    self.txt = ""
                    
                }) {
                    
                    Text("Send")
                }
            }
            
                .navigationBarTitle("\(name)",displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    
                    self.chat.toggle()
                    
                }, label: {
                
                    Image(systemName: "arrow.left").resizable().frame(width: 20, height: 15)
                    
                }))
            
        }.padding()
        .onAppear {
        
            self.getMsgs()
                
        }
    }
    
    func getMsgs(){
        
        let db = Firestore.firestore()
        
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid!).collection(self.uid).order(by: "date", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.nomsgs = true
                return
            }
            
            if snap!.isEmpty{
                
                self.nomsgs = true
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
                    
                    let id = i.document.documentID
                    let msg = i.document.get("msg") as! String
                    let user = i.document.get("user") as! String
                    
                    self.msgs.append(Msg(id: id, msg: msg, user: user))
                }

            }
        }
    }
}

struct Recent : Identifiable {
    
    var id : String
    var name : String
    var pic : String
    var lastmsg : String
    var time : String
    var date : String
    var stamp : Date
}

//Respective Chat Models all created in the Main/Home Page
struct RecentCellView : View {
    
    var url : String
    var name : String
    var time : String
    var date : String
    var lastmsg : String
    
    var body : some View{
        
        HStack{
            
            AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(name).foregroundColor(.black)
                        Text(lastmsg).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                         Text(date).foregroundColor(.gray)
                         Text(time).foregroundColor(.gray)
                    }
                }
                
                Divider()
            }
        }
    }
}


struct Msg : Identifiable {
    
    var id : String
    var msg : String
    var user : String
}

struct ChatBubble : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
            
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}

func sendMsg(user: String,uid: String,pic: String,date: Date,msg: String){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("Users").document(uid).collection("Recents").document(myuid!).getDocument { (snap, err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            // if there is no recents records....
            
            setRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
            return
        }
        
        if !snap!.exists{
            
            setRecents(user: user, uid: uid, pic: pic, msg: msg, date: date)
        }
        else{
            
            updateRecents(uid: uid, lastmsg: msg, date: date)
        }
    }
    
    updateDB(uid: uid, msg: msg, date: date)
}

func setRecents(user: String,uid: String,pic: String,msg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    let myname = UserDefaults.standard.value(forKey: "Username") as! String
    
    let mypic = UserDefaults.standard.value(forKey: "Profilepic") as! String
    
    db.collection("Users").document(uid).collection("Recents").document(myuid!).setData(["name":myname,"pic":mypic,"lastmsg":msg,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
    
    db.collection("Users").document(myuid!).collection("Recents").document(uid).setData(["name":user,"pic":pic,"lastmsg":msg,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
}

func updateRecents(uid: String,lastmsg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("Users").document(uid).collection("Recents").document(myuid!).updateData(["lastmsg":lastmsg,"date":date])
    
     db.collection("Users").document(myuid!).collection("Recents").document(uid).updateData(["lastmsg":lastmsg,"date":date])
}

func updateDB(uid: String,msg: String,date: Date){
    
    let db = Firestore.firestore()
    
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("msgs").document(uid).collection(myuid!).document().setData(["msg":msg,"user":myuid!,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
    
    db.collection("msgs").document(myuid!).collection(uid).document().setData(["msg":msg,"user":myuid!,"date":date]) { (err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
    }
}

func getCurrentUser() {
    let db = Firestore.firestore()
    if let userId = Auth.auth().currentUser?.uid {
        let collectionRef = db.collection("Users")
        let thisUserDoc = collectionRef.document(userId)
        thisUserDoc.getDocument(completion: { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }
            if let doc = document {
                let username = doc.get("Userame") ?? "No Name"
                let profilepic = doc.get("ProfilePic") ?? "No Picture"
                let about = doc.get("About") ?? "No About"
                print("Hey, \(username) welcome!")
                print("Hey, is this your about? : \(about)")
                print("Hey, kindly crosscheck your photo url: \(profilepic)")
                
            }
        })
    }
}

class getAllUsers : ObservableObject{
    
    @Published var users = [User]()
    @Published var empty = false
    
    init() {
        
        let db = Firestore.firestore()
        
        
        db.collection("Users").getDocuments { (snap, err) in

            if err != nil{
                
                print((err?.localizedDescription)!)
                self.empty = true
                return
            }
            
            if (snap?.documents.isEmpty)!{
                
                self.empty = true
                return
            }
            
            for i in snap!.documents{
                
                let id = i.documentID
                let name = i.get("Username") as! String
                let pic = i.get("ProfilePic") as! String
                let about = i.get("About") as! String
                
                if id != UserDefaults.standard.value(forKey: "uid") as! String{
                    
                    self.users.append(User(id: id, name: name, pic: pic, about: about))

                }
                
            }
            
            if self.users.isEmpty{
                
                self.empty = true
            }
        }
    }
}

struct UserCellView : View {
    
    var url : String
    var name : String
    var about : String
    
    var body : some View{
        
        HStack{
            
            AnimatedImage(url: URL(string: url)!).resizable().renderingMode(.original).frame(width: 55, height: 55).clipShape(Circle())
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(name).foregroundColor(.black)
                        Text(about).foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                }
                
                Divider()
            }
        }
    }
}

struct User : Identifiable {
    
    var id : String
    var name : String
    var pic : String
    var about : String
}


struct AnimatedShape: Shape {
      
      var centerX : CGFloat
      
      // animating Path....
      
      var animatableData: CGFloat{
          
            get{return centerX}
            set{centerX = newValue}
        
      }
      
      func path(in rect: CGRect) -> Path {
          
          return Path{path in
              
              path.move(to: CGPoint(x: 0, y: 15))
              path.addLine(to: CGPoint(x: 0, y: rect.height))
              path.addLine(to: CGPoint(x: rect.width, y: rect.height))
              path.addLine(to: CGPoint(x: rect.width, y: 15))
              
              // Curve....
              
              path.move(to: CGPoint(x: centerX - 35, y: 15))
              
              path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -30))
          }
      }
  }

struct newChatView : View {
    
    @ObservedObject var datas = getAllUsers()
    @Binding var name : String
    @Binding var uid : String
    @Binding var pic : String
    @Binding var show : Bool
    @Binding var chat : Bool
    
    
    var body : some View{
        
        VStack(alignment: .leading){

                if self.datas.users.count == 0{
                    
                    if self.datas.empty{
                        
                        Text("No Users Found")
                    }
                    else{
                        Spacer()
                        Loading()
                        Spacer()
                    }
                    
                }
                else{
                    
                    Text("Select To Chat").font(.title).foregroundColor(Color.black.opacity(0.5))
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        VStack(spacing: 12){
                            
                            ForEach(datas.users){i in
                                
                                Button(action: {
                                    
                                    self.uid = i.id
                                    self.name = i.name
                                    self.pic = i.pic
                                    self.show.toggle()
                                    self.chat.toggle()
                                    
                                    
                                }) {
                                    
                                    UserCellView(url: i.pic, name: i.name, about: i.about)
                                }
                                
                                
                            }
                            
                        }
                        
                    }
              }
        }
        .padding()
    }
}

struct Chat_tab : View {
    @State var show = false
    @State var chat = false
    @State var uid = ""
    @State var name = ""
    @EnvironmentObject var datas : MainObservable
    @State var pic = ""
    @State var myuid = UserDefaults.standard.value(forKey: "Username") as! String

    
    var body: some View{
        NavigationView{
            ZStack{
                    NavigationLink(destination: ChatView(name: self.name, pic: self.pic, uid: self.uid, chat: self.$chat), isActive: self.$chat){
                                    Text("")
                    }
                                VStack{
                                    
                                    if self.datas.recents.count == 0{
                                        
                                        if self.datas.norecents{
                                            
                                            Text("No Chat History")

                                        }
                                        
                                        else{
                                            VStack{
                                                LottieView(name: "concentric-snakes-loader", loopMode: .loop)
                                                    .frame(width: 200, height: 200, alignment: .center)
                                            
                                            
                                            }
                                        }
                                                                    
                                    }
                                    else{
                                        
                                        ScrollView(.vertical, showsIndicators: false) {
                                            
                                            VStack(spacing: 12){
                                                
                                                ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})){i in
                                                    
                                                    Button(action: {
                                                        
                                                        self.uid = i.id
                                                        self.name = i.name
                                                        self.pic = i.pic
                                                        self.chat.toggle()
                                                        
                                                    }) {
                                                        
                                                        RecentCellView(url: i.pic, name: i.name, time: i.time, date: i.date, lastmsg: i.lastmsg)
                                                    }
                                                    
                                                }
                                                
                                            }.padding()
                                            
                                        }
                                    }
                                }
                                .navigationBarTitle("Chat",displayMode: .inline)
                                .navigationBarItems(trailing: Button(action: {
                                                            self.show.toggle()
                                                            
                                                        }, label: {
                                                            Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                                                                
                                                        })
                                )
                                            
                }.sheet(isPresented: self.$show) {
                    
                    newChatView(name: self.$name, uid: self.$uid, pic: self.$pic, show: self.$show, chat: self.$chat)
                    
                }
                

        }
        

    }

}
