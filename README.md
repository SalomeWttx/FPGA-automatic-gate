# FPGA-automatic-gate

This projects contains VHDL code to control a gate using an FPGA.

## Getting Started

To use this project in the real life, you have to implement it on an FPGA. To do this, you'll have to generate a bitstream. For Xilinx's FPGAs, it's safe to use Vivado.
The constraints file provided in this project is made for the Basys3 board and its XC7A35T-1CPG236C Artix-7 FPGA.

This project includes the management of a 16-digit digicode, obstacle detection, and all the code needed to control the gate in a intuitive way.

A description of each part of the project is given at the beginning of every file.

### Prerequisites

To make a working portal, you'll need a FPGA, and all physical components connected to the FPGA (motor, H-bridge, 16-digit keyboard...)

## Running the tests

We made simulation files for most entities of the project. Test benches are file that end with "_tb.vhd".

## Authors

* **Alban Benmouffek** - *VHDL code, schematics* - [sonibla](https://github.com/sonibla)
* **Marco Guzzon** - *PCB, schematics, design of analog circuits*
* **Alban Benmouffek** - *Documentation, obstacle detection*

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

