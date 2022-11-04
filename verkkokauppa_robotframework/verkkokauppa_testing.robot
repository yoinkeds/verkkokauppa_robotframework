# Onni-Petteri Rantanen, Danila Karpov, Adewale Salami, Sonny Holman, Harsh Chahal, Anton Satalin

*** Settings ***
Library    OperatingSystem
Library    SeleniumLibrary
Library    String
Library    Collections
Library    DatabaseLibrary

*** Variables ***
${url}    https://www.verkkokauppa.com/
${logInUrl}    https://www.verkkokauppa.com/fi/account/login
${Fakeurl}    https://www.verkkokauppa.com/adgahh
${browser}    Chrome
${item1}    ps5
${item2}    xbox
${i}    1
${iterator}    1

# PRE-CONDITIONS FOR THE WHOLE PROJECT: HAVE THE ROBOT FRAMEWORK AND SELENIUM LIBRARIES + NEEDED CHROME DRIVERS. IF USING A BROWSER OTHER THAN CHROME CHANGE THE BROWSER VARIABLE AND DOWNLOAD DRIVERS ACCORDINGLY.
# ADDED SLEEP COMMANDS BECAUSE SOMETIMES SELENIUM GOES TOO FAST FOR YOUR COMPUTER TO LOAD WHICH CAUSES ERRORS. IF THERE ARE ERRORS ADD MORE SLEEP COMMANDS
*** Test Cases ***
TC_C_I (testcase_category_icons)
# In this test we see if all the categories have icons.
    Open Browser    ${url}    ${browser}
    Click Element    xpath://*[@id="app"]/div/header/div/label
    Sleep    3
    TRY
        WHILE    True    limit=25
        
            Page Should Contain Element   xpath://*[@id="app"]/div/div/aside/nav/div/div[2]/ul/li[${i}]/a/span[1]
            ${i}=    Evaluate    ${i}+${iterator}    
            IF    ${i}>6
                Scroll Element Into View    xpath://*[@id="app"]/div/div/aside/nav/div/div[2]/ul/li[29]
            END
            
        END
        EXCEPT    WHILE loop was aborted    type=start
        Log    it ended
    END
    Close Browser

# THERE SHOULD BE NO ERROR

*** Test Cases ***
TC_C_LP (testcase_category_landingpage)
# In this test we see if all the categories have landing pages.

    Open Browser    ${url}    ${browser}
    Click Element    xpath://*[@id="app"]/div/header/div/label
    Sleep    3
    TRY
        WHILE    True    limit=25
        
            Click Element   xpath://*[@id="app"]/div/div/aside/nav/div/div[2]/ul/li[${i}]/a   
            ${catalogurl}=    Get Location
            ${i}=    Evaluate    ${i}+${iterator}
            Should Match Regexp    ${catalogurl}    https://www.verkkokauppa.com/fi/catalog/

            Click Element    xpath://*[@id="app"]/div/header/div/label
            
            IF    ${i}>6
                Scroll Element Into View    xpath://*[@id="app"]/div/div/aside/nav/div/div[2]/ul/li[29]
            END
            
        END
        EXCEPT    WHILE loop was aborted    type=start
        Log    it ended
    END
    Close Browser
# THERE SHOULD BE NO ERROR

*** Test Cases ***
TC_S (testcase_search)
# In this test we see if the search bar works.
    Open Browser    ${url}    ${browser}

    Input Text    xpath://*[@id="app"]/div/header/div/nav/form/div/input    ${item1}
    Sleep    3
    Click Button    xpath://*[@id="app"]/div/header/div/nav/form/div/div/button[2]
    Sleep    3
    Click Element    xpath://*[@id="main"]/div/div[2]/div[1]/ol/li[1]/article/a
    Sleep    3
    Capture Element Screenshot    xpath://*[@id="main"]/section/aside/div[1]/div/div/div/ul/li[1]/span/picture/img    ElementScreenshot.png
    Sleep    2
    Scroll Element Into View    xpath://*[@id="main"]/section/article/div[1]
    Sleep    3
    Page Should Contain    ${item1}
    Close Browser
