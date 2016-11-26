--******************************************************************************
--        @TITRE : prescaler.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE     IEEE.STD_LOGIC_1164.ALL;

ENTITY prescaler IS
    GENERIC(max : POSITIVE := 100_000_000
           );
    PORT( clk    : IN  STD_ULOGIC;
          aNRst  : IN  STD_LOGIC;
          rst    : IN  STD_LOGIC;
          val    : IN  INTEGER RANGE 0 TO max;
          tick   : OUT STD_LOGIC
         );
END prescaler;

ARCHITECTURE Behavioral OF prescaler IS
    SIGNAL prescalReg : INTEGER RANGE 0 TO max;
BEGIN

    tick <= '1' WHEN prescalReg = 0 ELSE
            '0';

    PROCESS(clk, aNRst, val)
    BEGIN
        IF aNRst /= '1' THEN
            prescalReg <= val;
        ELSIF RISING_EDGE(clk) THEN
            IF rst /= '0' THEN
                prescalReg <= val;
            ELSE
                prescalReg <= prescalReg-1;
                IF prescalReg = 0 THEN
                    prescalReg <= val;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;
