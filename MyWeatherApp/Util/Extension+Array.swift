//
//  Extension+Array.swift
//  MyWeatherApp
//
//  Created by UnoEast on 4/15/20.
//  Copyright © 2020 DahmeyonMcDonald. All rights reserved.
//

import UIKit

extension Array {

    func filterDuplicates(_ includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()

        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }

        return results
    }
}
