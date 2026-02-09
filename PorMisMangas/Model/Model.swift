//
//  Model.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 09/02/26.
//

import Foundation

struct Mangas: Codable {
    let items: [Manga]
    let metadata: Metadata
}

struct Manga: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    let url: URL?
    let mainPicture: URL?
    let sypnosis: String?
    let score: Double
    let status: Status
    let startDate: String
    let endDate: String?
    let volumes: Int?
    let chapters: Int?
    let background: String?
    let authors: [Author]
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]
    
    enum Status: String, Codable, Sendable {
        case currentlyPublishing = "currently_publishing"
        case discontinued = "discontinued"
        case finished = "finished"
        case onHiatus = "on_hiatus"
        case unknown = "Unknown"
    }
    
    struct Author: Codable, Hashable {
        let id: UUID
        let firstName: String
        let lastName: String
        let role: Role
    }
    
    enum Role: String, Codable {
        case art = "Art"
        case story = "Story"
        case storyArt = "Story & Art"
        case unknown = "Unknown"
    }
    
    struct Genre: Codable, Hashable {
        let id: UUID
        let genre: GenreEnum
    }
    
    enum GenreEnum: String, Codable, Sendable {
        case action = "Action"
        case adventure = "Adventure"
        case avantGarde = "Avant Garde"
        case awardWinning = "Award Winning"
        case boysLove = "Boys Love"
        case comedy = "Comedy"
        case drama = "Drama"
        case ecchi = "Ecchi"
        case erotica = "Erotica"
        case fantasy = "Fantasy"
        case girlsLove = "Girls Love"
        case gourmet = "Gourmet"
        case hentai = "Hentai"
        case horror = "Horror"
        case mystery = "Mystery"
        case romance = "Romance"
        case sciFi = "Sci-Fi"
        case sliceOfLife = "Slice of Life"
        case sports = "Sports"
        case supernatural = "Supernatural"
        case suspense = "Suspense"
        case unknown = "Unknown"
    }
    
    struct Theme: Codable, Hashable {
        let id: UUID
        let theme: ThemeEnum
    }
    
    enum ThemeEnum: String, Codable {
        case adultCast = "Adult Cast"
        case anthropomorphic = "Anthropomorphic"
        case cgdct = "CGDCT"
        case childcare = "Childcare"
        case combatSports = "Combat Sports"
        case crossdressing = "Crossdressing"
        case delinquents = "Delinquents"
        case detective = "Detective"
        case educational = "Educational"
        case gagHumor = "Gag Humor"
        case gore = "Gore"
        case harem = "Harem"
        case highStakesGame = "High Stakes Game"
        case historical = "Historical"
        case idolsFemale = "Idols (Female)"
        case idolsMale = "Idols (Male)"
        case isekai = "Isekai"
        case iyashikei = "Iyashikei"
        case lovePolygon = "Love Polygon"
        case magicalSexShift = "Magical Sex Shift"
        case mahouShoujo = "Mahou Shoujo"
        case martialArts = "Martial Arts"
        case mecha = "Mecha"
        case medical = "Medical"
        case memoir = "Memoir"
        case military = "Military"
        case music = "Music"
        case mythology = "Mythology"
        case organizedCrime = "Organized Crime"
        case otakuCulture = "Otaku Culture"
        case parody = "Parody"
        case performingArts = "Performing Arts"
        case pets = "Pets"
        case psychological = "Psychological"
        case racing = "Racing"
        case reincarnation = "Reincarnation"
        case reverseHarem = "Reverse Harem"
        case romanticSubtext = "Romantic Subtext"
        case samurai = "Samurai"
        case school = "School"
        case showbiz = "Showbiz"
        case space = "Space"
        case strategyGame = "Strategy Game"
        case superPower = "Super Power"
        case survival = "Survival"
        case teamSports = "Team Sports"
        case timeTravel = "Time Travel"
        case vampire = "Vampire"
        case videoGame = "Video Game"
        case villainess = "Villainess"
        case visualArts = "Visual Arts"
        case workplace = "Workplace"
        case unknown = "Unknown"
    }
        
    struct Demographic: Codable, Hashable {
        let id: UUID
        let demographic: DemographicEnum
    }
    
    enum DemographicEnum: String, Codable {
        case josei = "Josei"
        case kids = "Kids"
        case seinen = "Seinen"
        case shoujo = "Shoujo"
        case shounen = "Shounen"
        case unknown = "Unknown"
    }
    
}

