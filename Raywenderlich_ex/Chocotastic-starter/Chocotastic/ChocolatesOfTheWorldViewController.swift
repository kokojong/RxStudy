/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import RxSwift
import RxCocoa

class ChocolatesOfTheWorldViewController: UIViewController {
  @IBOutlet private var cartButton: UIBarButtonItem!
  @IBOutlet private var tableView: UITableView!
  let europeanChocolates = Observable.just(Chocolate.ofEurope)
  
  private let disposeBag = DisposeBag()
}

//MARK: View Lifecycle
extension ChocolatesOfTheWorldViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Chocolate!!!"
    self.navigationController?.navigationBar.backgroundColor = .brown
//    tableView.dataSource = self
//    tableView.delegate = self
    
    setupCartObserver()
    setupCellConfiguration()
    setupCellTapHandling()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateCartButton()
  }
}

//MARK: - Rx Setup
private extension ChocolatesOfTheWorldViewController {
  func setupCartObserver() {
    ShoppingCart.sharedCart.chocolates.asObservable()
      .subscribe(onNext: {
        [unowned self] choco in
        self.cartButton.title = "\(choco.count)개의 🍫"
      })
      .disposed(by: disposeBag)
  }
  
  func setupCellConfiguration() {
    europeanChocolates
      .bind(to: tableView.rx
        .items(cellIdentifier: ChocolateCell.Identifier,
               cellType: ChocolateCell.self)) {
                row, chocolate, cell in
                cell.configureWithChocolate(chocolate: chocolate)
      }
      .disposed(by: disposeBag)
  }
  
  func setupCellTapHandling() {
    tableView
        .rx
        .modelSelected(Chocolate.self) //1
        .subscribe(onNext: { [unowned self] choco in // 2
          let newValue =  ShoppingCart.sharedCart.chocolates.value + [choco]
          ShoppingCart.sharedCart.chocolates.accept(newValue) //3
            
          if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
          } //4
        })
        .disposed(by: disposeBag) //5
    
  }
  
}

//MARK: - Imperative methods
private extension ChocolatesOfTheWorldViewController {
  func updateCartButton() {
    cartButton.title = "\(ShoppingCart.sharedCart.chocolates.value.count) 🍫"
  }
}

// MARK: - Table view data source
//extension ChocolatesOfTheWorldViewController: UITableViewDataSource {
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return 1
//  }
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return europeanChocolates.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChocolateCell.Identifier, for: indexPath) as? ChocolateCell else {
//      //Something went wrong with the identifier.
//      return UITableViewCell()
//    }
//
//    let chocolate = europeanChocolates[indexPath.row]
//    cell.configureWithChocolate(chocolate: chocolate)
//
//    return cell
//  }
//}

// MARK: - Table view delegate
//extension ChocolatesOfTheWorldViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    tableView.deselectRow(at: indexPath, animated: true)
//
//    let chocolate = europeanChocolates[indexPath.row]
////    ShoppingCart.sharedCart.chocolates.append(chocolate)
//    let newChocolates = ShoppingCart.sharedCart.chocolates.value + [chocolate]
//    ShoppingCart.sharedCart.chocolates.accept(newChocolates) // 새로운 초콜렛이 추가된 값으로 accept
////    updateCartButton()
//  }
//}

// MARK: - SegueHandler
extension ChocolatesOfTheWorldViewController: SegueHandler {
  enum SegueIdentifier: String {
    case goToCart
  }
}
