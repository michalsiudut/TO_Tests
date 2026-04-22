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

Response Status Should Be
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Integers    ${response.status_code}    ${expected_status}

Response Should Not Be 200
    [Arguments]    ${response}
    Should Not Be Equal As Integers    ${response.status_code}    200

Response Body Should Contain
    [Arguments]    ${response}    ${text}
    Should Contain    ${response.text}    ${text}