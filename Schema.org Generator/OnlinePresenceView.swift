//
//  OnlinePresenceView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUICore
import SwiftUI


struct OnlinePresenceView: View {
    @Binding var socialProfiles: String

    var body: some View {
        Form {
            Section(header: Text("Online Presence")) {
                TextField("Social Media Profiles (comma-separated)", text: $socialProfiles)
            }
        }
    }
}
