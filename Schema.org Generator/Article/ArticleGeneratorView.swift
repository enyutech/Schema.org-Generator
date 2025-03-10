//
//  ArticleGeneratorView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/10/25.
//


import SwiftUI

struct ArticleGeneratorView: View {
    @ObservedObject var schemaData = SchemaData()
    @State private var jsonOutput: String = ""
    @State private var showJsonOutput: Bool = false
    @State private var enableDateModified: Bool = false // Toggle for Date Modified

    var body: some View {
        VStack {
            Text("Article Schema Generator")
                .font(.headline)
                .padding()
                .foregroundColor(.primary)

            // Article Type Picker
            HStack {
                Picker("Article Type:", selection: $schemaData.articleType) {
                    ForEach(["Article", "NewsArticle", "BlogPosting"], id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            // URL Input
            HStack {
                Text("URL:")
                    .frame(width: 120, alignment: .leading)
                TextField("Enter URL", text: $schemaData.articleURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // Headline Input
            HStack {
                Text("Headline:")
                    .frame(width: 120, alignment: .leading)
                TextField("Enter headline", text: $schemaData.headline)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
            }

            // Image Input
            VStack(alignment: .leading) {
                HStack {
                    Text("Image URLs:")
                        .frame(width: 385, alignment: .leading)
                    Button(action: { schemaData.articleImages.append("") }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Image")
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                }
                ForEach($schemaData.articleImages.indices, id: \.self) { index in
                    HStack {
                        TextField("Image URL #\(index + 1)", text: $schemaData.articleImages[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: { schemaData.articleImages.remove(at: index) }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }

            // Author Section
            VStack(alignment: .leading) {
                Text("Author Information")
                    .font(.title3)
                    .bold()
                HStack {
                    Picker("Author Type:", selection: $schemaData.authorType) {
                        ForEach(["Person", "Organization"], id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                HStack {
                    Text("Author Name:")
                        .frame(width: 120, alignment: .leading)
                    TextField("Author Name", text: $schemaData.authorName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Author URL:")
                        .frame(width: 120, alignment: .leading)
                    TextField("Author URL", text: $schemaData.authorURL)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.top, 10)

            // Publisher Section
            VStack(alignment: .leading) {
                Text("Publisher Information")
                    .font(.title3)
                    .bold()
                HStack {
                    Text("Publisher Name:")
                        .frame(width: 120, alignment: .leading)
                    TextField("Publisher", text: $schemaData.publisherName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Publisher Logo URL:")
                        .frame(width: 120, alignment: .leading)
                    TextField("Publisher Logo URL", text: $schemaData.publisherLogo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.top, 10)

            // Date Pickers
            HStack {
                Text("Date Published:")
                    .frame(width: 120, alignment: .leading)
                DatePicker("", selection: $schemaData.datePublished, displayedComponents: .date)
                    .labelsHidden()
                
                Spacer()
                
                if enableDateModified {
                    HStack {
                        Text("Date Modified:")
                            .frame(width: 120, alignment: .leading)
                        DatePicker("", selection: Binding(
                            get: { schemaData.dateModified ?? Date() },
                            set: { schemaData.dateModified = $0 }
                        ), displayedComponents: .date)
                        .labelsHidden()
                    }
                }
            }
            .padding(.top, 10)

            // Toggle and Date Modified Picker
            Toggle("Include Date Modified", isOn: $enableDateModified)
                .padding(.top, 10)


            Spacer()
            
            // Generate JSON-LD Button
            HStack {
                Button("Generate JSON-LD") {
                    generateJsonLD()
                    showJsonOutput = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Button("Copy") { copyToClipboard() }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
            }

        }
        .frame(width: 500)
        .padding()
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    private func generateJsonLD() {
        var jsonDict: [String: Any] = [
            "@context": "https://schema.org",
            "@type": schemaData.articleType,
            "headline": schemaData.headline,
            "image": schemaData.articleImages.count == 1 ? schemaData.articleImages.first! : schemaData.articleImages,
            "author": [
                "@type": schemaData.authorType,
                "name": schemaData.authorName
            ],
            "publisher": [
                "@type": "Organization",
                "name": schemaData.publisherName,
                "logo": [
                    "@type": "ImageObject",
                    "url": schemaData.publisherLogo
                ]
            ],
            "datePublished": formatDate(schemaData.datePublished)
        ]

        // Conditionally add dateModified only if the toggle is enabled
        if enableDateModified, let dateModified = schemaData.dateModified {
            jsonDict["dateModified"] = formatDate(dateModified)
        }
        
        // Remove empty values
        jsonDict = jsonDict.filter { !("\($0.value)" == "" || $0.value is [String] && ($0.value as! [String]).isEmpty) }

        // Convert to JSON String
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonOutput = """
            <script type="application/ld+json">
            \(jsonString)
            </script>
            """
            showJsonOutput = true
        }
    }

    private func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(jsonOutput, forType: .string)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
