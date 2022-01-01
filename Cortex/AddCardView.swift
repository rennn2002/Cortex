//
//  AddCardView.swift
//  Cortex
//
//  Created by Nomura Rentaro on 2021/12/28.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    
    @FetchRequest(  // FetchRequest updates View corresponding to the change of data
        entity: Word.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)], predicate: nil
    ) private var words: FetchedResults<Word>
    
    @State var word: String = ""
    @State var word_trans: String = ""
    
    @Binding var showAddCardView: Bool
    
    @State var cardNum: Int = 0
    
    var body: some View {
        Form {
            Section(header:Text("word")) {
                TextField("Type word to add", text: self.$word)
                    .autocapitalization(.none)
                    .padding()
                TextField("Type word's translation", text: self.$word_trans)
                    .autocapitalization(.none)
                    .padding()
            }
            Section {
                Button(action: {
                    let newWord = Word(context: context)
                    newWord.id = UUID()
                    newWord.wordsName = self.word
                    newWord.timestamp = Date()
                    newWord.wordsNameTrans = self.word_trans
                    newWord.status = "white"
                    
                    try? context.save()
                    
                    presentationMode.wrappedValue.dismiss() // close current View\
                    
                    self.showAddCardView.toggle()
                }) {
                    Text("Add")
                        .fontWeight(.bold)
                }
            }
        }.navigationBarHidden(true)
            .highPriorityGesture(DragGesture(minimumDistance: 25, coordinateSpace: .local)
                                    .onEnded { value in
                if abs(value.translation.height) < abs(value.translation.width) {
                    if abs(value.translation.width) > 50.0 {
                        self.showAddCardView.toggle()
                    }
                }
            })
    }
}
