//
//  ColorAssets.swift
//  PartyMaker
//
//  Created by Руслан Садыков on 10.04.2021.
//

import UIKit

extension UIColor {
    
    static func mainWhite() -> UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
    }
}

//enum PersonalColors: String {
//    
//    case viceCity
//
//    var color: GradientView {
//        return GradientView(
//    }
//}

extension GradientView {
    public static var viceCity:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.2039215686, green: 0.5803921569, blue: 0.9019607843, alpha: 1), endColor: #colorLiteral(red: 0.9254901961, green: 0.431372549, blue: 0.6784313725, alpha: 1)) }
}

//extension CGColor {
//    public static var tabbarSelected:
//        CGColor { return UIColor(red: 0.227, green: 0.482, blue: 0.859, alpha: 1).cgColor }
//    public static var tabbarUnselected:
//        CGColor { return UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 1).cgColor }
//    public static var lightGreen:
//        CGColor { return UIColor(red: 112.0/255.0, green: 207.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor }
//    public static var lightRed:
//        CGColor { return UIColor(red: 235.0/255.0, green: 87.0/255.0, blue: 87.0/255.0, alpha: 1.0).cgColor }
//    public static var lightBlue:
//        CGColor { return UIColor(red: 58.0/255.0, green: 123.0/255.0, blue: 219.0/255.0, alpha: 1.0).cgColor }
//    public static var lightGray:
//        CGColor { return UIColor(red: 0.966, green: 0.966, blue: 0.966, alpha: 1).cgColor }
//    public static var darkGray:
//        CGColor { return UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1).cgColor }
//    public static var grayBackground:
//        CGColor { return UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1).cgColor }
//    public static var emptyStar:
//        CGColor { return UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0).cgColor }
//    public static var sizeLabelBackground:
//        CGColor { return UIColor(red: 0.529, green: 0.651, blue: 0.878, alpha: 1).cgColor }
//    public static var darkestGray:
//        CGColor { return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1).cgColor }
//    public static var lightShadow:
//        CGColor { return UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor }
//    public static var mapPopupHeaderShadow:
//        CGColor { return UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor }
//    public static var confirmAccountLabelGreen:
//        CGColor { return UIColor(red: 57.0/255.0, green: 192.0/255.0, blue: 114.0/255.0, alpha: 1.0).cgColor }
//    public static var accountTypeLabelGray:
//        CGColor { return UIColor(red: 109.0/255.0, green: 117.0/255.0, blue: 125.0/255.0, alpha: 1.0).cgColor }
//}
