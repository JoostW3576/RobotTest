*** Settings ***
Library         SeleniumLibrary
Library         Collections

*** Variables ***
${url}              https://www.saucedemo.com/
${cookies_bol}      //span[contains(text(),'Accepteren')]
${xpath_user_name}  //input[@id='user-name']
${xpath_pass_word}  //input[@id='password']

*** Test Cases ***
Ga naar site en ik kan inloggen
    [Tags]   TC01
    [Setup]  Uitgangsituatie klaarzetten
    Invullen Inloggevens    standard_user   secret_sauce    Products
    Select product Sortering
#    Select Product
#    Select Taal van Boek
#    Sluit de browser

Ga naar site en kan niet inloggen
    [Tags]  TC02
    [Setup]  Uitgangsituatie klaarzetten
    Invullen Inloggevens    locked_out_user     secret_sauce    Epic sadface
    Select product Sortering
#    Select Product
#    Select Taal van Boek
#    Sluit de browser

*** Keywords ***
Uitgangsituatie klaarzetten
        Open browser                         about:blank      chrome
        Maximize Browser Window
        go to       ${url}
        Wait Until Element Is Visible    //div[@class='login_logo']    timeout=20

Invullen Inloggevens
       [Arguments]  ${username}  ${password}  ${status}
       Input Text   ${xpath_user_name}    ${username}
       Input Text   ${xpath_pass_word}    ${password}
       Click Button    //input[@id='login-button']
       ${text_present}=     run keyword and return status  Page Should Contain   ${status}
       run keyword if  ${text_present}==True   Wait Until Page Contains   ${status}
       ...  ELSE IF    ${text_present}!=True   Wait Until Page Does Not Contain    ${status}
       ...  ELSE  log  geen enkele status wordt getoond
       Log  ${status}

Select product Sortering
       ${locator_present}=     run keyword and return status  Page Should Contain Element    //option[contains(text(),'Price (low to high)')]
       run keyword if   ${locator_present}==True   Click Element   //option[contains(text(),'Price (low to high)')]
         ...  ELSE IF   ${locator_present}==False  log  Locator voor Select product is niet mogelijk om daar naar toe te navigeren of beschikbaar

Product kiezen
       [Arguments]  ${product1}   ${product2}    ${product3}    ${product4}
       Opdracht_9.Select Product    ${product1}
       Opdracht_9.Select Product    ${product2}
       Opdracht_9.Select Product    ${product3}
       Opdracht_9.Select Product    ${product4}

Select Product
        &{resultaten_producten}     create dictionary   prijs_1=7.99    prijs_2=9.99    prijs_3=15.99   prijs_4=29.99
        log  ${resultaten_producten}
#        ${resultaten_producten}=     Convert To Number  ${resultaten_producten} 0
#        ${resultaten_producten}     Convert To Number  ${resultaten_producten} 0
        log  ${resultaten_producten}
        Get Element Count 	//div[@class="inventory_item_price"]
        :FOR    ${INDEX}    IN RANGE    1    ${resultaten_producten}
        \   Log    ${INDEX}
        ${lintext}=    Get Text    //div[@class="inventory_item_price"][contains(text(),'${INDEX}')]
        \   Log    ${lintext}
        \   ${linklength}    Get Length    ${lintext}
        \   Run Keyword If    ${linklength} >1    Append To List    ${resultaten_producten}    ${lintext}
        \   :END
        \   ${LinkSize}=    Get Length    ${resultaten_producten}
        \   Log    ${LinkSize}
        :FOR    ${ELEMENT}    IN    ${resultaten_producten}
        \   Log    ${ELEMENT}
        \   END


#    :FOR  ${occ}  IN RANGE  1  ${occurrence}+1
#    \  ${result}  ${msg} =  run keyword and ignore error    Convert To Number           ${text}
#    \                       continue for loop if  '${result}' == 'FAIL'
#    \  ${pass} =            run keyword and return status  Should be equal as numbers  ${value}  ${text}
#    \                       exit for loop if   '${pass}' == 'True'
#    should be equal  ${pass}  ${True}  msg=Expected value '${value}' is not equal to actual value '${text}'














#        click element   xpath://span[contains(text(),'Accepteren')]
#
#Ga akkoord met cookies bol.com
#        [Documentation]  in status_cookies wordt bepaald als deze waarde true is dan wordt het keyword
#        ...  BK_PageElement.Controleer cookies Weekendjeweg uitgevoerd en anders wordt er gelogd dat cookies
#        ...  worden verwijderd
#        Wait Until Element is Visible    ${cookies_bol}     timeout=1
#        ${status_cookies} =   run keyword and return status     Element Should Be Visible  ${cookies_bol}
#        run keyword if  '${status_cookies}' =='True'    Controleer cookies
#        ...     ELSE    log        Cookies zijn verwijderd
#
#Choose Boeken
#        [Arguments]  ${page_result}=Boeken
#        Scroll Element Into View  //span[contains(@class,'u-mt--xs')][contains(text(),'Boeken')]
#        click element    //span[contains(@class,'u-mt--xs')][contains(text(),'Boeken')]
#        Wait Until Page Contains    ${page_result}
#
#Select Taal van Boek
#        click element      //span[@class="checkbox-input"]//input[@value="8293"]
#
##Sluit de browser
##        Close browser
