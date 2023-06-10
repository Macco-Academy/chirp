//
//  AppError.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 10.06.23.
//

import Foundation

enum AppError: Error, LocalizedError {
    case errorDecoding
    case unknownError
    case invalidUrl
    case unauthorizedAccess
    case imageUploadFailed
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Response could not be decoded"
        case .unknownError:
            return "Oops!!! Something went wrong"
        case .invalidUrl:
            return "URL is invalid"
        case .unauthorizedAccess:
            return "Unauthorized Access!"
        case .imageUploadFailed:
            return "Error uploading image. Please try again later"
        case .serverError(let error):
            return error
        }
    }
}
