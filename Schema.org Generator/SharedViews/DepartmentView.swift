//
//  DepartmentView.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/7/25.
//

import SwiftUI

struct DepartmentView: View {
    @Binding var departments: [Department]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Departments")
                .font(.headline)
                .padding(.bottom, 5)

            Button(action: addDepartment) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Department")
                }
                .padding()
                .cornerRadius(8)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(.bottom, 10)

            ForEach($departments.indices, id: \.self) { index in
                departmentView(for: index)
            }
        }
        .padding()
    }

    private func departmentView(for index: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                TextField("Department Name", text: $departments[index].name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Image URL", text: Binding(
                    get: { departments[index].image ?? "" },
                    set: { departments[index].image = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Phone", text: Binding(
                    get: { departments[index].telephone ?? "" },
                    set: { departments[index].telephone = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(RoundedBorderTextFieldStyle())

                Menu {
                    ForEach(["LocalBusiness", "Attorney", "Notary"], id: \.self) { type in
                        Button(action: { departments[index].type = type }) {
                            Text(type)
                            if departments[index].type == type {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                } label: {
                    Text(departments[index].type)
                        .frame(width: 150)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }

                Button(action: { removeDepartment(at: index) }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            .padding(.vertical, 5)

            openingHoursView(for: index)
        }
        .padding(.vertical, 5)
        .border(Color.gray.opacity(0.5))
    }

    private func openingHoursView(for index: Int) -> some View {
        VStack(alignment: .leading) {
            Text("Opening Hours (Optional)")
                .font(.subheadline)
                .padding(.top, 5)

            Button(action: { addOpeningHours(to: index) }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Opening Hours")
                }
                .padding()
                .cornerRadius(8)
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
            }

            ForEach(departments[index].openingHoursSpecification.indices, id: \.self) { hourIndex in
                HStack {
                    MultiSelectPicker(selection: Binding(
                        get: { departments[index].openingHoursSpecification[hourIndex].dayOfWeek.compactMap { Weekday(rawValue: $0) } },
                        set: { newValue in
                            departments[index].openingHoursSpecification[hourIndex].dayOfWeek = newValue.map { $0.rawValue }
                        }
                    ))

                    TextField("Opens At (e.g. 09:00)", text: Binding(
                        get: { departments[index].openingHoursSpecification[hourIndex].opens },
                        set: { departments[index].openingHoursSpecification[hourIndex].opens = $0 }
                    ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)

                    TextField("Closes At (e.g. 17:00)", text: Binding(
                        get: { departments[index].openingHoursSpecification[hourIndex].closes },
                        set: { departments[index].openingHoursSpecification[hourIndex].closes = $0 }
                    ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120)

                    Button(action: { removeOpeningHours(from: index, at: hourIndex) }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }

    private func addDepartment() {
        withAnimation {
            departments.append(Department(type: "LocalBusiness", name: "", image: nil, telephone: nil, openingHoursSpecification: []))
        }
    }

    private func removeDepartment(at index: Int) {
        withAnimation {
            departments.remove(at: index)
        }
    }

    private func addOpeningHours(to index: Int) {
        withAnimation {
            departments[index].openingHoursSpecification.append(OpeningHoursSpecification(type: "", dayOfWeek: [""], opens: "", closes: ""))
        }
    }

    private func removeOpeningHours(from departmentIndex: Int, at hourIndex: Int) {
        withAnimation {
            departments[departmentIndex].openingHoursSpecification.remove(at: hourIndex)
        }
    }
}

// MultiSelectPicker for selecting days of the week
struct MultiSelectPicker: View {
    @Binding var selection: [Weekday]

    let allDays: [Weekday] = Weekday.allCases

    var body: some View {
        Menu {
            ForEach(allDays, id: \.self) { day in
                Button(action: {
                    if selection.contains(day) {
                        selection.removeAll { $0 == day }
                    } else {
                        selection.append(day)
                    }
                }) {
                    HStack {
                        Text(day.rawValue)
                        if selection.contains(day) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Text(selection.isEmpty ? "Select Days" : selection.map { $0.rawValue }.joined(separator: ", "))
                .frame(width: 200)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
        }
    }
}
