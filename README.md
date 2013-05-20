
### TF-IDF

> TF-IDF（term frequency–inverse document frequency）是一种用于资讯检索与文本挖掘的常用加权技术。TF-IDF是一种统计方法，用以评估一字词对于一个文件集或一个语料库中的其中一份文件的重要程度。字词的重要性随着它在文件中出现的次数成正比增加，但同时会随着它在语料库中出现的频率成反比下降。TF-IDF加权的各种形式常被搜索引擎应用，作为文件与用户查询之间相关程度的度量或评级。 [wikipedia](http://zh.wikipedia.org/wiki/TF-IDF)

最近看了 阮一峰 关于 [TF-IDF与余弦相似性的应用](http://www.ruanyifeng.com/blog/2013/03/tf-idf.html) 的一系列文章， 深受启发。


加上发现一个非常好的 [blog](http://zespia.tw/hexo/) 及 [皮肤](https://github.com/yhben/hexo-theme-memoir)


于时心血来潮，写个插件练习下。
<!--more-->

### 插件安装方法

``` sh
npm install git://github.com/vfasky/hexo-summarizer.git
```

#### 编辑配置文件  _config.yml 

``` yaml
plugins:
- hexo-summarizer
```

#### 在模板的适当处加入

``` ejs
<%- auto_keyword_desc(page.content) %>
```

当然，你要适当的改下模板的逻辑，如：

``` ejs
<% if (page.description){ %>
<meta name="description" content="<%= page.description %>">
<% } else if (page.content){ %>
<%- auto_keyword_desc(page.content) %>
<% } else if (config.description){ %>
<meta name="description" content="<%= config.description %>">
<% } %>
```
### 提取效果

#### 示例文章

[用机器代替人工做文章摘要，国内创业公司推出类Summly产品“自动摘要”](http://www.36kr.com/p/201471.html)

提取的值：

``` js
[ '但是如果粘贴 36Kr 上的文章进去的话，出来的效果并不让人满意，达不到通常理解的摘要的标准',
  '有创业者在试图减轻人们信息筛选之苦，我们之前介绍过两款机器代替人工做文章摘要的产品，一是Summy，该产品出自一个 16 岁的少年之手，Nick DAosio 为自己的自动新闻摘要应用Summy拿到100万美元融资，后传 Yahoo CEO Marissa Mayer 也有意收购 Summy暂无更新的消息',
  '我同事体验后发现，这两款产品想法和愿景很好，但是实际使用效果并不如人意：Summy 基本就是截取个开头，而一些文章的核心内容并没放在开头；而针对一些比较偏重事实的文章，确实读 Cipped 提出的三点摘要就能大概了解文章内容了，而一些偏重观点性的文章，Cipped 还是提的不是很好' ]
```