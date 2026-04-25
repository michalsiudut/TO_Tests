*** Settings ***
Resource    common.resource

*** Keywords ***
Attach UE
    ${body}=    Create Dictionary    ue_id=${VALID_UE_ID}
    ${response}=    POST On Session    epc    /ues    json=${body}    expected_status=any
    Set Suite Variable    ${RESPONSE}    ${response}

Verify UE Is Attached
    Should Be Equal As Integers    ${RESPONSE.status_code}    200

Attach UE With ID
    [Arguments]    ${ue_id}
    ${body}=    Create Dictionary    ue_id=${ue_id}
    ${response}=    POST On Session    epc    /ues    json=${body}    expected_status=any
    RETURN    ${response}

Get UE By ID
    [Arguments]    ${ue_id}
    ${response}=    GET On Session    epc    /ues/${ue_id}    expected_status=any
    RETURN    ${response}

Detach UE By ID
    [Arguments]    ${ue_id}
    ${response}=    DELETE On Session    epc    /ues/${ue_id}    expected_status=any
    RETURN    ${response}
