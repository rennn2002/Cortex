//
//  ColorBarView.swift
//  Cortex
//
//  Created by Nomura Rentaro on 2021/12/31.
//

import Foundation
import SwiftUI
import CoreData

struct ColorBarView: View {
    
    var color: Color
    
    @Environment(\.managedObjectContext) private var context
    @FetchRequest var words: FetchedResults<Word>
    
    @State var isSelected: Bool = false
    
    @Binding var selectedStatus: [String]
    @State var colorsDict: [Color:String] = [Color.green: "green", Color.red: "red", Color.blue: "blue", Color.pink: "pink", Color.white: "white"]
    
    var body: some View {
        ZStack {
            HStack {
                Circle()
                    .foregroundColor(color)
                    .frame(width: 15, height: 15)
                    .shadow(color: .black.opacity(0.15), radius: 3)
                Text(self.colorsDict[color]!)
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
            }.padding(.horizontal, 10)
                .zIndex(1)
    //            .background(Capsule().foregroundColor(self.isSelected ? .gray.opacity(0.5) : .gray.opacity(0.1)).frame(height: 25))
            if self.isSelected {
                Capsule().frame(height:35).foregroundColor(.gray.opacity(0.2)).shadow(color: .gray.opacity(0.1) , radius: 1, x: 0, y: 0).zIndex(0)
            } else {
                Capsule().stroke().frame(height:35).foregroundColor(.gray.opacity(0.05)).shadow(color: .gray.opacity(0.15) , radius: 1, x: 0, y: 0).zIndex(0)
            }
        }
        .onTapGesture {
            if self.isSelected {   // If color is already selected
                self.isSelected.toggle()
                self.selectedStatus.removeAll(where: {$0 == self.colorsDict[color]!})   // Remove selected color from selectedStatus list
                print(self.selectedStatus)
            } else {    // If color is not yet selected
                self.isSelected.toggle()
                self.selectedStatus.append(self.colorsDict[color]!)
                print(self.selectedStatus)
            }
            if !self.selectedStatus.isEmpty {
                words.nsPredicate = NSPredicate(format: "status IN %@", self.selectedStatus)
            } else {
                words.nsPredicate = nil
            }
        }
        .onAppear {
            if self.selectedStatus.contains(self.colorsDict[color]!) {
                //self.isSelected.toggle()
                print(self.selectedStatus)
            }
            if !self.selectedStatus.isEmpty {
                words.nsPredicate = NSPredicate(format: "status IN %@", self.selectedStatus)
            } else {
                words.nsPredicate = nil
            }
            print(self.selectedStatus)
        }
    }
}
