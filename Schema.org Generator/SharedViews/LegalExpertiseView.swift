//
//  LegalExpertiseView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI

struct LegalExpertiseView: View {
    @Binding var knowsAbout: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Legal Expertise")
                .font(.headline)
                .padding(.bottom, 5)

            List {
                ForEach(knowsAbout.indices, id: \.self) { index in
                    HStack {
                        TextField("Enter area of legal expertise", text: $knowsAbout[index])
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 400)

                        Button(action: {
                            removeExpertise(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(knowsAbout.count == 1) // Prevent removing last field
                    }
                }
                .onMove(perform: moveExpertise)
            }
            .frame(height: min(CGFloat(knowsAbout.count) * 50, 300)) // Limit height

            Button(action: addExpertise) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Expertise")
                }
                .padding(.vertical, 5)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 5)
        }
        .padding()
    }

    // Function to add a new expertise field
    private func addExpertise() {
        knowsAbout.append("")
    }

    // Function to remove an expertise field
    private func removeExpertise(at index: Int) {
        if knowsAbout.count > 1 {
            knowsAbout.remove(at: index)
        }
    }

    // Function to handle reordering
    private func moveExpertise(from source: IndexSet, to destination: Int) {
        knowsAbout.move(fromOffsets: source, toOffset: destination)
    }
}
