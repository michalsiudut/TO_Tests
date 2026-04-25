*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/ue_keywords.resource
Resource    ../resources/bearer_keywords.resource

Suite Setup       Create API Session
Test Setup        Reset Simulator
Test Teardown     Reset Simulator

*** Test Cases ***
BC1 - Verify dedicated bearer can be added
    [Tags]    bearer    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${response.status_code}    200

BC2 - Verify added bearer is visible on UE
    [Tags]    bearer    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${add_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${add_response.status_code}    200

    ${get_response}=    Get UE By ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200
    Should Contain    ${get_response.text}    "5"

BC3 - Verify adding duplicate bearer returns error
    [Tags]    bearer    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${first_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${first_response.status_code}    200

    ${second_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Not Be Equal As Integers    ${second_response.status_code}    200

BC4 - Verify bearer out of range returns error
    [Tags]    bearer    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Add Bearer To UE    ${VALID_UE_ID}    10
    Should Not Be Equal As Integers    ${response.status_code}    200

BC5 - Verify dedicated bearer can be removed
    [Tags]    bearer    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${add_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${add_response.status_code}    200

    ${delete_response}=    Delete Bearer From UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${delete_response.status_code}    200

BC6 - Verify removed bearer is no longer visible
    [Tags]    bearer    positive
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${add_response}=    Add Bearer To UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${add_response.status_code}    200

    ${delete_response}=    Delete Bearer From UE    ${VALID_UE_ID}    5
    Should Be Equal As Integers    ${delete_response.status_code}    200

    ${get_response}=    Get UE By ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200
    Should Not Contain    ${get_response.text}    "5"

BC7 - Verify default bearer 9 cannot be removed
    [Tags]    bearer    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Delete Bearer From UE    ${VALID_UE_ID}    9
    Should Not Be Equal As Integers    ${response.status_code}    200

BC8 - Verify deleting bearer out of range returns error
    [Tags]    bearer    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Delete Bearer From UE    ${VALID_UE_ID}    10
    Should Not Be Equal As Integers    ${response.status_code}    200

BC9 - Verify deleting inactive bearer returns error
    [Tags]    bearer    negative
    ${attach_response}=    Attach UE With ID    ${VALID_UE_ID}
    Should Be Equal As Integers    ${attach_response.status_code}    200

    ${response}=    Delete Bearer From UE    ${VALID_UE_ID}    5
    Should Not Be Equal As Integers    ${response.status_code}    200
