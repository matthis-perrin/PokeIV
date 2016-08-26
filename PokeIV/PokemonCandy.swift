//
//  PokemonCandy.swift
//  PokeIV
//
//  Created by Matthis Perrin on 8/21/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PokemonCandy: UIView {
    
    private var _num: PokemonNum
    var num: PokemonNum {
        get {
            return _num
        }
        set(num) {
            self._num = num
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self._num = .Unknown
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let candyColor = PokemonCandy.pokemonNumToCandyColor[POKEMON_NUM_TO_FAMILY[self.num] ?? .FamilyUnknown]
        let primaryColor = candyColor?.primary ?? PokemonCandy.defaultPrimary
        let secondaryColor = candyColor?.secondary ?? PokemonCandy.defaultSecondary
        
        let base = PokemonCandy.imageWithMask(PokemonCandy.candyBase, color: primaryColor)
        let secondary = PokemonCandy.imageWithMask(PokemonCandy.candySecondary, color: secondaryColor)
        
        base?.drawInRect(rect)
        secondary?.drawInRect(rect)
        PokemonCandy.candyHighlight?.drawInRect(rect)
    }
    
    private static func imageWithMask(image: UIImage?, color: UIColor) -> UIImage? {
        guard let image = image else {
            return nil
        }
        let rect = CGRectMake(0, 0, image.size.width, image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let ctx = UIGraphicsGetCurrentContext()
        image.drawInRect(rect)
        CGContextSetFillColorWithColor(ctx, color.CGColor)
        CGContextSetBlendMode(ctx, .SourceAtop)
        CGContextFillRect(ctx, rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return img;
    }
    
    
    // STATIC RESSOURCES
    
    private static let candyBase = UIImage(named: "candy_painted_base_color.png")
    private static let candySecondary = UIImage(named: "candy_painted_secondary_color.png")
    private static let candyHighlight = UIImage(named: "candy_painted_highlight.png")
    
    private struct CandyColor {
        let primary: UIColor
        let secondary: UIColor
    }
    
    private static let defaultPrimary = UIColor.whiteColor()
    private static let defaultSecondary = UIColor.whiteColor()
    
    private static let pokemonNumToCandyColor: [PokemonFamily: CandyColor] = [
        .FamilyBulbasaur: CandyColor(primary: UIColor(red: 0.21176470588235294, green: 0.7843137254901961, blue: 0.6431372549019608, alpha: 1.0), secondary: UIColor(red: 0.6392156862745098, green: 0.984313725490196, blue: 0.5137254901960784, alpha: 1.0)),
        .FamilyCharmander: CandyColor(primary: UIColor(red: 0.9411764705882353, green: 0.5725490196078431, blue: 0.18823529411764706, alpha: 1.0), secondary: UIColor(red: 1, green: 0.9019607843137255, blue: 0.6, alpha: 1.0)),
        .FamilySquirtle: CandyColor(primary: UIColor(red: 0.5215686274509804, green: 0.7686274509803922, blue: 0.8392156862745098, alpha: 1.0), secondary: UIColor(red: 0.9490196078431372, green: 0.9098039215686274, blue: 0.7450980392156863, alpha: 1.0)),
        .FamilyCaterpie: CandyColor(primary: UIColor(red: 0.6470588235294118, green: 0.803921568627451, blue: 0.5294117647058824, alpha: 1.0), secondary: UIColor(red: 0.9803921568627451, green: 0.8901960784313725, blue: 0.6941176470588235, alpha: 1.0)),
        .FamilyWeedle: CandyColor(primary: UIColor(red: 0.9058823529411765, green: 0.7372549019607844, blue: 0.5137254901960784, alpha: 1.0), secondary: UIColor(red: 0.8588235294117647, green: 0.4627450980392157, blue: 0.6784313725490196, alpha: 1.0)),
        .FamilyPidgey: CandyColor(primary: UIColor(red: 0.9137254901960784, green: 0.8784313725490196, blue: 0.7176470588235294, alpha: 1.0), secondary: UIColor(red: 0.8235294117647058, green: 0.6196078431372549, blue: 0.396078431372549, alpha: 1.0)),
        .FamilyRattata: CandyColor(primary: UIColor(red: 0.6627450980392157, green: 0.5372549019607843, blue: 0.7294117647058823, alpha: 1.0), secondary: UIColor(red: 0.8509803921568627, green: 0.8431372549019608, blue: 0.7450980392156863, alpha: 1.0)),
        .FamilySpearow: CandyColor(primary: UIColor(red: 0.9215686274509803, green: 0.7254901960784313, blue: 0.6274509803921569, alpha: 1.0), secondary: UIColor(red: 0.996078431372549, green: 0.36470588235294116, blue: 0.4235294117647059, alpha: 1.0)),
        .FamilyEkans: CandyColor(primary: UIColor(red: 0.796078431372549, green: 0.6588235294117647, blue: 0.788235294117647, alpha: 1.0), secondary: UIColor(red: 0.9450980392156862, green: 0.8784313725490196, blue: 0.5647058823529412, alpha: 1.0)),
        .FamilyPikachu: CandyColor(primary: UIColor(red: 0.9607843137254902, green: 0.8274509803921568, blue: 0.40784313725490196, alpha: 1.0), secondary: UIColor(red: 0.8862745098039215, green: 0.6509803921568628, blue: 0.36470588235294116, alpha: 1.0)),
        .FamilySandshrew: CandyColor(primary: UIColor(red: 0.8784313725490196, green: 0.8235294117647058, blue: 0.6431372549019608, alpha: 1.0), secondary: UIColor(red: 0.788235294117647, green: 0.6941176470588235, blue: 0.5019607843137255, alpha: 1.0)),
        .FamilyNidoranFemale: CandyColor(primary: UIColor(red: 0.7725490196078432, green: 0.8274509803921568, blue: 0.8941176470588236, alpha: 1.0), secondary: UIColor(red: 0.5882352941176471, green: 0.592156862745098, blue: 0.7725490196078432, alpha: 1.0)),
        .FamilyNidoranMale: CandyColor(primary: UIColor(red: 0.8352941176470589, green: 0.6235294117647059, blue: 0.7568627450980392, alpha: 1.0), secondary: UIColor(red: 0.7647058823529411, green: 0.4392156862745098, blue: 0.5882352941176471, alpha: 1.0)),
        .FamilyClefairy: CandyColor(primary: UIColor(red: 0.9450980392156862, green: 0.8274509803921568, blue: 0.8196078431372549, alpha: 1.0), secondary: UIColor(red: 0.9450980392156862, green: 0.7490196078431373, blue: 0.7529411764705882, alpha: 1.0)),
        .FamilyVulpix: CandyColor(primary: UIColor(red: 0.9607843137254902, green: 0.5254901960784314, blue: 0.3686274509803922, alpha: 1.0), secondary: UIColor(red: 0.9647058823529412, green: 0.8235294117647058, blue: 0.611764705882353, alpha: 1.0)),
        .FamilyJigglypuff: CandyColor(primary: UIColor(red: 0.9450980392156862, green: 0.8235294117647058, blue: 0.8823529411764706, alpha: 1.0), secondary: UIColor(red: 0.9176470588235294, green: 0.7254901960784313, blue: 0.807843137254902, alpha: 1.0)),
        .FamilyZubat: CandyColor(primary: UIColor(red: 0.2784313725490196, green: 0.5411764705882353, blue: 0.7490196078431373, alpha: 1.0), secondary: UIColor(red: 0.8627450980392157, green: 0.5529411764705883, blue: 0.8431372549019608, alpha: 1.0)),
        .FamilyOddish: CandyColor(primary: UIColor(red: 0.4392156862745098, green: 0.5843137254901961, blue: 0.7490196078431373, alpha: 1.0), secondary: UIColor(red: 0.4588235294117647, green: 0.7529411764705882, blue: 0.4196078431372549, alpha: 1.0)),
        .FamilyParas: CandyColor(primary: UIColor(red: 0.9450980392156862, green: 0.5294117647058824, blue: 0.23921568627450981, alpha: 1.0), secondary: UIColor(red: 1, green: 0.8196078431372549, blue: 0.34901960784313724, alpha: 1.0)),
        .FamilyVenonat: CandyColor(primary: UIColor(red: 0.6, green: 0.5607843137254902, blue: 0.8392156862745098, alpha: 1.0), secondary: UIColor(red: 0.8862745098039215, green: 0.2627450980392157, blue: 0.4745098039215686, alpha: 1.0)),
        .FamilyDiglett: CandyColor(primary: UIColor(red: 0.6901960784313725, green: 0.5215686274509804, blue: 0.4392156862745098, alpha: 1.0), secondary: UIColor(red: 0.9333333333333333, green: 0.7725490196078432, blue: 0.8627450980392157, alpha: 1.0)),
        .FamilyMeowth: CandyColor(primary: UIColor(red: 0.9254901960784314, green: 0.8784313725490196, blue: 0.7686274509803922, alpha: 1.0), secondary: UIColor(red: 1, green: 0.8862745098039215, blue: 0.5411764705882353, alpha: 1.0)),
        .FamilyPsyduck: CandyColor(primary: UIColor(red: 0.9568627450980393, green: 0.7686274509803922, blue: 0.5294117647058824, alpha: 1.0), secondary: UIColor(red: 0.9333333333333333, green: 0.9333333333333333, blue: 0.8470588235294118, alpha: 1.0)),
        .FamilyMankey: CandyColor(primary: UIColor(red: 0.8980392156862745, green: 0.8392156862745098, blue: 0.796078431372549, alpha: 1.0), secondary: UIColor(red: 0.7647058823529411, green: 0.5725490196078431, blue: 0.4980392156862745, alpha: 1.0)),
        .FamilyGrowlithe: CandyColor(primary: UIColor(red: 0.9529411764705882, green: 0.6274509803921569, blue: 0.33725490196078434, alpha: 1.0), secondary: UIColor(red: 0.24705882352941178, green: 0.23921568627450981, blue: 0.16470588235294117, alpha: 1.0)),
        .FamilyPoliwag: CandyColor(primary: UIColor(red: 0.5176470588235295, green: 0.6235294117647059, blue: 0.792156862745098, alpha: 1.0), secondary: UIColor(red: 0.9254901960784314, green: 0.9254901960784314, blue: 0.9647058823529412, alpha: 1.0)),
        .FamilyAbra: CandyColor(primary: UIColor(red: 0.8980392156862745, green: 0.807843137254902, blue: 0.3607843137254902, alpha: 1.0), secondary: UIColor(red: 0.5568627450980392, green: 0.4745098039215686, blue: 0.5803921568627451, alpha: 1.0)),
        .FamilyMachop: CandyColor(primary: UIColor(red: 0.6313725490196078, green: 0.7333333333333333, blue: 0.8705882352941177, alpha: 1.0), secondary: UIColor(red: 0.8627450980392157, green: 0.807843137254902, blue: 0.6941176470588235, alpha: 1.0)),
        .FamilyBellsprout: CandyColor(primary: UIColor(red: 0.9215686274509803, green: 0.8823529411764706, blue: 0.43137254901960786, alpha: 1.0), secondary: UIColor(red: 0.6862745098039216, green: 0.8352941176470589, blue: 0.49411764705882355, alpha: 1.0)),
        .FamilyTentacool: CandyColor(primary: UIColor(red: 0.44313725490196076, green: 0.6745098039215687, blue: 0.8470588235294118, alpha: 1.0), secondary: UIColor(red: 0.7607843137254902, green: 0.27058823529411763, blue: 0.5372549019607843, alpha: 1.0)),
        .FamilyGeodude: CandyColor(primary: UIColor(red: 0.6745098039215687, green: 0.6274509803921569, blue: 0.47058823529411764, alpha: 1.0), secondary: UIColor(red: 0.4588235294117647, green: 0.3803921568627451, blue: 0.03137254901960784, alpha: 1.0)),
        .FamilyPonyta: CandyColor(primary: UIColor(red: 0.9294117647058824, green: 0.9058823529411765, blue: 0.7803921568627451, alpha: 1.0), secondary: UIColor(red: 0.9607843137254902, green: 0.5647058823529412, blue: 0.3843137254901961, alpha: 1.0)),
        .FamilySlowpoke: CandyColor(primary: UIColor(red: 0.8745098039215686, green: 0.6313725490196078, blue: 0.7254901960784313, alpha: 1.0), secondary: UIColor(red: 0.9333333333333333, green: 0.8823529411764706, blue: 0.7803921568627451, alpha: 1.0)),
        .FamilyMagnemite: CandyColor(primary: UIColor(red: 0.8156862745098039, green: 0.8549019607843137, blue: 0.8784313725490196, alpha: 1.0), secondary: UIColor(red: 0.5725490196078431, green: 0.7137254901960784, blue: 0.7764705882352941, alpha: 1.0)),
        .FamilyFarfetchd: CandyColor(primary: UIColor(red: 0.6745098039215687, green: 0.6196078431372549, blue: 0.5843137254901961, alpha: 1.0), secondary: UIColor(red: 0.5843137254901961, green: 0.984313725490196, blue: 0.592156862745098, alpha: 1.0)),
        .FamilyDoduo: CandyColor(primary: UIColor(red: 0.7843137254901961, green: 0.5803921568627451, blue: 0.3843137254901961, alpha: 1.0), secondary: UIColor(red: 0.6862745098039216, green: 0.4588235294117647, blue: 0.37254901960784315, alpha: 1.0)),
        .FamilySeel: CandyColor(primary: UIColor(red: 0.7803921568627451, green: 0.8745098039215686, blue: 0.9098039215686274, alpha: 1.0), secondary: UIColor(red: 0.7137254901960784, green: 0.792156862745098, blue: 0.9294117647058824, alpha: 1.0)),
        .FamilyGrimer: CandyColor(primary: UIColor(red: 0.7490196078431373, green: 0.6431372549019608, blue: 0.7803921568627451, alpha: 1.0), secondary: UIColor(red: 0.37254901960784315, green: 0.3254901960784314, blue: 0.4392156862745098, alpha: 1.0)),
        .FamilyShellder: CandyColor(primary: UIColor(red: 0.6705882352941176, green: 0.611764705882353, blue: 0.7725490196078432, alpha: 1.0), secondary: UIColor(red: 0.8784313725490196, green: 0.7098039215686275, blue: 0.7019607843137254, alpha: 1.0)),
        .FamilyGastly: CandyColor(primary: UIColor(red: 0.1411764705882353, green: 0.13333333333333333, blue: 0.13725490196078433, alpha: 1.0), secondary: UIColor(red: 0.6078431372549019, green: 0.4980392156862745, blue: 0.7176470588235294, alpha: 1.0)),
        .FamilyOnix: CandyColor(primary: UIColor(red: 0.7098039215686275, green: 0.7137254901960784, blue: 0.7215686274509804, alpha: 1.0), secondary: UIColor(red: 0.3843137254901961, green: 0.3843137254901961, blue: 0.39215686274509803, alpha: 1.0)),
        .FamilyDrowzee: CandyColor(primary: UIColor(red: 0.9725490196078431, green: 0.796078431372549, blue: 0.34509803921568627, alpha: 1.0), secondary: UIColor(red: 0.6862745098039216, green: 0.4745098039215686, blue: 0.3803921568627451, alpha: 1.0)),
        .FamilyKrabby: CandyColor(primary: UIColor(red: 0.9215686274509803, green: 0.5647058823529412, blue: 0.38823529411764707, alpha: 1.0), secondary: UIColor(red: 0.9294117647058824, green: 0.8509803921568627, blue: 0.807843137254902, alpha: 1.0)),
        .FamilyVoltorb: CandyColor(primary: UIColor(red: 0.7137254901960784, green: 0.27450980392156865, blue: 0.33725490196078434, alpha: 1.0), secondary: UIColor(red: 0.9411764705882353, green: 0.8980392156862745, blue: 0.9176470588235294, alpha: 1.0)),
        .FamilyExeggcute: CandyColor(primary: UIColor(red: 0.9568627450980393, green: 0.8666666666666667, blue: 0.9058823529411765, alpha: 1.0), secondary: UIColor(red: 0.9372549019607843, green: 0.7647058823529411, blue: 0.7568627450980392, alpha: 1.0)),
        .FamilyCubone: CandyColor(primary: UIColor(red: 0.8313725490196079, green: 0.8352941176470589, blue: 0.8392156862745098, alpha: 1.0), secondary: UIColor(red: 0.796078431372549, green: 0.7098039215686275, blue: 0.47843137254901963, alpha: 1.0)),
        .FamilyHitmonlee: CandyColor(primary: UIColor(red: 0.7411764705882353, green: 0.6235294117647059, blue: 0.5333333333333333, alpha: 1.0), secondary: UIColor(red: 0.9333333333333333, green: 0.8823529411764706, blue: 0.7803921568627451, alpha: 1.0)),
        .FamilyHitmonchan: CandyColor(primary: UIColor(red: 0.7843137254901961, green: 0.6705882352941176, blue: 0.7333333333333333, alpha: 1.0), secondary: UIColor(red: 0.8941176470588236, green: 0.39215686274509803, blue: 0.23137254901960785, alpha: 1.0)),
        .FamilyLickitung: CandyColor(primary: UIColor(red: 0.8901960784313725, green: 0.6823529411764706, blue: 0.7254901960784313, alpha: 1.0), secondary: UIColor(red: 0.9411764705882353, green: 0.8941176470588236, blue: 0.792156862745098, alpha: 1.0)),
        .FamilyKoffing: CandyColor(primary: UIColor(red: 0.5450980392156862, green: 0.5607843137254902, blue: 0.6823529411764706, alpha: 1.0), secondary: UIColor(red: 0.8705882352941177, green: 0.8784313725490196, blue: 0.7490196078431373, alpha: 1.0)),
        .FamilyRhyhorn: CandyColor(primary: UIColor(red: 0.7372549019607844, green: 0.7411764705882353, blue: 0.7490196078431373, alpha: 1.0), secondary: UIColor(red: 0.5843137254901961, green: 0.611764705882353, blue: 0.6352941176470588, alpha: 1.0)),
        .FamilyChansey: CandyColor(primary: UIColor(red: 0.8784313725490196, green: 0.6823529411764706, blue: 0.6980392156862745, alpha: 1.0), secondary: UIColor(red: 0.7764705882352941, green: 0.5529411764705883, blue: 0.5294117647058824, alpha: 1.0)),
        .FamilyTangela: CandyColor(primary: UIColor(red: 0.4, green: 0.4235294117647059, blue: 0.615686274509804, alpha: 1.0), secondary: UIColor(red: 0.8941176470588236, green: 0.43137254901960786, blue: 0.5490196078431373, alpha: 1.0)),
        .FamilyKangaskhan: CandyColor(primary: UIColor(red: 0.592156862745098, green: 0.5294117647058824, blue: 0.5058823529411764, alpha: 1.0), secondary: UIColor(red: 0.8901960784313725, green: 0.8666666666666667, blue: 0.7215686274509804, alpha: 1.0)),
        .FamilyHorsea: CandyColor(primary: UIColor(red: 0.6235294117647059, green: 0.8117647058823529, blue: 0.9137254901960784, alpha: 1.0), secondary: UIColor(red: 0.9882352941176471, green: 0.9686274509803922, blue: 0.8431372549019608, alpha: 1.0)),
        .FamilyGoldeen: CandyColor(primary: UIColor(red: 0.9019607843137255, green: 0.9019607843137255, blue: 0.9058823529411765, alpha: 1.0), secondary: UIColor(red: 0.9529411764705882, green: 0.5176470588235295, blue: 0.4117647058823529, alpha: 1.0)),
        .FamilyStaryu: CandyColor(primary: UIColor(red: 0.7058823529411765, green: 0.5843137254901961, blue: 0.4117647058823529, alpha: 1.0), secondary: UIColor(red: 0.9607843137254902, green: 0.9019607843137255, blue: 0.5333333333333333, alpha: 1.0)),
        .FamilyMrMime: CandyColor(primary: UIColor(red: 0.8980392156862745, green: 0.38823529411764707, blue: 0.5294117647058824, alpha: 1.0), secondary: UIColor(red: 1, green: 0.807843137254902, blue: 0.8352941176470589, alpha: 1.0)),
        .FamilyScyther: CandyColor(primary: UIColor(red: 0.5725490196078431, green: 0.7725490196078432, blue: 0.5294117647058824, alpha: 1.0), secondary: UIColor(red: 0.9647058823529412, green: 0.9411764705882353, blue: 0.8117647058823529, alpha: 1.0)),
        .FamilyJynx: CandyColor(primary: UIColor(red: 0.7686274509803922, green: 0.27058823529411763, blue: 0.3215686274509804, alpha: 1.0), secondary: UIColor(red: 0.39215686274509803, green: 0.19215686274509805, blue: 0.5294117647058824, alpha: 1.0)),
        .FamilyElectabuzz: CandyColor(primary: UIColor(red: 0.9607843137254902, green: 0.8588235294117647, blue: 0.4666666666666667, alpha: 1.0), secondary: UIColor(red: 0.0784313725490196, green: 0.09019607843137255, blue: 0.3686274509803922, alpha: 1.0)),
        .FamilyMagmar: CandyColor(primary: UIColor(red: 0.9607843137254902, green: 0.8313725490196079, blue: 0.4666666666666667, alpha: 1.0), secondary: UIColor(red: 0.9411764705882353, green: 0.4, blue: 0.3058823529411765, alpha: 1.0)),
        .FamilyPinsir: CandyColor(primary: UIColor(red: 0.7372549019607844, green: 0.6941176470588235, blue: 0.6705882352941176, alpha: 1.0), secondary: UIColor(red: 0.8117647058823529, green: 0.8313725490196079, blue: 0.8470588235294118, alpha: 1.0)),
        .FamilyTauros: CandyColor(primary: UIColor(red: 0.8470588235294118, green: 0.6274509803921569, blue: 0.34509803921568627, alpha: 1.0), secondary: UIColor(red: 0.5333333333333333, green: 0.49411764705882355, blue: 0.43529411764705883, alpha: 1.0)),
        .FamilyMagikarp: CandyColor(primary: UIColor(red: 0.9098039215686274, green: 0.47058823529411764, blue: 0.2235294117647059, alpha: 1.0), secondary: UIColor(red: 0.9647058823529412, green: 0.9411764705882353, blue: 0.8117647058823529, alpha: 1.0)),
        .FamilyLapras: CandyColor(primary: UIColor(red: 0.4196078431372549, green: 0.6549019607843137, blue: 0.8313725490196079, alpha: 1.0), secondary: UIColor(red: 1, green: 0.9411764705882353, blue: 0.8549019607843137, alpha: 1.0)),
        .FamilyDitto: CandyColor(primary: UIColor(red: 0.6784313725490196, green: 0.5529411764705883, blue: 0.7450980392156863, alpha: 1.0), secondary: UIColor(red: 0.8588235294117647, green: 0.8470588235294118, blue: 0.7450980392156863, alpha: 1.0)),
        .FamilyEevee: CandyColor(primary: UIColor(red: 0.792156862745098, green: 0.592156862745098, blue: 0.3803921568627451, alpha: 1.0), secondary: UIColor(red: 0.49411764705882355, green: 0.33725490196078434, blue: 0.12941176470588237, alpha: 1.0)),
        .FamilyPorygon: CandyColor(primary: UIColor(red: 0.9058823529411765, green: 0.4588235294117647, blue: 0.48627450980392156, alpha: 1.0), secondary: UIColor(red: 0.4196078431372549, green: 0.7803921568627451, blue: 0.7725490196078432, alpha: 1.0)),
        .FamilyOmanyte: CandyColor(primary: UIColor(red: 0.8666666666666667, green: 0.8627450980392157, blue: 0.8, alpha: 1.0), secondary: UIColor(red: 0.45098039215686275, green: 0.807843137254902, blue: 0.8862745098039215, alpha: 1.0)),
        .FamilyKabuto: CandyColor(primary: UIColor(red: 0.7568627450980392, green: 0.5137254901960784, blue: 0.20784313725490197, alpha: 1.0), secondary: UIColor(red: 0.3058823529411765, green: 0.3058823529411765, blue: 0.2823529411764706, alpha: 1.0)),
        .FamilyAerodactyl: CandyColor(primary: UIColor(red: 0.8313725490196079, green: 0.7294117647058823, blue: 0.8274509803921568, alpha: 1.0), secondary: UIColor(red: 0.6941176470588235, green: 0.5882352941176471, blue: 0.7725490196078432, alpha: 1.0)),
        .FamilySnorlax: CandyColor(primary: UIColor(red: 0.19607843137254902, green: 0.396078431372549, blue: 0.5137254901960784, alpha: 1.0), secondary: UIColor(red: 0.8901960784313725, green: 0.8549019607843137, blue: 0.807843137254902, alpha: 1.0)),
        .FamilyDratini: CandyColor(primary: UIColor(red: 0.5647058823529412, green: 0.6823529411764706, blue: 0.8313725490196079, alpha: 1.0), secondary: UIColor(red: 0.9372549019607843, green: 0.9176470588235294, blue: 0.9019607843137255, alpha: 1.0)),
    ]

}
