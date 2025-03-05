//
//  SchemaData.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//


import SwiftUI

class SchemaData: ObservableObject {
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var description: String = ""
    @Published var disambiguatingDescription: String = ""
    @Published var socialProfiles: String = ""
    @Published var imageUrl: String = ""
    @Published var telephone: String = ""
    @Published var openingHours: String = ""
    @Published var paymentAccepted: String = ""
    @Published var priceRange: String = ""
    @Published var slogan: String = ""

    // Address
    @Published var streetAddress: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var postalCode: String = ""
    @Published var country: String = ""

    // Legal Expertise & Services
    @Published var knowsAbout: String = ""
    @Published var aggregateRating: String = ""
    @Published var reviewCount: String = ""
    @Published var foundingDate: String = ""

    // Founder Details (Expanded)
    @Published var founderName: String = ""
    @Published var founderUrl: String = ""
    @Published var founderDescription: String = ""
    @Published var founderDisambiguatingDescription: String = ""
    @Published var founderImage: String = ""
    @Published var founderTelephone: String = ""
    @Published var founderKnowsAbout: String = ""
    @Published var founderKnowsLanguage: String = ""
    @Published var founderNationality: String = ""
    @Published var founderGender: String = ""
    @Published var founderWorkLocation: String = ""
    @Published var founderJobTitle: String = ""
}
