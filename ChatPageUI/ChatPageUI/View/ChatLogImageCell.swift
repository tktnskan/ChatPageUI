//
//  ChatLogImageCell.swift
//  ChatPageUI
//
//  Created by Jinyung Yoon on 2022/07/12.
//

import UIKit

class ChatLogImageCell: UICollectionViewCell {
    static let reuseId = "ChatLogImageCell"
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 10
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView(image: UIImage.strokedCheckmark)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
               
        let largeBoldDoc = UIImage(systemName: "person.circle", withConfiguration: largeConfig)

        view.image = largeBoldDoc
//        view.layer.cornerRadius = view.bounds.width / 2
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.clear.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .red
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
        profileImageView.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imgView)
        addSubview(profileImageView)
        imgView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self)
        }
    }
    
    func set(chat: Chat) {
        imgView.image = chat.image
        if chat.sender == .coach {
            profileImageView.isHidden = false
            profileImageView.snp.remakeConstraints { make in
                make.top.equalTo(self)
                make.leading.equalTo(self).offset(10)
                make.height.width.equalTo(30)
            }
            imgView.snp.remakeConstraints { make in
                make.top.equalTo(self)
                make.leading.equalTo(profileImageView.snp.trailing).offset(10)
                make.width.equalTo(chat.image!.size.width)
                make.height.equalTo(chat.image!.size.height)
            }
        } else {
            profileImageView.isHidden = true
            imgView.snp.remakeConstraints { make in
                make.top.equalTo(self)
                make.trailing.equalTo(self).offset(-10)
                make.width.equalTo(chat.image!.size.width)
                make.height.equalTo(chat.image!.size.height)
            }
        }
    }
}
