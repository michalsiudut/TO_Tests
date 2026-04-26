*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/ue_keywords.resource
Resource    ../resources/bearer_keywords.resource
Resource    ../resources/traffic_keywords.resource

Suite Setup       Create API Session
Test Setup        Reset Simulator
Test Teardown     Reset Simulator

*** Test Cases ***
SC1 - Verify active bearer stats return configured target
    [Tags]    stats    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${start_response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    10
    Should Be Equal As Integers    ${start_response.status_code}    200

    ${stats_response}=    Get Traffic Stats    ${VALID_UE_ID}    9
    Should Be Equal As Integers    ${stats_response.status_code}    200
    Response JSON Field Should Be    ${stats_response}    target_bps    10000000
    Response Body Should Contain    ${stats_response}    tcp

SC2 - Verify existing bearer without traffic returns empty stats
    [Tags]    stats    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${stats_response}=    Get Traffic Stats    ${VALID_UE_ID}    9
    Should Be Equal As Integers    ${stats_response.status_code}    200
    Response JSON Field Should Be    ${stats_response}    tx_bps    0
    Response JSON Field Should Be    ${stats_response}    rx_bps    0
    Response JSON Field Should Be    ${stats_response}    duration    0

SC3 - Verify stats for bearer not attached to UE returns error
    [Tags]    stats    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${stats_response}=    Get Traffic Stats    ${VALID_UE_ID}    5
    Should Not Be Equal As Integers    ${stats_response.status_code}    200

SC4 - Verify aggregated stats for one UE counts default bearer
    [Tags]    stats    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${stats_response}=    Get Aggregated Traffic Stats For UE    ${VALID_UE_ID}
    Should Be Equal As Integers    ${stats_response.status_code}    200
    Response JSON Field Should Be    ${stats_response}    ue_count    1
    Response JSON Field Should Be    ${stats_response}    bearer_count    1
    Response JSON Field Should Be    ${stats_response}    total_tx_bps    0
    Response JSON Field Should Be    ${stats_response}    total_rx_bps    0

SC5 - Verify aggregated stats include traffic from multiple bearers
    [Tags]    stats    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${add_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${add_response.status_code}    200

    ${first_start_response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    10
    Should Be Equal As Integers    ${first_start_response.status_code}    200
    ${second_start_response}=    Start Traffic    ${VALID_UE_ID}    5    udp    Mbps    20
    Should Be Equal As Integers    ${second_start_response.status_code}    200

    Sleep    1s
    ${stats_response}=    Get Aggregated Traffic Stats For UE    ${VALID_UE_ID}
    Should Be Equal As Integers    ${stats_response.status_code}    200
    Response JSON Field Should Be    ${stats_response}    ue_count    1
    Response JSON Field Should Be    ${stats_response}    bearer_count    2
    ${body}=    Set Variable    ${stats_response.json()}
    Should Be True    ${body["total_tx_bps"]} > 0
    Should Be True    ${body["total_rx_bps"]} > 0
