//
//  FounderView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUICore
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
        Form {
            Section(header: Text("Founder Information")) {
                TextField("Founder Name", text: $founderName)
                TextField("Founder Profile URL", text: $founderUrl)
                TextField("Founder Description", text: $founderDescription)
                TextField("Founder Disambiguating Description", text: $founderDisambiguatingDescription)
                TextField("Founder Image URL", text: $founderImage)
                TextField("Founder Telephone", text: $founderTelephone)
                TextField("Founder Knows About (comma-separated)", text: $founderKnowsAbout)
                TextField("Founder Knows Language", text: $founderKnowsLanguage)
                TextField("Founder Nationality", text: $founderNationality)
                TextField("Founder Gender", text: $founderGender)
                TextField("Founder Work Location", text: $founderWorkLocation)
                TextField("Founder Job Title", text: $founderJobTitle)
            }
        }
    }
}
