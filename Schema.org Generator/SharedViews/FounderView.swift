//
//  FounderView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI

struct FounderView: View {
    @Binding var founderName: String
    @Binding var founderUrl: String
    @Binding var founderDescription: String
    @Binding var founderDisambiguatingDescription: String
    @Binding var founderImage: String
    @Binding var founderTelephone: String
    @Binding var founderKnowsAbout: String
    @Binding var founderKnowsLanguage: String
    @Binding var founderNationality: String
    @Binding var founderGender: String
    @Binding var founderWorkLocation: String
    @Binding var founderJobTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Founder Information")
                .font(.headline)
                .padding(.bottom, 5)

            Grid {
                GridRow {
                    Text("Founder Name:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter founder name", text: $founderName)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Profile URL:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter profile URL", text: $founderUrl)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Description:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter a description", text: $founderDescription)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Disambiguating Description:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Further clarify the founder", text: $founderDisambiguatingDescription)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Image URL:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter image URL", text: $founderImage)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Telephone:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter phone number", text: $founderTelephone)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Knows About:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter topics (comma-separated)", text: $founderKnowsAbout)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Knows Language:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter languages spoken", text: $founderKnowsLanguage)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Nationality:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter nationality", text: $founderNationality)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Gender:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter gender", text: $founderGender)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Work Location:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter work location", text: $founderWorkLocation)
                        .textFieldStyle(.roundedBorder)
                }
                GridRow {
                    Text("Job Title:")
                        .frame(width: 180, alignment: .trailing)
                    TextField("Enter job title", text: $founderJobTitle)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .frame(maxWidth: 600)
            .padding()
        }
        .padding()
    }
}
