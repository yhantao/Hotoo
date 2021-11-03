# Hotoo
Reading SXNews about news feeds flow<br />
Trying to mimik what I learned, using http public api in TouTiao search, fulfilling news feeds under different topic categories, hot search page, and recommentation.

### March 3rd update
Add UIActivityController to fulfill share function

### March 2rd update
Add the recommendataion news feeds in detail page，slightly tweak the structure of detailed page，from a whole WKWebView to UITableView including 2 sections to manage WKWebView and related article cell，and will add app extension for sharing later.

### Feb 29th update
Finish the main functionality of news feeds and hot search page，using a navigation controller to wrap a tabbar controller. Different news feeds controllers are children controller under tabbar controller's news tab，Using scroll view on the top of page or tap to switch between each news topi. Will introduce caching strategy later to improve the memory performance, and also lazy load each tableview to avoid leaks.

News table have 3 types of cell/model，and will render a cell to a corresponding data model.

### 3.Dependencies
cocoapods, MJRefresh，ReactiveCocoa，SDWebImage，(seems like iOS 13.3.1 gets some problem with reactive objc, and is still under testing)，currently only support iOS 13.0+ and iPhone X+.
>1. Install Xcode 4.4.1 (or newer) from the Mac App Store.<br />
>2. Open Xcode, and go to Preferences, then select the Downloads tab.<br />
>3. Install the Command Line Tools by clicking on the Install button next to that item in the Components list.<br />
>4. When Xcode and the Command Line Tools are installed, open Terminal and update Gem:<br />
```
sudo gem update --system
```
>5. Install CocoaPods:<br />
```
sudo gem install cocoapods
```
 
>6. Setup CocoaPods:<br />
```
pod setup
```
if already setup Cocoapods，go to project directly
```
cd [YOUR_LOCAL_PROJECT_NAME]/Hotoo
```
and
```
pod install
```
### Demo pages (screenshots)
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo2.jpg" alt="Drawing" width="400px" /> <img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo4.jpg" alt="Drawing" width="400px" />

<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo5.jpg" alt="Drawing" width="400px" /> <img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo6.jpg" alt="Drawing" width="400px" />



