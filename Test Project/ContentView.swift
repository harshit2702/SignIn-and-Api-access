//
//  ContentView.swift
//  Test Project
//
//  Created by Harshit Agarwal on 11/06/23.
//
import AuthenticationServices
import SwiftUI

struct ContentView: View {
    @AppStorage("email") var email = ""
    @AppStorage("firstName") var firstName = ""
    @AppStorage("lastName") var lastName = ""
    @AppStorage("userID") var userId = ""
    
    @State private var isPresented = false
    
    
    var body: some View {
        NavigationStack {
            if email.isEmpty {
                VStack {
                    Spacer()
                    SignInWithAppleButton(.continue){request  in
                        request.requestedScopes = [.email,.fullName,]
                    } onCompletion: { result in
                        switch result {
                        case .success(let auth):
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                userId = credential.user
                                
                                email = credential.email ?? ""
                                firstName = credential.fullName?.givenName ?? ""
                                lastName = credential.fullName?.familyName ?? ""
                                
                                break
                            default:
                                break
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .frame(height: 50)
                    .cornerRadius(15)
                    HStack{
                        Rectangle()
                            .frame(height: 1)
                        Text("or")
                        Rectangle()
                            .frame(height: 1)
                    }
                    Button{
                        isPresented = true
                    }label: {
                        Text("Sign in with email Id")
                    }
                }
                .navigationTitle("Sign In")
                .padding()
                .sheet(isPresented: $isPresented){
                    @State var emailId = ""
                    @State var fName = ""
                    @State var lName = ""
                    List {
                        Section("Email"){
                            TextField("Enter Email", text: $emailId)
                        }
                        Section("Name"){
                            TextField("Enter First Name", text: $fName)
                            TextField("Enter Last Name", text: $lName)
                        }
                        if emailId.isEmpty && fName.isEmpty && lName.isEmpty {
                            Button("Save"){
                                email = emailId
                                firstName = fName
                                lastName = lName
                                isPresented.toggle()
                            }
                        }
                    }
                    .padding()
                    
                }
                .toolbar(){
                    Menu{
                        Button("Sign out"){
                            email = ""
                            firstName = ""
                            lastName = ""
                            userId = ""
                        }
                    }label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    }
                }
            }
            else{
                movieSearchAPI()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
