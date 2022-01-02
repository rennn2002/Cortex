//
//  ContentView.swift
//  Cortex
//
//  Created by Nomura Rentaro on 2021/12/28.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var selectedStatus: [String] = ["all"]
    
    @FetchRequest(  // FetchRequest updates View corresponding to the change of data
        entity: Word.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)], predicate:nil , animation: .linear(duration: 0.5)
    ) var words: FetchedResults<Word>
    
    @State var status: String = "white"
    
    //    @State var wordsRequest: FetchRequest<Word> = FetchRequest(entity: Word.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)], predicate: nil)
    //
    //    @FetchRequest var words: FetchedResults<Word> {wordsRequest.wrappedValue}
    
    //    init() {
    //        @State var status: String = "white"
    //        self.wordsRequest = FetchRequest(entity: Word.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)], predicate: NSPredicate(format: "status = %@", status), animation: .linear(duration: 1.0))
    //    }
    
    @State var offset = CGSize.zero
    @State var showAddCardView: Bool = false
    @State var cardNum: Int = 0
    
    @State var isAllSelected: Bool = false
    
    let colorsList: [Color] = [Color.clear, Color.white, Color.green, Color.pink, Color.blue]
    
    @State var text: String = ""
    
    @State private var isEditing = false
    
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if !self.words.isEmpty {
                    ForEach(self.words) { word in
                        CardView(id: word.id!, word: word.wordsName!, word_trans: word.wordsNameTrans!, status: word.status!)
                    }
                } else {
                    VStack {
                        Spacer(minLength: UIScreen.main.bounds.height/3)
                            .fixedSize()
                        Text("No cards")
                            .foregroundColor(.gray)
                            .font(.title)
                    }.edgesIgnoringSafeArea(.all)
                }
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddCardView(showAddCardView: self.$showAddCardView), isActive: self.$showAddCardView) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .principal) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.colorsList, id:\.self) { color in
                                ColorBarView(color: color, words: self._words, selectedStatus: self.$selectedStatus)
                            }
                        }
                    }
                }
            }
        }
    }
}
