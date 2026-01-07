# Mini Processing Unit (MPU) – Verilog Based Custom Micro-Architecture

This project implements a fully-functional Mini Processing Unit (MPU) designed using Verilog HDL. 

The MPU follows a modular micro-architecture inspired by basic RISC processors and consists of independent, reusable RTL blocks:

 * The Program Counter,
 * Instruction Memory,
 * Instruction Register,
 * Register File, ALU,
 * Control Unit (FSM),
 * Data Memory.

The design supports arithmetic operations, logical operations, shift/rotate functions, branching, comparison, immediate execution, and state-based control sequencing. It is suitable for learning Digital Design, RTL Architecture, Computer Organization, and Backend VLSI Physical Design flows (RTL → GDS).


## Project Objectives

* Design a synthesizable Mini CPU-like Processing Unit in Verilog

* Implement instruction fetch–decode–execute sequencing via FSM

* Develop modular RTL blocks mapped to real processor components

* Execute arithmetic, logic, shift, comparison and control-flow instructions

* Provide an extendable architecture for FPGA / ASIC / PD workflows

* Enable waveform-based functional verification


