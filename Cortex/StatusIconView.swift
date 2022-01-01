//
//  StatusIconView.swift
//  Cortex
//
//  Created by Nomura Rentaro on 2021/12/30.
//

import Foundation
import SwiftUI
import CoreData

struct StatusIconView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(  // FetchRequest updates View corresponding to the change of data
        entity: Word.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Word.timestamp, ascending: true)], predicate: nil
    ) private var words: FetchedResults<Word>
    
    @State var id: UUID
    @State var color: Color
    @State var oldColor: Color = .white
    @State var showpallet: Bool = false
    
    @State var palletColors: [Color] = [Color.blue, Color.pink, Color.green, Color.white]
    
    @State var colorsDict: [Color:String] = [Color.green: "green", Color.red: "red", Color.blue: "blue", Color.pink: "pink", Color.white: "white"]
    
    var body: some View {
        ZStack(alignment: .center) {
            Spacer()
            Circle()
                .foregroundColor(self.color)
                .frame(width: 20, height: 20)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 1, y: 1)
                .onTapGesture {
                    self.showpallet.toggle()
                }
                .padding(.leading, 15)
            if self.showpallet {
                
                ZStack {
                    ForEach(0..<self.palletColors.count) { index in
                        Circle()
                            .foregroundColor(self.palletColors[index])
                            .frame(width: 20, height: 20)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 1, y: 1)
                            .offset(x: -CGFloat(Int(index+1)*30))
                            .onTapGesture {
                                self.oldColor = self.color
                                self.color = self.palletColors[index]
                                editstatus(id: self.id, color: self.color)
                                self.showpallet.toggle()
                            }
                    }
                }
            }
        }
    }
    
    func editstatus(id: UUID, color: Color) {
        let wordRequested: NSFetchRequest<Word> = Word.fetchRequest()
        wordRequested.predicate = NSPredicate.init(format: "id=%@", id.uuidString)
        let savedWords =  try? context.fetch(wordRequested) // search word by UUID
        for word in savedWords! {
            word.status = colorsDict[color]
        }
        try? context.save()
       
    }
}
