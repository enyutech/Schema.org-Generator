//
//  LegalExpertiseView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUICore
import SwiftUI


struct LegalExpertiseView: View {
    @Binding var knowsAbout: String

    var body: some View {
        Form {
            Section(header: Text("Legal Expertise")) {
                TextField("Knows About (comma-separated)", text: $knowsAbout)
            }
        }
    }
}
