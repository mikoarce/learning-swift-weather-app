//
//  NativeExtensions.swift
//  Clima
//

import Foundation

///
///    Formats Float to a String where f is the decimal places to print
///    Ex.
///        myPi = 3.14159265359
///        myPi.format(format: ".3") = 3.142
///
extension Float {
    func format(val: String) -> String {
        return String(format: "%\(val)f", self)
    }
}

///
///  Formats Double to a String where f is the decimal places to print
///  Ex.
///      myPi = 3.14159265359
///      myPi.format(format: ".3") = 3.142
///
extension Double {
    func format(val: String) -> String {
        return String(format: "%\(val)f", self)
    }
}
