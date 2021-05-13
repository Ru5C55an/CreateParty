//
//  PermissionsService.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 03.05.2021.
//

import SPPermissions

class PermissionsService {
    
    static let shared = PermissionsService()
    
    func showPermissions(parent: UIViewController) {
        
        let controller = SPPermissions.dialog([.camera, .photoLibrary, .contacts, .locationWhenInUse])

        // Ovveride texts in controller
        controller.titleText = "Необходим доступ к следующим данным"
        controller.headerText = "Запрос разрешений"
        controller.footerText = "В случае, если разрешение не было получено, то данный функционал будет недоступен. Вы можете в любой момент изменить настройки разрешений в меню Профиль"

        // Set `DataSource` or `Delegate` if need.
        // By default using project texts and icons.
        controller.dataSource = self
        controller.delegate = self

        // Always use this method for present
        controller.present(on: parent)
    }
    
    func showOnePermissonRequest(parent: UIViewController, permission: SPPermission) {
        let controller = SPPermissions.native([permission])

        // Set `Delegate` if need.
        controller.delegate = self

        // Always use this method for request.
        // You can pass any controller, this request because need implement base protocol.
        controller.present(on: parent)
    }
}

// MARK: - SPPermissionsDelegate, SPPermissionsDataSource
extension PermissionsService: SPPermissionsDelegate, SPPermissionsDataSource {
    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        
        switch permission {
        
        case .camera:
            // Titles
            cell.permissionTitleLabel.text = "Камера"
            cell.permissionDescriptionLabel.text = "Чтобы устанавливать фото профиля или вечеринки"
            cell.button.allowTitle = "Нет"
            cell.button.allowedTitle = "Да"

            // Colors
            cell.iconView.color = .systemBlue
            cell.button.allowedBackgroundColor = .systemBlue
            cell.button.allowTitleColor = .systemBlue
        case .photoLibrary:
//             Titles
            cell.permissionTitleLabel.text = "Фото"
            cell.permissionDescriptionLabel.text = "Чтобы сохранять сделанные фото"
            cell.button.allowTitle = "Нет"
            cell.button.allowedTitle = "Да"

            // Colors
            cell.iconView.color = .systemBlue
            cell.button.allowedBackgroundColor = .systemBlue
            cell.button.allowTitleColor = .systemBlue
        case .microphone:
            break
        case .calendar:
            break
        case .contacts:
            // Titles
            cell.permissionTitleLabel.text = "Контакты"
            cell.permissionDescriptionLabel.text = "Чтобы выбирать контакты, если захотите поделиться приложением"
            cell.button.allowTitle = "Нет"
            cell.button.allowedTitle = "Да"

            // Colors
            cell.iconView.color = .systemBlue
            cell.button.allowedBackgroundColor = .systemBlue
            cell.button.allowTitleColor = .systemBlue
        case .reminders:
            break
        case .speech:
            break
        case .locationAlwaysAndWhenInUse:
            break
        case .motion:
            break
        case .mediaLibrary:
            break
        case .bluetooth:
            break
        case .notification:
//             Titles
            cell.permissionTitleLabel.text = "Уведомления"
            cell.permissionDescriptionLabel.text = "Чтобы уведомлять о самых важных событиях"
            cell.button.allowTitle = "Нет"
            cell.button.allowedTitle = "Да"

            // Colors
            cell.iconView.color = .systemBlue
            cell.button.allowedBackgroundColor = .systemBlue
            cell.button.allowTitleColor = .systemBlue
        case .locationWhenInUse:
            // Titles
            cell.permissionTitleLabel.text = "Местоположение"
            cell.permissionDescriptionLabel.text = "Чтобы устанавливать место проведения вечеринки"
            cell.button.allowTitle = "Нет"
            cell.button.allowedTitle = "Да"
            // Colors
            cell.iconView.color = .systemBlue
            cell.button.allowedBackgroundColor = .systemBlue
            cell.button.allowTitleColor = .systemBlue
        case .tracking:
            break
        }

        // If you want set custom image.
//        cell.set(UIImage(named: "IMAGE-NAME")!)
        
        return cell
    }
}


