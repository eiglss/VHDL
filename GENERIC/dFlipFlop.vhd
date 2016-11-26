--******************************************************************************
--        @TITRE : dFlipFlop.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;

ENTITY dFlipFlop IS
    GENERIC( length : POSITIVE := 8
           );
    PORT( clk       : IN  STD_ULOGIC;
          aNRst     : IN  STD_LOGIC;
          en, rst   : IN  STD_LOGIC;
          d         : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
          q         : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0)
        );
END dFlipFlop;

ARCHITECTURE Behavioral OF dFlipFlop IS
BEGIN

    PROCESS(aNRst, clk)
    BEGIN
        IF aNRst /= '1' THEN
            q <= (OTHERS => '0');
        ELSIF RISING_EDGE(clk) THEN
            IF rst /= '0' THEN
                q <= (OTHERS => '0');
            ELSIF en = '1' THEN
                q <= d;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
