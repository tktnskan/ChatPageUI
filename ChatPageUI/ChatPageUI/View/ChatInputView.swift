//
//  ChatInputView.swift
//  ChatPageUI
//
//  Created by Jinyung Yoon on 2022/07/09.
//

import UIKit
import SnapKit

protocol Publisher {
    var observers: [Observer] { get set }
    func subscribe(observer: Observer)
    func unSubscribe(observer: Observer)
    func notify(message: String)
}

protocol Observer {
    var id: String { get set }
    func update(message: String)
}


final class ChatInputView: UIView {

    var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var textView: UITextView = {
        var textView = UITextView()
        textView.textColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 25)
//        textView.
        
        return textView
    }()
    
    var sendBtn: UIButton = {
        var btn = UIButton()
        btn.setTitle("보내기", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    var sendPicBtn: UIButton = {
        var btn = UIButton(type: .contactAdd)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var cameraBtn: UIButton = {
        let btn = UIButton(type: .infoDark)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var isTextSizeDetermined: Bool = false
    var singleLineHeight: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        addSubview(cameraBtn)
        addSubview(sendPicBtn)
        addSubview(containerView)
//        textView.delegate = self
        containerView.addSubview(textView)
        containerView.addSubview(sendBtn)
        
        sendPicBtn.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(2)
            make.bottom.equalTo(self).offset(-5)
            make.height.width.equalTo(30)
        }
        
        cameraBtn.snp.makeConstraints { make in
            make.leading.equalTo(sendPicBtn.snp.trailing).offset(2)
            make.bottom.equalTo(self).offset(-5)
            make.height.width.equalTo(30)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(cameraBtn.snp.trailing).offset(2)
            make.bottom.top.trailing.equalTo(self)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.top.equalTo(containerView)
            make.bottom.equalTo(containerView).offset(-notchHeight)
            make.width.equalTo(containerView).multipliedBy(0.8)
        }
        
        sendBtn.snp.makeConstraints { make in
            make.leading.equalTo(textView.snp.trailing)
            make.bottom.trailing.equalTo(containerView)
            make.height.equalTo(40)
        }
    }
    
    func updateTextFont() {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero) || isTextSizeDetermined) {
            return;
        }

        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)));

        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont;
        }
        
        isTextSizeDetermined = true
    }
}
//
//extension ChatInputView: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        updateTextFont()
//        let cellSize = NSString(string: textView.text!).boundingRect(
//            with: CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude),
//                    options: .usesLineFragmentOrigin,
//                    attributes: [
//                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
//                    ],
//                    context: nil)
//        if textView.text.contains("\n") || cellSize.height >= 40 {
//            singleLineHeight = 80
//        } else {
//            singleLineHeight = 40
//        }
//        self.snp.updateConstraints { make in
//            make.height.equalTo(singleLineHeight + notchHeight)
//        }
//    }
//}
