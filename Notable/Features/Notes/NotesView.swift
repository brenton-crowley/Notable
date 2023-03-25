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
    @State private var showDeleteAlert = false
    @State private var currentNote: Note?
    
    var body: some View {
        
        NavigationView {
            Group {
                if let notes = myNotes.notes,
                   notes.count > 0 {
                    List {
                        ForEach (notes) { note in
                            noteRow(note)
                        }
                        .onDelete(perform: myNotes.deleteNotes)
                    }
                } else {
                    Text("Tap + to add a note")
                }
            }
            .navigationTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete: \(currentNote?.noteName ?? "")", isPresented: $showDeleteAlert, actions: {
                deleteNoteButton
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addNoteButton
                }
            }
        }
        .onAppear(perform: {
            
        })
        .fullScreenCover(
            isPresented: $myNotes.presentLoginScreen) {
                userLoginView
            }
            
        
    }
    
    @ViewBuilder
    func noteRow(_ note: Note) -> some View {
        HStack {
            Text(note.noteName ?? "")
                .onTapGesture {
                    //
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
            .environmentObject(MyNotes(storageProvider: StorageProvider.previewWithNotes))
    }
}
