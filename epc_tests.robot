*** Settings ***
Library    RequestsLibrary

Suite Setup    Create Session    epc    http://localhost:8000


*** Test Cases ***

AC1 - Verify UE can be attached
    [Tags]    attach
    [Setup]    Reset Simulator

    Attach UE
    Verify UE Is Attached

    [Teardown]    Reset Simulator


*** Keywords ***

Reset Simulator
    ${response}=    POST On Session    epc    /reset
    Should Be Equal As Integers    ${response.status_code}    200


Attach UE
    ${body}=        Create Dictionary    ue_id=${1}
    ${response}=    POST On Session       epc    /ues    json=${body}    expected_status=any
    Set Suite Variable    ${RESPONSE}     ${response}


Verify UE Is Attached
    Should Be Equal As Integers    ${RESPONSE.status_code}    200