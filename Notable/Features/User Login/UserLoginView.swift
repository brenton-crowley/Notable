//
//  UserLoginView.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import SwiftUI

struct UserLoginView: View {
    
    private struct Constants {
     
        static let viewTitle = "User Login"
        
        // TextEditor
        static let singleLineTextfieldHeight:CGFloat = 30.0
    }
    
    @EnvironmentObject private var myNotes: MyNotes
    
    @State private var usernameText: String = ""
    @State private var passwordText: String = ""
    
    @Binding var isPresented: Bool
    
    var body: some View {
        
        NavigationView {
            List {
                usernameEditor
                passwordEditor
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.viewTitle)
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
//                    dismissButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    loginButton
                }
            }
        }
    }
    
    // MARK: - Toolbar Buttons
    
    var dismissButton: some View {
        
        Button("Cancel") {
            isPresented = false
        }
    }
    
    var loginButton: some View {
        
        Button("Login") {
            //TODO: connects with the viewmodel
            // send the username text and the password
            // once success, then isPresented = false
            let cleandedUsername = usernameText.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleandedPassword = passwordText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            myNotes.tryLoginWithUsername(cleandedUsername, andPassword: cleandedPassword)
        }
    }
    
    // MARK: - Data Entry Fields
    
    var usernameEditor: some View {
        
        dataEntryField(
            labelText: "Username",
            labelSystemIcon: "person.circle",
            boundText: $usernameText)
        
    }
    
    var passwordEditor: some View {
        
        dataEntryField(
            labelText: "Password",
            labelSystemIcon: "key.horizontal",
            boundText: $passwordText,
            isSecure: true)
        
    }
    
    @ViewBuilder
    private func dataEntryField(
        labelText: String,
        labelSystemIcon: String,
        boundText: Binding<String>,
        isSecure: Bool = false,
        prompt:String? = nil,
        height: CGFloat = Constants.singleLineTextfieldHeight) -> some View {
            
            Section {
                if isSecure {
                    SecureField("", text: boundText)
                        .textContentType(.password)
                } else {
                    TextEditor(text: boundText)
                        .font(.callout)
                        .frame(height: height)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                }
            } header: {
                Label(prompt ?? labelText, systemImage: labelSystemIcon)
                
            }
        }
}

struct UserLoginView_Previews: PreviewProvider {
    static var previews: some View {
        UserLoginView(isPresented: Binding.constant(true))
            .environmentObject(MyNotes())
    }
}
