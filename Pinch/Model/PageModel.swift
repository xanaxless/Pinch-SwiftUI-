//
//  PageModel.swift
//  Pinch
//
//  Created by Yerkebulan Serikov on 17.04.2022.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page{
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
