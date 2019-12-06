# FPGA-automatic-gate

This projects contains VHDL code to control a gate using an FPGA.

## Getting Started

To use this project in the real life, you have to implement it on an FPGA. To do this, you'll have to generate a bitstream. For Xilinx's FPGAs, it's safe to use [Vivado](https://www.xilinx.com/products/design-tools/vivado.html).
The constraints file provided in this project is made for the *Basys3* board and its XC7A35T-1CPG236C Artix-7 FPGA.

This project includes the management of a 16-digit digicode, obstacle detection, and all the code needed to control the gate in a intuitive way.

A description of each part of the project is given at the beginning of every file. It's written in French. There's no English translation available so far
The main file is [Portail.vhd](portail.srcs/sources_1/Portail.vhd).

### Prerequisites

To make a working portal, you'll need a FPGA, and all physical components connected to the FPGA (motor, H-bridge, 16-digit keyboard...)

Attention : the FPGA's clock must be 100Mhz !

## Running the tests

We made simulation files for most entities of the project. Test benches are file that end with "_tb.vhd".

## Authors

* [**Alban Benmouffek**](https://github.com/sonibla) - *VHDL code, schematics*
* **Marco Guzzon** - *PCB, schematics, design of analog circuits*
* **Salomé Wattiaux** - *Documentation, obstacle detection*

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

