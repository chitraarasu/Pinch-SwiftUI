//
//  PageModel.swift
//  Pinch
//
//  Created by kirshi on 2/18/23.
//

import Foundation

struct Page : Identifiable{
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailImage: String {
        return "thumb-" + imageName
    }
}
