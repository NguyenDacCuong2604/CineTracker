//
//  CastDetailState.swift
//  CineTracker
//
//  Created by MAC VN on 21/5/26.
//

import Foundation

struct CastDetailState {
    var person: SectionState<Person> = .idle
    var credits: SectionState<PersonMovieCredit> = .idle
    var isRefreshing: Bool = false
}
