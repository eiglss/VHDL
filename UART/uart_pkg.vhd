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

    FUNCTION getParity(data : IN STD_LOGIC_VECTOR; even : IN BOOLEAN) RETURN STD_LOGIC;
    FUNCTION sel(cond : BOOLEAN; ifTrue, ifFalse: INTEGER) RETURN INTEGER;
    FUNCTION to_stdLogicVector(i: STD_LOGIC) RETURN STD_LOGIC_VECTOR;

    -- uart component
    COMPONENT uart IS
        GENERIC(dataLength  : uartLength_t := 8;
                parity      : uartParity_t := N;
                stop        : uartStop_t := 1
               );
        PORT(clk        : IN  STD_ULOGIC;
             aNRst      : IN  STD_LOGIC;
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

    -- additional component
    COMPONENT txControler IS
        GENERIC(dataLength : uartLength_t := 8;
                parity     : uartParity_t := N;
                stop       : uartStop_t := 1
               );
        PORT(clk        : IN  STD_ULOGIC;
             aNRst      : IN  STD_LOGIC;
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
        PORT(clk        : IN  STD_ULOGIC;
             aNRst      : IN  STD_LOGIC;
             start      : IN  STD_LOGIC;
             tick       : IN  STD_LOGIC;
             count      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
             shEn       : OUT STD_LOGIC;
             rxBusy     : OUT STD_LOGIC;
             dataReady  : OUT STD_LOGIC
            );
    END COMPONENT;

    COMPONENT shiftRegister IS
        GENERIC(length          : POSITIVE := 8;
                rightNotLeft    : BOOLEAN := TRUE
               );
        PORT(clk, aNRst : IN  STD_LOGIC;
             shEn, ldEn : IN  STD_LOGIC;
             serialIn   : IN  STD_LOGIC;
             datIn      : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
             datOut     : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0);
             serialOut  : OUT STD_LOGIC
             );
    END COMPONENT;

    COMPONENT counter IS
        GENERIC(length  : POSITIVE := 8
               );
        PORT(clk                      : IN  STD_ULOGIC;
             aNRst                    : IN  STD_LOGIC;
             en, rst, incNotDec, load : IN  STD_LOGIC;
             dIn                      : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
             dOut                     : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0)
            );
    END COMPONENT;

END uart_pkg;

PACKAGE BODY uart_pkg IS

    FUNCTION getParity(data : IN STD_LOGIC_VECTOR; even : IN BOOLEAN) RETURN STD_LOGIC IS
        VARIABLE rtn : STD_LOGIC := '0';
    BEGIN
        FOR i IN data'RANGE LOOP
            rtn := rtn XOR data(i);
        END LOOP;
        IF even THEN
            RETURN rtn;
        ELSE
            RETURN NOt rtn;
        END IF;
    END FUNCTION;

    FUNCTION sel(cond : BOOLEAN; ifTrue, ifFalse: INTEGER) RETURN INTEGER IS
    BEGIN
        IF cond THEN
            RETURN(ifTrue);
        ELSE
            RETURN(ifFalse);
        END IF;
    END FUNCTION;

    FUNCTION to_stdlogicvector(i: STD_LOGIC) RETURN STD_LOGIC_VECTOR IS
        VARIABLE stdlv :STD_LOGIC_VECTOR(0 DOWNTO 0):= (0 => i);
    BEGIN
        RETURN stdlv;
    END;

END uart_pkg;
