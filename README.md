# Swift---AOPasscode
Safer passcode for your app in Swift

Do your friends/people around you know your passcode to unlock your phone/app? It is easy to watch somebody while typing passcode on the screen and memorize the code - it't just 4 numbers, right?

With our passcode your app will be way safer and can not be hacked as you have to set different combination of numbers and colors. These are generated and displayed randomly each time it is launched, so there is no way even if somebody
is watching you, that he/she would guess the passcode. They simple can't be sure if you was tapping on color or number and next time the order comes differently and you'll be tapping different button again!

Set new passcode: ( red + 4 + green + 6)

![](http://www.viralideasltd.com/github/SetPasscode.gif)

Test the passcode

![](http://www.viralideasltd.com/github/TestPasscode.gif)



## Requirements 
iOS 9.3 or higher

## Usage
Download the file and copy the following files into your project:

* AOPasscode.swift
* SetAOPasscode.swift
* AOPasscodeView.xib
* SetAOPasscodeView.xib

In your ViewController simply add these lines to call the view to set the password in your button action:

        let passView = SetAOPasscodeView.instanceFromNib()
        passView.frame = self.view.frame
        self.view.addSubview(passView)

If you need to unlock any app/view, just call AOPasscode view in viewDidAppear method or on button action as such:

        let view = AOPasscode.instanceFromNib()
        view.frame = self.view.frame
        self.view.addSubview(view)

...And you're done!

## Customization

* Overwrite the colors in AOPasscode.swift and SetAOPasscode.swift for custom set up
* Change size of the passcode buttons in xib files
* Change background colors in all xib files

## Licence - Free, no restrictions