# THERE SHOULD BE NO ERROR

*** Test Cases ***
TC_PP (testcase_productpage)
# In this we see if the product page has the necessary product info.
    Open Browser    ${url}    ${browser}

    Input Text    xpath://*[@id="app"]/div/header/div/nav/form/div/input    ${item1}
    Sleep    3
    Click Button    xpath://*[@id="app"]/div/header/div/nav/form/div/div/button[2]
    Sleep    3
    Click Element    xpath://*[@id="main"]/div/div[2]/div[1]/ol/li[1]/article/a
    Sleep    3
    Scroll Element Into View    xpath://*[@id="main"]/section/nav
    Sleep    3
    Page Should Contain Element    xpath://*[@id="tabs-page-select-tab0"]
    Sleep    3
    Page Should Contain Element    xpath://*[@id="tabs-page-select-tab1"]
    Close Browser
# THERE SHOULD BE NO ERROR

*** Test Cases ***
# Since all ps5's are sold out from Verkkokauppa we cannot test adding them to the shopping cart, so we have to use a different item.
TC_SC (testcase_shoppingcart)
# In this test we try adding a product to the shopping cart.
    Open Browser    ${url}    ${browser}

    Input Text    xpath://*[@id="app"]/div/header/div/nav/form/div/input    ${item2}
    Sleep    3
    Click Button    xpath://*[@id="app"]/div/header/div/nav/form/div/div/button[2]
    Sleep    3
    Click Element    xpath://*[@id="main"]/div/div[2]/div[1]/ol/li[1]/article/a
    Sleep    3
    Click Button    xpath://*[@id="allow-cookies"]
    Sleep    3
    Click Button    xpath://*[@id="main"]/section/aside/div[2]/div[2]/div[1]/div[2]/button[1]
    Sleep    3
    Page Should Contain    Lisätty ostoskoriin
    Close Browser

# THERE SHOULD BE NO ERROR

*** Test Cases ***
TC_CI (testcase_contactinfo)
# In this test we see the websites contact info.
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Scroll Element Into View    xpath://*[@id="main"]/div/div[9]/div/a
    Click Element    xpath://*[@id="app"]/div/aside/div[2]/div/div[2]/nav/div[2]/ul[1]/li[5]/a
    Page Should Contain    Yhteystiedot
    Sleep    3
    Close Browser

# THERE SHOULD BE NO ERROR


*** Test Cases ***
TC_IC (testcase_invalidcredentials)
# In this test we test if we are able to log in with invalid credentials.
    Open Browser    ${logInUrl}    ${browser}
    Maximize Browser Window
    Page Should Contain    Kirjautuminen
    Input Text    xpath://*[@id="login-form-email"]    test@test.com
    Click Button    xpath://*[@id="login-button"]
    Input Text    xpath://*[@id="login-form-password"]    test
    Click Button    xpath://*[@id="login-button"]
    Sleep    2
    Page Should Contain    Antamasi sähköpostiosoite tai salasana oli väärin.
    Close Browser
    # THERE SHOULD BE NO ERROR

*** Test Cases ***
TC_404 (testcase_404)
# In this test we try if we are able to open a url that does not exist.
    Open Browser    ${Fakeurl}    ${browser}
    Page Should Contain    Sivua ei löytynyt, mutta tässä parhaiten myyneitä uutuksiamme...
    Close Browser
# THERE SHOULD BE NO ERROR

*** Test Cases ***
TC_P (testcase_ping)
# In this test we ping the website.
    ${ping}=    Run    ping www.verkkokauppa.com
    Log to Console    ${ping}
# PING SHOULD BE LOGGED TO CONSOLE

*** Test Cases ***
TC_MR (testcase_mobileresulotion)
# In this test we see if the website fits with mobile resolutions.
    Open Browser    ${url}    ${browser}
    Set Window Size    400    890
    Page Should Contain Element    xpath://*[@id="app"]/div/header
    Close Browser
    # THERE SHOULD BE NO ERROR