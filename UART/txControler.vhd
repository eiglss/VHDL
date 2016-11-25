--******************************************************************************
--        @TITRE : txControler.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

LIBRARY WORK;
USE     WORK.uart_pkg.ALL;

ENTITY txControler IS
GENERIC(dataLength : uartLength_t := 8;
        parity     : uartParity_t := N;
        stop       : uartStop_t := 1
       );
PORT(clk, aNRst : IN  STD_LOGIC;
     datReady   : IN  STD_LOGIC;
     tick       : IN  STD_LOGIC;
     count      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
     shEn       : OUT STD_LOGIC;
     ldEn       : OUT STD_LOGIC;
     txBusy     : OUT STD_LOGIC
    );
END ENTITY txControler;

ARCHITECTURE mealy OF txControler IS
    TYPE state_t IS (idle, send);
    SIGNAL state : state_t;
BEGIN

    Transition : PROCESS(clk, aNRst) IS
    BEGIN
        IF aNRst = '0' THEN
            state <= idle;
        ELSIF RISING_EDGE(clk) THEN
            CASE state IS
            WHEN idle =>
                IF datReady = '1' THEN
                    state <= send;
                END IF;
            WHEN send =>
                IF tick = '1' AND UNSIGNED(count) >= (dataLength+0+stop) AND parity = N THEN
                    state <= idle;
                ELSIF tick = '1' AND UNSIGNED(count) >= (dataLength+1+stop) AND parity /= N THEN
                    state <= idle;
                END IF;
            END CASE;
        END IF;
    END PROCESS Transition;

    shEn <= '1' WHEN state = send AND tick = '1' ELSE
            '0';

    ldEn <= '1' WHEN state = idle AND datReady = '1' ELSE
            '0';

    txBusy <= '1' WHEN state = send ELSE
              '0';

END ARCHITECTURE mealy;

