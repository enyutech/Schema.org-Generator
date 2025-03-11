//
//  KnowsAboutView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/11/25.
//


import SwiftUI

struct KnowsAboutView: View {
    @Binding var knowsAbout: [String]

    var body: some View {
        VStack {
            Text("Knows About")
                .font(.headline)
                .padding(.bottom, 5)

            List {
                ForEach(knowsAbout.indices, id: \ .self) { index in
                    HStack {
                        TextField("Enter knowledge URL", text: $knowsAbout[index])
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 400)

                        Button(action: {
                            removeKnowsAbout(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onMove(perform: moveKnowsAbout)
            }

            Button(action: addKnowsAbout) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Entry")
                }
                .padding(.vertical, 5)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 5)
        }
        .frame(width: 500)
        .padding()
    }

    // Function to add a new knowsAbout field
    private func addKnowsAbout() {
        knowsAbout.append("")
    }

    // Function to remove a knowsAbout field
    private func removeKnowsAbout(at index: Int) {
        knowsAbout.remove(at: index)
    }

    // Function to handle reordering
    private func moveKnowsAbout(from source: IndexSet, to destination: Int) {
        knowsAbout.move(fromOffsets: source, toOffset: destination)
    }
}
