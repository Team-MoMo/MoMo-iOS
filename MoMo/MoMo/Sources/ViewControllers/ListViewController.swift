//
//  ListViewController.swift
//  MoMo
//
//  Created by 이정엽 on 2020/12/29.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var filteredDate: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    var widthSize: CGFloat = 0.0
    var secondWidthSize: CGFloat = 0.0
    var dummyData: [List] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        self.listTableView.rowHeight  = UITableView.automaticDimension
        self.listTableView.estimatedRowHeight = 266
        self.listTableView.dataSource = self
        widthSize = CGFloat(self.view.bounds.width * (325/414))
        secondWidthSize = CGFloat(self.view.bounds.width * (237/414))

        setData()
    }
    
    private func registerXib() {
        let listcellnib = UINib(nibName: "ListTableViewCell", bundle: nil)
        listTableView.register(listcellnib, forCellReuseIdentifier: "ListTableViewCell")
    }
    
    func setData() {
        dummyData.append(contentsOf: [
            List(
                iconImage: "icHappyBlue",
                 category: "행복",
                 date: "12.01",
                 day: "화",
                 depth: "2m",
                 quote: "할머니가 자애로운 손길로 내 얼굴과 머리카락, 이마를 쓸어주는게 좋았다. 마치 내 존재 전부를 쓸어주는 것 같았다. 아 진짜 이거 어떻게 해야 돼 너무 힘들다 ㄹㅇ 제발 끝났으면 좋겠다",
                 author: "박연준",
                 title: "<인생은 이상하게 흐른다>",
                 publisher: "(달)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이. 망했다 ㄹㅇ"),
            List(
                iconImage: "icLoveBlue",
                 category: "사랑",
                 date: "12.02",
                 day: "수",
                 depth: "700m",
                 quote: "나는 사랑받고 있다고 느꼈다. 사랑에는 언제나 한 방울의 연민이 포함되기 때문이다.",
                 author: "박연준",
                 title: "<인생은 이상하게 흐른다>",
                 publisher: "(달)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(
                iconImage: "icBoredBlue",
                category: "권태",
                date: "12.08",
                day: "화",
                depth: "300m",
                quote: "너무 많은 당신 때문에 상처는 더욱 싱싱해지고 내가 있는 이 공간은 좁아진다.나는 어디에 머물러야 하나?",
                author: "황인숙",
                title: "<좋은 일이 아주 없는 건 아니잖아>",
                publisher: "(달)",
                journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(
                iconImage: "icSadBlue",
                category: "슬픔",
                date: "12.11",
                day: "금",
                depth: "100m",
                quote: "도라였다. 얼굴을 돌렸다. 종일 가시가 박힌 것처럼 가슴이 따가웠다.",
                author: "손원평",
                title: "<아몬드>",
                publisher: "(창비)",
                journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icMemoryBlue",
                 category: "추억",
                 date: "12.12",
                 day: "토",
                 depth: "300m",
                 quote: "어쩌면 좋으냐 네가 너무 많이 예뻐서 어쩌면 좋으냐 네가 너무 많아서",
                 author: "나태주",
                 title: "<끝까지 남겨두는 그 마음>",
                 publisher: "(북로그컴퍼니)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icDailyBlue",
                 category: "일상",
                 date: "12.16",
                 day: "수",
                 depth: "30m",
                 quote: "아무것도 아냐. 미안해, 놀라게 해서. 별일 아니니까 걱정하지마.",
                 author: "히가시노 게이고",
                 title: "<나미야 잡화점의 기적>",
                 publisher: "(현대문학)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icAngryBlue",
                 category: "화남",
                 date: "12.18",
                 day: "금",
                 depth: "심해",
                 quote: "여기서 살아야 할 사람이 커튼을 치고 싶다는데 그것조차 잘못된 생각이라고 몰아붙이는 그 눈빛이랑 조금도 소통하고 싶지 않았다.",
                 author: "히가시노 게이고",
                 title: "<나미야 잡화점의 기적>",
                 publisher: "(현대문학)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ..."),
            List(iconImage: "icConsoleBlue",
                 category: "위로",
                 date: "12.20",
                 day: "일",
                 depth: "100m",
                 quote: "“괜찮아, 영주.” 한지가 말했다. 충동적으로 여기에 머물기로 한 것도, 네가 해야 했던 일을 내팽겨쳐버린 것도, 수도원 생활도 모두, 괜찮아.",
                 author: "최은영",
                 title: "<쇼코의 미소 - 한지와 영주>",
                 publisher: "(문학동네)",
                 journal: "오늘 새벽엔 눈이 내렸다. 창문을 열어 창문을 열어 흰눈이내린다. 크리스마스가 끝이 났다. 모모와 ...")
        ])
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.setCell(list: dummyData[indexPath.row])
        cell.quoteSpacing(dummyData[indexPath.row].quote)
        cell.journalView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 20)
        cell.journaltext(dummyData[indexPath.row].journal, widthSize)
        cell.setLabelUnderline(widthSize,secondWidthSize)
        cell.selectionStyle = .none
        return cell
    }
}

extension UIView {
    
    func round(corners: UIRectCorner, cornerRadius: Double) {
        
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
