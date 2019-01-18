*** Comments ***
前端页面：https://webapp.jzb.com/work_tools/

首页API
作文详情API
作文列表筛选项API
作文列表API
单元作文详情API
单元作文列表筛选项API
单元作文列表API
用户收藏作文分组列表API
用户收藏作文列表API
用户添加收藏API
用户取消收藏API
搜索热词API
搜索API
分组筛选+搜索API

*** Settings ***
Library    RequestsLibrary

Suite Setup    Connect Session
Suite Teardown    Delete All Sessions   
Test Setup    Setup Test     
Test Teardown    Teardown Test

*** Variables ***
${SERVER}    https://webapp.jzb.com
${UA}    Mozilla/5.0 (Linux; Android 9; MIX 3 Build/PKQ1.180729.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/68.0.3440.91 Mobile Safari/537.36patriarch/7.3 (android;9;Scale/2.75,1080*2210)
${COOKIE1}    GA1.2.385320673.1546968303    
${COOKIE2}    f79abcc31cg8pUDt5EN7mhErAKlUsYT9EHJfKx8PYGkGxU34tunX5CtzNgBPTN6rZG9uNHqsG%2BFxVclbpi%2F3aXNGoxEzktHUNR7TgByp75qaA    
${COOKIE3}    1
${DELAY}    1

*** Keywords ***
Setup Test
    Log    *-*-*-*-*-*-*-*-*-* Start Test *-*-*-*-*-*-*-*-*-*

Teardown Test
    Log    *-*-*-*-*-*-*-*-*-* End Test *-*-*-*-*-*-*-*-*-*    
    Sleep    ${DELAY}
    
Connect Session
    # header
    &{header}    Create Dictionary    UA=${UA}
    &{cookies}    Create Dictionary    _ga=${cookie1}    FDX_auth=${cookie2}    api_key=${cookie2}    _gat=${cookie3}
    Create Session    zwtoolsapi    ${SERVER}    ${header}   ${cookies}    disable_warnings=1
    
Get Method
    [Arguments]    ${uri}    ${host}=zwtoolsapi    ${header}=None    ${cookie}=None    
    ${response}    Get Request    ${host}    ${uri}
    Should Be True    ${response.status_code}==200
    [Return]    ${response.text}
    
# Post Method
    # [Arguments]    ${uri}    ${host}=zwtoolsapi    ${header}=None    ${cookie}=None    
    # ${response}    Get Request    ${host}    ${uri}
    # [Return]    ${response.text}
    
Base Assert
    [Arguments]    ${resp}
    Should Contain    ${resp}    "errmsg":"操作成功"  
    Should Contain    ${resp}    "state":200
    Should Contain    ${resp}    "errcode":0

Del Collection
    [Arguments]    ${artid}
    ${resp}    Get Method    /zwtools/usercollect/cancel?artid=${artid}
    @{element}    Create List    code    msg
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Should Contain    ${resp}    "code":1
    Should Contain    ${resp}    "msg":"取消收藏成功"
    
*** Test Cases ***
首页
    ${resp}    Get Method    /zwtools/index
    @{element}    Create List    errmsg    day_material    id    intro    title    excellence    typeid    typename    user_grade    name    total    state
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "total":10

作文详情(id=336263)
    ${resp}    Get Method    /zwtools/artinfo?id=336263
    @{element}    Create List    id    cate    typeid    title    intro    content    comment    view    collect    is_collect    state    other_art 
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}  
    Should Contain    ${resp}    "title":"秋天"
    Should Contain    ${resp}    "intro":"灸热的夏天不知不觉地离开
    Should Contain    ${resp}    "title":"我爱我的家乡"

作文详情(id=)
    ${resp}    Get Method    /zwtools/artinfo?id= 
    # 断言
    Should Contain    ${resp}    "errmsg":"文章id不存在"
    Should Contain    ${resp}    "state":404
    Should Contain    ${resp}    "res":null

作文详情(id=-1)
    ${resp}    Get Method    /zwtools/artinfo?id=-1
    # 断言
    Should Contain    ${resp}    "errmsg":"文章id不存在"
    Should Contain    ${resp}    "state":404
    Should Contain    ${resp}    "res":null

作文详情(id="336263")
    ${resp}    Get Method    /zwtools/artinfo?id="336263"
    # 断言
    Should Contain    ${resp}    "errmsg":"文章id不存在"
    Should Contain    ${resp}    "state":404
    Should Contain    ${resp}    "res":null

