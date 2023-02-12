//
//  HomeViewController.swift
//  MoMo
//
//  Created by 초이 on 2021/01/08.
//

import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
    @IBOutlet weak var coachmarkView: UIView!
    
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
    var dateArray: [String] = ["", "", ""]
    
    var objView = UIImageView()
    
    // flag
    var isFromDiary: Bool = false
    var isFromLogoutOrWithdrawal: Bool = false
    
    //
    var headerView: HomeDayNightView?
    var tagNum: Int = 0
    
    // coachmark
    var coachmarkTouchCount = 0
    
    let serviceEndUseCase: ServiceEndModalUseCase = ServiceEndModalUseCaseImpl()
    
    var serviceEndModalView: ServiceEndModalView?
    
    // MARK: - View Life Cycle
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // edge pan gesture 추가
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        homeTableView.allowsSelection = true
        
        // 오늘 날짜 가져오기
        self.getCurrentFormattedDate()
        
        // bubble table view cell register
        let cellNib = UINib(nibName: Constants.Name.bubbleTableViewCell, bundle: nil)
        self.homeTableView.register(cellNib, forCellReuseIdentifier: Constants.Identifier.bubbleTableViewCell)
        self.homeTableView.backgroundColor = UIColor.clear
        
        // tableView separator 없애기
        homeTableView.separatorStyle = .none
        
        // 첫 화면 버튼 hidden 처리
        calendarButton.isHidden = true
        swipeUpButton.isHidden = true
        homeTopButton.isHidden = true
        
        // 권한 위임
        self.homeTableView.dataSource = self
        self.homeTableView.delegate = self
        devideArrayByDepth()
        createGradientColorSets()
        
        // tableHeaderView register
        self.headerView = Bundle.main.loadNibNamed(Constants.Name.homeDayNightViewXib, owner: self, options: nil)?.last as? HomeDayNightView  // awakeNib!!!
        self.headerView?.homeDayNightViewDelegate = self
        
        // tableHeaderView 지정
        self.homeTableView.tableHeaderView = self.headerView
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
        
        // 서비스 종료 팝업
        if serviceEndUseCase.shouldShowPopUp {
            let modalView: ServiceEndModalView = ServiceEndModalView.loadNib()
            modalView.didTapDownloadButtonHandler = { [weak self] _ in
                self?.serviceEndUseCase.agreeNotToSeeAgainFor3Days()
                self?.dismissServiceEndModalView()
                self?.pushToServiceEndViewController()
            }
            modalView.didTapDoNotSeeAgainFor3DaysConfirmButtonHandler = { [weak self] _ in
                self?.serviceEndUseCase.agreeNotToSeeAgainFor3Days()
                self?.dismissServiceEndModalView()
            }
            modalView.didTapDoNotSeeAgainConfirmButton = { [weak self] _ in
                self?.serviceEndUseCase.agreeNotToSeeAgain()
                self?.dismissServiceEndModalView()
            }
            serviceEndModalView = modalView
            showServiceEndModalViewWithAnimation(modalView: modalView)
        }
    }
    
    func showServiceEndModalViewWithAnimation(modalView: ServiceEndModalView) {
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.isHidden = true
        view.addSubview(modalView)
        NSLayoutConstraint.activate([
            modalView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            modalView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            modalView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            modalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        UIView.animate(withDuration: 0.3) {
            modalView.isHidden = false
        }
    }
    
    func dismissServiceEndModalView() {
        if let view = serviceEndModalView, view.superview != nil {
            view.removeFromSuperview()
            serviceEndModalView = nil
        }
    }
    
    func pushToServiceEndViewController() {
        let storyboard = UIStoryboard(name: Constants.Name.serviceEndStoryboard, bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: Constants.Identifier.serviceEndViewController) as? ServiceEndViewController else { return }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 백버튼 숨김
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = true
        
        
        let userId = UserDefaults.standard.integer(forKey: "userId")
        
        if self.isFromDiary {
            // self.attachTableHeaderView()
            self.headerView?.getSeletectedDateDiaryAPI()
            getDiariesWithAPI(
                userId: "\(APIConstants.userId)",
                year: "\(dateArray[0])",
                month: "\(dateArray[1])",
                order: "depth", day: nil,
                emotionId: nil,
                depth: nil) {
                self.homeTableView.reloadData()
            }
        }
        
        DiariesService.shared.getDiaries(userId: "\(userId)",
                                         year: dateArray[0],
                                         month: dateArray[1],
                                         order: "depth",
                                         day: nil,
                                         emotionId: nil,
                                         depth: nil
        ) { networkResult in
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
                print("pathErr at DiariesService viewWillAppear")
            case .serverErr:
                print("serverErr at DiariesService viewWillAppear")
            case .networkFail:
                print("networkFail at DiariesService viewWillAppear")
            }
            self.calculateFramesOfSections()
            self.paintGradientWithFrame()
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
            
            // 단계별 objet 배치
            self.rearrangeObjet()
            
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
        
        homeTableView.reloadData()
        
        if self.isFromLogoutOrWithdrawal {
            self.isFromLogoutOrWithdrawal = false
            self.pushToLoginViewController()
        }
        
        initCoachmarkView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        // navi bar button 만들기
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Functions
    
    private func initCoachmarkView() {
        
        if !UserDefaults.standard.bool(forKey: "didLogin") {
            coachmarkView.isHidden = false
            coachmarkView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            // 첫번째 코치마크 뷰 register
            if let coachmark1 = Bundle.main.loadNibNamed(Constants.Name.coachmarkFirstViewXib, owner: nil, options: nil)?.first as? UIView {
                coachmark1.frame = self.coachmarkView.bounds
                coachmarkView.addSubview(coachmark1)
            }
            
            let coachmarkGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchCoachmark(_:)))
            coachmarkView.addGestureRecognizer(coachmarkGesture)
        } else {
            coachmarkView.isHidden = true
        }
    }
    
    @objc func touchCoachmark(_ gesture: UITapGestureRecognizer) {
        coachmarkTouchCount += 1
        if coachmarkTouchCount == 1 {
            // 두번째 코치마크 뷰
            for view in coachmarkView.subviews {
                view.removeFromSuperview()
            }
            if let coachmark2 = Bundle.main.loadNibNamed(Constants.Name.coachmarkSecondViewXib, owner: nil, options: nil)?.first as? UIView {
                coachmark2.frame = self.coachmarkView.bounds
                coachmarkView.addSubview(coachmark2)
            }
        } else {
            // 코치마크 뷰 숨기기
            for view in coachmarkView.subviews {
                view.removeFromSuperview()
            }
            coachmarkView.isHidden = true
            UserDefaults.standard.setValue(true, forKey: "didLogin")
            coachmarkTouchCount = 0
        }
    }
    
    func rearrangeObjet() {
        // 단계별 objet 배치
        self.removeAllObjets()
        self.paintGradientWithFrame()
        self.attachDepth0Objet()
        self.attachDepth1Objet()
        self.attachDepth2Objet()
        self.attachDepth3Objet()
        self.attachDepth4Objet()
        self.attachDepth5Objet()
        self.attachDepth6Objet()
    }
    
    func pushToLoginViewController() {
        let loginStoryboard = UIStoryboard(name: Constants.Name.loginStoryboard, bundle: nil)
        guard let loginViewController = loginStoryboard.instantiateViewController(identifier: Constants.Identifier.loginViewController) as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func attachTableHeaderView() {
        // tableHeaderView register
        headerView = Bundle.main.loadNibNamed(Constants.Name.homeDayNightViewXib, owner: self, options: nil)?.last as? HomeDayNightView
        headerView?.homeDayNightViewDelegate = self
        // tableHeaderView 지정
        homeTableView.tableHeaderView = headerView
        DispatchQueue.main.async {
            self.homeTableView.tableHeaderView?.frame.size.height = UIScreen.main.bounds.height
        }
        
    }
    
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

            view.isUserInteractionEnabled = false
            view.addSubview(imgView)
            
            self.tagNum += 1
            view.tag = self.tagNum
            self.homeTableView.addSubview(view)
            self.homeTableView.sendSubviewToBack(view)
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
                let emptyDiary = Diary(id: 0, position: -1, depth: sectionIndex, contents: "-", wroteAt: "-", userID: 0, sentenceID: 0, emotionID: 0, createdAt: "0", updatedAt: "0", sentence: Sentence(id: 0, contents: "-", bookName: "-", writer: "-", publisher: "-", createdAt: "-", updatedAt: "-", blindedAt: "-", deletedAt: "-"), emotion: Emotion(id: 0, name: Name(rawValue: "위로")!, createdAt: "-", updatedAt: "-"))
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
                let emptyDiary = Diary(id: 0, position: -1, depth: sectionIndex, contents: "-", wroteAt: "2021-01-14T14:50:49.000Z", userID: 0, sentenceID: 0, emotionID: 0, createdAt: "0", updatedAt: "0", sentence: Sentence(id: 0, contents: "-", bookName: "-", writer: "-", publisher: "-", createdAt: "-", updatedAt: "-", blindedAt: "-", deletedAt: "-"), emotion: Emotion(id: 0, name: Name(rawValue: "위로")!, createdAt: "-", updatedAt: "-"))
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
        objView = UIImageView(frame: CGRect(x: frameX, y: frameY, width: img.size.width, height: img.size.height))
        objView.image = img

        objView.isUserInteractionEnabled = false
        homeTableView.addSubview(objView)
        self.tagNum += 1
        objView.tag = self.tagNum
    }
    
    // bottom 오브제 배치
    func attachBottomObjet(frameX: CGFloat, frameY: CGFloat, img: UIImage) {
        let imgWidth = img.size.width
        let imgHeight = img.size.height
        let width = UIScreen.main.bounds.width
        let height = (imgHeight * width) / imgWidth
        objView = UIImageView(frame: CGRect(x: frameX, y: frameY, width: UIScreen.main.bounds.width, height: height))
        objView.image = img
        
        objView.isUserInteractionEnabled = false
        homeTableView.addSubview(objView)
        self.tagNum += 1
        objView.tag = self.tagNum
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
    
    // MARK: objet 붙이고 떼기
    
    // 다 떼기
    func removeAllObjets() {
        for view in homeTableView.subviews {
            if view.tag >= 1 {
                view.removeFromSuperview()
            }
        }
    }
    
    // 0단계 - 2m
    func attachDepth0Objet() {
        let sectionFrameY = sectionFrameArray[0].origin.y
        let sectionFrameBottom = sectionFrameArray[1].origin.y
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let rock1 = Constants.Design.Image.depth0Rock1
        let rock2 = Constants.Design.Image.depth0Rock2
        let fish1 = Constants.Design.Image.depth0Fish1
        let fish2 = Constants.Design.Image.depth0Fish2
        let fish5 = Constants.Design.Image.depth0Fish5
        let seaweed1 = Constants.Design.Image.depth0Seaweed1
        let bubble1 = Constants.Design.Image.depth0Bubble1
        
        // objet 붙이기
        attachObjet(frameX: screenWidth - (rock1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (rock2?.size.height ?? CGFloat(0)), img: rock2 ?? UIImage())
        attachObjet(frameX: 64, frameY: sectionFrameCenterY - 124 - (fish1?.size.height ?? CGFloat(0)), img: fish1 ?? UIImage())
        attachObjet(frameX: screenWidth - 47 - (fish2?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY + 151, img: fish2 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed1?.size.height ?? CGFloat(0)), img: seaweed1 ?? UIImage())
        attachObjet(frameX: 75, frameY: sectionFrameCenterY + 219, img: fish5 ?? UIImage())
        attachObjet(frameX: screenWidth - 40 - (bubble1?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY - (bubble1?.size.height ?? CGFloat(0)), img: bubble1 ?? UIImage())
    }
    
    // 1단계 - 30m
    func attachDepth1Objet() {
        let sectionFrameY = sectionFrameArray[1].origin.y
        let sectionFrameBottom = sectionFrameArray[2].origin.y
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let rock1 = Constants.Design.Image.depth1Rock1
        let seaweed = Constants.Design.Image.depth1Seaweed
        let seaweed3 = Constants.Design.Image.depth1Seaweed3
        let dolphin1 = Constants.Design.Image.depth1Dolphin1
        let dolphin2 = Constants.Design.Image.depth1Dolphin2
        let coral1 = Constants.Design.Image.depth1Coral1
        let fish1 = Constants.Design.Image.depth1Fish1
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: seaweed ?? UIImage())
        attachObjet(frameX: 9, frameY: sectionFrameCenterY - 90, img: dolphin1 ?? UIImage())
        attachObjet(frameX: screenWidth - 22 - (dolphin2?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY + 137, img: dolphin2 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (coral1?.size.height ?? CGFloat(0)), img: coral1 ?? UIImage())
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom, img: fish1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed3?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - 267 - (seaweed3?.size.height ?? CGFloat(0)), img: seaweed3 ?? UIImage())
    }
    
    // 2단계 - 100m
    func attachDepth2Objet() {
        let sectionFrameY = sectionFrameArray[2].origin.y
        let sectionFrameBottom = sectionFrameArray[3].origin.y
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let fish1 = Constants.Design.Image.depth2Fish1
        let fish2 = Constants.Design.Image.depth2Fish2
        let fish3 = Constants.Design.Image.depth2Fish3
        let turtle1 = Constants.Design.Image.depth2Turtle1
        let turtle2 = Constants.Design.Image.depth2Turtle2
        let seaweed1 = Constants.Design.Image.depth2Seaweed1
        let seaweed2 = Constants.Design.Image.depth2Seaweed2
        
        // objet 붙이기
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: fish1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - 433 - (fish2?.size.height ?? CGFloat(0)), img: fish2 ?? UIImage())
        attachObjet(frameX: 136, frameY: sectionFrameCenterY + 186, img: fish3 ?? UIImage())
        attachObjet(frameX: screenWidth - 68 - (turtle1?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY - 134 - (turtle1?.size.height ?? CGFloat(0)), img: turtle1 ?? UIImage())
        attachObjet(frameX: 9, frameY: sectionFrameCenterY + 17, img: turtle2 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (seaweed1?.size.height ?? CGFloat(0)), img: seaweed1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed2?.size.height ?? CGFloat(0)), img: seaweed2 ?? UIImage())
    }
    
    // 3단계 - 300m
    func attachDepth3Objet() {
        let sectionFrameY = sectionFrameArray[3].origin.y
        let sectionFrameBottom = sectionFrameArray[4].origin.y
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
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
        attachObjet(frameX: 88, frameY: sectionFrameCenterY - 177 - (fish1?.size.height ?? CGFloat(0)), img: fish1 ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameCenterY + 174, img: fish2 ?? UIImage())
        attachObjet(frameX: screenWidth - 44 - (stingray1?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY - (stingray1?.size.height ?? CGFloat(0)), img: stingray1 ?? UIImage())
        attachObjet(frameX: screenWidth - (rock1?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (rock1?.size.height ?? CGFloat(0)), img: rock1 ?? UIImage())
    }
    
    // 4단계 - 700m
    func attachDepth4Objet() {
        let sectionFrameY = sectionFrameArray[4].origin.y
        let sectionFrameBottom = sectionFrameArray[5].origin.y
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
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
        attachObjet(frameX: 0, frameY: sectionFrameCenterY - (whale1?.size.height ?? CGFloat(0)), img: whale1 ?? UIImage())
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY + 125, img: fish1 ?? UIImage())
    }
    
    // 5단계 - 1005m
    func attachDepth5Objet() {
        let sectionFrameY = sectionFrameArray[5].origin.y
        let sectionFrameBottom = sectionFrameArray[6].origin.y
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
        let screenWidth = UIScreen.main.bounds.width
                
        // img 변수 선언
        let seaweed1 = Constants.Design.Image.depth5Seaweed1
        let seaweed2 = Constants.Design.Image.depth5Seaweed2
        let seaweed3 = Constants.Design.Image.depth5Seaweed3
        let shark = Constants.Design.Image.depth5Shark
        let rock1 = Constants.Design.Image.depth5Rock1
        let bubble1 = Constants.Design.Image.depth5Bubble1
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: seaweed1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed2?.size.width ?? CGFloat(0)), frameY: sectionFrameBottom - (seaweed2?.size.height ?? CGFloat(0)), img: seaweed2 ?? UIImage())
        attachObjet(frameX: screenWidth - (shark?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY - 82 - (shark?.size.height ?? CGFloat(0)), img: shark ?? UIImage())
        attachObjet(frameX: 0, frameY: sectionFrameBottom - (rock1?.size.height ?? CGFloat(0)), img: rock1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed3?.size.width ?? CGFloat(0)), frameY: sectionFrameY + 174, img: seaweed3 ?? UIImage())
        attachObjet(frameX: 84, frameY: sectionFrameCenterY + 160, img: bubble1 ?? UIImage())
    }
    
    // 6단계 - 심해
    func attachDepth6Objet() {
        let sectionFrameY = sectionFrameArray[6].origin.y
        let sectionFrameBottom = sectionFrameArray[6].origin.y + sectionFrameArray[6].size.height
        let sectionFrameCenterY = sectionFrameBottom - ((sectionFrameBottom - sectionFrameY) / 2)
        let screenWidth = UIScreen.main.bounds.width
        
        // img 변수 선언
        let rock1 = Constants.Design.Image.depth6Rock1
        let seaweed1 = Constants.Design.Image.depth6Seaweed1
        let sea = Constants.Design.Image.depth6Sea
        let fish1 = Constants.Design.Image.depth6Fish1
        
        // sea 이미지 높이 계산
        let imgWidth = sea?.size.width ?? CGFloat(0)
        let imgHeight = sea?.size.height ?? CGFloat(0)
        let width = UIScreen.main.bounds.width
        let height = (imgHeight * width) / imgWidth
        
        // objet 붙이기
        attachObjet(frameX: 0, frameY: sectionFrameY, img: rock1 ?? UIImage())
        attachObjet(frameX: screenWidth - (seaweed1?.size.width ?? CGFloat(0)), frameY: sectionFrameY, img: seaweed1 ?? UIImage())
        attachObjet(frameX: screenWidth - (fish1?.size.width ?? CGFloat(0)), frameY: sectionFrameCenterY - (fish1?.size.height ?? CGFloat(0)), img: fish1 ?? UIImage())
        attachBottomObjet(frameX: 0, frameY: sectionFrameBottom - height, img: sea ?? UIImage())
    }
    
    func getCurrentFormattedDate() {
        let today = AppDate()
        let year = today.getYearToString()
        let month = today.getMonthToString()
        let day = today.getDayToString()
        let weekDay = today.getWeekday().toKorean()
        
        dateArray[0] = year
        dateArray[1] = month
        dateArray[2] = day
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchUpHomeTopButton(_ sender: Any) {
        homeTableView.setContentOffset(.zero, animated: true)
        swipeUpButton.isHidden = true
    }
    
    @IBAction func touchUpUploadButton(_ sender: Any) {
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let moodViewController = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else {
            return
        }
        moodViewController.moodViewUsage = .upload
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
    @IBAction func touchUpListButton(_ sender: Any) {
        let listStoryboard = UIStoryboard(name: Constants.Name.listStoryboard, bundle: nil)
        guard let dvc = listStoryboard.instantiateViewController(identifier: Constants.Identifier.listViewController) as? ListViewController else {
            return
        }
        dvc.year = Int(dateArray[0])!
        dvc.month = Int(dateArray[1])!
        
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    @IBAction func touchUpCalendarButton(_ sender: Any) {
        let homeModalViewController = HomeModalViewController()
        
        homeModalViewController.modalPresentationStyle = .custom
        
        homeModalViewController.transitioningDelegate = self
        homeModalViewController.homeModalViewDelegate = self
        
        homeModalViewController.year = Int(dateArray[0]) ?? 0
        homeModalViewController.month = Int(dateArray[1]) ?? 0
        
        self.present(homeModalViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func touchMyPageButton(_ sender: UIButton) {
        let settingStoryboard = UIStoryboard(name: Constants.Name.settingStoryboard, bundle: nil)
        guard let settingViewController = settingStoryboard.instantiateViewController(identifier: Constants.Identifier.settingViewController) as? SettingViewController else {
            return
        }
        settingViewController.settingViewUsage = .setting
        self.navigationController?.pushViewController(settingViewController, animated: true)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        UploadModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension HomeViewController: UploadModalViewDelegate {
    func passData(_ date: String) {
        dateArray = date.components(separatedBy: ". ")
        
        getDiariesWithAPI(
            userId: "\(APIConstants.userId)",
            year: "\(dateArray[0])",
            month: "\(dateArray[1])",
            order: "depth", day: nil,
            emotionId: nil,
            depth: nil) {
            
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
            
            // table view cell에게 데이터 전달
            let rowArray = bubbleDepthArray[indexPath.section]
            cell.setCell(bubble: rowArray[indexPath.row])
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        return UITableViewCell()
    }
    
    // 각 cell의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowArray = bubbleDepthArray[indexPath.section]
        
        // 빈 셀이 아닐 때
        if rowArray[indexPath.row].position != -1 {
            let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
            guard let dvc = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else {
                return
            }
            dvc.diaryId = bubbleDepthArray[indexPath.section][indexPath.row].id
            dvc.initialDepth = AppDepth(rawValue: bubbleDepthArray[indexPath.section][indexPath.row].depth)
            self.navigationController?.pushViewController(dvc, animated: true)
        }
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
        depthLabel.attributedText = depthLabel.text?.textSpacing()
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

extension HomeViewController: HomeDayNightViewDelegate {
    func writeButtonTouchUp(_ sender: UIButton) {
        // 업로드 뷰로 푸쉬
        let onboardingStoryboard = UIStoryboard(name: Constants.Name.onboardingStoryboard, bundle: nil)
        guard let moodViewController = onboardingStoryboard.instantiateViewController(identifier: Constants.Identifier.moodViewController) as? MoodViewController else {
            return
        }
        moodViewController.moodViewUsage = .upload
        self.navigationController?.pushViewController(moodViewController, animated: true)
    }
    
    func showAllButtonTouchUp(_ sender: UIButton, diaryId: Int) {
        // 다이어리 뷰로 푸쉬
        let diaryStoryboard = UIStoryboard(name: Constants.Name.diaryStoryboard, bundle: nil)
        guard let diaryViewController = diaryStoryboard.instantiateViewController(identifier: Constants.Identifier.diaryViewController) as? DiaryViewController else {
            return
        }
        diaryViewController.diaryId = diaryId
        self.navigationController?.pushViewController(diaryViewController, animated: true)
    }
}

extension HomeViewController {
    func getDiariesWithAPI(userId: String,
                           year: String,
                           month: String,
                           order: String,
                           day: String?,
                           emotionId: String?,
                           depth: String?,
                           completion: @escaping () -> Void) {
        DiariesService.shared.getDiaries(userId: userId, // "\(APIConstants.userId)",
                                         year: year, // "\(dateArray[0])",
                                         month: month, // "\(dateArray[1])",
                                         order: order, // "depth",
                                         day: nil,
                                         emotionId: nil,
                                         depth: nil
        ) { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let diary = data as? [Diary] {
                    self.diaryArray = diary
                    self.devideArrayByDepth()

                    DispatchQueue.main.async {
                        completion()
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr at getDiariesWithAPI")
            case .serverErr:
                print("serverErr at getDiariesWithAPI")
            case .networkFail:
                print("networkFail at getDiariesWithAPI")
            }
            self.calculateFramesOfSections()
            self.paintGradientWithFrame()
        }
    }
}

extension HomeViewController: HomeModalViewDelegate {
    func passData(year: Int, month: Int) {
        self.dateArray[0] = "\(year)"
        self.dateArray[1] = "\(month)"
        
        getDiariesWithAPI(
            userId: "\(APIConstants.userId)",
            year: "\(year)",
            month: "\(month)",
            order: "depth",
            day: nil,
            emotionId: nil,
            depth: nil) {
            self.homeTableView.reloadData()
            
            // 단계별 objet 배치
            self.rearrangeObjet()
        }
    }
}
