//
//  TMDbResponse.swift
//  TMDb
//
//  Created by Alexander Losikov on 11/16/19.
//  Copyright © 2019 Alexander Losikov. All rights reserved.
//

import Foundation

enum TMDbResponse<DataType> {
    case data(DataType)
    case error(Error)
}