作文列表筛选项-范文(cate=1)
    ${resp}    Get Method    /zwtools/artlist/option?cate=1
    @{element}    Create List    type    grade    id    name    写人作文    叙事作文    写景作文    状物作文    想象作文    期末考试作文    诗歌
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "name":"三年级"
    Should Contain    ${resp}    "name":"四年级"
    Should Contain    ${resp}    "name":"五年级"
    Should Contain    ${resp}    "name":"六年级"

作文列表筛选项-素材(cate=2)
    ${resp}    Get Method    /zwtools/artlist/option?cate=2
    @{element}    Create List    type    grade    id    name    名言警句    哲理故事    名人故事    好词好句    时事论据    天气描写
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "name":"三年级"
    Should Contain    ${resp}    "name":"四年级"
    Should Contain    ${resp}    "name":"五年级"
    Should Contain    ${resp}    "name":"六年级"

作文列表筛选项-写作技巧(cate=3)
    ${resp}    Get Method    /zwtools/artlist/option?cate=3
    @{element}    Create List    type    grade    id    name    写作方法    写作基础    经验交流    文学常识
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "name":"三年级"
    Should Contain    ${resp}    "name":"四年级"
    Should Contain    ${resp}    "name":"五年级"
    Should Contain    ${resp}    "name":"六年级"

作文列表筛选项(cate=0)
    ${resp}    Get Method    /zwtools/artlist/option?cate=0
    # 断言
    Should Contain    ${resp}    "errmsg":"cate值不存在"
    Should Contain    ${resp}    "state":404
    Should Contain    ${resp}    "res":null

作文列表筛选项(cate=)
    ${resp}    Get Method    /zwtools/artlist/option?cate=
    # 断言
    Should Contain    ${resp}    "errmsg":"cate值不存在"
    Should Contain    ${resp}    "state":404
    Should Contain    ${resp}    "res":null

作文列表筛选项(cate="1")
    ${resp}    Get Method    /zwtools/artlist/option?cate="1"
    # 断言
    Should Contain    ${resp}    "errmsg":"cate值不存在"
    Should Contain    ${resp}    "state":404
    Should Contain    ${resp}    "res":null
    
作文列表
    ${resp}    Get Method    /zwtools/artlist?cate=1&start=0&limit=20&keyword=
    @{element}    Create List    id    intro    title    typeid    typename    total    grade    type
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "cate":1    cate字段错误
    Should Contain    ${resp}    "limit":20    limit字段错误
    
作文列表(cate=1&limit=1)
    ${resp}    Get Method    /zwtools/artlist?cate=1&start=0&limit=1&keyword=3
    @{element}    Create List    id    intro    title    typeid    typename    total    grade    type
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Not Contain    ${resp}    "title":"六年级上期末考试作文_550字"
    Should Contain    ${resp}    "cate":1
    Should Contain    ${resp}    "limit":1

作文列表(type=22@小说&grade=5@五年级)
    ${resp}    Get Method    /zwtools/artlist?cate=1&type=22&grade=5&start=0&limit=20&keyword=
    @{element}    Create List    id    intro    title    typeid    typename    total    grade    type
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Not Contain    ${resp}    "typename":"状物作文"
    Should Not Contain    ${resp}    "typename":"叙事作文"
    Should Contain    ${resp}    "typename":"小说"
    Should Contain    ${resp}    "cate":1
    Should Contain    ${resp}    "limit":20
    Should Contain    ${resp}    "grade":5
    Should Contain    ${resp}    "type":22
    Should Contain    ${resp}    "typeid":"22"
    
单元作文详情
    ${resp}    Get Method    /zwtools/unitinfo?id=10
    @{element}    Create List    id    typeid    grade    term    title    content    example_artid    guide    material    practice    technique_artid    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp} 
    Should Contain    ${resp}    "id":"10"
    Should Contain    ${resp}    "title":"写熟悉的人的一件事"
    
单元作文详情(id=)
    ${resp}    Get Method    /zwtools/unitinfo?id= 
    # 断言
    Should Contain    ${resp}    "errmsg":"id不存在"
    Should Contain    ${resp}    "res":null
    Should Contain    ${resp}    "state":404
    
