*** Settings ***
Library    RequestsLibrary
 
  
Suite Setup    Create Session    zwtoolsapi    https://webapp.jzb.com    disable_warnings=1   
*** Test Cases ***
创建会话
    ${resp}    Get Request    zwtoolsapi    /zwtools/index
    # ${type}    Evaluate    type($resp)  
    # ${type}    Evaluate    type(${resp})  
    Log    ${resp}         
创建
    Create Session    zwtoolsapi    https://webapp.jzb.com
    ${resp}    Get Request    zwtoolsapi    /zwtools/index   
    Evaluate    expression    
    #字典    Tab键隔开每一个键值对
    # &{datas}=    Create Dictionary    number=1012002
    # ${rep}    Get Request    api  /zwtools/index    params=${datas}
    # Log    ${rep}
    # #状态码
   # # Log    ${rep.status_code}
    # #断言
    # Should Be Equal As Strings    200    ${rep.status_code}    
    # #响应数据
    # Log    ${rep.text}        
test1
    ${a1}    Set Variable    5
    ${a2}    Set Variable    2
    ${a3}    Set Variable    ${a1}+${a2}
    ${a4}    Evaluate    ${a1}+${a2}    
    ${a4}    Evaluate    $a1+$a2    
    
    ${b}    Evaluate    type(${a1})  
    ${c}    Evaluate    type($a2)  