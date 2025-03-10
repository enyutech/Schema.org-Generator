//
//  JsonOutputView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUICore
import SwiftUI


struct JsonOutputView: View {
    @Binding var jsonOutput: String
    @Environment(\.presentationMode) var presentationMode // Allows dismissing the sheet
    
    var body: some View {
        VStack {
            Text("Generated JSON-LD")
                .font(.headline)
                .padding()
            
            ScrollView {
                Text(jsonOutput.isEmpty ? "No JSON generated." : jsonOutput) // Show message if empty
                    .textSelection(.enabled)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(NSColor.quaternaryLabelColor)))
                    .frame(minHeight: 200)
            }
            .padding()
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss() // Correctly dismisses the sheet
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}
