//
//  AboutMeView.swift
//  PokedexV2
//
//  Created by Diogo Filipe Abreu Rodrigues on 17/04/2024.
//

import UIKit

class AboutMeView: UIViewController {
    
    var textLabel : UILabel?
    var textBox : UIVisualEffectView?
    var image : UIImageView?
    
    var imageCenterConstrait : NSLayoutConstraint?
    var imageMarginConstrait : NSLayoutConstraint?
    var labelLeadingConstrait : NSLayoutConstraint?
    var labelTopConstrait : NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBacgorundImage()
        addTextBox()
    }
    
    func addBacgorundImage() {
        let backgroundImage = UIImageView(image: UIImage(named: "Image"))
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    func addTextBox(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        textBox = UIVisualEffectView(effect: blurEffect)
        guard let textBox else {return}
        textBox.layer.cornerRadius = 50
        textBox.clipsToBounds = true
        view.addSubview(textBox)
        textBox.translatesAutoresizingMaskIntoConstraints = false
        textBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        textBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        textBox.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50).isActive = true
        textBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        
     // addTextLabel
        
        textLabel = UILabel()
        guard let textLabel else { return  }
        textLabel.text = """
This app was devoped by Diogo Rodrigues as a part of a internship in DigitalWorks.

The Objective of the app os to use the API provided by https://pokeapi.co/ to obtain and display information about the Pokemon.

All the app was designed using a storyboard or xib files, with the exeption of this very page. Some of my favorite aspecsts are: the layout shown on the first page, the iteractive sprite, and the dynamic habitat image show
"""
        
        textLabel.numberOfLines = 0
        
        textBox.contentView.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: textBox.contentView.bottomAnchor, constant: -30).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: textBox.contentView.trailingAnchor,constant: -30).isActive = true
        
        labelTopConstrait = textLabel.topAnchor.constraint(equalTo: textBox.contentView.topAnchor, constant: 210)
        labelTopConstrait?.isActive = true
        
        labelLeadingConstrait = textLabel.leadingAnchor.constraint(equalTo: textBox.contentView.leadingAnchor, constant: 30)
        labelLeadingConstrait?.isActive = true
        
    // add profileImage
        
        let contentview = textBox.contentView
        
        image = UIImageView(image: UIImage(named: "AboutMe"))
        guard let image else { return }
        contentview.addSubview(image)
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        imageCenterConstrait = image.centerXAnchor.constraint(equalTo: contentview.centerXAnchor , constant: 0)
        imageCenterConstrait?.isActive = true
        
        imageMarginConstrait = image.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 10 )
        imageMarginConstrait?.isActive = true
        
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        changeLayouyt()
    }
    
    
    
    func changeLayouyt() {
        guard var imageCenterConstrait else { return  }
        guard var imageMarginConstrait  else { return  }
        guard var labelTopConstrait else { return  }
        guard var labelLeadingConstrait else { return }
        guard let contentview = textBox?.contentView  else { return }
        guard let image else { return }
        guard let textLabel else { return }
        
        imageCenterConstrait.isActive = false
        imageMarginConstrait.isActive = false
        labelTopConstrait.isActive = false
        labelLeadingConstrait.isActive = false
        
            if UIDevice.current.orientation.isLandscape {
                self.imageCenterConstrait = image.centerYAnchor.constraint(equalTo: contentview.centerYAnchor , constant: 0)
                self.imageCenterConstrait?.isActive = true
                
                self.imageMarginConstrait = image.leadingAnchor.constraint(equalTo: contentview.leadingAnchor, constant: 10 )
                self.imageMarginConstrait?.isActive = true
                
                self.labelTopConstrait = textLabel.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 30)
                self.labelTopConstrait?.isActive = true
                
                self.labelLeadingConstrait = textLabel.leadingAnchor.constraint(equalTo: contentview.leadingAnchor, constant: 220)
                self.labelLeadingConstrait?.isActive = true
            } else {
                self.imageCenterConstrait = image.centerXAnchor.constraint(equalTo: contentview.centerXAnchor , constant: 0)
                self.imageCenterConstrait?.isActive = true
                
                self.imageMarginConstrait = image.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 10 )
                self.imageMarginConstrait?.isActive = true
                
                self.labelTopConstrait = textLabel.topAnchor.constraint(equalTo: contentview.topAnchor, constant: 210)
                self.labelTopConstrait?.isActive = true
                
                self.labelLeadingConstrait = textLabel.leadingAnchor.constraint(equalTo: contentview.leadingAnchor, constant: 50)
                self.labelLeadingConstrait?.isActive = true
                
            }
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            changeLayouyt()
    }
}
