summarize = require('./summarize').summarize

hexo.extend.helper.register('auto_keyword_desc', (html)->
    
    v = summarize(html)
    "
        <meta name=\"description\" content=\"#{v.summarizes.join(';').replace('"','\'')}\">\n
        <meta name=\"keywords\" content=\"#{v.words.join(',').replace('"','\'')}\">
    "
)