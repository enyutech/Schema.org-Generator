//
//  WelcomeView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/9/25.
//

import SwiftUI

struct WelcomeView: View {
    let urlString = "https://enyutech.com/software/apple/schema-org-generator"

    var body: some View {
        VStack {
            Spacer()
            Text("Schema.org Generator")
                .font(.largeTitle)
            Text("Generate JSON-LD for your website or app.")
                .font(.subheadline)
            Spacer()
            Text("Copyright © 2025 Enyutech LLC. All rights reserved.")
                .font(.caption)
        }
    }
}

#Preview {
    WelcomeView()
}