单元作文详情(id="2")
    ${resp}    Get Method    /zwtools/unitinfo?id="2"
    # 断言
    Should Contain    ${resp}    "errmsg":"id不存在"
    Should Contain    ${resp}    "res":null
    Should Contain    ${resp}    "state":404

单元作文列表筛选项
    ${resp}    Get Method    /zwtools/unitlist/option
    @{element}    Create List    id    name    grade_term    type    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}   
    Base Assert    ${resp} 
    Should Contain    ${resp}    "name":"人教版"  
    
单元作文列表(grade_term=3_2@三年级下)
    ${resp}    Get Method    /zwtools/unitlist?grade_term=3_2&type=35&start=0&limit=20
    @{element}    Create List    id    title    content    total    type
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "grade_term":"3_2"
    Should Contain    ${resp}    "limit":20
    
单元作文列表(grade_term=4_2@四年级下)
    ${resp}    Get Method    /zwtools/unitlist?grade_term=4_2&type=35&start=0&limit=20
    # 断言
    Should Contain    ${resp}    "errmsg":"目前只有三年级上下册"
    Should Contain    ${resp}    "res":null
    Should Contain    ${resp}    "state":404
     
用户添加收藏(添加一个收藏artid=336263)
    ${resp}    Get Method    /zwtools/usercollect/add?artid=336263
    @{element}    Create List    res
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "code":1
    Should Contain    ${resp}    "msg":"收藏成功"

用户收藏作文分组列表
    ${resp}    Get Method    /zwtools/usercollect/catelist
    @{element}    Create List    id    name    catelist    范文    素材    写作技巧    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}

用户收藏作文列表(检查"total":1)
    ${resp}    Get Method    /zwtools/usercollect?cate=1&start=0&limit=20
    @{element}    Create List    artid    title    intro    typename    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "artid":"336263"
    Should Contain    ${resp}    "title":"秋天"
    Should Contain    ${resp}    "typeid":"13"
    Should Contain    ${resp}    "typename":"写景作文"
    Should Contain    ${resp}    "catename":"范文"
    Should Contain    ${resp}    "total":1

用户添加收藏(继续添加一个收藏artid=258710)
    ${resp}    Get Method    /zwtools/usercollect/add?artid=258710
    @{element}    Create List    res
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "code":1
    Should Contain    ${resp}    "msg":"收藏成功"

用户收藏作文列表(检查"total":2)
    ${resp}    Get Method    /zwtools/usercollect?cate=1&start=0&limit=20
    @{element}    Create List    artid    title    intro    typename    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "artid":"336263"
    Should Contain    ${resp}    "title":"六年级上期末考试作文_550字"
    Should Contain    ${resp}    "title":"秋天"
    Should Contain    ${resp}    "typeid":"13"
    Should Contain    ${resp}    "typename":"写景作文"
    Should Contain    ${resp}    "catename":"范文"
    Should Contain    ${resp}    "total":2

用户取消全部收藏
    @{artids}    Create List    336263    258710
    :FOR    ${artid}    IN    @{artids}
    \    Del Collection    ${artid}
    \    Sleep    ${DELAY}  
    
用户收藏作文列表(检查"total":0)
    ${resp}    Get Method    /zwtools/usercollect?cate=1&start=0&limit=20
    @{element}    Create List    res    limit    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "list":[]
    Should Contain    ${resp}    "total":0
    
搜索热词
    ${resp}    Get Method    /zwtools/search/hot
    @{element}    Create List    hotword
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}

搜索
    ${resp}    Get Method    /zwtools/search?keyword=%E4%BD%9C%E6%96%87&grade=3
    @{element}    Create List    searchlist    id    title    typename    intro    total    limit    cate    offset    more    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "typename":"叙事作文"
    Should Contain    ${resp}    "more":1

搜索(grade=100)
    ${resp}    Get Method    /zwtools/search?keyword=%E4%BD%9C%E6%96%87&grade=100
    # 断言
    Base Assert    ${resp}
    Should Contain    ${resp}    "searchlist":[]
    
分组筛选+搜索
    ${resp}    Get Method    /zwtools/search/option?cate=1&grade=3&start=0&limit=20&keyword=%E4%BD%9C%E6%96%87
    @{element}    Create List    typeid    id    title    typename    intro    total    limit    cate    offset    
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp}     ${i}
    Base Assert    ${resp}
    Should Contain    ${resp}    "typename":"叙事作文"
    Should Contain    ${resp}    "title":"我感到自豪_500字"