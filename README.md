# Cipg

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Cipg is available through github. To install
it,  Add the repo source to the top of your pod file, followed by the Master pod repo

```ruby
source 'https://github.com/AppzoneTech/specs.git'
source 'https://github.com/CocoaPods/Specs.git'
```

Add the pod like any other pod and run pod install

```ruby
pod 'Cipg', '~> 0.1.2'
```

## Usage

import the sdk 

```swift
...
import Cipg
```

###  Full sample
```swift

import UIKit
import Cipg

class ViewController: UIViewController, CipgDelegate {
var cipgSdk : CipgSdk? = nil
override func viewDidLoad() {
super.viewDidLoad()
}

override func viewDidAppear(_ animated: Bool) {
cipgSdk = CipgSdk(paymentUrl: "baseUrl should be passed here")
self.setUpViews()
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
}

func setUpViews(){
let payButton : UIButton = {
let button : UIButton = UIButton()
button.setTitle("Pay", for: .normal)
button.translatesAutoresizingMaskIntoConstraints = false
button.setTitleColor(UIColor.white, for: .normal)
button.backgroundColor = UIColor.red
button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
button.layer.cornerRadius = 5
return button
}()

view.addSubview(payButton);

NSLayoutConstraint.activate(
[
payButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
payButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
payButton.widthAnchor.constraint(equalToConstant: 300),
payButton.heightAnchor.constraint(equalToConstant: 50)
])

payButton.addTarget(self, action: #selector(self.actionPay), for: .touchUpInside)

}

@objc func actionPay() {
var charge = Charge();
charge.amount = "2000"
charge.currencyCode = "566"
charge.customerEmail = "test@test"
charge.merchantId = "00037"
charge.productName = "TestMerchant"
charge.orderId  = "9163090"

cipgSdk?.delegate = self
cipgSdk?.pay(view: self, charge: charge);
}


func onError(msg: String) {
print("OnError called from main app")
print(msg)
}

func onSuccess(msg: String) {
print("OnSuccess called from main app")
print(msg)
}
}
```



## Author

AppzoneTech, techusers.user05@gmail.com

## License

Cipg is available under the MIT license. See the LICENSE file for more info.
