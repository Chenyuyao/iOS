# Motcha iOS
The iOS app of Motcha.

## Description ##

Description of the app :-p

## How to Contribute ##
1. Install [CocoaPods](http://cocoapods.org/). CocoaPods serve as a tool to install/integrate 3rd party frameworks/plugins.
2. Fork this project into your account.
3. Clone this project to your local machine from your account.
4. Add "upstream" remote endpoint into your local repo settings:
    1. Make sure that your local machine is authorized by your account. Check out [this](https://help.github.com/articles/generating-ssh-keys/).
    2. Navigate under your project home dir, execute <pre>git remote add upstream git@github.com:Motcha/iOS.git</pre>
    3. Now you can sync from the upstream repo by executing the following: 
    <pre>
    git fetch upstream
    git rebase upstream/master
    </pre>
5. Execute the following to install any 3rd party stuff.
    <pre>
    pod setup
    pod install
    </pre>
6. Run the app, confirming it works.
7. Start coding and send pull requests!