*** Comments ***
API:
	1.“今日必读”聚合页和“家长资讯”（标签）聚合页接口
	2.“本地升学”聚合页接口
	3.“白皮书”标签详情页接口
	4.“分享和浏览”接口
	5.家长资讯标签接口
	6.今日必读feed流接口
	7.大家都在看/本地升学模块标签接口
	8.大家都在看/本地升学模块feed接口
	9.大家都在看/本地升学模块查看更多接口
	10.首页/获取模版信息
	11.首页/根据模块地址获取模块信息
	12.详情页/今日必读文章详情
	13.详情页/升学社区文章详情
	14.详情页/文章点赞
	15.详情页/文章举报

*** Settings ***
Library    RequestsLibrary
Library    MyLibrary

Suite Setup    Get Vrf Params
Suite Teardown    Delete All Sessions
Test Setup    Setup Test
Test Teardown    Teardown Test



*** Variables ***
${APPSERVER}    https://appsupport.jzb.com
${WEBSERVER}    http://webapp.jzb.com
${VRFSERVER}    http://aitools.dev.jzb.com
${AUTH}    c664dcd69btYuiVokMx1vbyO7qInjs9fncpJp2WoJc3vRPZ7nA6CMFO7hHKvZx4y53H1mUxcXsARVlwgBEu4YduAYdhDK6VzVa0aJWSuS9h7U0GcJfkQ
# ${AUTH}    3a83aca650Zk6RD8FzMQQvfQ9Xb88gEzi7bqR04/JOpErbOP3SjkwHDltLSGs22TiACiLDiuA9tNy+rrYdsMiyMGHt/KNRRFVRqMUOPabsHgpo1l5R0rXHZw    # 13439072345
# ${AUTH}    c664dcd69btYuiVokMx1vbyO7qInjs9fncpJp2WoJc3vRPZ7nA6CMFO7hHKvZx4y53H1mUxcXsARVlwgBEu4YduAYdhDK6VzVa0aJWSuS9h7U0GcJfkQ
# ${AUTH}    c664dcd69btYuiVokMx1vbyO7qInjs9fncpJp2WoJc3vRPZ7nA6CMFO7hHKvZx4y53H1mUxcXsARVlwgBEu4YduAYdhDK6VzVa0aJWSuS9h7U0GcJfkQ
${UA}    patriarch/7.3 (android;8.0.0;Scale/3.0,1080*2030)
${DELAY}    1    # 请求间隔
${NUM}    0    # 计数器

*** Keywords ***
Setup Test
    Log    *-*-*-*-*-*-*-*-*-* Start Test *-*-*-*-*-*-*-*-*-*

Teardown Test
    Log     *-*-*-*-*-*-*-*-*-* End Test *-*-*-*-*-*-*-*-*-*
    Sleep    ${DELAY}

# 获取vrf字段值（pinus&X-Identity-Code）
Get Vrf Params
    ${resp}    Get Method    ${VRFSERVER}    /getVrfToken    num=-1
    ${res}    To Dict    ${resp}
    Set Suite Variable    ${_pinus}    ${res}[objects][pinus]
    Set Suite Variable    ${_identity}    ${res}[objects][X-Identity-Code]

Set Header
    ${pinus}    Get Variable Value    ${_pinus}
    ${identity}    Get Variable Value    ${_identity}
    &{header}    Create Dictionary    authorization=${AUTH}    User-Agent=${UA}    pinus=${pinus}    x-identity-code=${identity}
    [Return]    ${header}

Set Cookies
    &{cookie}    Create Dictionary    _ga=GA1.2.556530450.1548161063    api_key=3a83aca650Zk6RD8FzMQQvfQ9Xb88gEzi7bqR04%2FJOpErbOP3SjkwHDltLSGs22TiACiLDiuA9tNy%2BrrYdsMiyMGHt%2FKNRRFVRqMUOPabsHgpo1l5R0rXHZw    FDX_auth=3a83aca650Zk6RD8FzMQQvfQ9Xb88gEzi7bqR04%2FJOpErbOP3SjkwHDltLSGs22TiACiLDiuA9tNy%2BrrYdsMiyMGHt%2FKNRRFVRqMUOPabsHgpo1l5R0rXHZw
    [Return]    ${cookie}
    
Set Header1
    &{header}    Create Dictionary    User-Agent=${UA}    Content-Type=application/json
    [Return]    ${header}

# 计数器
Get VrfNum
    [Arguments]    ${num}
    ${n}    Evaluate    ${num}+1
    Set Global Variable    ${n}
    Log    当前请求vrf接口共 ${n} 次    
    
Get Method
    [Documentation]
    ...    ${server_addr}：服务器地址    \n
    ...    ${uri}：资源地址    \n
    ...    ${resp_keys}：返回报文中的字段    \n
    ...    ${num}=${NUM}：开始计数为0    \n
    [Arguments]    ${server_addr}    ${uri}    @{resp_keys}    ${num}=${NUM}    ${cookie}=None    ${header}=None
    Create Session    apitest    ${serveraddr}    cookies=${cookie}    disable_warnings=1
    ${resp}    Get Request    apitest    ${uri}    ${header}
    Should Be True    ${resp.status_code}==200
    # 断言
    :FOR    ${i}    IN    @{resp_keys}
    \    Should Contain    ${resp.text}    ${i}
    Log    ${resp.text}
    Get VrfNum    ${num}
    [Return]    ${resp.text}

# Post Method
    
