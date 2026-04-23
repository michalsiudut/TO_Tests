*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/ue_keywords.resource

Suite Setup       Create API Session
Test Setup        Reset Simulator
Test Teardown     Reset Simulator

*** Test Cases ***
AC1 - Verify UE can be attached
    [Tags]    attach    positive
    [Setup]    Reset Simulator

    Attach UE
    Verify UE Is Attached

    [Teardown]    Reset Simulator

AC2 - Verify attach with UE ID out of range returns error
    [Tags]    attach    negative
    ${response}=    Attach UE With ID    ${INVALID_UE_ID}
    Should Not Be Equal As Integers    ${response.status_code}    200

AC3 - Verify already attached UE returns error
    [Tags]    attach    negative
    ${first}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${first.status_code}    200

    ${second}=    Attach UE With ID    ${VALID_UE_ID}
    Should Not Be Equal As Integers    ${second.status_code}    200

AC4 - Verify attached UE can be retrieved
    [Tags]    attach    positive
    ${response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${response.status_code}    200

    ${get_response}=    Get UE By ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200

AC5 - Verify attached UE gets default bearer 9
    [Tags]    attach    positive
    ${response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${response.status_code}    200

    ${get_response}=    Get UE By ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200
    Should Contain    ${get_response.text}    9