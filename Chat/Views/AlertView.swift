//
//  AlertView.swift
//  AlertView
//
//  Created by Mister Okine on 29/07/2021.
//

import SwiftUI

struct AlertView: View {
    var msg: String
    

    @Binding var show: Bool
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            Text("Alert")
                .fontWeight(.light)
                .foregroundColor(.black)
                
            
            Text(msg)
                .foregroundColor(.black)
                .fontWeight(.ultraLight)
                
            
            Button(action: {
                // closing popup...
                show.toggle()
                
            }, label: {
                Text("Okay")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .background(Color.blue)
                    .cornerRadius(20)
            })
            
            // centering the button
            .frame(alignment: .center)
        })
        .padding()
        .background(.thinMaterial)
        .cornerRadius(15)
        .padding(.horizontal,25)
        
        // background dim...
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.2).ignoresSafeArea())
    }
}

