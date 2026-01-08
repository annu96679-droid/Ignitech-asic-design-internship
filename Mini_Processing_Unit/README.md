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

## Schematic 

**Before Synthesis**

<img width="1483" height="532" alt="image" src="https://github.com/user-attachments/assets/75159bd1-81e0-4ba4-a6b9-29e46de8e72d" />

**After Synthesis**

<img width="1565" height="318" alt="image" src="https://github.com/user-attachments/assets/681a2f70-bea4-4bac-b086-46b5351b9b5b" />

# Instruction memory

**Instruction Memory Module – Detailed Explanation**

* The Instruction Memory stores the program executed by the Mini Processing Unit (MPU).

* It is a read-only memory (ROM) that outputs a 16-bit instruction based on the address provided by the Program Counter (PC).

**Module Interface**

**Inputs**

* address [7:0]
* The memory address supplied by the Program Counter.
* Since it is 8-bit wide, the instruction memory can store 256 instructions.

**Outputs**

* instruction [15:0]
* The 16-bit instruction fetched from memory at the given address.

**Internal Architecture**

* The instruction memory is implemented as a 256 × 16-bit register array:

* reg [15:0] mem [0:255];


* Each memory location stores one complete instruction.

* The memory is pre-initialized using an initial block, making it suitable for simulation and synthesis as ROM.

**Instruction Encoding Format**

The MPU supports multiple instruction formats:

* R-Type (Register Type)

   * [ opcode(4) | rd(2) | rs1(2) | rs2(2) | unused(6) ]


* Used for arithmetic and logical operations like ADD, SUB, AND, OR, etc.

* I-Type (Immediate Type)
    * [ opcode(4) | rd(2) | rs1(2) | immediate(8) ]


* Used for immediate operations such as LDI (Load Immediate).

* J-Type (Jump Type)
    * [ opcode(4) | unused(4) | jump_address(8) ]


* Used for control-flow instructions like JUMP.

**Program Stored in Instruction Memory**

The memory is initialized with a test program that demonstrates all major MPU features:

* Immediate Load

* Loads constants into registers (R0, R1, R2).

* Arithmetic Operations

* ADD, SUB, ADC, INC, DEC, MUL.

* Logical Operations

* AND, OR, XOR, NOT.

* Shift and Rotate

* SHL, SHR, ROL, ROR.

* Comparison

* CMP instruction updates flags without writing results.

* Control Flow

* Jump instruction redirects execution.

* NOP Instructions

* Remaining memory locations are filled with NOPs to ensure safe execution.

**Example:**

* mem[0] = {4'b0110, 2'b00, 2'b00, 8'h0A}; // LDI R0, 10
* mem[3] = {4'b0000, 2'b11, 2'b00, 2'b01, 6'b000000}; // ADD R3, R0, R1

**Instruction Fetch Operation**

Instruction fetch is asynchronous:

always @(*) begin
    instruction = mem[address];
end


* Whenever the Program Counter changes, the corresponding instruction is immediately available at the output.

* No clock is required for read operations, enabling fast instruction fetch.

**Key Characteristics**

* 256-instruction program space

* 16-bit wide instruction word

* ROM-style implementation

* Supports arithmetic, logical, shift, and control-flow instructions

* Designed to integrate seamlessly with the Program Counter and Control Unit

**Role in the MPU**

* The Instruction Memory forms the Instruction Fetch stage of the processor pipeline.

* It supplies decoded instructions to the Instruction Register, enabling execution by the Control Unit and ALU.
