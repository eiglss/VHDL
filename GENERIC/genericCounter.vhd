--******************************************************************************
--        @TITRE : genericCounter.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;
USE     IEEE.NUMERIC_STD.ALL;

ENTITY genericCounter IS
    GENERIC(length      : POSITIVE := 8
           );
    PORT(clk                      : IN  STD_ULOGIC;
         aNRst                    : IN  STD_LOGIC;
         en, rst, incNotDec, load : IN  STD_LOGIC;
         dIn                      : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
         dOut                     : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0)
        );
END genericCounter;

ARCHITECTURE Behavioral OF genericCounter IS
    SIGNAL countReg : UNSIGNED(length-1 DOWNTO 0);
BEGIN

    dOut <= STD_LOGIC_VECTOR(countReg);

    counter : PROCESS(clk, aNRst)
    BEGIN
        IF aNRst /= '1' THEN
            countReg <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk) THEN
            IF rst /= '0' THEN
                countReg <= (OTHERS => '0');
            ELSIF load = '1' THEN
                countReg <= UNSIGNED(din);
            ELSIF en = '1' THEN
                IF incNotDec = '1' THEN
                    countReg <= countReg+1;
                ELSIF incNotDec = '0' THEN
                    countReg <= countReg-1;
                END IF;
            END IF;
        END IF;
    END PROCESS counter;

END Behavioral;
