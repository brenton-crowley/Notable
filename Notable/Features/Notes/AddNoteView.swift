//
//  AddNoteView.swift
//  Notable
//
//  Created by Brent Crowley on 25/3/2023.
//

import SwiftUI

struct AddNoteView: View {
    
    private struct Constants {
     
        static let viewTitle = "Add Note"
        
    }
    
    @EnvironmentObject private var myNotes: MyNotes
    
    @State private var noteNameText: String = ""
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                TextEditor(text: $noteNameText)
                    .font(.callout)
                    .multilineTextAlignment(.leading)
//                    .frame(height: height)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.viewTitle)
            .listStyle(.insetGrouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    dismissButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
    }
    
    var dismissButton: some View {
        
        Button("Cancel") {
            isPresented = false
        }
    }
    
    var saveButton: some View {
        
        Button("Save") {
            //TODO: connects with the viewmodel
            let cleandedNoteName = noteNameText.trimmingCharacters(in: .whitespacesAndNewlines)

            myNotes.makeNoteWithName(cleandedNoteName)
            isPresented = false
        }
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView(isPresented: Binding.constant(false))
    }
}