struct Metadata: Codable {
    let per: Int
    let page: Int
    let total: Int
}

extension Manga {
    var formattedScore: String {
        String(format: "%.2f", score)
    }
    var formattedStartDate: String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: startDate) else {
            return startDate
        }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
    var formattedEndDate: String? {
        guard let endDate = endDate else { return nil }
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: endDate) else {
            return endDate
        }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}

extension Manga.Status: CaseIterable {
    var localizedName: String {
        switch self {
        case .currentlyPublishing: return "Currently Publishing"
        case .discontinued: return "Discontinued"
        case .finished: return "Finished"
        case .onHiatus: return "On Hiatus"
        case .unknown: return "Unknown"
        }
    }
}

extension Manga.GenreEnum: CaseIterable {}
extension Manga.ThemeEnum: CaseIterable {}
extension Manga.DemographicEnum: CaseIterable {}

let mangaTest = Manga(
    id: 155,
    title: "Brain Powerd",
    titleEnglish: "Brain Powered",
    titleJapanese: "ブレンパワード",
    url: URL(string: "https://myanimelist.net/manga/155/Brain_Powerd"),
    mainPicture: URL(string: "https://cdn.myanimelist.net/images/manga/2/76769l.jpg"),
    sypnosis: "The discovery of an alien organic vessel submerged in the ocean reveals a plot to unleash planetary destruction... A collective of evil scientists called the Reclaimers works to hasten mankind's extinction. As one of Earth's defenders, Hime Utsumiya fights on a team of mecha called Brain Powered's to combat them. Unfortunately the Reclaimers also have these mecha and mankind's fate hangs in the balance.\n\n(Source: Tokyopop)",
    score: 6.29,
    status: Manga.Status.finished,
    startDate: "1997-11-26T00:00:00Z",
    endDate: "2000-10-26T00:00:00Z",
    volumes: 4,
    chapters: 18,
    background: "Brain Powerd was published in English as Brain Powered by Tokyopop from June 3, 2003 to January 1, 2004.",
    authors: [
        Manga.Author(id: UUID(uuidString: "43797A9F-7F29-42BD-89FE-90362A9EB3F3")!, firstName: "Yukiru", lastName: "Sugisaki", role: Manga.Role.storyArt),
        Manga.Author(id: UUID(uuidString: "45C831ED-908B-42C6-9E08-7B3C15BA2370")!, firstName: "Yoshiyuki", lastName: "Tomino", role: Manga.Role.story)
    ],
    genres: [
        Manga.Genre(id: UUID(uuidString: "BE70E289-D414-46A9-8F15-928EAFBC5A32")!, genre: Manga.GenreEnum.adventure),
        Manga.Genre(id: UUID(uuidString: "4312867C-1359-494A-AC46-BADFD2E1D4CD")!, genre: Manga.GenreEnum.drama),
        Manga.Genre(id: UUID(uuidString: "2DEDC015-82DA-4EF4-B983-F0F58C8F689E")!, genre: Manga.GenreEnum.sciFi)
    ],
    themes: [
        Manga.Theme(id: UUID(uuidString: "AAF43F3B-1B60-4F80-B7DA-9B1C6BFD1AA9")!, theme: Manga.ThemeEnum.mecha)
    ],
    demographics: [
        Manga.Demographic(id: UUID(uuidString: "5E05BBF1-A72E-4231-9487-71CFE508F9F9")!, demographic: Manga.DemographicEnum.shounen)
    ]
)
