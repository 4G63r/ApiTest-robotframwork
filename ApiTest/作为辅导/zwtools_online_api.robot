*** Settings ***
Library    RequestsLibrary
Library    Collections
# 创建会话
Test Setup    Create Session    zwtoolsapi    https://webapp.jzb.com
Test Teardown    Sleep    1    

*** Variables ***
${User-Agent}    Mozilla/5.0 (Linux; Android 9; MIX 3 Build/PKQ1.180729.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/68.0.3440.91 Mobile Safari/537.36patriarch/7.3 (android;9;Scale/2.75,1080*2210)
${cookie1}    GA1.2.385320673.1546968303    
${cookie2}    f79abcc31cg8pUDt5EN7mhErAKlUsYT9EHJfKx8PYGkGxU34tunX5CtzNgBPTN6rZG9uNHqsG%2BFxVclbpi%2F3aXNGoxEzktHUNR7TgByp75qaA    
${cookie3}    1

*** Keywords ***
取消收藏
    [Arguments]    ${artid}
    # header
    ${header}    Create Dictionary    User-Agent=${User-Agent}
    ${cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    _gat=${cookie3}
    Create Session    zwtoolsapi    https://webapp.jzb.com    ${header}   ${cookies} 
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect/cancel?artid=${artid}
    @{element}    Create List    code    msg
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "code":1    code字段错误
    Should Contain    ${resp.text}    "msg":"取消收藏成功"    msg字段错误
    Log    ****** 测试通过 ******  
    
*** Test Cases ***
首页1
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/index
    # @{element}    Create List    id    intro    title    typeid    typename    user_grade    name
    # # 断言
    # Should Be True    ${resp.status_code} == 200    响应状态码错误
    # :FOR    ${i}    IN    @{element}
    # \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    # Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    # Should Contain    ${resp.text}    "state":200    state字段错误
    # Log    ****** 测试通过 ****** 
    
首页
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/index
    @{element}    Create List    id    intro    title    typeid    typename    user_grade    name
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ****** 

作文详情
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/artinfo?id=266620
    @{element}    Create List    id    cate    typeid    typeid    title    intro    content    comment    view    collect    is_collect    state 
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "title":"一次打屁股的教训_900字"    title字段错误
    Log    ****** 测试通过 ******	

作文详情(id=)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artinfo?id= 
    # 断言
    Should Contain    ${resp.text}    "errmsg":"文章id不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":404    state字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Log    ****** 测试通过 ******	

作文详情(id=-1)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artinfo?id=-1
    # 断言
    Should Contain    ${resp.text}    "errmsg":"文章id不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":404    state字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Log    ****** 测试通过 ******	

作文详情(id="266620")
    ${resp}    Get Request    zwtoolsapi    /zwtools/artinfo?id="266620"
    # 断言
    Should Contain    ${resp.text}    "errmsg":"文章id不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":404    state字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Log    ****** 测试通过 ******	

作文列表筛选项-范文(cate=1)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist/option?cate=1
    @{element}    Create List    type    grade    id    name    写人作文    叙事作文
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******	

作文列表筛选项-素材(cate=2)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist/option?cate=2
    @{element}    Create List    type    grade    id    name    名言警句    成语故事
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******	

作文列表筛选项-写作技巧(cate=3)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist/option?cate=3
    @{element}    Create List    type    grade    id    name    写作方法    文学常识
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******	

作文列表筛选项(cate=0)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist/option?cate=0
    # 断言
    Should Contain    ${resp.text}    "errmsg":"cate值不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":404    state字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Log    ****** 测试通过 ******	

作文列表筛选项(cate=)
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist/option?cate= 
    # 断言
    Should Contain    ${resp.text}    "errmsg":"cate值不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":404    state字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Log    ****** 测试通过 ******	

作文列表筛选项(cate="1")
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist/option?cate="1"
    # 断言
    Should Contain    ${resp.text}    "errmsg":"cate值不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":404    state字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Log    ****** 测试通过 ******	
    
作文列表
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist?cate=1&start=0&limit=20&keyword=
    @{element}    Create List    id    intro    title    typeid    typename
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "cate":1    cate字段错误
    Should Contain    ${resp.text}    "limit":20    limit字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******  
    
作文列表(cate=3&limit=1)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist?cate=3&start=0&limit=1&keyword=3
    @{element}    Create List    id    intro    title    typeid
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "cate":3    cate字段错误
    Should Contain    ${resp.text}    "limit":1    limit字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******  
    
作文列表-叙事作文(type=12&grade=4)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/artlist?cate=1&type=12&grade=4&start=0&limit=20&keyword=
    @{element}    Create List    id    intro    title    typeid    typename    type
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "typename":"叙事作文"    typename字段错误
    Should Contain    ${resp.text}    "grade":4    grade字段错误
    Should Contain    ${resp.text}    "typeid":"12"    typeid字段错误
    Should Contain    ${resp.text}    "type":12    type字段错误
    Should Contain    ${resp.text}    "cate":1    cate字段错误
    Should Contain    ${resp.text}    "limit":20    limit字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******  
    
单元作文详情
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/unitinfo?id=1
    @{element}    Create List    id    typeid    grade    title    content    example_artid    technique_artid    
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "id":"1"    id字段错误    
    Log    ****** 测试通过 ******	
    
单元作文详情(id=)
    ${resp}    Get Request    zwtoolsapi    /zwtools/unitinfo?id= 
    # 断言
    Should Contain    ${resp.text}    "errmsg":"id不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "res":null    res字段错误
    Should Contain    ${resp.text}    "state":404    state字段错误    
    Log    ****** 测试通过 ******	
    
单元作文详情(id="2")
    ${resp}    Get Request    zwtoolsapi    /zwtools/unitinfo?id="2"
    # 断言
    Should Contain    ${resp.text}    "errmsg":"id不存在"    errmsg字段错误    
    Should Contain    ${resp.text}    "res":null    res字段错误
    Should Contain    ${resp.text}    "state":404    state字段错误    
    Log    ****** 测试通过 ******	

单元作文列表筛选项
    ${resp}    Get Request    zwtoolsapi    /zwtools/unitlist/option
    @{element}    Create List    id    name    grade_term    type    
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误    
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误    
    Should Contain    ${resp.text}    "name":"人教版"    name字段错误    
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******	
    
单元作文列表(grade_term=3_2)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/unitlist?grade_term=3_2&type=35&start=0&limit=20
    @{element}    Create List    id    title    content    total    grade_term    type
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "grade_term":"3_2"    grade_term字段错误
    Should Contain    ${resp.text}    "limit":20    limit字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******  
    
单元作文列表(grade_term=4_2)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/unitlist?grade_term=4_2&type=35&start=0&limit=20
    # 断言
    Should Contain    ${resp.text}    "errmsg":"目前只有三年级上下册"    errmsg字段错误
    Should Contain    ${resp.text}    "res":null    res字段错误
    Should Contain    ${resp.text}    "state":404    state字段错误
    Log    ****** 测试通过 ******  
     
用户添加收藏(添加一个收藏artid=266620)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    # header
    ${header}    Create Dictionary    User-Agent=${User-Agent}
    ${cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    api_key=${cookie2}    _gat=${cookie3}
    # 重新创建session
    Create Session    zwtoolsapi    https://webapp.jzb.com    ${header}   ${cookies}
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect/add?artid=266620
    @{element}    Create List    code    msg
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "code":1    code字段错误
    Should Contain    ${resp.text}    "msg":"收藏成功"    msg字段错误
    Log    ****** 测试通过 ******

用户收藏作文分组列表
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect/catelist
    @{element}    Create List    id    name    catelist    "范文"    "素材"    "写作技巧"    
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******

用户收藏作文列表(检查"total":1)
    Create Session    zwtoolsapi    https://webapp.jzb.com
    # header
    ${header}    Create Dictionary    User-Agent=${User-Agent}
    ${cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    _gat=${cookie3}
    # 重新创建session
    Create Session    zwtoolsapi    https://webapp.jzb.com    ${header}   ${cookies}
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect?cate=1&start=0&limit=20
    @{element}    Create List    artid    title    intro    typename    
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "artid":"266620"    artid字段错误
    Should Contain    ${resp.text}    "title":"一次打屁股的教训_900字"    title字段错误
    Should Contain    ${resp.text}    "typename":"叙事作文"    typename字段错误
    Should Contain    ${resp.text}    "catename":"范文"    catename字段错误
    Should Contain    ${resp.text}    "total":1    total字段错误
    Log    ****** 测试通过 ******

用户添加收藏(继续添加一个收藏artid=258710)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    # header
    ${header}    Create Dictionary    User-Agent=${User-Agent}
    ${cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    api_key=${cookie2}    _gat=${cookie3}
    # 重新创建session
    Create Session    zwtoolsapi    https://webapp.jzb.com    ${header}   ${cookies}
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect/add?artid=258710
    @{element}    Create List    code    msg
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "code":1    code字段错误
    Should Contain    ${resp.text}    "msg":"收藏成功"    msg字段错误
    Log    ****** 测试通过 ******

用户收藏作文列表(检查"total":2)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    # header
    ${header}    Create Dictionary    User-Agent=${User-Agent}
    ${cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    _gat=${cookie3}
    # 重新创建session
    Create Session    zwtoolsapi    https://webapp.jzb.com    ${header}   ${cookies}
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect?cate=1&start=0&limit=20
    @{element}    Create List    artid    title    intro    期末考试作文    叙事作文    六年级上期末考试作文_550字   
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "artid":"266620"    artid字段错误
    Should Contain    ${resp.text}    "title":"一次打屁股的教训_900字"    title字段错误
    Should Contain    ${resp.text}    "catename":"范文"    catename字段错误
    Should Contain    ${resp.text}    "total":2    total字段错误
    Log    ****** 测试通过 ******

用户取消收藏(artid=266620&258710)
    @{artids}    Create List    266620    258710
    :FOR    ${artid}    IN    @{artids}
    \    取消收藏    ${artid}
    \    Sleep    2    
    
用户收藏作文列表(检查"total":0)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    # header
    ${header}    Create Dictionary    User-Agent=${User-Agent}
    ${cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    _gat=${cookie3}
    # 重新创建session
    Create Session    zwtoolsapi    https://webapp.jzb.com    ${header}   ${cookies}
    ${resp}    Get Request    zwtoolsapi    /zwtools/usercollect?cate=1&start=0&limit=20
    @{element}    Create List    list    total    start    limit   
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "list":[]    list字段错误
    Should Contain    ${resp.text}    "total":0    total字段错误
    Log    ****** 测试通过 ******
    
搜索热词
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/search/hot
    @{element}    Create List    hotword
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Log    ****** 测试通过 ******

搜索
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/search?keyword=%E4%BD%9C%E6%96%87&grade=3
    @{element}    Create List    searchlist    id    title    typename    intro    total    limit    cate    offset    
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "typename":"叙事作文"    typename字段错误
    Should Contain    ${resp.text}    "more":1    more字段错误
    Log    ****** 测试通过 ******

搜索(grade=100)
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/search?keyword=%E4%BD%9C%E6%96%87&grade=100
    # 断言
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "searchlist":[]    searchlist字段错误
    Log    ****** 测试通过 ******
    
分组筛选+搜索
    # Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/search/option?cate=1&grade=3&start=0&limit=20&keyword=%E4%BD%9C%E6%96%87
    @{element}    Create List    typeid    id    title    typename    intro    total    limit    cate    offset    
    # 断言
    Should Be True    ${resp.status_code} == 200    响应状态码错误
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}    字段缺失/或者${i}字段名称错误
    Should Contain    ${resp.text}    "errmsg":"操作成功"    errmsg字段错误
    Should Contain    ${resp.text}    "state":200    state字段错误
    Should Contain    ${resp.text}    "typename":"叙事作文"    typename字段错误
    Log    ****** 测试通过 ******
    