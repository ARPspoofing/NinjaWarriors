//
//  AuthenticationView.swift
//  NinjaWarriors
//
//  Created by Muhammad Reyaaz on 13/3/24.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Spacer(minLength: 0)
                NavigationLink("Single Player", value: "SingleLobbyView")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                NavigationLink("Multiplayer Account", value: "SignInView")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                NavigationLink("Multiplayer Guest", value: "LobbyView")
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(width: 300, height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                Spacer(minLength: 0)
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "SingleLobbyView":
                    SingleLobbyView(path: $path)
                case "SignInView":
                    SignInView(path: $path)
                case "LobbyView":
                    LobbyView(path: $path)
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Home")
            .background(
                Image("lobby-bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
            )
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
