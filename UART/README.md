## Synopsis

This "UART" repository contain the VHDL source code of a functional Universal Asynchronous Receiver Transmitter.

## Version 0.0.1
###Generic parameters:
- "dataLength" it allows to choose the length of your data that you want to receive/transmit by connecting this parameter to an integer between 5 to 9.
- "parity" correspond to the parity of the data. The possibles values are "N" (None), "E" (Even) and "O" (Odd).
- "stop" correspond to the number of stop bits. This value must be an integer between 1 and 2. (the 1.5 value is not yet implemented).

###Port parameters:
- "clk" correspond to the clock of your system
- "aNRst" for "Asynchronous Not Reset" is an asynchronous reset that is inactive at '1'.
- "tick" is the clock of the uart, when it's equal to '1' and there is a rising edge on the "clk" a new bit is read or write if a transmission is  engaged.

#### Transmitter (Tx)
- "txDatReady" must be set at '1' when a data is ready to be send. And set to '0' before the end of the transmission otherwise a new transmission begin.
- "datIn" is the data that will transmit via the uart. only the data present when the "txDatReady" flag is set to '1' and at least a rising edge of the "clk" is taken into account, will be send. Any modification of this value after this rising edge will not be send during the transmission.
- "txBusy" is set to '1' when a transmission is in progress, else it's set to '0'.
- "tx" is the tx line of the uart.

#### Receiver (Rx)
- "rxDatReady" is set to '1' during a single clock cycle of "clk" when a data has been received and is available on "datOut".
- "datOut" is the data that has been receive via the uart.
- "rxBusy" is set to '1' when a reception is in progress, else it's set to '0'.
- "rx" is the rx line of the uart.

## License

This repository is under MIT license.

Copyright (c) 2016 Enzo IGLESIS
