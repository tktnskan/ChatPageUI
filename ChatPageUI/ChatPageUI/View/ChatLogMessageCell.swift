//
//  ChatLogMessageCell.swift
//  ChatPageUI
//
//  Created by Jinyung Yoon on 2022/07/12.
//

import UIKit

class ChatLogMessageCell: UICollectionViewCell {
    
    static let reuseId = "ChatMessageCell"
    
    var lblTitle: CustomLabel = {
        let lbl = CustomLabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 20)
        lbl.layer.cornerRadius = 10
        lbl.clipsToBounds = true
        return lbl
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
        addSubview(lblTitle)
        addSubview(profileImageView)
    }
    
    func setConstraint(width: CGFloat, who: Chat.Sender) {
        if who == .coach {
            profileImageView.isHidden = false
        } else {
            profileImageView.isHidden = true
        }
        
        if who == .member {
            lblTitle.snp.remakeConstraints { make in
                make.top.bottom.equalTo(self)
                make.trailing.equalTo(self).offset(-10)
                make.width.equalTo(min(width + 10, self.frame.width * 0.7 + 10))
            }
        } else {
            profileImageView.snp.remakeConstraints { make in
                make.top.equalTo(self)
                make.leading.equalTo(self).offset(10)
                make.height.width.equalTo(30)
            }
            lblTitle.snp.remakeConstraints { make in
                make.top.bottom.equalTo(self)
                make.leading.equalTo(profileImageView.snp.trailing).offset(10)
                make.width.equalTo(min(width + 10, self.frame.width * 0.7 + 10))
            }
        }
    }
    
    func set(chat: Chat) {
        lblTitle.text = chat.message
        lblTitle.textColor = .black
        lblTitle.sizeToFit()
        
        switch chat.sender {
        case .member:
            lblTitle.textAlignment = .left
            lblTitle.backgroundColor = .white
        case .coach:
            lblTitle.textAlignment = .left
            lblTitle.backgroundColor = .green
        }
    }
}


class CustomLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        super.drawText(in: rect.inset(by: insets))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
