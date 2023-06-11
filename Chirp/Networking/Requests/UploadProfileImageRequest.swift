//
//  UploadProfileImageRequest.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/10/23.
//

import Foundation

struct UploadProfileImageRequest: Encodable {
    let userID: String
    let imageData: Data
    let imageExtension: String
    let timestamp: String
}
