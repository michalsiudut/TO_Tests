*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource   ../variables/env.resource

*** Keywords ***
Create API Session
    Create Session    epc    ${BASE_URL}

Reset Simulator
    ${response}=    POST On Session    epc    /reset    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    200

Response Body Should Contain
    [Arguments]    ${response}    ${text}
    Should Contain    ${response.text}    ${text}

Response JSON Field Should Be
    [Arguments]    ${response}    ${field}    ${expected}
    ${body}=    Set Variable    ${response.json()}
    ${actual}=    Get From Dictionary    ${body}    ${field}
    Should Be Equal As Integers    ${actual}    ${expected}
