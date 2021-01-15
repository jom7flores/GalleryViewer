//
//  ImageThumbnail.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import Combine
import CoreLocation
import UIKit

struct ImageThumbnail {
    let id: String
    let dateAdded: Date?
    let location: CLLocationCoordinate2D?
    var isFavorite: Bool
    let resourceSubject: CurrentValueSubject<ResourceState, Never>

    init(
        id: String,
        dateAdded: Date?,
        location: CLLocationCoordinate2D?,
        resourceState: ResourceState,
        isFavorite: Bool
    ) {
        self.id = id
        self.dateAdded = dateAdded
        self.location = location
        self.resourceSubject = .init(resourceState)
        self.isFavorite = isFavorite
    }
}

enum ResourceState {
    case none
    case loading
    case loaded(UIImage?)

    var resource: UIImage? {
        switch self {
        case let .loaded(image):
            return image
        default:
            return nil
        }
    }
}

extension ResourceState: Equatable {}
