--******************************************************************************
--        @TITRE : shiftRegister.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shiftRegister IS
GENERIC(length          : POSITIVE := 8;
        rightNotLeft    : BOOLEAN := TRUE
       );
PORT(clk        : IN  STD_ULOGIC;
     aNRst      : IN  STD_LOGIC;
     shEn, ldEn : IN  STD_LOGIC;
     serialIn   : IN  STD_LOGIC;
     datIn      : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
     datOut     : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0);
     serialOut  : OUT STD_LOGIC
     );
END ENTITY shiftRegister;

ARCHITECTURE behavioral OF shiftRegister IS
    SIGNAL shReg : STD_LOGIC_VECTOR(length-1 DOWNTO 0);
BEGIN

    datOut <= shReg;

    PROCESS(clk, aNRst) IS
    BEGIN
        IF aNRst = '0' THEN
            shReg <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk) THEN
            IF ldEn = '1' THEN
                shReg <= datIn;
            ELSIF shEn = '1' THEN
                IF rightNotLeft THEN
                    shReg(length-1) <= serialIn;
                    shReg(length-2 DOWNTO 0) <= shReg(length-1 DOWNTO 1);
                ELSE
                    shReg(0) <= serialIn;
                    shReg(length-1 DOWNTO 1) <= shReg(length-2 DOWNTO 0);
                END IF;
            END IF;
        END IF;
    END PROCESS;

    sreialOutRight_gen : IF rightNotLeft GENERATE
        serialOut <= shReg(0);
    END GENERATE;

    sreialOutLeft_gen : IF NOT rightNotLeft GENERATE
        serialOut <= shReg(length-1);
    END GENERATE;

END ARCHITECTURE behavioral;
