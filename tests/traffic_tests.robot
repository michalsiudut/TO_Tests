*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/ue_keywords.resource
Resource    ../resources/bearer_keywords.resource
Resource    ../resources/traffic_keywords.resource

Suite Setup       Create API Session
Test Setup        Reset Simulator
Test Teardown     Reset Simulator

*** Test Cases ***
TC1 - Verify traffic can be started on default bearer
    [Tags]    traffic    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    10
    Should Be Equal As Integers    ${response.status_code}    200

TC2 - Verify traffic stats can be retrieved for active bearer
    [Tags]    traffic    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${start_response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    10
    Should Be Equal As Integers    ${start_response.status_code}    200

    ${stats_response}=    Get Traffic Stats    ${VALID_UE_ID}    9
    Should Be Equal As Integers    ${stats_response.status_code}    200
    Should Contain    ${stats_response.text}    tcp

TC3 - Verify traffic can be stopped on active bearer
    [Tags]    traffic    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${start_response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    10
    Should Be Equal As Integers    ${start_response.status_code}    200

    ${stop_response}=    Stop Traffic    ${VALID_UE_ID}    9
    Should Be Equal As Integers    ${stop_response.status_code}    200

TC4 - Verify traffic without throughput returns error
    [Tags]    traffic    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${body}=    Create Dictionary    protocol=udp
    ${response}=    Start Traffic With Body    ${VALID_UE_ID}    9    ${body}
    Should Not Be Equal As Integers    ${response.status_code}    200

TC5 - Verify traffic with multiple throughput units returns error
    [Tags]    traffic    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${body}=    Create Dictionary    protocol=udp    Mbps=1    kbps=2    bps=3
    ${response}=    Start Traffic With Body    ${VALID_UE_ID}    9    ${body}
    Should Not Be Equal As Integers    ${response.status_code}    200

TC6 - Verify traffic on inactive bearer returns error
    [Tags]    traffic    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Start Traffic    ${VALID_UE_ID}    5    tcp    Mbps    10
    Should Not Be Equal As Integers    ${response.status_code}    200

TC7 - Verify traffic above 100 Mbps should be rejected according to documentation
    [Tags]    traffic    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    101
    Should Not Be Equal As Integers    ${response.status_code}    200

TC8 - Verify negative throughput should be rejected according to documentation
    [Tags]    traffic    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Start Traffic    ${VALID_UE_ID}    9    udp    bps    -100
    Should Not Be Equal As Integers    ${response.status_code}    200

TC9 - Verify total UE traffic above 100 Mbps should be rejected according to documentation
    [Tags]    traffic    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${add_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${add_response.status_code}    200

    ${first_response}=    Start Traffic    ${VALID_UE_ID}    5    tcp    Mbps    60
    Should Be Equal As Integers    ${first_response.status_code}    200

    ${second_response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    60
    Should Not Be Equal As Integers    ${second_response.status_code}    200

TC10 - Verify traffic stats are zero after stopping traffic
    [Tags]    traffic    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${start_response}=    Start Traffic    ${VALID_UE_ID}    9    tcp    Mbps    10
    Should Be Equal As Integers    ${start_response.status_code}    200

    Sleep    1s
    ${stop_response}=    Stop Traffic    ${VALID_UE_ID}    9
    Should Be Equal As Integers    ${stop_response.status_code}    200

    ${stats_response}=    Get Traffic Stats    ${VALID_UE_ID}    9
    Should Be Equal As Integers    ${stats_response.status_code}    200
    Response JSON Field Should Be    ${stats_response}    tx_bps    0
    Response JSON Field Should Be    ${stats_response}    rx_bps    0

TC11 - Verify stopping inactive traffic returns error
    [Tags]    traffic    spec_mismatch
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${add_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${add_response.status_code}    200

    ${stop_response}=    Stop Traffic    ${VALID_UE_ID}    5
    Should Not Be Equal As Integers    ${stop_response.status_code}    200
