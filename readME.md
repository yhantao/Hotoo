# Hotoo
看了SXNews的工程也参考模仿网易新闻做的新闻软件<br />
本人是iOS萌新，第一次写新闻流app，主要功能包括各类新闻，热搜，以后会在加短视频和更多个性化板块

### 2月29日更新

###### 1.概括
基本完成主要新闻类app的功能，包括各类新闻和热搜，主要框架是navigation controller里面包含一个tabbar controller，各类新闻controller被包含在tabbar controller的news模块，通过scroll view拖动或顶部新闻类型tab进行交换，以后会优化初始化加载（目前是全不新闻列表页初始化都加载，很影响性能）。新闻模块提供了4种自定义的cell，通过对数据的解析，来判断改加载到哪种自定义cell中。关于新闻详情页，请求页面返回的数据中既有一个url地址，也有一个xml的字符串，url地址展示后不美观，所以做法是将xml格式的字符串解析并在WKWebView中展示，这其中做到了图文混排并设置了css样式。
###### 2.实现
实现都是手码，除了launch storyboard没用storyboard和xib
###### 3.集成
主要集成了MJRefresh，ReactiveCocoa，SDWebImage，貌似iOS 13.3.1集成reactive objc有问题，还在调试，目前只适配了iOS 13+刘海屏机型
###### 3.效果
Launching页面
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo1.png" alt="Drawing" width="375px" /><br /><br />
热搜新闻结果页面
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo2.jpg" alt="Drawing" width="375px" /><br /><br />
新闻细节页面
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo3.jpg" alt="Drawing" width="375px" /><br /><br />
体育新闻模块页面
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo4.jpg" alt="Drawing" width="375px" /><br /><br />
体育新闻细节页面
<img src="https://github.com/yhantao/Hotoo/blob/master/Hotoo/demo/HTNews_demo5.jpg" alt="Drawing" width="375px" /><br /><br />


