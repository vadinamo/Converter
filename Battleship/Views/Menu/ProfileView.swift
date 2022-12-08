//
//  ProfileView.swift
//  Battleship
//
//  Created by Вадим Юрьев on 8.12.22.
//

import SwiftUI
import Firebase


struct ProfileView: View {
    @ObservedObject var vm: ViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                print(vm.userIsLoggedIn)
                try! Auth.auth().signOut()
                vm.userIsLoggedIn = false
            }, label: {
                Text("Sign Out")
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
