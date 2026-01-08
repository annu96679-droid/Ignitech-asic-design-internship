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


# Program Counter

**Role in CPU**

The Program Counter stores the address of the next instruction to execute.

It supports:

* Sequential instruction execution (PC + 1)

* Jump / branch instructions (load address)

* Reset start at instruction 0

**Signals:**

| Signal       | Type   | Meaning              |
| ------------ | ------ | -------------------- |
| clk          | input  | Synchronizes updates |
| rst          | input  | Resets PC to 0       |
| pc_enable    | input  | Allows PC to update  |
| pc_load      | input  | Enables jump         |
| jump_address | input  | Target jump address  |
| pc_out       | output | Current PC value     |

**Behavior**

* If reset = 1 → PC resets to 0

* If pc_enable = 1 and pc_load = 0 → PC increments

* If pc_enable = 1 and pc_load = 1 → load jump_address


## Module

```bash
module program_counter(
    input wire clk,
    input wire rst,
    input wire pc_enable,
    input wire pc_load,
    input wire [7:0] jump_address,
    output reg [7:0] pc_out  // Fixed: Changed from pc_out to [7:0] pc_out
);
    
    always @(posedge clk or posedge rst)
    begin
        if (rst) begin
            pc_out <= 8'b0;
        end else if (pc_enable) begin
            if (pc_load) begin
                pc_out <= jump_address;
            end else begin
                pc_out <= pc_out + 1;
            end
        end
    end
endmodule

```

**Program Counter (PC) Module – Working Explanation**

The Program Counter (PC) is a sequential logic block responsible for holding the address of the current instruction being executed by the processor. It controls the flow of instruction execution.

**Input**

* clk – System clock; PC updates occur on the rising edge.

* rst – Asynchronous reset; resets the PC to 0.

* pc_enable – Enables PC update when asserted.

* pc_load – Selects jump operation when asserted.

* jump_address [7:0] – Target address for jump instructions.

**Output**

* pc_out [7:0] – Current program counter value (instruction address).

**Functional Behavior**

* On reset (rst = 1), the PC is cleared to 0.

When pc_enable = 1:

* If pc_load = 1, the PC loads the value from jump_address (used for jump/branch instructions).

* If pc_load = 0, the PC increments by 1, moving to the next instruction.

## Schematic (without synthesis)

<img width="1483" height="532" alt="image" src="https://github.com/user-attachments/assets/75159bd1-81e0-4ba4-a6b9-29e46de8e72d" />
