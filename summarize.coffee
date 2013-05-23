# 载入分词模块
Segment = require('node-segment').Segment

segment = new Segment()
# 使用默认的识别模块及字典，载入字典文件需要1秒，仅初始化时执行一次即可
segment.useDefault()

# 找到句子的簇，返回最高的簇重要性
get_cluster_val = (sentence, words)->
    clustes  = [
        { words: [], count: 0 }
    ]
    index    = 0
    no_match = 0
    size     = 3 #门槛值

    for v in sentence.words
        for w in words
            #命中
            if v.w == w
                if no_match >= size
                    no_match = 0
                    index    = index + 1
                    clustes.push { words: [], count: 0 }
                
                data = clustes[index]
                data.count = data.count + 1
            else
                no_match = no_match + 1
                data = clustes[index]

            data.words.push v
    
    # 计算重要性
    max_value = 0
    for v in clustes
        val = v.count * v.count / v.words.length
        if val > max_value
            max_value = val
    return max_value



# 取词频
get_top_TF = (sentences)->
    _words = []

    for v in sentences
        for word in v.words
            word_count = get_word_count(word, sentences)
            #console.log word_count
            if word_count 
                is_in = false
                for w in _words
                    if w.word == word_count.word 
                        is_in = true
                        break
                if false == is_in
                    _words.push word_count

    _words.sort (a, b)->
        return b.count - a.count

# 取一个词的出现次数
get_word_count = (word, sentences)->
    not_good = [8192, 4096, 262144, 2048]
    
    txt = word.w.toString().trim()

    if txt.length < 2
        return false

  
    if false == /.*[\u4e00-\u9fa5]+.*$/.test(txt) and txt.length <= 2
        # 如是不是专有名，小于 3 位 ： not_good
        if txt.toUpperCase() != txt
            return false


    if word.p in not_good 
        return false

    count = 0
    for v in sentences
        for w in v.words
            if word.w == w.w
                count = count + 1
    {
        count : count ,
        word : txt
    }

summarize = (html) ->
    txt = html.trim().replace(/<\/p>/g, '\n')
                     .replace(/<\/?[^>]*>/g,'')
                     .replace(/[ | ]*\n/g,'\n')
                     .replace(/\\n\\n/g, '\n')
                     .replace(/&nbsp;/ig,'')
    # 简单的分句子
    sentences = []
    for v in txt.split('\n')
        for v in v.split('。')
            for v2 in v.split('. ')
                v2 = v2.trim()
                if v2 != ''
                    word_line = v2.toString().trim()
                    pattern   = new RegExp("[`~#$^&*()|{}''\\[\\]<>~#%lt￥……&*（）&|【】‘”“'、？]") 
                    rs        = []; 
                    for v3 in word_line.split('')
                        rs.push v3.replace(pattern, '').toString()

                    word_line = rs.join('').toString()
                    #console.log rs.length
                    if rs.length
                        # 如果是中文，小于15字的句子: not_good
                        if /.*[\u4e00-\u9fa5]+.*$/.test(word_line) 
                            if word_line.length < 15
                                continue 
                        else if word_line.length < 30
                            continue
                        #console.log word_line
                        sentences.push 
                            sentence : word_line
                            words : segment.doSegment v2
                    
    words     = []
    hot_words = get_top_TF sentences
    #console.log hot_words

    # 取前 10 % 的关键字
    word_count = hot_words.length * .10
    word_count = 10 if word_count <= 10

    for v, k in hot_words
        break if k >= word_count
        words.push v.word.w

    data = []
    for v in sentences
        data.push
            sentence: v.sentence
            val: get_cluster_val(v, words)

    data = data.sort (a, b)->
        return b.val - a.val

    summarizes = []
    for v, k in data
        break if k == 3
        summarizes.push v.sentence

    # 取前10个关键字
    keyword = []
    for v, k in hot_words
        break if k == 10
        keyword.push v.word


    {
        summarizes : summarizes 
        words : keyword
        txt : txt
    }


exports.summarize = summarize
return