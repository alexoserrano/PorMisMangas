//
//  PaginationState.swift
//  PorMisMangas
//
//  Created by Alejandro Serrano on 19/02/26.
//

import Foundation

struct PaginationState: Sendable {
    var currentPage: Int = 1
    var itemsPerPage: Int = 16
    var totalItems: Int = 0
    var isLoading: Bool = false
    var hasMorePages: Bool {
        currentPage * itemsPerPage < totalItems
    }
    
    var totalPages: Int {
        guard itemsPerPage > 0 else { return 0 }
        return (totalItems + itemsPerPage - 1) / itemsPerPage
    }
    
    var startItem: Int {    //Calcular número de mangas inicio dependiendo la página
        guard totalItems > 0 else { return 0 }
        return (currentPage - 1) * itemsPerPage + 1
    }
    
    var endItem: Int { //Calcular número de mangas fin dependiendo la página
        guard totalItems > 0 else { return 0 }
        let calculatedEnd = currentPage * itemsPerPage
        return min(calculatedEnd, totalItems)
    }
    
    mutating func updateWith(metadata: Metadata) {
        currentPage = metadata.page
        itemsPerPage = metadata.per
        totalItems = metadata.total
    }
    
    mutating func nextPage() {
        guard hasMorePages else { return }
        currentPage += 1
    }
    
    mutating func previousPage() {
        guard currentPage > 1 else { return }
        currentPage -= 1
    }
    
    mutating func goToPage(_ page: Int) {
        guard page > 0, page <= totalPages else { return }
        currentPage = page
    }
    
    mutating func reset() {
        currentPage = 1
        totalItems = 0
        isLoading = false
    }
}
