*** Comments ***
前端页面：https://webapp.jzb.com/work_tools/

*** Settings ***
Library    RequestsLibrary
Library    Collections



*** Variables ***
${host}    https://webapp.jzb.com
${User-Agent}    Mozilla/5.0 (Linux; Android 9; MIX 3 Build/PKQ1.180729.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/68.0.3440.91 Mobile Safari/537.36patriarch/7.3 (android;9;Scale/2.75,1080*2210)
${cookie1}    GA1.2.385320673.1546968303    
${cookie2}    f79abcc31cg8pUDt5EN7mhErAKlUsYT9EHJfKx8PYGkGxU34tunX5CtzNgBPTN6rZG9uNHqsG%2BFxVclbpi%2F3aXNGoxEzktHUNR7TgByp75qaA    
${cookie3}    1

*** Keywords ***
connect session
    Create Session    zwtoolsapi    ${host}    disable_warnings=1
    
get method
    [Arguments]    ${uri}    ${host}=zwtoolsapi    ${header}=None    ${cookie}=None    
    ${response}    Get Request    ${host}    ${uri}
    [Return]    ${response}         