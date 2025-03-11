//
//  FAQGeneratorView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/10/25.
//


import SwiftUI
import AppKit // Required for clipboard functionality

struct FAQGeneratorView: View {
    @StateObject private var schemaData = SchemaData() // Store FAQ items in SchemaData
    @State private var showJsonOutput = false
    @State private var jsonOutput: String = ""

    var body: some View {
        VStack {
            Text("FAQ Schema Generator")
                .font(.headline)
                .padding()
                .foregroundColor(.primary)

            List {
                ForEach($schemaData.faqItems.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Question #\(index + 1)")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.gray)

                        TextField("Enter Question", text: $schemaData.faqItems[index].question)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("Answer")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.gray)

                        TextField("Enter Answer", text: $schemaData.faqItems[index].answer)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        if schemaData.faqItems.count > 1 {
                            Button(action: { removeQuestion(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.borderless)
                            .padding(.top, 5)
                        }
                    }
                    .padding(.vertical, 5)
                }
            }

            Button(action: addQuestion) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Question")
                }
                .padding()
                .cornerRadius(8)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.bottom, 10)

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
            .padding()

        }
        .sheet(isPresented: $showJsonOutput) {
            JsonOutputView(jsonOutput: $jsonOutput)
        }
    }

    private func addQuestion() {
        schemaData.faqItems.append(FAQItem(question: "", answer: ""))
    }

    private func removeQuestion(at index: Int) {
        schemaData.faqItems.remove(at: index)
    }

    private func generateJsonLD() {
        struct FAQSchema: Codable {
            let context: String
            let type: String
            let mainEntity: [FAQQuestion]

            enum CodingKeys: String, CodingKey {
                case context = "@context"
                case type = "@type"
                case mainEntity
            }
        }

        struct FAQQuestion: Codable {
            let type: String
            let name: String
            let acceptedAnswer: FAQAnswer

            enum CodingKeys: String, CodingKey {
                case type = "@type"
                case name
                case acceptedAnswer
            }
        }

        struct FAQAnswer: Codable {
            let type: String
            let text: String

            enum CodingKeys: String, CodingKey {
                case type = "@type"
                case text
            }
        }

        let context = "https://schema.org"

        let questions = schemaData.faqItems.map { FAQQuestion(type: "Question", name: $0.question, acceptedAnswer: FAQAnswer(type: "Answer", text: $0.answer)) }

        let faqSchema = FAQSchema(context: context, type: "FAQPage", mainEntity: questions)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        if let jsonData = try? encoder.encode(faqSchema),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonOutput = """
            <script type="application/ld+json">
            \(jsonString)
            </script>
            """
        } else {
            jsonOutput = """
            <script type="application/ld+json">
            {}
            </script>
            """
        }
    }

    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(jsonOutput, forType: .string)
    }
}
