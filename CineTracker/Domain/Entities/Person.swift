//
//  Person.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct Person: Identifiable, Hashable {
    let id: Int
    let name: String
    let biography: String
    let birthday: Date?
    let deathday: Date?
    let placeOfBirth: String?
    let profileURL: URL?
    let knownForDepartment: String
    let popularity: Double

    var age: Int? {
        guard let birthday = birthday else { return nil }
        let endDate = deathday ?? Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: birthday, to: endDate)
        return components.year
    }

    var formattedBirthday: String? {
        guard let birthday = birthday else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: L10n.Person.birthdayLocale)
        return formatter.string(from: birthday)
    }

    var lifeStatus: String? {
        guard birthday != nil else { return nil }
        if let deathday = deathday {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return L10n.Person.deceasedOn(formatter.string(from: deathday))
        }
        if let age = age {
            return L10n.Person.ageYears(age)
        }
        return nil
    }

    var departmentTitle: String {
        switch knownForDepartment.lowercased() {
        case "acting": return L10n.Person.departmentActing
        case "directing": return L10n.Person.departmentDirecting
        case "writing": return L10n.Person.departmentWriting
        case "production": return L10n.Person.departmentProduction
        case "camera": return L10n.Person.departmentCamera
        case "editing": return L10n.Person.departmentEditing
        case "sound": return L10n.Person.departmentSound
        case "art": return L10n.Person.departmentArt
        default: return knownForDepartment
        }
    }
}
