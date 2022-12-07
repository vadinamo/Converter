//
//  LoginView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 7.12.22.
//

import SwiftUI

struct LoginView: View {
    @State var login: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            Text("Weclome").font(.largeTitle)
            TextField("Login", text: $login)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                
            }, label: {
                Spacer()
                Text("Sign up")
                Spacer()
            })
            .buttonStyle(.borderedProminent)
            
            Button(action: {
                
            }, label: {
                Text("Already have an account? Log in")
            })
            .foregroundColor(.white)
        }
        .preferredColorScheme(.dark)
        .padding()
    }
}
