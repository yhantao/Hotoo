# Hotoo
看了SXNews的工程也参考模仿网易新闻做的新闻软件。<br />
本人第一次写新闻流app，希望多多指教，目前主要功能包括各类新闻，热搜，以后会在加短视频和更多个性化板块。
### 3月3日更新
增加新闻细节页面UIActivityController实现分享
### 3月2日更新
增加新闻细节页面相关新闻的推送，并且重构新闻细节页面的框架，由原来的一整页的WKWebView换成UITableView上分2个section分别放WKWebView和related article cell，今后会再加上分享extension的接口。
### 2月29日更新
###### 1.概括
基本完成主要新闻类app的功能，包括各类新闻和热搜，主要框架是navigation controller里面包含一个tabbar controller，各类新闻controller被包含在tabbar controller的news模块，通过scroll view拖动或顶部新闻类型tab进行交换，以后会优化初始化加载（目前是全部新闻列表页初始化都加载，很影响性能）。新闻模块提供了3种自定义的cell，通过对数据的解析，来判断改加载到哪种自定义cell中。关于新闻详情页，请求页面返回的数据中既有一个url地址，也有一个xml的字符串，url地址展示后不美观，所以做法是将xml格式的字符串解析并在WKWebView中展示，这其中做到了图文混排并设置了css样式。
###### 2.实现
实现都是手码，除了launch storyboard没用storyboard和xib。
###### 3.集成
主要用cocoapods集成了MJRefresh，ReactiveCocoa，SDWebImage，貌似iOS 13.3.1集成reactive objc有问题，还在调试，目前只适配了iOS 13+刘海屏机型。如果没有setup过Cocoapods,可按照以下步骤setup
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
如果已经setup好了Cocoapods，进入工程目录
```
cd [YOUR_LOCAL_PROJECT_NAME]/Hotoo
```
然后完成集成
```
pod install
```
###### 3.效果
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo2.jpg" alt="Drawing" width="160px" />x
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo3.jpg" alt="Drawing" width="160px" />x
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo4.jpg" alt="Drawing" width="160px" />x
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo5.jpg" alt="Drawing" width="160px" />x
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo6.jpg" alt="Drawing" width="160px" />


