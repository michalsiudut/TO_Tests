*** Settings ***
Resource    common.resource

*** Keywords ***
Add Bearer To UE
    [Arguments]    ${ue_id}    ${bearer_id}
    ${body}=    Create Dictionary    bearer_id=${bearer_id}
    ${response}=    POST On Session    epc    /ues/${ue_id}/bearers    json=${body}    expected_status=any
    RETURN    ${response}

Delete Bearer From UE
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    DELETE On Session    epc    /ues/${ue_id}/bearers/${bearer_id}    expected_status=any
    RETURN    ${response}
