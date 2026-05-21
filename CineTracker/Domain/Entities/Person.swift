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
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: birthday)
    }

    var lifeStatus: String? {
        guard birthday != nil else { return nil }
        if let deathday = deathday {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return "Đã mất ngày \(formatter.string(from: deathday))"
        }
        if let age = age {
            return "\(age) tuổi"
        }
        return nil
    }

    var departmentTitle: String {
        switch knownForDepartment.lowercased() {
        case "acting": return "Diễn viên"
        case "directing": return "Đạo diễn"
        case "writing": return "Biên kịch"
        case "production": return "Sản xuất"
        case "camera": return "Quay phim"
        case "editing": return "Dựng phim"
        case "sound": return "Âm thanh"
        case "art": return "Mỹ thuật"
        default: return knownForDepartment
        }
    }
}
