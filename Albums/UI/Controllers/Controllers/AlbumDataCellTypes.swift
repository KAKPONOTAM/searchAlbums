import Foundation

enum AlbumDataSection: CaseIterable {
    case descriptionSection
    case trackNameSection
    
    static func getSection(index: Int) -> Self {
        return allCases[index]
    }
}

enum AlbumDataCellTypes: CaseIterable {
    case albumName
    case groupName
    case albumReleaseDate

    static func getRow(index: Int) -> Self {
        return allCases[index]
    }
}
