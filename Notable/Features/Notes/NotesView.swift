//
//  ContentView.swift
//  Notable
//
//  Created by Brent Crowley on 24/3/2023.
//

import SwiftUI
import CoreData

struct NotesView: View {
    
    private struct Constants {
        
        static let navigationTitle = "MyNotes"
        static let addNoteIcon = "plus"
    }
    
    @EnvironmentObject private var myNotes: MyNotes
    
    @State private var isAddNotePresented: Bool = false
    
    var body: some View {
        
        NavigationView {
            Group {
                if let notes = myNotes.user?.notes?.allObjects as? [Note] {
                    List (notes) { note in
                        Text(note.timestamp?.description ?? "")
                    }
                }
            }
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addNoteButton
                }
            }
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
    
    var addNoteButton: some View {
        Button {
            isAddNotePresented = true
        } label: {
            Image(systemName: Constants.addNoteIcon)
        }
        .sheet(isPresented: $isAddNotePresented) {
            AddNoteView(isPresented: $isAddNotePresented)
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
            .environmentObject(MyNotes(storageProvider: StorageProvider.preview))
    }
}
