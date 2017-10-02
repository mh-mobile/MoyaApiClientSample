//
//  WebApiRequestType.swift
//
//  Created by maru on 2017/09/19.
//

import Foundation
import Moya

protocol WebApiRequestType: TargetType {
    associatedtype ResponseType: Codable
}
