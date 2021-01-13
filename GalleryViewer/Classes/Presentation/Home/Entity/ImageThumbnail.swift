//
//  ImageThumbnail.swift
//  GalleryViewer
//
//  Created by Josue Flores on 1/12/21.
//

import CoreLocation
import UIKit

struct ImageThumbnail {
    let id: String
    let dateAdded: Date
    let location: CLLocationCoordinate2D?
    var resource: UIImage?
}
