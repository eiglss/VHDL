--******************************************************************************
--        @TITRE : rxControler.vhd
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

LIBRARY WORK;
USE     WORK.uart_pkg.ALL;

ENTITY rxControler IS
    GENERIC(dataLength : uartLength_t := 8;
            parity     : uartParity_t := N;
            stop       : uartStop_t := 1
           );
    PORT(clk        : IN  STD_ULOGIC;
         aNRst      : IN  STD_LOGIC;
         start      : IN  STD_LOGIC;
         tick       : IN  STD_LOGIC;
         count      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
         shEn       : OUT STD_LOGIC;
         rxBusy     : OUT STD_LOGIC;
         dataReady  : OUT STD_LOGIC
        );
END ENTITY rxControler;

ARCHITECTURE mealy OF rxControler IS
    TYPE state_t IS (idle, receive);
    SIGNAL state : state_t;
BEGIN

Transition : PROCESS(clk, aNRst) IS
    BEGIN
        IF aNRst = '0' THEN
            state <= idle;
            dataReady <= '0';
        ELSIF RISING_EDGE(clk) THEN
            CASE state IS
            WHEN idle =>
                dataReady <= '0';
                IF start = '1' AND tick = '1' THEN
                    state <= receive;
                END IF;
            WHEN receive =>
                IF tick = '1' AND UNSIGNED(count) >= (dataLength+0+stop-1) AND parity = N THEN
                    state <= idle;
                    dataReady <= '1';
                ELSIF tick = '1' AND UNSIGNED(count) >= (dataLength+1+stop-1) AND parity /= N THEN
                    state <= idle;
                    dataReady <= '1';
                END IF;
            END CASE;
        END IF;
    END PROCESS Transition;

    shEn <= '1' WHEN state = receive AND tick = '1' ELSE
            '0';

    rxBusy <= '1' WHEN state = receive ELSE
              '0';

END ARCHITECTURE mealy;
