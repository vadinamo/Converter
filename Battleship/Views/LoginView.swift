//
//  LoginView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 7.12.22.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        if vm.userIsLoggedIn {
            MenuView(vm: vm)
        }
        else {
            content
        }
    }
    
    var content: some View {
        VStack {
            Text("Weclome").font(.largeTitle)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            Button(action: {
                register()
            }, label: {
                Spacer()
                Text("Sign up")
                Spacer()
            })
            .buttonStyle(.borderedProminent)
            
            Button(action: {
                login()
            }, label: {
                Text("Already have an account? Log in")
            })
        }
        .preferredColorScheme(.dark)
        .padding()
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    vm.userIsLoggedIn = true
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                vm.userIsLoggedIn = true
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}
