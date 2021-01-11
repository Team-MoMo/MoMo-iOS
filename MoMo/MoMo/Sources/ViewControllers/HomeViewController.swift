//
//  HomeViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/08.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var myPageButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var swipeUpButton: UIButton!
    @IBOutlet weak var swipeDownButton: UIButton!
    @IBOutlet weak var homeTopButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var swipeUpButtonTop: NSLayoutConstraint!
    @IBOutlet weak var homeTopButtonBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var bubbleDataArray = BubbleData() // 통신으로 받아오는 data
    var bubbleDepthArray: [[Bubble]] = [] // depth 별로 잘라놓은 Bubble 배열의 배열
    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]() // 단계 별 gradient color 배열
    var currentColorSet: Int = 0
    var sectionFrameArray: [CGRect]  = [] // section 별 background frame 배열
    
    let rowHeight: CGFloat = 150
    let sectionHeight: CGFloat = 100
    
    var statusBarHeight: CGFloat = 0
    let swipeButtonTopBottomMargin: CGFloat = 16
    let swipeButtonBottomMarginWithNotch: CGFloat = 8
    
    // section header
    let depthLabelFrameX: CGFloat = 32
    let depthLabelFrameY: CGFloat = 51
    let depthLabelFrameHeight: CGFloat = 42
    let depthLabelFontSize: CGFloat = 28
    
    // MARK: - View Life Cycle
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableHeaderView register
        let headerView = Bundle.main.loadNibNamed(Constants.Name.homeDayNightViewXib, owner: self, options: nil)?.last as? UIView ?? UIView()
        
        // bubble table view cell register
        let cellNib = UINib(nibName: Constants.Name.bubbleTableViewCell, bundle: nil)
        self.homeTableView.register(cellNib, forCellReuseIdentifier: Constants.Identifier.bubbleTableViewCell)
        self.homeTableView.backgroundColor = UIColor.clear
        
        // tableView separator 없애기
        homeTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        // 첫 화면 버튼 hidden 처리
        calendarButton.isHidden = true
        swipeUpButton.isHidden = true
        homeTopButton.isHidden = true
        
        // 오늘 작성한 일기가 없을 때
        // uploadButton.isHidden = true
        
        // 권한 위임
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        devideArrayByDepth()
        createGradientColorSets()
        
        // tableHeaderView 지정
        homeTableView.tableHeaderView = headerView
        DispatchQueue.main.async {
            self.homeTableView.tableHeaderView?.frame.size.height = UIScreen.main.bounds.height
        }
        
        // contentOffset 0부터 시작하도록 조정
        homeTableView.contentInsetAdjustmentBehavior = .never
        
        // statusbar 높이 가져오기
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
    }
    
    // viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        // navigation bar 투명화
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        // notch가 없는 기종을 위한 autolayout 설정
        swipeUpButtonTop.constant = statusBarHeight + swipeButtonTopBottomMargin
        if view.safeAreaInsets.bottom == 0 {
            homeTopButtonBottom.constant = swipeButtonTopBottomMargin
        } else {
            homeTopButtonBottom.constant = view.safeAreaInsets.bottom + swipeButtonBottomMarginWithNotch
        }
        
        // section 별 frame 값 계산
        for sectionIndex in 0..<7 {
            if sectionIndex == 0 {
                var frame = homeTableView.rect(forSection: sectionIndex)
                frame.size.height = rowHeight * CGFloat(bubbleDepthArray[sectionIndex].count) + sectionHeight
                sectionFrameArray.append(frame)
            } else {
                var frame = homeTableView.rect(forSection: sectionIndex)
                frame.origin.y = sectionFrameArray[sectionIndex-1].origin.y + rowHeight * CGFloat(bubbleDepthArray[sectionIndex-1].count) + sectionHeight
                frame.size.height = rowHeight * CGFloat(bubbleDepthArray[sectionIndex].count) + sectionHeight
                sectionFrameArray.append(frame)
            }
        }
        
        // section 별 frame에 맞게 gradient 입히기
        for sectionIndex in 0..<7 {
            let frame = sectionFrameArray[sectionIndex]
            let view = UIView(frame: frame)
            let gradientView = UIView(frame: frame)
            let imgView = UIImageView(frame: view.bounds)
            
            currentColorSet = sectionIndex
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.frame
            gradientLayer.colors = colorSets[currentColorSet]
            
            let image = UIImage.gradientImageWithBounds(bounds: frame, colors: colorSets[sectionIndex])
            imgView.image = image
            
            view.addSubview(imgView)
            
            homeTableView.addSubview(view)
            homeTableView.sendSubviewToBack(view)
        }
        attachDepth0Objet()
        
    }
    
    // MARK: - Functions

    // 단계 별 bubble data 배열 생성
    func devideArrayByDepth() {
        let totalArray = bubbleDataArray.objectsArray
        for sectionIndex in 0..<homeTableView.numberOfSections {
            let bubbleArray = totalArray.filter { (bubble: Bubble) -> Bool in
                return bubble.depth == sectionIndex
            }
            bubbleDepthArray.append(bubbleArray)
        }
        
        // 각 section별로 bubble이 4개 이하일 때 4개로 채워줌
        for sectionIndex in 0..<homeTableView.numberOfSections {
            let emptyBubble = Bubble(date: "", cate: "", depth: sectionIndex, leadingNum: -1)
            while bubbleDepthArray[sectionIndex].count < 4 {
                bubbleDepthArray[sectionIndex].append(emptyBubble)
            }
        }
    }
    
    // gradient 단계 별 color 배열
    func createGradientColorSets() {
        colorSets.append([UIColor.Gradient1.cgColor, UIColor.Gradient2.cgColor]) // 1단계
        colorSets.append([UIColor.Gradient2.cgColor, UIColor.Gradient3.cgColor]) // 2단계
        colorSets.append([UIColor.Gradient3.cgColor, UIColor.Gradient4.cgColor]) // 3단계
        colorSets.append([UIColor.Gradient4.cgColor, UIColor.Gradient5.cgColor]) // 4단계
        colorSets.append([UIColor.Gradient5.cgColor, UIColor.Gradient6.cgColor]) // 5단계
        colorSets.append([UIColor.Gradient6.cgColor, UIColor.Gradient7.cgColor]) // 6단계
        colorSets.append([UIColor.Gradient7.cgColor, UIColor.Gradient8.cgColor]) // 7단계
        
        currentColorSet = 0
    }
    
    // 전달받은 img, frame의 x, y값에 맞게 오브제 배치
    func attachObjet(frameX: CGFloat, frameY: CGFloat, img: UIImage) {
        let imgView = UIImageView(frame: CGRect(x: frameX, y: frameY, width: img.size.width, height: img.size.height))
        imgView.image = img
        
        homeTableView.addSubview(imgView)
    }
    
    // MARK: objet 붙이기
    
    // 0단계 - 2m
    func attachDepth0Objet() {
        let sectionFrameY = sectionFrameArray[0].origin.y
        let sectionFrameRight = sectionFrameArray[0].origin.x + sectionFrameArray[0].size.width
        let sectionFrameBottom = sectionFrameArray[1].origin.y
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let rock1 = Constants.Design.Image.depth0Rock1
        let rock2 = Constants.Design.Image.depth0Rock2
        let fish1 = Constants.Design.Image.depth0Fish1
        let fish2 = Constants.Design.Image.depth0Fish2
        let seaweed1 = Constants.Design.Image.depth0Seaweed1
        
        // objet 붙이기
        attachObjet(frameX: screenWidth - (rock1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (rock2?.size.height ?? CGFloat(0)), img: rock2 ?? UIImage())
        attachObjet(frameX: 64, frameY: sectionFrameY + 161, img: fish1 ?? UIImage())
        attachObjet(frameX: sectionFrameRight - 47 - (fish2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - 197 - (fish2?.size.height ?? CGFloat(0)), img: fish2 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed1?.size.height ?? CGFloat(0)), img: seaweed1 ?? UIImage())
    }
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchUpHomeTopButton(_ sender: Any) {
        homeTableView.setContentOffset(.zero, animated: true)
        swipeUpButton.isHidden = true
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    // 단계의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    // 단계 구분 section header 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    // 단계 구분 section footer 높이
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    // 각 단계 당 물방울의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bubbleDepthArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = homeTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.bubbleTableViewCell) as? BubbleTableViewCell {
            
            // table view cell에게 데이터 전달
            let rowArray = bubbleDepthArray[indexPath.section]
            cell.setCell(bubble: rowArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    // 각 cell의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    // 각 cell의 배경 투명화
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 각 cell의 배경 투명화
        cell.backgroundColor = UIColor.clear
        // z Position main thread에서 조정
        DispatchQueue.main.async {
            for index in 0 ..< tableView.visibleCells.count {
                let zPosition = CGFloat(tableView.visibleCells.count - index)
                tableView.visibleCells[index].layer.zPosition = zPosition
            }
        }
    }
    
    // secion header view에 label 붙이기
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: sectionHeight))
        let depthLabel = UILabel(frame: CGRect(x: depthLabelFrameX, y: depthLabelFrameY, width: tableView.frame.size.width, height: depthLabelFrameHeight))
        depthLabel.font = UIFont.systemFont(ofSize: depthLabelFontSize, weight: .light)
        depthLabel.textColor = UIColor.white
        depthLabel.text = Constants.Content.depthNameArray[section]
        // depthLabel.attributedText = depthLabel.text?.textSpacing(lineSpacing: 7)
        sectionHeaderView.addSubview(depthLabel)
        sectionHeaderView.backgroundColor = UIColor.clear // 투명화

        return sectionHeaderView
    }
    
    // scroll이 시작됐을 때
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 화면 전체가 gradient 일 때만
        if scrollView.contentOffset.y >= sectionFrameArray[0].origin.y {
            homeTopButton.isHidden = false
            myPageButton.setImage(Constants.Design.Image.btnIcMy, for: .normal)
            calendarButton.isHidden = false
        } else {
            homeTopButton.isHidden = true
            myPageButton.setImage(Constants.Design.Image.btnIcMyBlue, for: .normal)
            calendarButton.isHidden = true
        }
    }
    
    // scroll 감속이 시작됐을 때
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        swipeUpButton.isHidden = true
        swipeDownButton.isHidden = true
    }
    
    // scroll 감속이 끝나고 정지 상태일 때
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        
        if yOffset == 0 {
            swipeDownButton.isHidden = false
        }
        
        if yOffset >= sectionFrameArray[0].origin.y {
            swipeUpButton.isHidden = false
            swipeDownButton.isHidden = false
        }
        
        if yOffset + UIScreen.main.bounds.height >= sectionFrameArray[6].origin.y + sectionFrameArray[6].size.height {
            swipeUpButton.isHidden = false
            swipeDownButton.isHidden = true
        }
        
        if yOffset < sectionFrameArray[0].origin.y {
            let contentOffset = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(contentOffset, animated: true)
            swipeUpButton.isHidden = true
            swipeDownButton.isHidden = false
        }
    }
    
    // 손을 뗐을 때 한 번만 호출
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let yOffset = scrollView.contentOffset.y
        
        if yOffset > 0 && yOffset < sectionFrameArray[0].origin.y {
            // 내려갈 때
            if velocity.y > 0 {
                targetContentOffset.pointee = CGPoint(x: 0, y: sectionFrameArray[0].origin.y)
                
            // 올라갈 때
            } else if velocity.y < 0 {
                targetContentOffset.pointee = CGPoint(x: 0, y: 0)
            }
        }
    }
}
