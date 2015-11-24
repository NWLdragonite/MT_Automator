#Include <definitions>
#Include <logger>
#Include <config>


config_iniRead() {
    global 0
    global 1
    global MT_CONFIG_PATH
    global MT_SELECT_PATH
    global SNR_Array

    Section := %0%
    iniSection := %1%

    logger_Log("Section:" . Section)

    ; IniRead, mtCount, MT_CONFIG_PATH, Section, MT_COUNT
    IniRead, mtCount, %MT_CONFIG_PATH%, %Section%, MT_COUNT
    logger_Log("MT Count:" . mtCount)

    IniRead, port, %MT_CONFIG_PATH%, %Section%, PORT_INDEX
    logger_Log("Port:" . port)

    IniRead, dbIndex, %MT_CONFIG_PATH%, %Section%, DB_LIST_NUM
    logger_Log("DB:" . dbIndex)

    IniRead, mode, %MT_CONFIG_PATH%, %Section%, MODE
    logger_Log("Mode:" . mode)

    IniRead, vlanIndex, %MT_CONFIG_PATH%, %Section%, VLAN_INDEX
    logger_Log("VLan:" . vlanIndex)

    IniRead, langIndex, %MT_CONFIG_PATH%, %Section%, LANG_INDEX
    logger_Log("Language:" . langIndex)

    ;populate the arrays
    Loop, %mtCount%
    {
        IniRead, outputVar, %MT_CONFIG_PATH%, %Section%, Scenario%A_Index%
        logger_Log("outputVar:" . outputVar)
        SNR_Array[%A_Index%] := outputVar
        logger_Log("SNR:" . SNR_Array[%A_Index%])

        IniRead, card_ID%A_Index%, %MT_CONFIG_PATH%, %Section%, CARD_ID%A_Index%
        logger_Log("Card ID:" . card_ID%A_Index%)

    }

    resetMTSettings(mode)

    Loop, %mtCount%
    {
        value := 1
        Filename := MT_SELECT_PATH
        Section := getMtSection(A_Index)
        Key := "CHECKED"
        ;Write checked status
        IniWrite, 1, %Filename%, %Section%, %Key%
        logger_Log("value:" . value)
        logger_Log("Filename:" . Filename)
        logger_Log("Section:" . Section)
        logger_Log("Key:" . Key)

    }
}

resetMTSettings(mode) {
    global MT_MAX
    global MT_SELECT_PATH

    Filename := MT_SELECT_PATH

    mode := mode ? "3G_CARD_ID" : "LTE_CARD_ID"
    Loop, %MT_MAX%
    {
        MTSection := getMtSection(A_Index)
        logger_Log("MTSection:" . MTSection)

        cardSection := getCardSection(mode, A_Index)
        logger_Log("Card Section:" . CardSection)

        IniWrite, 0, %Filename%, %MTSection%, CHECKED
        IniWrite, 0, %Filename%, %cardSection%, ENDIAN
    }
}

padNumber(num) {

    if (num > 9) 
    {
        value := num
    } 
    Else
    {
        ;Add leading zero
        value := "0" . num
    }

    return value
}


getMtSection(num) {

    ;Building [MT_01]
    mtSection := "MT_" . padNumber(num) 

    return mtSection
}

getCardSection(mode, num) {

    ;Convert to zero index
    zeroIndex := num - 1

    /*
    Building [LTE_CARD_ID_00] or
    Building [3G_CARD_ID_00]
    */
    cardSection := mode . "_" . padNumber(zeroIndex)

    return cardSection
}