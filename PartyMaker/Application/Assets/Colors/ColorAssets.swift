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

enum PersonalColors: String {
    
    case viceCity
    case cosmicFusion
    case susetGradient
    case bradyFun
    case sherbert
    case dusk
    case grapefruitSunset
    case politics
    case redSunset
    case dania
    case jupiter
    case transfile
    case nighthawk
    case atlas
    case megaTron
    case punYeta
    case kingYna
    
    var gradient: GradientView {
        switch self {
        case .viceCity:  return .viceCity
        case .cosmicFusion: return .cosmicFusion
        case .susetGradient: return .sunsetGradient
        case .bradyFun: return .bradyFun
        case .sherbert: return .sherbert
        case .dusk: return .dusk
        case .grapefruitSunset: return .grapefruitSunset
        case .politics: return .politics
        case .redSunset: return .redSunset
        case .dania: return .dania
        case .jupiter: return .jupiter
        case .transfile: return .transfile
        case .nighthawk: return .nighthawk
        case .atlas: return .atlas
        case .megaTron: return .megaTron
        case .punYeta: return .punYeta
        case .kingYna: return .kingYna
        }
    }
}

extension GradientView {
    
    public static var viceCity:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.2039215686, green: 0.5803921569, blue: 0.9019607843, alpha: 1), endColor: #colorLiteral(red: 0.9254901961, green: 0.431372549, blue: 0.6784313725, alpha: 1)) }
    public static var cosmicFusion:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 1, green: 0, blue: 0.8, alpha: 1), endColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.6, alpha: 1)) }
    public static var sunsetGradient:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 1, green: 0.4941176471, blue: 0.3725490196, alpha: 1), endColor: #colorLiteral(red: 0.9960784314, green: 0.7058823529, blue: 0.4823529412, alpha: 1)) }
    public static var bradyFun:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0, green: 0.7647058824, blue: 1, alpha: 1), endColor: #colorLiteral(red: 1, green: 1, blue: 0.1098039216, alpha: 1)) }
    public static var sherbert:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.968627451, green: 0.6156862745, blue: 0, alpha: 1), endColor: #colorLiteral(red: 0.3921568627, green: 0.9529411765, blue: 0.5490196078, alpha: 1)) }
    public static var dusk:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1), endColor: #colorLiteral(red: 0.9921568627, green: 0.4549019608, blue: 0.4235294118, alpha: 1)) }
    public static var grapefruitSunset:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.9137254902, green: 0.3921568627, blue: 0.262745098, alpha: 1), endColor: #colorLiteral(red: 0.5647058824, green: 0.3058823529, blue: 0.5843137255, alpha: 1)) }
    public static var politics:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1), endColor: #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)) }
    public static var redSunset:
        GradientView { return GradientView(from: .leading, to: .trailing, center: .center, startColor: #colorLiteral(red: 0.2078431373, green: 0.3607843137, blue: 0.4901960784, alpha: 1), endColor: #colorLiteral(red: 0.7529411765, green: 0.4235294118, blue: 0.5176470588, alpha: 1), centerColor: #colorLiteral(red: 0.4235294118, green: 0.3568627451, blue: 0.4823529412, alpha: 1)) }
    public static var dania:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.7450980392, green: 0.5764705882, blue: 0.7725490196, alpha: 1), endColor: #colorLiteral(red: 0.4823529412, green: 0.7764705882, blue: 0.8, alpha: 1)) }
    public static var jupiter:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 1, green: 0.8470588235, blue: 0.6078431373, alpha: 1), endColor: #colorLiteral(red: 0.09803921569, green: 0.3294117647, blue: 0.4823529412, alpha: 1)) }
    public static var transfile:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.0862745098, green: 0.7490196078, blue: 0.9921568627, alpha: 1), endColor: #colorLiteral(red: 0.7960784314, green: 0.1882352941, blue: 0.4, alpha: 1)) }
    public static var nighthawk:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.1607843137, green: 0.5019607843, blue: 0.7254901961, alpha: 1), endColor: #colorLiteral(red: 0.1725490196, green: 0.2431372549, blue: 0.3137254902, alpha: 1)) }
    public static var atlas:
        GradientView { return GradientView(from: .leading, to: .trailing, center: .center, startColor: #colorLiteral(red: 0.9960784314, green: 0.6745098039, blue: 0.368627451, alpha: 1), endColor: #colorLiteral(red: 0.2941176471, green: 0.7529411765, blue: 0.7843137255, alpha: 1), centerColor: #colorLiteral(red: 0.7803921569, green: 0.4745098039, blue: 0.8156862745, alpha: 1)) }
    public static var megaTron:
        GradientView { return GradientView(from: .leading, to: .trailing, center: .center, startColor: #colorLiteral(red: 0.7764705882, green: 1, blue: 0.8666666667, alpha: 1), endColor: #colorLiteral(red: 0.968627451, green: 0.4745098039, blue: 0.4901960784, alpha: 1), centerColor: #colorLiteral(red: 0.9843137255, green: 0.8431372549, blue: 0.5254901961, alpha: 1)) }
    public static var punYeta:
        GradientView { return GradientView(from: .leading, to: .trailing, startColor: #colorLiteral(red: 0.06274509804, green: 0.5529411765, blue: 0.7803921569, alpha: 1), endColor: #colorLiteral(red: 0.937254902, green: 0.5568627451, blue: 0.2196078431, alpha: 1)) }
    public static var kingYna:
        GradientView { return GradientView(from: .leading, to: .trailing, center: .center, startColor: #colorLiteral(red: 0.1019607843, green: 0.1647058824, blue: 0.4235294118, alpha: 1), endColor: #colorLiteral(red: 0.9921568627, green: 0.7333333333, blue: 0.1764705882, alpha: 1), centerColor: #colorLiteral(red: 0.6980392157, green: 0.1215686275, blue: 0.1215686275, alpha: 1)) }
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
