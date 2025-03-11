//
//  OperatingHoursView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/7/25.
//


import SwiftUI
import Foundation

struct OperatingHoursView: View {
    @Binding var openingHours: [OpeningHour]
    @State private var isOpen24_7: Bool = false

    var body: some View {
        VStack {
            Text("Operating Hours")
                .font(.headline)
                .padding(.bottom, 5)

            // Toggle for 24/7 Operation
            Toggle("Open 24/7", isOn: $isOpen24_7)
                .onChange(of: isOpen24_7) { newValue in
                    if newValue {
                        // Set full-week schedule
                        openingHours = [OpeningHour(
                            days: Weekday.allCases,
                            opensAt: "00:00",
                            closesAt: "23:59"
                        )]
                    } else {
                        // Allow custom input
                        openingHours.removeAll()
                    }
                }
                .padding(.bottom, 10)

            // Show operating hours form only when NOT 24/7
            if !isOpen24_7 {
                Button(action: addOperatingHour) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Opening Hours")
                    }
                    .padding()
                    .cornerRadius(8)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(.bottom, 10)
            }

            ForEach($openingHours.indices, id: \.self) { index in
                HStack {
                    // Day Selector Dropdown
                    Menu {
                        ForEach(Weekday.allCases, id: \.self) { day in
                            Button(action: {
                                toggleDaySelection(index: index, day: day)
                            }) {
                                HStack {
                                    Text(day.rawValue)
                                    if openingHours[index].days.contains(day) {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Text(openingHours[index].days.isEmpty ? "Select Days" : openingHours[index].days.map { $0.rawValue }.joined(separator: ", "))
                            .frame(width: 150)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }

                    // Time Inputs
                    TextField("Opens at (e.g. 08:00)", text: $openingHours[index].opensAt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)

                    TextField("Closes at (e.g. 21:00)", text: $openingHours[index].closesAt)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)

                    // Remove Entry Button
                    Button(action: { removeOperatingHour(at: index) }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .frame(width: 500)
        .padding()
        .onAppear {
            // Check if the data is already 24/7
            isOpen24_7 = openingHours.count == 1 &&
                         openingHours.first?.days.count == 7 &&
                         openingHours.first?.opensAt == "00:00" &&
                         openingHours.first?.closesAt == "23:59"
        }
    }

    private func addOperatingHour() {
        withAnimation {
            openingHours.append(OpeningHour(days: [], opensAt: "", closesAt: ""))
        }
    }

    private func removeOperatingHour(at index: Int) {
        withAnimation {
            openingHours.remove(at: index)
        }
    }

    private func toggleDaySelection(index: Int, day: Weekday) {
        if let existingIndex = openingHours[index].days.firstIndex(of: day) {
            openingHours[index].days.remove(at: existingIndex)
        } else {
            openingHours[index].days.append(day)
        }
    }
}
