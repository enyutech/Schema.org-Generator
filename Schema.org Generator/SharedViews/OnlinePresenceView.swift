//
//  OnlinePresenceView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI

struct OnlinePresenceView: View {
    @Binding var socialProfiles: [String]

    var body: some View {
        VStack {
            Text("Online Presence (same as)")
                .font(.headline)
                .padding(.bottom, 5)

            List {
                ForEach(socialProfiles.indices, id: \.self) { index in
                    HStack {
                        TextField("Enter social media profile URL", text: $socialProfiles[index])
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 400)

                        Button(action: {
                            removeProfile(at: index)
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onMove(perform: moveProfile)
            }
//            .frame(height: min(CGFloat(socialProfiles.count) * 50, 300)) // Limit height

            Button(action: addProfile) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Profile")
                }
                .padding(.vertical, 5)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.top, 5)
        }
        .frame(width: 500)
        .padding()
    }

    // Function to add a new profile field
    private func addProfile() {
        socialProfiles.append("")
    }

    // Function to remove a profile field
    private func removeProfile(at index: Int) {
        socialProfiles.remove(at: index)
    }

    // Function to handle reordering
    private func moveProfile(from source: IndexSet, to destination: Int) {
        socialProfiles.move(fromOffsets: source, toOffset: destination)
    }
}