*** Test Cases ***  
“今日必读”聚合页
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/pgc/today/infos?tag=1&pageNum=0&pageSize=20&v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    objects    "headTitle":"早知道就好了"    "headSubtitle":"每天3分钟，帮孩子解决1个问题。"    "headDisplay":"· 今日为你定制    separator    articles    id    redirectUrl    title    imgUrl    viewNum    classifyName    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${NUM}
    
“家长资讯”（标签）聚合页
    ${n}    Get Variable Value    ${n}
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/pgc/today/infos?tag=0&classifyTodayId=8&pageNum=0&pageSize=20&v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    objects    headTitle    headSubtitle    headDisplay    separator    articles    id    redirectUrl    title    imgUrl    viewNum    classifyName    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${n}
    
“本地升学”聚合页
    ${n}    Get Variable Value    ${n}
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/pgc/thread/infos?classifyThreadId=6&pageNum=0&pageSize=20&v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    objects    "headTitle":"精华荐帖"    headSubtitle    "headDisplay":"· 今日为你定制    separator    articles    id    redirectUrl    title    content    viewNum    date    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${n}
    
“白皮书”标签详情页
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /appsupport/api/v1/pgc/thread/infos/tag?classifyThreadId=1
    @{element}    Create List    "errcode":0    objects    headTitle    headSubtitle    starPgcTitle    starPgcContent    articles    id    redirectUrl    title    meta
    Get Method    ${WEBSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}
    
浏览 
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /appsupport/api/v1/pgc/ext/view/PGCThread1548301042661703
    @{element}    Create List    "errcode":0    objects    "pgcId":"PGCThread1548301042661703"    shareNum    viewNum    meta
    Get Method    ${WEBSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}

家长资讯标签
    ${n}    Get Variable Value    ${n}
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/parentsInfo/grid/?v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    objects    moduleID    cardID    title    pageUrl    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${n}

    
今日必读feed流
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /api/v1/todayRead/feed
    @{element}    Create List    "errcode":0    objects    title    pageUrl    imgUrl    viewNum    classifyName    total    limit    offset    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}

大家都在看/本地升学模块标签
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /api/v1/threadStudy/grid
    @{element}    Create List    "errcode":0    objects    title    pageUrl    imgUrl    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}
    
大家都在看/本地升学模块feed流
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /api/v1/threadStudy/feed
    @{element}    Create List    "errcode":0    objects    title    pageUrl    meta    total    limit    offset
    Get Method    ${APPSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}
    
大家都在看/本地升学模块查看更多
     ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /api/v1/threadStudy/more
    @{element}    Create List    "errcode":0    objects    "title":"查看更多"    pageUrl    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}

获取是首页模版信息
    ${n}    Get Variable Value    ${n}
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/tmp/info/?v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    errmsg    objects    version    modules    shadow    scroll    loadMore    pageCircle    url    type    moduleID    sort    meta
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${n}

根据模块地址获取模块信息(今日必读)
    ${n}    Get Variable Value    ${n}
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/pgc/home/modules/1?pageNum=5&v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    errmsg    objects    subTitle    cardID    type    "title":"查看更多"    image    btitle1    pageUrl    type    btitle2    margin    color    height    total    limit    offset
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${n}
    
根据模块地址获取模块信息(广告位)
    ${n}    Get Variable Value    ${n}
    ${header}    Set Header
    ${uri}    Set Variable    /api/v1/pgc/home/modules/3?pageNum=5&v=7.3&ver=7.3&channel=website&deviceId=ffffffff-c7a8-b0f1-0000-0000265bc76d&deviceType=MIX_2&deviceVersion=8.0.0
    @{element}    Create List    "errcode":0    errmsg    objects    cardID    android_uninstall_url    image    uri_type    ad_type    android_appstore_url    "ad_name":"广告"    ios_uninstall_url    title    uri    android_target_url    id    type    ad_icon
    Get Method    ${APPSERVER}    ${uri}    @{element}    header=${header}    num=${n}
    
获取今日必读文章详情
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /appsupport/api/v1/pgc/today/info/PGCToday1548251170137491
    @{element}    Create List    "errcode":0    errmsg    objects    "pgcId":"PGCToday1548251170137491"    author    title    imgUrl    liked    publishTime    likeCount    title    content    display    enable    classifyInfo    id    name    meta
    Get Method    ${WEBSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}
    
获取升学社区文章详情
    ${n}    Get Variable Value    ${n}
    ${n}    Evaluate    ${n}-1    
    ${cookie}    Set Cookies
    ${uri}    Set Variable    /appsupport/api/v1/pgc/thread/info/PGCThread1548301042661703
    @{element}    Create List    "errcode":0    objects    "pgcId":"PGCThread1548301042661703"    author    ifStar    imgUrl    liked    chapterId    publishTime    likeCount    title    content    display    enable    classifyInfo    id    name    meta
    Get Method    ${WEBSERVER}    ${uri}    @{element}    cookie=${cookie}    num=${n}
    
文章点赞
    ${cookie}    Set Cookies
    ${header}    Set Header1
    &{data}    Create Dictionary    pgcId=PGCToday1548142128325948    type=today        
    Create Session    headlineapi    ${WEBSERVER}       disable_warnings=1    cookies=${cookie}
    ${resp}    Post Request    headlineapi    /appsupport/api/v1/pgc/article/like   data=${data}     headers=${header}
    Should Be True    ${resp.status_code}==200
    @{element}    Create List    "errcode":0    "errmsg":"该文章已点赞"    objects    meta
    # 断言
    :FOR    ${i}    IN    @{element}
    \    Should Contain    ${resp.text}     ${i}
    
# 详情页/文章举报   
    # Create Session    headlineapi    ${APPSERVER}    disable_warnings=1
