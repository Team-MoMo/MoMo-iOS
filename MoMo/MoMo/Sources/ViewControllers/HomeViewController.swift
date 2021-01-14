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
    var bubbleDepthArray: [[Diary]] = [] // depth 별로 잘라놓은 Bubble 배열의 배열
    
    var diaryArray: [Diary] = []
    
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
    
    // date
    var dateArray: [String] = []
    
    var objView = UIImageView()
    
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
        
        DiariesService.shared.getDiaries(userId: "\(APIConstants.userId)",
                                         year: "2020",
                                         month: "8",
                                         order: "depth",
                                         day: nil,
                                         emotionId: nil,
                                         depth: nil
        ) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let diary = data as? [Diary] {
                    self.diaryArray = diary
                    self.devideArrayByDepth()

                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
            self.calculateFramesOfSections()
            self.paintGradientWithFrame()
            self.homeTableView.reloadData()
            
             // 단계별 objet 배치
            self.attachDepth0Objet()
            self.attachDepth1Objet()
            self.attachDepth2Objet()
            self.attachDepth3Objet()
            self.attachDepth4Objet()
            self.attachDepth5Objet()
            self.attachDepth6Objet()
            
            let pleaseView = UIView(frame: CGRect(x: 0, y: self.sectionFrameArray[0].origin.y, width: UIScreen.main.bounds.width, height: 500))
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.touchBubble(_:)))
            pleaseView.addGestureRecognizer(tapRecognizer)
        }
        
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
        
        // tableFooterView 지정
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        let footerImageVIew = attachFooterObjet()
        footer.addSubview(footerImageVIew)
        homeTableView.tableFooterView = footer
        
        // contentOffset 0부터 시작하도록 조정
        homeTableView.contentInsetAdjustmentBehavior = .never
        
        // statusbar 높이 가져오기
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        // 오늘 날짜 가져오기
        getCurrentFormattedDate()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        // navi bar button 만들기
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Functions
    
    // section 별 frame에 맞게 gradient 입히기
    func paintGradientWithFrame() {
        for sectionIndex in 0..<7 {
            let frame = self.sectionFrameArray[sectionIndex]
            let view = UIView(frame: frame)
            let gradientView = UIView(frame: frame)
            let imgView = UIImageView(frame: view.bounds)
            
            self.currentColorSet = sectionIndex
            self.gradientLayer = CAGradientLayer()
            self.gradientLayer.frame = gradientView.frame
            self.gradientLayer.colors = self.colorSets[self.currentColorSet]
            
            let image = UIImage.gradientImageWithBounds(bounds: frame, colors: self.colorSets[sectionIndex])
            imgView.image = image
            
            view.addSubview(imgView)
            
            self.homeTableView.addSubview(view)
            self.homeTableView.sendSubviewToBack(view)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.touchBubble(_:)))
            view.addGestureRecognizer(tapRecognizer)
        }
    }
    
    // 단계 별 bubble data 배열 생성
    func devideArrayByDepth() {
        let totalArray = diaryArray
        
        if bubbleDepthArray.count == 0 {
            for sectionIndex in 0..<7 {
                let bubbleArray = totalArray.filter { (bubble: Diary) -> Bool in
                    return bubble.depth == sectionIndex
                }
                bubbleDepthArray.append(bubbleArray)
            }
            
            // 각 section별로 bubble이 4개 이하일 때 4개로 채워줌
            for sectionIndex in 0..<7 {
                let emptyDiary = Diary(id: 0, position: -1, depth: sectionIndex, contents: "-", wroteAt: "-", userID: 0, sentenceID: 0, emotionID: 0, createdAt: "0", updatedAt: "0", sentence: Sentence(id: 0, contents: "-", bookName: "-", writer: "-", publisher: "-", createdAt: "-", updatedAt: "-"), emotion: Emotion(id: 0, name: Name(rawValue: "위로")!, createdAt: "-", updatedAt: "-"))
                while bubbleDepthArray[sectionIndex].count < 4 {
                    bubbleDepthArray[sectionIndex].append(emptyDiary)
                }
            }
        } else {
            bubbleDepthArray = []
            for sectionIndex in 0..<7 {
                let bubbleArray = totalArray.filter { (bubble: Diary) -> Bool in
                    return bubble.depth == sectionIndex
                }
                bubbleDepthArray.append(bubbleArray)
            }
            
            // 각 section별로 bubble이 4개 이하일 때 4개로 채워줌
            for sectionIndex in 0..<7 {
                let emptyDiary = Diary(id: 0, position: -1, depth: sectionIndex, contents: "-", wroteAt: "2021-01-14T14:50:49.000Z", userID: 0, sentenceID: 0, emotionID: 0, createdAt: "0", updatedAt: "0", sentence: Sentence(id: 0, contents: "-", bookName: "-", writer: "-", publisher: "-", createdAt: "-", updatedAt: "-"), emotion: Emotion(id: 0, name: Name(rawValue: "위로")!, createdAt: "-", updatedAt: "-"))
                while bubbleDepthArray[sectionIndex].count < 4 {
                    bubbleDepthArray[sectionIndex].append(emptyDiary)
                }
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
    
    // section 별 frame 값 계산
    func calculateFramesOfSections() {
        
        if bubbleDepthArray.count == 0 {
            for sectionIndex in 0..<7 {
                if sectionIndex == 0 {
                    var frame = homeTableView.rect(forSection: sectionIndex)
                    frame.origin.y -= 1
                    frame.size.height = rowHeight * CGFloat(bubbleDepthArray[sectionIndex].count) + sectionHeight + 1
                    sectionFrameArray.append(frame)
                } else {
                    var frame = homeTableView.rect(forSection: sectionIndex)
                    frame.origin.y = sectionFrameArray[sectionIndex-1].origin.y + rowHeight * CGFloat(bubbleDepthArray[sectionIndex-1].count) + sectionHeight
                    frame.size.height = rowHeight * CGFloat(bubbleDepthArray[sectionIndex].count) + sectionHeight + 1
                    sectionFrameArray.append(frame)
                }
            }
        } else {
            sectionFrameArray = []
            for sectionIndex in 0..<7 {
                if sectionIndex == 0 {
                    var frame = homeTableView.rect(forSection: sectionIndex)
                    frame.origin.y -= 1
                    frame.size.height = rowHeight * CGFloat(bubbleDepthArray[sectionIndex].count) + sectionHeight + 1
                    sectionFrameArray.append(frame)
                } else {
                    var frame = homeTableView.rect(forSection: sectionIndex)
                    frame.origin.y = sectionFrameArray[sectionIndex-1].origin.y + rowHeight * CGFloat(bubbleDepthArray[sectionIndex-1].count) + sectionHeight
                    frame.size.height = rowHeight * CGFloat(bubbleDepthArray[sectionIndex].count) + sectionHeight + 1
                    sectionFrameArray.append(frame)
                }
            }
        }
    }
    
    // 전달받은 img, frame의 x, y값에 맞게 오브제 배치
    func attachObjet(frameX: CGFloat, frameY: CGFloat, img: UIImage) {
        let imgView = UIImageView(frame: CGRect(x: frameX, y: frameY, width: img.size.width, height: img.size.height))
        imgView.image = img
        
        homeTableView.addSubview(imgView)
    }
    
    // bottom 오브제 배치
    func attachBottomObjet(frameX: CGFloat, frameY: CGFloat, img: UIImage) {
        let imgWidth = img.size.width
        let imgHeight = img.size.height
        let width = UIScreen.main.bounds.width
        let height = (imgHeight * width) / imgWidth
        objView = UIImageView(frame: CGRect(x: frameX, y: frameY, width: UIScreen.main.bounds.width, height: height))
        objView.image = img
        
        homeTableView.addSubview(objView)
    }
    
    // footer 오브제 배치
    func attachFooterObjet() -> UIImageView {
        let img = Constants.Design.Image.depth6bottom ?? UIImage()
        let imgWidth = img.size.width
        let imgHeight = img.size.height
        let width = UIScreen.main.bounds.width
        let height = (imgHeight * width) / imgWidth
        let imgView = UIImageView(frame: CGRect(x: 0, y: -1, width: UIScreen.main.bounds.width, height: height))
        imgView.image = img
        
        return imgView
    }
    
    // MARK: objet 붙이기
    
    // TODO: - 근데 맨 밑에꺼만 떼짐
    // 다 떼기
    func removeAllObjets() {
        print(self.homeTableView.subviews.contains(objView))
        while self.homeTableView.subviews.contains(objView) {
            print(self.homeTableView.subviews.contains(objView))
            self.objView.removeFromSuperview()
            print(self.homeTableView.subviews.contains(objView))
        }
//        if self.homeTableView.subviews.contains(objView) {
//            print(objView)
//            self.objView.removeFromSuperview()
//        }
    }
    
    // 0단계 - 2m
    func attachDepth0Objet() {
        let sectionFrameY = sectionFrameArray[0].origin.y
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
        attachObjet(frameX: screenWidth - 47 - (fish2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - 197 - (fish2?.size.height ?? CGFloat(0)), img: fish2 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed1?.size.height ?? CGFloat(0)), img: seaweed1 ?? UIImage())
    }
    
    // 1단계 - 30m
    func attachDepth1Objet() {
        let sectionFrameY = sectionFrameArray[1].origin.y
        let sectionFrameBottom = sectionFrameArray[2].origin.y
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let rock1 = Constants.Design.Image.depth1Rock1
        let seaweed = Constants.Design.Image.depth1Seaweed
        let dolphin1 = Constants.Design.Image.depth1Dolphin1
        let dolphin2 = Constants.Design.Image.depth1Dolphin2
        let coral1 = Constants.Design.Image.depth1Coral1
        let fish1 = Constants.Design.Image.depth1Fish1
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: seaweed ?? UIImage())
        attachObjet(frameX: 9, frameY: sectionFrameY + 260, img: dolphin1 ?? UIImage())
        attachObjet(frameX: screenWidth - 22 - (dolphin2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - 143 - (dolphin2?.size.width ?? CGFloat(0)), img: dolphin2 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom, img: coral1 ?? UIImage())
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom, img: fish1 ?? UIImage())
    }
    
    // 2단계 - 100m
    func attachDepth2Objet() {
        let sectionFrameY = sectionFrameArray[2].origin.y
        let sectionFrameBottom = sectionFrameArray[3].origin.y
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let fish1 = Constants.Design.Image.depth2Fish1
        let fish2 = Constants.Design.Image.depth2Fish2
        let turtle1 = Constants.Design.Image.depth2Turtle1
        let turtle2 = Constants.Design.Image.depth2Turtle2
        let seaweed1 = Constants.Design.Image.depth2Seaweed1
        let seaweed2 = Constants.Design.Image.depth2Seaweed2
        
        // objet 붙이기
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: fish1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameY + 147, img: fish2 ?? UIImage())
        attachObjet(frameX: screenWidth - 68 - (turtle1?.size.width ?? CGFloat(0)), frameY: sectionFrameY + 118, img: turtle1 ?? UIImage())
        attachObjet(frameX: 9, frameY: sectionFrameBottom - 148 - (turtle2?.size.height ?? CGFloat(0)), img: turtle2 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (seaweed1?.size.height ?? CGFloat(0)), img: seaweed1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed2?.size.height ?? CGFloat(0)), img: seaweed2 ?? UIImage())
    }
    
    // 3단계 - 300m
    func attachDepth3Objet() {
        let sectionFrameY = sectionFrameArray[3].origin.y
        let sectionFrameBottom = sectionFrameArray[4].origin.y
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let seaweed1 = Constants.Design.Image.depth3Seaweed1
        let seaweed2 = Constants.Design.Image.depth3Seaweed2
        let seaweed3 = Constants.Design.Image.depth3Seaweed3
        let fish1 = Constants.Design.Image.depth3Fish1
        let fish2 = Constants.Design.Image.depth3Fish2
        let stingray1 = Constants.Design.Image.depth3Stingray1
        let rock1 = Constants.Design.Image.depth3Rock1
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: seaweed1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed2?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: seaweed2 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (seaweed3?.size.height ?? CGFloat(0)), img: seaweed3 ?? UIImage())
        attachObjet(frameX: 88, frameY: sectionFrameY + 7, img: fish1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - 24 - (fish2?.size.height ?? CGFloat(0)), img: fish2 ?? UIImage())
        attachObjet(frameX: screenWidth - 44 - (stingray1?.size.width ?? CGFloat(0)), frameY: sectionFrameY + 148, img: stingray1 ?? UIImage())
        attachObjet(frameX: screenWidth - (rock1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (rock1?.size.height ?? CGFloat(0)), img: rock1 ?? UIImage())
    }
    
    // 4단계 - 700m
    func attachDepth4Objet() {
        let sectionFrameY = sectionFrameArray[4].origin.y
        let sectionFrameBottom = sectionFrameArray[5].origin.y
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let seaweed1 = Constants.Design.Image.depth4Seaweed1
        let seaweed2 = Constants.Design.Image.depth4Seaweed2
        let rock1 = Constants.Design.Image.depth4Rock1
        let whale1 = Constants.Design.Image.depth4Whale1
        let fish1 = Constants.Design.Image.depth4Fish1
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: seaweed1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (seaweed2?.size.height ?? CGFloat(0)), img: seaweed2 ?? UIImage())
        attachObjet(frameX: screenWidth - (rock1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameY + 67, img: whale1 ?? UIImage())
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (fish1?.size.height ?? CGFloat(0)), img: fish1 ?? UIImage())
    }
    
    // 5단계 - 1005m
    func attachDepth5Objet() {
        let sectionFrameY = sectionFrameArray[5].origin.y
        let sectionFrameBottom = sectionFrameArray[6].origin.y
        let screenWidth = UIScreen.main.bounds.width
                
        // img 변수 선언
        let seaweed1 = Constants.Design.Image.depth5Seaweed1
        let seaweed2 = Constants.Design.Image.depth5Seaweed2
        let shark = Constants.Design.Image.depth5Shark
        let rock1 = Constants.Design.Image.depth5Rock1
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: seaweed1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed2?.size.height ?? CGFloat(0)), img: seaweed2 ?? UIImage())
        attachObjet(frameX: screenWidth - (shark?.size.width ?? CGFloat(0)), frameY: sectionFrameY + 62, img: shark ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (rock1?.size.height ?? CGFloat(0)), img: rock1 ?? UIImage())
    }
    
    // 6단계 - 심해
    func attachDepth6Objet() {
        let sectionFrameY = sectionFrameArray[6].origin.y
        let sectionFrameBottom = sectionFrameArray[6].origin.y + sectionFrameArray[6].size.height
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let rock1 = Constants.Design.Image.depth6Rock1
        let seaweed1 = Constants.Design.Image.depth6Seaweed1
        let sea = Constants.Design.Image.depth6Sea
        
        // sea 이미지 높이 계산
        let imgWidth = sea?.size.width ?? CGFloat(0)
        let imgHeight = sea?.size.height ?? CGFloat(0)
        let width = UIScreen.main.bounds.width
        let height = (imgHeight * width) / imgWidth
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: seaweed1 ?? UIImage())
        attachBottomObjet(frameX: 0, frameY: sectionFrameBottom - height, img: sea ?? UIImage())
    }
    
    // MARK: 해찌꺼뽀려옴2
    func getCurrentFormattedDate() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy. MM. dd. EEEE"
        dateFormatter.locale = Locale.current
        
        let formattedDate = dateFormatter.string(from: date)
        dateArray = formattedDate.components(separatedBy: ". ")
    }
    
    @objc func touchBubble(_ sender: UITapGestureRecognizer) {
        print("fuck")
        
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        guard let dvc = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else {
            return
        }
        //dvc.diaryId = bubbleDepthArray[indexPath.section][indexPath.row].id
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchUpHomeTopButton(_ sender: Any) {
        homeTableView.setContentOffset(.zero, animated: true)
        swipeUpButton.isHidden = true
    }
    
    @IBAction func touchUpUploadButton(_ sender: Any) {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let dvc = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else {
            return
        }
        dvc.changeUsage = false
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    @IBAction func touchUpListButton(_ sender: Any) {
        let listStoryboard = UIStoryboard(name: Constants.Name.listStoryboard, bundle: nil)
        let dvc = listStoryboard.instantiateViewController(identifier: Constants.Identifier.listViewController)
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    @IBAction func touchUpCalendarButton(_ sender: Any) {
        let uploadModalViewController = UploadModalViewController()
        
        
        uploadModalViewController.modalPresentationStyle = .custom
        
        uploadModalViewController.transitioningDelegate = self
        uploadModalViewController.uploadModalDataDelegate = self
        
        uploadModalViewController.year = Int(dateArray[0]) ?? 0
        uploadModalViewController.month = Int(dateArray[1]) ?? 0
        uploadModalViewController.day = Int(dateArray[2]) ?? 0
        
        self.present(uploadModalViewController, animated: true, completion: nil)
        
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        UploadModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension HomeViewController: UploadModalPassDataDelegate {
    func passData(_ date: String) {
        dateArray = date.components(separatedBy: ". ")
        DiariesService.shared.getDiaries(userId: "\(APIConstants.userId)",
                                         year: "\(dateArray[0])",
                                         month: "\(dateArray[1])",
                                         order: "depth",
                                         day: nil,
                                         emotionId: nil,
                                         depth: nil
        ) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let diary = data as? [Diary] {
                    self.diaryArray = diary
                    self.devideArrayByDepth()

                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
            self.calculateFramesOfSections()
            self.paintGradientWithFrame()
            self.homeTableView.reloadData()
            
            // 단계별 objet 배치
            self.removeAllObjets()
//            self.attachDepth0Objet()
//            self.attachDepth1Objet()
//            self.attachDepth2Objet()
//            self.attachDepth3Objet()
//            self.attachDepth4Objet()
//            self.attachDepth5Objet()
//            self.attachDepth6Objet()
        }
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
        if bubbleDepthArray.count == 0 {
            return 4
        } else {
            return bubbleDepthArray[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = homeTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.bubbleTableViewCell) as? BubbleTableViewCell {
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchBubble(_:)))
            cell.superview?.addGestureRecognizer(tapRecognizer)
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("zz")
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        guard let dvc = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else {
            return
        }
        dvc.diaryId = bubbleDepthArray[indexPath.section][indexPath.row].id
        self.navigationController?.pushViewController(dvc, animated: true)
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
                let zPosition = CGFloat(tableView.visibleCells.count + 999)
                tableView.visibleCells[index].layer.zPosition = zPosition
                // print(index)
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.touchBubble(_:)))
                cell.contentView.addGestureRecognizer(tapRecognizer)
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
