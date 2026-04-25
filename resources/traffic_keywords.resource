*** Settings ***
Resource    common.resource

*** Keywords ***
Start Traffic
    [Arguments]    ${ue_id}    ${bearer_id}    ${protocol}    ${throughput_key}    ${throughput_value}
    ${body}=    Create Dictionary    protocol=${protocol}
    Set To Dictionary    ${body}    ${throughput_key}=${throughput_value}
    ${response}=    POST On Session    epc    /ues/${ue_id}/bearers/${bearer_id}/traffic    json=${body}    expected_status=any
    RETURN    ${response}

Start Traffic With Body
    [Arguments]    ${ue_id}    ${bearer_id}    ${body}
    ${response}=    POST On Session    epc    /ues/${ue_id}/bearers/${bearer_id}/traffic    json=${body}    expected_status=any
    RETURN    ${response}

Get Traffic Stats
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    GET On Session    epc    /ues/${ue_id}/bearers/${bearer_id}/traffic    expected_status=any
    RETURN    ${response}

Get Aggregated Traffic Stats
    ${response}=    GET On Session    epc    /ues/stats    expected_status=any
    RETURN    ${response}

Get Aggregated Traffic Stats For UE
    [Arguments]    ${ue_id}
    ${response}=    GET On Session    epc    url=/ues/stats?ue_id=${ue_id}    expected_status=any
    RETURN    ${response}

Stop Traffic
    [Arguments]    ${ue_id}    ${bearer_id}
    ${response}=    DELETE On Session    epc    /ues/${ue_id}/bearers/${bearer_id}/traffic    expected_status=any
    RETURN    ${response}
