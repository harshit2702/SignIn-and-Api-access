//
//  SignInWithEmail.swift
//  Test Project
//
//  Created by Harshit Agarwal on 11/06/23.
//

import SwiftUI

struct SignInWithEmail: View {
    var body: some View {
        VStack{
            TextField("Enter EmailId",value: $email)
        }
    }
}

struct SignInWithEmail_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmail()
    }
}
