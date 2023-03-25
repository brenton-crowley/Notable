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
        
        static let navigationTitle = "Notable"
        static let addNoteIcon = "plus"
        static let defaultAlertPrompt = "Note"
        static let noNotesPrompt = "Tap + to add a note"
        static let userIcon = "person.circle"
    }
    
    @EnvironmentObject private var myNotes: MyNotes
    
    @State private var isAddNotePresented: Bool = false
    @State private var showDeleteAlert = false
    @State private var currentNote: Note?
    
    var headerTitleText:String {
        if let user = myNotes.user { return "\(user.username ?? "User")'s Notes" }
        else { return Constants.navigationTitle }
    }
    
    var body: some View {
        
        NavigationView {
            notesList
                .navigationTitle(Constants.navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .alert("Delete: \(currentNote?.noteName ?? Constants.defaultAlertPrompt)",
                       isPresented: $showDeleteAlert,
                       actions: {
                    deleteNoteButton
                })
                .toolbar {
                    
                    if myNotes.user != nil {
                        ToolbarItem(placement: .navigationBarLeading) {
                            logoutButton
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addNoteButton
                    }
                }
                .fullScreenCover(
                    isPresented: $myNotes.presentLoginScreen) {
                        userLoginView
                    }
        }
        
        
    }
    
    var notesList: some View {
        VStack {
            Label(headerTitleText, systemImage: Constants.userIcon)
            if let notes = myNotes.notes,
               notes.count > 0 {
                List {
                    noteRows(notes)
                }
            } else {
                Spacer()
                Text(Constants.noNotesPrompt) // If user has no notes, prompt to add a note.
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func noteRows(_ notes: [Note]) -> some View {
        ForEach (notes) { note in
            noteRow(note)
        }
        .onDelete(perform: myNotes.deleteNotes) // Swipe to delete functionality
    }
    
    @ViewBuilder
    func noteRow(_ note: Note) -> some View {
        HStack {
            Text(note.noteName ?? "")
                .onTapGesture {
                    currentNote = note
                    showDeleteAlert = true
                }
            Spacer()
        }
    }
    
    var userLoginView: some View {
        UserLoginView(isPresented: $myNotes.presentLoginScreen)
            .alert(myNotes.alertText ?? "",
                   isPresented: $myNotes.showAlert) {
                Button("OK", role: .cancel) {
                    myNotes.alertText = nil
                    if myNotes.user != nil { myNotes.presentLoginScreen = false }
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
    
    var logoutButton: some View {
        Button {
            myNotes.logOut()
        } label: {
            Text("Log out")
        }
    }
    
    var deleteNoteButton: some View {
        Button("Delete", role: .destructive) {
            
            if let currentNote = currentNote,
               let index = myNotes.notes?.firstIndex(of: currentNote) {
                let indexSet = IndexSet([index])
                myNotes.deleteNotes(fromOffsets: indexSet)
            }
            
            currentNote = nil
            showDeleteAlert = false
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
            .environmentObject(MyNotes(storageProvider: StorageProvider.previewWithLoggedInUser))
    }
}
