//
//  NativeExtensions.swift
//  Clima
//
//  Created by Miko Arce on 2018-03-22.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

/*
    Formats Float to a String where f is the decimal places to print
    Ex.
        myPi = 3.14159265359
        myPi.format(format: ".3") = 3.142
 */
extension Float {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

/*
     Formats Double to a String where f is the decimal places to print
     Ex.
         myPi = 3.14159265359
         myPi.format(format: ".3") = 3.142
 */
extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
