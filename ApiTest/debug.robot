*** Settings ***
Library    RequestsLibrary
Library    Collections      

*** Test Cases ***
创建会话
    Create Session    api    http://webapp-dev.jzb.com
    #字典    Tab键隔开每一个键值对
    &{datas}=    Create Dictionary    number=1012002
    ${rep}    Get Request    api  /zwtools/index    params=${datas}
    Log    ${rep}
    #状态码
   # Log    ${rep.status_code}
    #断言
    Should Be Equal As Strings    200    ${rep.status_code}    
    #响应数据
    Log    ${rep.text}        