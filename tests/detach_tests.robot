*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/ue_keywords.resource

Suite Setup       Create API Session
Test Setup        Reset Simulator
Test Teardown     Reset Simulator

*** Test Cases ***
DC1 - Verify attached UE can be detached
    [Tags]    detach    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${detach_response}=    Detach UE By ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${detach_response.status_code}    200

DC2 - Verify detached UE cannot be retrieved
    [Tags]    detach    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${detach_response}=    Detach UE By ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${detach_response.status_code}    200

    ${get_response}=    Get UE By ID    ${VALID_UE_ID}
    Should Not Be Equal As Integers    ${get_response.status_code}    200

DC3 - Verify detach of non-attached UE returns error
    [Tags]    detach    negative
    ${response}=    Detach UE By ID    ${VALID_UE_ID}
    Should Not Be Equal As Integers    ${response.status_code}    200
