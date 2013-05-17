
### TF-IDF

> TF-IDF（term frequency–inverse document frequency）是一种用于资讯检索与文本挖掘的常用加权技术。TF-IDF是一种统计方法，用以评估一字词对于一个文件集或一个语料库中的其中一份文件的重要程度。字词的重要性随着它在文件中出现的次数成正比增加，但同时会随着它在语料库中出现的频率成反比下降。TF-IDF加权的各种形式常被搜索引擎应用，作为文件与用户查询之间相关程度的度量或评级。 [wikipedia](http://zh.wikipedia.org/wiki/TF-IDF)

最近看了 阮一峰 关于 [TF-IDF与余弦相似性的应用](http://www.ruanyifeng.com/blog/2013/03/tf-idf.html) 的一系列文章， 深受启发。


加入发现一个非常好 [blog](http://zespia.tw/hexo/) 及 [皮肤](https://github.com/yhben/hexo-theme-memoir)


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
