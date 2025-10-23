//
//  AddInsightView.swift
//  Lumēn
//
//  Created by Brian J Gonzalez on 10/22/25.
//


import SwiftUI

struct AddInsightView: View {
    @EnvironmentObject var store: InsightStore
    @Environment(\.dismiss) var dismiss

    @State private var author = ""
    @State private var text = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Author")) {
                    TextField("Who said it?", text: $author)
                }

                Section(header: Text("Insight")) {
                    TextField("Write your insight...", text: $text, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("New Insight")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newInsight = Insight(
                            id: UUID(),
                            author: author.isEmpty ? "Anonymous" : author,
                            text: text.isEmpty ? "Untitled Insight" : text,
                            date: Date(),
                            isFavorite: false
                        )
                        store.add(newInsight)
                        dismiss()
                    }
                    .disabled(text.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
            }
        }
    }
}
