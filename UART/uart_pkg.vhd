--******************************************************************************
--        @TITRE : uart_pkg.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE uart_pkg IS

-- UART
    SUBTYPE uartLength_t IS INTEGER RANGE 5 TO 9;
    TYPE uartParity_t IS (N, E, O);
    SUBTYPE uartStop_t IS INTEGER RANGE 1 TO 2;

    COMPONENT uart IS
        GENERIC(dataLength  : uartLength_t := 8;
                parity      : uartParity_t := N;
                stop        : uartStop_t := 1
               );
        PORT(clk, aNRst : IN  STD_LOGIC;
             tick       : IN  STD_LOGIC;
             -- tx
             txDatReady : IN  STD_LOGIC;
             datIn      : IN  STD_LOGIC_VECTOR(dataLength-1 DOWNTO 0);
             txBusy     : OUT STD_LOGIC;
             tx         : OUT STD_LOGIC;
             -- rx
             rx         : IN  STD_LOGIC;
             rxDatReady : OUT STD_LOGIC;
             rxBusy     : OUT STD_LOGIC;
             datOut     : OUT STD_LOGIC_VECTOR(dataLength-1 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT txControler IS
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
        END COMPONENT;

    COMPONENT rxControler IS
        GENERIC(dataLength : uartLength_t := 8;
                parity     : uartParity_t := N;
                stop       : uartStop_t := 1
               );
        PORT(clk, aNRst : IN  STD_LOGIC;
             start      : IN  STD_LOGIC;
             tick       : IN  STD_LOGIC;
             count      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
             shEn       : OUT STD_LOGIC;
             rxBusy     : OUT STD_LOGIC;
             dataReady  : OUT STD_LOGIC
            );
        END COMPONENT;

END uart_pkg;
