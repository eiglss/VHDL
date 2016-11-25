--******************************************************************************
--        @TITRE : uart.vhd
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
USE     WORK.generic_pkg.ALL;

ENTITY uart IS
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
END uart;

ARCHITECTURE Structural OF uart IS
 -- TX
    SIGNAL iCountTx : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL iTxShEn  : STD_LOGIC;
    SIGNAL iTxLdEn  : STD_LOGIC;
    SIGNAL iDataTx  : STD_LOGIC_VECTOR(sel(parity = N, 1+dataLength+stop, 1+dataLength+1+stop)-1 DOWNTO 0);
    SIGNAL iTx      : STD_LOGIC;
    SIGNAL iTxBusy  : STD_LOGIC;
 -- RX
    SIGNAL iRxStart     : STD_LOGIC;
    SIGNAL iRxBusy      : STD_LOGIC;
    SIGNAL iCountRx     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL iRxShEn      : STD_LOGIC;
    SIGNAL iRxDatOut    : STD_LOGIC_VECTOR(sel(parity = N, dataLength+stop, dataLength+1+stop)-1 DOWNTO 0);
    SIGNAL iRxDatReady  : STD_LOGIC;
BEGIN
 -- TX

    tx <= '1' WHEN iTxBusy = '0' OR aNRst = '0' ELSE
          iTx;
          
    txBusy <= iTxBusy;

    dataTxN1_gen : IF parity = N AND stop = 1 GENERATE
    BEGIN
        iDataTx <= "1"&datIN&"0";
    END GENERATE;
    
    dataTxN2_gen : IF parity = N AND stop = 2 GENERATE
    BEGIN
        iDataTx <= "11"&datIN&"0";
    END GENERATE;
    
    dataTxOE1_gen : IF NOT(parity = N) AND stop = 1 GENERATE
        iDataTx <= "1"&TO_STDLOGICVECTOR(getParity(datIn, parity = E))&datIN&"0";
    END GENERATE;
    
    dataTxOE2_gen : IF NOT(parity = N) AND stop = 2 GENERATE
        iDataTx <= "11"&TO_STDLOGICVECTOR(getParity(datIn, parity = E))&datIN&"0";
    END GENERATE;
 
    txControler_ci : txControler
        GENERIC MAP(dataLength => dataLength,
                    parity     => parity,
                    stop       => stop
                   )
        PORT MAP(clk        => clk,
                 aNRst      => aNRst,
                 datReady   => txDatReady,
                 tick       => tick,
                 count      => iCountTx,
                 shEn       => iTxShEn,
                 ldEn       => iTxLdEn,
                 txBusy     => iTxBusy
                );

    txCounter_ci : genericCounter
        GENERIC MAP(length  => 4
                   )
        PORT MAP(clk        => clk,
                 aNRst      => aNRst,
                 rst        => iTxLdEn,
                 en         => iTxShEn,
                 incNotDec  => '1',
                 load       => '0',
                 dIn        => (OTHERS => '0'),
                 dOut       => iCountTx
                );

    txShiftReg_ci : shiftRegister
        GENERIC MAP(length          => sel(parity = N, 1+dataLength+stop,1+dataLength+1+stop),
                    rightNotLeft    => TRUE
               )
        PORT MAP(clk        => clk,
                 aNRst      => aNRst,
                 shEn       => iTxShEn,
                 ldEn       => iTxLdEn,
                 serialIn   => '0',
                 datIn      => iDataTx,
                 datOut     => OPEN,
                 serialOut  => iTx
                );

 -- RX 

    iRxStart <= '1' WHEN rx = '0' AND iRxBusy = '0' ELSE
                '0';

    rxBusy <= iRxBusy;

    rxControler_ci : rxControler
        GENERIC MAP(dataLength => dataLength,
                    parity     => parity,
                    stop       => stop
                   )
        PORT MAP(clk        => clk,
                 aNRst      => aNRst,
                 start      => iRxStart,
                 tick       => tick,
                 count      => iCountRx,
                 shEn       => iRxShEn,
                 rxBusy     => iRxBusy,
                 dataReady  => iRxDatReady
                );

    rxCounter_ci : genericCounter
        GENERIC MAP(length  => 4
                   )
        PORT MAP(clk        => clk,
                 aNRst      => aNRst,
                 rst        => iRxStart,
                 en         => iRxShEn,
                 incNotDec  => '1',
                 load       => '0',
                 dIn        => (OTHERS => '0'),
                 dOut       => iCountRx
                );
 
    rxShiftReg_ci : shiftRegister
        GENERIC MAP(length          => sel(parity = N, dataLength+stop,dataLength+1+stop),
                    rightNotLeft    => TRUE
               )
        PORT MAP(clk        => clk,
                 aNRst      => aNRst,
                 shEn       => iRxShEn,
                 ldEn       => iRxStart,
                 serialIn   => rx,
                 datIn      => (OTHERS => '0'),
                 datOut     => iRxDatOut,
                 serialOut  => open
                );

    datOut <= iRxDatOut(dataLength-1 DOWNTO 0);
    
    datReadyRxN1_gen : IF parity = N AND stop = 1 GENERATE
    BEGIN
        rxDatReady <= iRxDatReady WHEN iRxDatOut(dataLength) = '1' ELSE
                      '0';
    END GENERATE;
    
    datReadyExN2_gen : IF parity = N AND stop = 2 GENERATE
    BEGIN
        rxDatReady <= iRxDatReady WHEN iRxDatOut(dataLength+1 DOWNTO dataLength) = "11" ELSE
                      '0';
    END GENERATE;
    
    datReadyRxOE1_gen : IF NOT(parity = N) AND stop = 1 GENERATE
        rxDatReady <= iRxDatReady WHEN iRxDatOut(dataLength+1) = '1' AND iRxDatOut(dataLength DOWNTO dataLength) = TO_STDLOGICVECTOR(getParity(datIn, parity = E)) ELSE
                      '0';
    END GENERATE;
    
    datReadyRxOE2_gen : IF NOT(parity = N) AND stop = 2 GENERATE
        rxDatReady <= iRxDatReady WHEN iRxDatOut(dataLength+1 DOWNTO dataLength) = "11" AND iRxDatOut(dataLength DOWNTO dataLength) = TO_STDLOGICVECTOR(getParity(datIn, parity = E)) ELSE
                      '0';
    END GENERATE;

END Structural;

