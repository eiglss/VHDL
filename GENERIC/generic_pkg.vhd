--******************************************************************************
--        @TITRE : generic_pkg.vhd
--      @VERSION : 0
--     @CREATION : october, 2016
-- @MODIFICATION :
--      @AUTEURS : Enzo IGLESIS
--    @COPYRIGHT : Copyright (c) 2016 Enzo IGLESIS
--      @LICENSE : MIT License (MIT)
--******************************************************************************

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE generic_pkg IS

    FUNCTION bitSize(n : NATURAL) RETURN NATURAL;

    FUNCTION getParity(data : IN STD_LOGIC_VECTOR; even : IN BOOLEAN) RETURN STD_LOGIC;

    FUNCTION sel(cond : BOOLEAN; ifTrue, ifFalse: INTEGER) RETURN INTEGER;

    FUNCTION TO_STDLOGICVECTOR(i: STD_LOGIC) RETURN STD_LOGIC_VECTOR;

    COMPONENT dFlipFlop IS
        GENERIC( length : POSITIVE := 8
               );
        PORT( clk       : IN  STD_ULOGIC;
              aNRst     : IN  STD_LOGIC;
              en, rst   : IN  STD_LOGIC;
              d         : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
              q         : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT genericCounter IS
        GENERIC( length : POSITIVE := 8
               );
        PORT( clk                      : IN  STD_ULOGIC;
              aNRst                    : IN  STD_LOGIC;
              en, rst, incNotDec, load : IN  STD_LOGIC;
              dIn                      : IN  STD_LOGIC_VECTOR(length-1 DOWNTO 0);
              dOut                     : OUT STD_LOGIC_VECTOR(length-1 DOWNTO 0)
            );
    END COMPONENT;

    COMPONENT shiftRegister IS
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
    END COMPONENT;

    COMPONENT prescaler IS
        GENERIC(max : POSITIVE := 100_000_000
               );
        PORT( clk    : IN  STD_ULOGIC;
              aNRst  : IN  STD_LOGIC;
              rst    : IN  STD_LOGIC;
              val    : IN  INTEGER RANGE 0 TO max;
              tick   : OUT STD_LOGIC
             );
    END COMPONENT;

END generic_pkg;

PACKAGE BODY generic_pkg IS

    FUNCTION bitSize(n : NATURAL) RETURN NATURAL IS
        VARIABLE temp    : NATURAL := n;
        VARIABLE ret_val : NATURAL := 0;
    BEGIN
        WHILE temp >= 1 LOOP
            ret_val := ret_val + 1;
            temp    := temp / 2;
        END LOOP;
        IF ret_val = 0 THEN
            ret_val := 1;
        END IF;
        RETURN ret_val;
    END FUNCTION;

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
    END FUNCTION sel;

    FUNCTION to_stdlogicvector(i: STD_LOGIC) RETURN STD_LOGIC_VECTOR IS
        VARIABLE stdlv :STD_LOGIC_VECTOR(0 DOWNTO 0):= (0 => i);
    BEGIN
        RETURN stdlv;
    END;

END generic_pkg;
