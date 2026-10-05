//
//  IndexStoreSymbol+.swift
//
//
//  Created by p-x9 on 2024/06/14
//
//

import Foundation
import SwiftIndexStore

extension IndexStoreSymbol {
    var demangledName: String? {
        guard let usr else { return nil }

        // swift symbol
        if usr.hasPrefix("s:") {
            let index = usr.lastIndex(of: ":").map { usr.index($0, offsetBy: -1) }
            if let index {
                var symbol = String(usr[index...])
                symbol.replaceSubrange(symbol.startIndex...symbol.index(symbol.startIndex, offsetBy: 1), with: "$S")
                return stdlib_demangleName(symbol)
            }
        }
        return stdlib_demangleName(usr)
    }
}

extension IndexStoreSymbol {
    public func matches(
        target: RestrictedTarget
    ) -> Bool {
        let demangledName = demangledName ?? name ?? usr ?? ""

        if target.module == "Examples" || target.type?.contains("UIColor") == true || target.module?.contains("UIColor") == true {
            print("DEBUG MATCH: name=\(name ?? "nil"), demangled=\(demangledName)")
            print("DEBUG MATCH: target.module=\(target.module ?? "nil")")
            print("DEBUG MATCH: target.type=\(target.type ?? "nil")")
            print("DEBUG MATCH: target.demangledNamePattern=\(target.demangledNamePattern)")
            print("DEBUG MATCH: target.name=\(target.name)")
        }

        let matchResult = demangledName.matches(pattern: target.demangledNamePattern)
        let debugCondition = target.module == "Examples" || target.type?.contains("UIColor") == true || target.module?.contains("UIColor") == true
        if debugCondition {
            print("DEBUG MATCH: matchResult=\(matchResult)")
        }
        if matchResult {
            if debugCondition {
                print("DEBUG MATCH: MATCHED by demangledNamePattern")
            }
            return true
        }

        let prefix = [target.module, target.type].compactMap(\.self).joined(separator: ".")
        if let name,
           !prefix.isEmpty,
           demangledName.hasPrefix(prefix),
           name.matches(pattern: target.name)
        {
            if debugCondition {
                print("DEBUG MATCH: MATCHED by prefix")
            }
            return true
        }

        if debugCondition {
            print("DEBUG MATCH: prefix=\(prefix), hasPrefix=\(demangledName.hasPrefix(prefix))")
            if let name {
                print("DEBUG MATCH: name.matches(pattern)=\(name.matches(pattern: target.name))")
            }
        }

        if let name,
           let targetModule = target.module,
           demangledName.hasPrefix("(extension in \(targetModule))"),
           name.matches(pattern: target.name) {
            if debugCondition {
                print("DEBUG MATCH: MATCHED by extension")
            }
            return true
        }

        if let name,
           let targetModule = target.module,
           let targetType = target.type,
           name.matches(pattern: target.name) {
            let whereClausePattern = "where .* == \(targetModule)\\.\(targetType)\\>"
            if demangledName.matches(pattern: whereClausePattern) {
                if debugCondition {
                    print("DEBUG MATCH: MATCHED by where clause pattern")
                }
                return true
            }
        }

        // Match when type is nil and module is regex pattern
        if let name,
           let targetModule = target.module,
           target.type == nil,
           demangledName.matches(pattern: targetModule),
           name.matches(pattern: target.name) {
            if debugCondition {
                print("DEBUG MATCH: MATCHED by module regex + name pattern")
            }
            return true
        }

        return false
    }
}
