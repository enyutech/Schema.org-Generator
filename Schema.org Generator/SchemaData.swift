//
//  SchemaData.swift
//  Schema.org Generator
//
//  Created by David Rodriguez on 3/5/25.
//

import SwiftUI

class SchemaData: ObservableObject {
    @Published var id: String = "" // Ensure this exists
    @Published var name: String = ""
    @Published var url: String = ""
    @Published var description: String = ""
    @Published var disambiguatingDescription: String = ""
    @Published var socialProfiles: [String] = [""]
    @Published var imageUrl: String = ""
    @Published var telephone: String = ""
    @Published var openingHours: [OpeningHour] = []
    @Published var paymentAccepted: String = ""
    @Published var priceRange: String = ""
    @Published var slogan: String = ""

    // Selectable Business Types
    @Published var businessType: String = "LocalBusiness"

    let businessTypes: [String] = [
        "LocalBusiness", "AnimalShelter", "ArchiveOrganization", "AutomotiveBusiness",
        "ChildCare", "Dentist", "DryCleaningOrLaundry", "EmergencyService",
        "EmploymentAgency", "EntertainmentBusiness", "FinancialService", "FoodEstablishment",
        "GovernmentOffice", "HealthAndBeautyBusiness", "HomeAndConstructionBusiness",
        "InternetCafe", "LegalService", "Library", "LodgingBusiness",
        "MedicalBusiness", "ProfessionalService", "RadioStation", "RealEstateAgent",
        "RecyclingCenter", "SelfStorage", "ShoppingCenter", "SportsActivityLocation",
        "Store", "TelevisionStation", "TouristInformationCenter", "TravelAgency"
    ]

    // Address
    @Published var streetAddress: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var postalCode: String = ""
    @Published var country: String = ""

    // Legal Expertise & Services
    @Published var knowsAbout: [String] = [""]
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

    // LocalBusiness-Specific Fields
    @Published var currenciesAccepted: String = ""
    @Published var servesCuisine: String = ""
    @Published var geoLatitude: Double = 0.0  // Changed to Double for compatibility
    @Published var geoLongitude: Double = 0.0 // Changed to Double for compatibility
    @Published var hasMap: String = ""
    @Published var departments: [Department] = []
    @Published var reviews: [Review] = []
    
    // FAQ Storage
    @Published var faqItems: [FAQItem] = []
    
    @Published var websiteSchema = WebsiteSchema()
    
    @Published var personName: String = ""
    @Published var personUrl: String = ""
    @Published var personImageUrl: String = ""
    @Published var personJobTitle: String = ""
    @Published var personCompany: String = ""
    @Published var personSocialProfiles: [String] = []
}

// Enum for days of the week
enum Weekday: String, CaseIterable, Codable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
}


// Model for operating hours
struct OperatingHour: Identifiable {
    let id = UUID()
    var days: [Weekday] = []
    var opensAt: String = ""
    var closesAt: String = ""
}

// OpeningHour Struct
struct OpeningHour: Codable {
    var days: [Weekday]
    var opensAt: String
    var closesAt: String

    // Convert to OpeningHoursSpecification
    func toOpeningHoursSpecification() -> OpeningHoursSpecification {
        return OpeningHoursSpecification(
            type: "OpeningHoursSpecification",
            dayOfWeek: days.map { $0.rawValue },
            opens: opensAt,
            closes: closesAt
        )
    }
}

// Updated Department struct to conform to Codable
struct Department: Codable {
    var type: String
    var name: String
    var image: String?
    var telephone: String?
    var openingHoursSpecification: [OpeningHoursSpecification] // ✅ Ensure this exists

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case name, image, telephone, openingHoursSpecification
    }
}

// Updated Review struct to conform to Codable
struct Review: Identifiable, Codable {
    var id = UUID()
    var author: String = ""
    var rating: String = ""
    var reviewBody: String = ""
}

// GeoCoordinates Struct
struct GeoCoordinates: Codable {
    let type: String
    var latitude: Double
    var longitude: Double

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case latitude, longitude
    }
}

// Address Struct
struct Address: Codable {
    let type: String
    var streetAddress: String
    var addressLocality: String
    var addressRegion: String
    var postalCode: String
    var addressCountry: String

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case streetAddress, addressLocality, addressRegion, postalCode, addressCountry
    }
}

// OpeningHoursSpecification Struct
struct OpeningHoursSpecification: Codable {
    var type: String
    var dayOfWeek: [String]
    var opens: String
    var closes: String

    enum CodingKeys: String, CodingKey {
        case type = "@type"
        case dayOfWeek, opens, closes
    }
}

struct WebsiteSchema: Identifiable, Codable {
    var id = UUID()
    var name: String = ""
    var url: String = ""
    var searchUrl: String = ""
    var queryParam: String = ""
}

// Model for FAQ Items
struct FAQItem: Identifiable, Codable {
    var id = UUID()
    var question: String
    var answer: String
}

struct LocalBusinessSchema: Codable {
    let context: String
    var type: String
    var name: String
    var image: String
    var id: String
    var url: String
    var telephone: String
    var priceRange: String
    var address: Address  // ✅ Changed from [String: String] to Address
    var geo: GeoCoordinates // ✅ Changed from [String: Double] to GeoCoordinates
    var openingHoursSpecification: [OpeningHoursSpecification] // ✅ Fully Codable
    var sameAs: [String]
    var department: [Department]  // ✅ Ensure Department is Codable

    enum CodingKeys: String, CodingKey {
        case context = "@context"
        case type = "@type"
        case name, image, id = "@id", url, telephone, priceRange, address, geo, openingHoursSpecification, sameAs, department
    }
}
