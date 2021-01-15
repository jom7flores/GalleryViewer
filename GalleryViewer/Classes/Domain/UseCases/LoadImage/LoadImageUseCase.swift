//
//  LoadImageUseCase.swift
//  GalleryViewer
//
//  Created by Josue Inchaurregui on 1/14/21.
//

import Combine
import UIKit

protocol LoadImageUseCase {
    func start(imageId: String) -> AnyPublisher<UIImage?, Never>
}
