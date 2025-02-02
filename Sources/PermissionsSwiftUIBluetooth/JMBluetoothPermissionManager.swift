//
//  JMBluetoothPermissionManager.swift
//
//
//  Created by Jevon Mao on 1/31/21.
//

import CoreBluetooth
import UIKit
import CorePermissionsSwiftUI

@available(iOS 13.0, tvOS 13.0, *)
public extension PermissionType.PermissionManager {
    static let bluetooth = JMBluetoothPermissionManager()
}

@available(iOS 13.0, tvOS 13.0, *)
final public class JMBluetoothPermissionManager: PermissionType.PermissionManager {
    private var completion: ((Bool, Error?) -> Void)?
    private var manager: CBCentralManager?
    
    public override var permissionType: PermissionType {
        .bluetooth
    }

    public override var authorizationStatus: AuthorizationStatus {
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .allowedAlways:
                return .authorized
            case .notDetermined:
                return .notDetermined
            default:
                return .denied
            }
        } else {
            switch CBCentralManager().authorization {
            case .allowedAlways:
                return .authorized
            case .notDetermined:
                return .notDetermined
            default:
                return .denied
            }
        }
    }

    public override func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
        self.completion = completion
        if self.authorizationStatus != .authorized {
            self.manager = CBCentralManager(delegate: self, queue: nil)
        }
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension JMBluetoothPermissionManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.authorization {
        case .notDetermined:
            break
        case .allowedAlways:
            self.completion?(true, nil)
        default:
            self.completion?(false, nil)
        }
    }
}
