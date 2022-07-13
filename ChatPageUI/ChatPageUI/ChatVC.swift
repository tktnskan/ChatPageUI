//
//  ViewController.swift
//  ChatPageUI
//
//  Created by Jinyung Yoon on 2022/07/09.
//

import UIKit
import SnapKit

class ChatVC: UIViewController {
    
    
    lazy var chatInputView: ChatInputView = ChatInputView()
    
    var collectionView: UICollectionView!
    
    var singleLineHeight: CGFloat = 40
    var keyboardHeight: CGFloat = 0
    var availabelWidth: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        settingDelegate()
        scrollToBottom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification , object: nil)
    }

    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        if keyboardHeight == 0 {
            keyboardHeight = keyboardFrame.cgRectValue.height

            reMakeUIChatInputView(bottomMarginConstant: keyboardHeight)
        }
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        keyboardHeight = 0
        reMakeUIChatInputView(bottomMarginConstant: notchHeight)
    }
    
    private func configureUI() {
    
        view.addSubview(chatInputView)
        chatInputView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
            make.height.equalTo(singleLineHeight + notchHeight)
        }
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: createColumnFlowLayout())
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.bottom.equalTo(chatInputView.snp.top)
        }
    }
    
    private func settingDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: ChatLogMessageCell.reuseId)
        collectionView.register(ChatLogImageCell.self, forCellWithReuseIdentifier: ChatLogImageCell.reuseId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = .cyan
        
        chatInputView.textView.delegate = self
        chatInputView.sendPicBtn.addTarget(self, action: #selector(didTouchedSendPic), for: .touchUpInside)
        chatInputView.cameraBtn.addTarget(self, action: #selector(didTouchedCamera), for: .touchUpInside)
        chatInputView.sendBtn.addTarget(self, action: #selector(didTouchedSend), for: .touchUpInside)
    }
    
    private func reMakeUIChatInputView(bottomMarginConstant: CGFloat) {
        chatInputView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view).offset(-bottomMarginConstant + notchHeight)
            make.height.equalTo(singleLineHeight + notchHeight)
        }
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: mockData.count - 1, section: self.collectionView.numberOfSections - 1)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func createColumnFlowLayout(columnNumber: CGFloat = 1) -> UICollectionViewFlowLayout {
        let width = UIScreen.main.bounds.width
        let padding: CGFloat = 0
        let minimumItemSpacing: CGFloat = 0
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / columnNumber
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: 40)
        flowLayout.scrollDirection = .vertical
        
        return flowLayout
    }
    
    @objc
    private func didTouchedSendPic() {
//        let url = URL(string: "https://picsum.photos")
//        var image : UIImage?
//        DispatchQueue.global().async {
//            let data = try? Data(contentsOf: url!)
//            DispatchQueue.main.async {
//                image = UIImage(data: data!)
//                mockData.append(Chat(sender: .member, time: "123r24r", image: image))
//                self.collectionView.reloadData()
//                self.availabelWidth.removeAll()
//                self.scrollToBottom()
//            }
//        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        // imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc
    private func didTouchedCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc
    private func didTouchedSend() {
        if !chatInputView.textView.text.isEmpty, let text = chatInputView.textView.text {
            mockData.append(Chat(sender: .member, time: "1111", message: text))
            chatInputView.textView.text.removeAll()
            singleLineHeight = 40
            reMakeUIChatInputView(bottomMarginConstant: keyboardHeight)
            availabelWidth.removeAll()
            collectionView.reloadData()
            scrollToBottom()
        }
    }
}

extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mockData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = mockData[indexPath.item]
        
        if data.message != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogMessageCell.reuseId, for: indexPath) as! ChatLogMessageCell
            cell.set(chat: data)
            cell.setConstraint(width: availabelWidth[indexPath.item], who: data.sender)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLogImageCell.reuseId, for: indexPath) as! ChatLogImageCell
            cell.set(chat: data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = mockData[indexPath.item]
        
        if data.message != nil {
            self.view.endEditing(true)
        } else {
            let imgView = UIImageView()
            let resizedImage = data.image?.resize(newWidth: UIScreen.main.bounds.width)
            imgView.image = resizedImage
            let vc = ModalImagePinchVC(imgView: imgView)
            vc.modalPresentationStyle = .fullScreen
            vc.view.backgroundColor = .black
            self.present(vc, animated: true)
        }
    }
}

extension ChatVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = mockData[indexPath.item]
        let str = data.message
        let width = collectionView.frame.width * 0.7
        if str == nil {
            availabelWidth.append(width)
            let ratio = data.image!.size.height / data.image!.size.width
            let width = min(250, data.image!.size.width)
            return CGSize(width: collectionView.frame.width, height: width * ratio)
        }

        let cellSize = NSString(string: str!).boundingRect(
                    with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [
                            NSAttributedString.Key.font:    UIFont.systemFont(ofSize: 20)
                    ],
                    context: nil)
        availabelWidth.append(cellSize.width)
        return CGSize(width: collectionView.frame.width, height: cellSize.height + 10)
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        chatInputView.updateTextFont()
        let cellSize = NSString(string: textView.text!).boundingRect(
            with: CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [
                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
                    ],
                    context: nil)
        if textView.text.contains("\n") || cellSize.height >= 40 {
            singleLineHeight = 80
        } else {
            singleLineHeight = 40
        }
        chatInputView.snp.updateConstraints { make in
            make.height.equalTo(singleLineHeight + notchHeight)
        }
    }
}


extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let int = Int.random(in: 0...1)
            
            let width = min(250, pickedImage.size.width)
            let resizeImage = pickedImage.resize(newWidth: width)
            if int == 0 {
                mockData.append(Chat(sender: .coach, time: "123r24r", image: resizeImage))
            } else {
                mockData.append(Chat(sender: .member, time: "123r24r", image: resizeImage))
            }
            
            collectionView.reloadData()
            scrollToBottom()
        }
        dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
