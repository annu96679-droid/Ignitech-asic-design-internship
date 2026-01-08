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

## Module

```bash
module instruction_memory (
    input wire [7:0] address,
    output reg [15:0] instruction
);

    // 256x16 Instruction Memory with extended instruction set
   (* keep = "true" *) 
    reg [15:0] mem [0:255];
    
    integer i;
    
    initial
    begin
       
        // Format variations:
        // R-type: [opcode(4)][rd(2)][rs1(2)][rs2(2)][xxx(6)]
        // I-type: [opcode(4)][rd(2)][rs1(2)][imm(8)]
        // J-type: [opcode(4)][xxx(4)][address(8)]
        
        // Test Program: Demonstrates all ALU operations
        mem[0] = {4'b0110, 2'b00, 2'b00, 8'h0A};   // LDI R0, 0x0A (10)
        mem[1] = {4'b0110, 2'b01, 2'b00, 8'h05};   // LDI R1, 0x05 (5)
        mem[2] = {4'b0110, 2'b10, 2'b00, 8'h03};   // LDI R2, 0x03 (3)
        
        // Arithmetic Operations
        mem[3] = {4'b0000, 2'b11, 2'b00, 2'b01, 6'b000000};  // ADD R3, R0, R1 (10 + 5 = 15)
        mem[4] = {4'b0001, 2'b11, 2'b00, 2'b01, 6'b000000};  // SUB R3, R0, R1 (10 - 5 = 5)
        mem[5] = {4'b0010, 2'b11, 2'b00, 2'b01, 6'b000000};  // ADC R3, R0, R1 (with carry)
        mem[6] = {4'b0011, 2'b00, 2'b00, 8'b00000000};       // INC R0 (R0 = 11)
        mem[7] = {4'b0100, 2'b01, 2'b00, 8'b00000000};       // DEC R1 (R1 = 4)
        mem[8] = {4'b0101, 2'b11, 2'b00, 2'b10, 6'b000000};  // MUL R3, R0, R2 (11 * 3 = 33)
        
        // Compare Operation
        mem[9] = {4'b0110, 2'b00, 2'b00, 2'b01, 6'b000000};  // CMP R0, R1 (set flags)
        
        // Move Operation
        mem[10] = {4'b0111, 2'b11, 2'b01, 8'b00000000};      // MOV R3, R1 (copy R1 to R3)
        
        // Logical Operations
        mem[11] = {4'b1000, 2'b11, 2'b00, 2'b01, 6'b000000}; // AND R3, R0, R1
        mem[12] = {4'b1001, 2'b11, 2'b00, 2'b01, 6'b000000}; // OR R3, R0, R1
        mem[13] = {4'b1010, 2'b11, 2'b00, 2'b01, 6'b000000}; // XOR R3, R0, R1
        mem[14] = {4'b1011, 2'b00, 2'b00, 8'b00000000};      // NOT R0
        
        // Shift Operations
        mem[15] = {4'b1100, 2'b00, 2'b00, 8'b00000000};      // SHL R0 (R0 << 1)
        mem[16] = {4'b1101, 2'b01, 2'b00, 8'b00000000};      // SHR R1 (R1 >> 1)
        mem[17] = {4'b1110, 2'b10, 2'b00, 8'b00000000};      // ROL R2
        mem[18] = {4'b1111, 2'b11, 2'b00, 8'b00000000};      // ROR R3
        
        // Control Flow
        mem[19] = 16'hB000;                // JUMP to address 0
       
        // mem[20] would be JZ if zero flag is set
        
        // Fill rest with NOPs (opcode 1111 with no write)
        for (i = 20; i < 256; i = i + 1) begin
            mem[i] = 16'hB000; // NOP instruction
        end
    end
    
    always @(*) begin
        instruction = mem[address];
    end

endmodule
```

## Synthesis

**Before Synthesis**
<img width="1207" height="367" alt="image" src="https://github.com/user-attachments/assets/3e2f4d77-6df4-40a8-b5c4-baa703e78c0c" />

**After Synthesis**

<img width="707" height="725" alt="image" src="https://github.com/user-attachments/assets/091a492c-28f0-4d9c-ab0e-de2f32d5e195" />

## Instruction Register


### Theory: Instruction Register in a Mini Processing Unit

In a **Mini Processing Unit (MPU)**, instructions are fetched from the Instruction Memory using the Program Counter.  
However, memory outputs can change every clock cycle as the PC increments.

To ensure **stable execution**, the fetched instruction must be **latched and held constant** while it is decoded and executed.

This is the purpose of the **Instruction Register (IR)**.

---

### Why an Instruction Register is Required

Without an Instruction Register:
- Instruction memory output may change during execution
- Control signals may become unstable
- Incorrect operations may occur

With an Instruction Register:
- Instructions are **captured once**
- Decoding and execution happen reliably
- Multi-cycle CPU operation becomes possible

---

###  Role of Instruction Register in MPU Pipeline


The Instruction Register acts as a **pipeline latch** between:
- **Fetch Stage**
- **Decode & Execute Stages**

---

## Working of Instruction Register

The Instruction Register operates in **three conditions**:

### Reset Condition
- Clears the stored instruction
- Prevents execution of invalid data after reset

### Load Condition
- Loads a new instruction from Instruction Memory
- Happens only during the FETCH stage

### Hold Condition
- Retains the same instruction
- Allows proper decode and execution

---

### Module Interface

| Signal | Width | Description |
|------|------|-------------|
| `clk` | 1-bit | System clock |
| `rst` | 1-bit | Asynchronous reset |
| `ir_load` | 1-bit | Instruction load enable |
| `instruction_in` | 16-bit | Instruction from memory |
| `instruction_out` | 16-bit | Stored instruction |

---
### Instruction Field Decoding

