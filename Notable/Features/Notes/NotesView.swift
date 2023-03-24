//
//  ContentView.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import SwiftUI
import CoreData

struct NotesView: View {
    
    @EnvironmentObject private var myNotes: MyNotes
    
    var body: some View {
        
        NavigationView {
            List {
                
            }
        }
        .onAppear(perform: {
            //            isLoginScreenPresented = (myNotes.user == nil)
        })
        .task {
            // fetch logged in user
            
        }
        .fullScreenCover(
            isPresented: $myNotes.presentLoginScreen) {
                UserLoginView(isPresented: $myNotes.presentLoginScreen)
                    .alert(myNotes.alertText ?? "",
                           isPresented: $myNotes.showAlert) {
                        Button("OK", role: .cancel) {
                            myNotes.alertText = nil
                            if myNotes.user != nil { myNotes.presentLoginScreen = false }
                        }
                    }
            }
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
            .environmentObject(MyNotes(storageProvider: StorageProvider.preview))
    }
}