| Field Name           | Bit Range | Description                |
| -------------------- | --------- | -------------------------- |
| Opcode               | [15:12]   | Specifies instruction type |
| Destination Register | [11:10]   | Target register            |
| Source Register 1    | [9:8]     | First operand              |
| Source Register 2    | [7:6]     | Second operand             |
| Immediate            | [7:0]     | Immediate data             |
| Jump Offset          | [7:0]     | Jump address               |

## Module

```bash
module instruction_register(
input wire clk,
input wire rst,
input ir_load,      //enable
input wire [15:0] instruction_in,
output reg [15:0] instruction_out
);

always @(posedge clk or posedge rst)
begin
if (rst)
begin
instruction_out <= 16'b0;
end
else if (ir_load)
begin
instruction_out <= instruction_in;
end
end

 wire [3:0] opcode = instruction_out[15:12];
 wire [1:0] reg_dest = instruction_out[11:10];
 wire [1:0] reg_src1 = instruction_out[9:8];
 wire [1:0] reg_src2 = instruction_out[7:6];
 wire [7:0] immediate = instruction_out[7:0];
 wire [7:0] jump_offset = instruction_out[7:0];

endmodule

```
## Schematic

**Before Synthesis**

<img width="1248" height="433" alt="image" src="https://github.com/user-attachments/assets/4fa4e65d-3bb7-4722-9cfc-843724f6120e" />

**After Synthesis**

<img width="445" height="722" alt="image" src="https://github.com/user-attachments/assets/6b075d26-88d8-47b6-aaa1-630b3272e917" />

## Register File


### Role of Register File in Mini Processing Unit (MPU)

The **Register File** is a high-speed storage block inside the Mini Processing Unit that holds **temporary data operands and results** required during instruction execution.

In this MPU design, the Register File consists of **four 8-bit general-purpose registers (R0–R3)**.  
It supports:
- **Two simultaneous read operations**
- **One synchronous write operation**

This structure enables efficient execution of arithmetic, logical, and data movement instructions.

---

### Register File Architecture

- Number of registers: **4**
- Width of each register: **8 bits**
- Address width: **2 bits**
- Read ports: **2 (asynchronous)**
- Write ports: **1 (synchronous)**


---

### Working of Register File

**Reset Operation**
- When `rst = 1`, all registers are initialized with predefined values.
- Ensures a known startup state for simulation and execution.

```verilog
R0 = 8'h0A
R1 = 8'h05
R2 = 8'h03
R3 = 8'h00

**Write Operation (Synchronous)**

* Write occurs only on the rising edge of the clock

* Enabled when reg_write_en = 1

* Data is written to the register selected by reg_write_addr

* registers[reg_write_addr] <= reg_write_data;

* Controlled by the Control Unit during the WRITE-BACK stage.

**Read Operation (Asynchronous)**

* Two registers can be read simultaneously

* Read data updates immediately when read address changes

```bash
reg_read_data1 = registers[reg_read_addr1];
reg_read_data2 = registers[reg_read_addr2];
```
### Inputs Signal

| Signal           | Width | Description                  |
| ---------------- | ----- | ---------------------------- |
| `clk`            | 1-bit | System clock                 |
| `rst`            | 1-bit | Asynchronous reset           |
| `reg_write_en`   | 1-bit | Enables write operation      |
| `reg_write_addr` | 2-bit | Destination register address |
| `reg_read_addr1` | 2-bit | Source register 1            |
| `reg_read_addr2` | 2-bit | Source register 2            |
| `reg_write_data` | 8-bit | Data to be written           |

### Output Signal

| Signal           | Width | Description                 |
| ---------------- | ----- | --------------------------- |
| `reg_read_data1` | 8-bit | Data from source register 1 |
| `reg_read_data2` | 8-bit | Data from source register 2 |
| `reg0_out`       | 8-bit | Content of register R0      |
| `reg1_out`       | 8-bit | Content of register R1      |
| `reg2_out`       | 8-bit | Content of register R2      |
| `reg3_out`       | 8-bit | Content of register R3      |

## Module

```bash
module register_file (
    input  wire       clk,
    input  wire       rst,
    input  wire       reg_write_en,
    input  wire [1:0] reg_write_addr,
    input  wire [1:0] reg_read_addr1,
    input  wire [1:0] reg_read_addr2,
    input  wire [7:0] reg_write_data,
    output reg  [7:0] reg_read_data1,
    output reg  [7:0] reg_read_data2,
    output wire [7:0] reg0_out,
    output wire [7:0] reg1_out,
    output wire [7:0] reg2_out,
    output wire [7:0] reg3_out
);

    // 4 general-purpose registers
    reg [7:0] registers [0:3];

    // -------- SINGLE always-block (reset + write) --------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            registers[0] <= 8'h0A;
            registers[1] <= 8'h05;
            registers[2] <= 8'h03;
            registers[3] <= 8'h00;
        end 
        else if (reg_write_en) begin
            registers[reg_write_addr] <= reg_write_data;
        end
    end

    // -------- Asynchronous reads --------
    always @(*) begin
        reg_read_data1 = registers[reg_read_addr1];
        reg_read_data2 = registers[reg_read_addr2];
    end

    // -------- Safe outputs for monitoring --------
    assign reg0_out = registers[0];
    assign reg1_out = registers[1];
    assign reg2_out = registers[2];
    assign reg3_out = registers[3];

endmodule
```
## Schematic

**Before Synthesis**

<img width="1512" height="726" alt="image" src="https://github.com/user-attachments/assets/252fa6a5-e0b8-489a-8e5f-ce17983cbd2a" />

**After Synthesis**

<img width="496" height="730" alt="image" src="https://github.com/user-attachments/assets/5f4bd362-35a8-4bd3-b4c8-9687ce077632" />


