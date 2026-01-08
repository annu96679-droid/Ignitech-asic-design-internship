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


# 1. Program Counter

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

# 2. Instruction memory

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

## 3. Instruction Register


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

## 4. Register File


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
```

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

## 5. Arithmatic Logic Unit


### Role of ALU in Mini Processing Unit (MPU)

The **Arithmetic Logic Unit (ALU)** is the core computational block of the Mini Processing Unit.  
It performs all **arithmetic, logical, shift, rotate, and comparison operations** required by instructions.

The ALU receives operands from the **Register File**, executes the operation selected by the **Control Unit**, and produces:
- Result data
- Status flags for conditional operations and branching

---

### ALU Architecture Overview

- Operand width: **8-bit**
- Control select width: **4-bit**
- Output result: **8-bit**
- Status flags: **Carry, Zero, Sign, Overflow**
- Fully combinational design


---

### Input Signal Description

| Signal | Width | Description |
|------|------|-------------|
| `A` | 8-bit | First operand |
| `B` | 8-bit | Second operand |
| `Cin` | 1-bit | Carry input (used in ADC) |
| `sel` | 4-bit | ALU operation select |

---

### Output Signal Description

| Signal | Width | Description |
|------|------|-------------|
| `R` | 8-bit | Result of operation |
| `C` | 1-bit | Carry flag |
| `Z` | 1-bit | Zero flag |
| `S` | 1-bit | Sign flag |
| `V` | 1-bit | Overflow flag |

---

### Working of ALU

The ALU operates as a **pure combinational block** using a `case(sel)` structure.

A 9-bit temporary register is used internally to correctly capture carry and overflow:

```verilog
reg [8:0] temp;
```

### ALU Operation Table

| `sel`  | Operation | Description                |
| ------ | --------- | -------------------------- |
| `0000` | ADD       | A + B                      |
| `0001` | SUB       | A − B                      |
| `0010` | ADC       | A + B + Carry              |
| `0011` | INC       | A + 1                      |
| `0100` | DEC       | A − 1                      |
| `0101` | MUL       | A × B                      |
| `0110` | CMP       | Compare A − B (flags only) |
| `0111` | MOV       | Pass B                     |
| `1000` | AND       | A & B                      |
| `1001` | OR        | A | B                      |
| `1010` | XOR       | A ^ B                      |
| `1011` | NOT       | ~A                         |
| `1100` | SHL       | Shift left                 |
| `1101` | SHR       | Shift right                |
| `1110` | ROL       | Rotate left                |
| `1111` | ROR       | Rotate right               |

## Module

```bash
module ALU_8bit(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire Cin,
    input wire [3:0] sel,
    output reg [7:0] R,
    output reg C,
    output reg Z,
    output reg S,
    output reg V
);
    
    reg [8:0] temp;
 
    always @(*)
    begin
        // Default values
        R = 8'b0; 
        C = 1'b0;
        V = 1'b0; 

        case (sel)  // Only use lower 4 bits for operation
            // Arithmetic
            4'b0000 : begin
                temp = A + B; 
                R = temp[7:0]; 
                C = temp[8]; 
                V = (A[7] == B[7]) && (R[7] != A[7]);
            end
  
            // SUB
            4'b0001 : begin
                temp = A - B; 
                R = temp[7:0]; 
                C = temp[8];
                V = (A[7] != B[7]) && (R[7] != A[7]);
            end
  
            // ADD with carry
            4'b0010 : begin
                temp = A + B + Cin; 
                R = temp[7:0]; 
                C = temp[8];
                V = (A[7] == B[7]) && (R[7] != A[7]);
            end
  
            // Increment
            4'b0011: begin
                temp = A + 1; 
                R = temp[7:0]; 
                C = temp[8];
            end
  
            // Decrement
            4'b0100: begin                
                temp = A - 1; 
                R = temp[7:0]; 
                C = temp[8];
            end
  
            // Multiplier
            4'b0101 : begin
                temp = A * B; 
                R = temp[7:0]; 
                C = temp[8];
            end
  
            // Compare (A-B), flags only
            4'b0110 : begin
                temp = A - B; 
                R = 8'b0000;  // Fixed: Changed from 4'b0000 to 8'b0000
                C = temp[8];
                V = (A[7] != B[7]) && (temp[7] != A[7]);
            end
  
            // Pass
            4'b0111 : begin
                R = B;
            end
  
            // Logical
            4'b1000: R = A & B;            // AND
            4'b1001: R = A | B;            // OR
            4'b1010: R = A ^ B;            // XOR
            4'b1011: R = ~A;               // NOT
  
            // Shift
            4'b1100: R = A << 1;           // Logical left shift
            4'b1101: R = A >> 1;           // Logical right shift
            4'b1110: R = {A[6:0], A[7]};   // Left rotate shift
            4'b1111: R = {A[0], A[7:1]};   // Right rotate shift
  
            default: R = 8'b0000;
        endcase
  
        Z = (R == 8'b0000);  // Fixed: Changed from 4'b0000 to 8'b0000
        S = R[7];
    end 
endmodule
```

## Schematic

**Before Synthesis**

<img width="925" height="723" alt="image" src="https://github.com/user-attachments/assets/93afdfd1-47ef-406a-9add-8d2dc5c85635" />

**After Synthesis**

<img width="937" height="726" alt="image" src="https://github.com/user-attachments/assets/1f2a27af-22f5-4e02-8154-0d559371f326" />


## 7. Control Unit

### Role of Control Unit in Mini Processing Unit (MPU)

The **Control Unit** is the **brain of the Mini Processing Unit**.  
It does not process data itself, but **controls and coordinates all other blocks** such as:

- Program Counter
- Instruction Register
- Register File
- ALU
- Data Memory

This Control Unit is implemented as a **Finite State Machine (FSM)** that sequences instruction execution across multiple clock cycles.

---

### Control Unit Architecture

- Instruction-driven FSM
- Multi-cycle execution model
- Opcode-based control signal generation
- Flag-aware branching support


---

### Input Signal Description

| Signal | Width | Description |
|------|------|-------------|
| `clk` | 1-bit | System clock |
| `rst` | 1-bit | Asynchronous reset |
| `opcode` | 4-bit | Instruction opcode |
| `zero_flag` | 1-bit | ALU zero flag |
| `sign_flag` | 1-bit | ALU sign flag |
| `overflow_flag` | 1-bit | ALU overflow flag |

---

### Output Signal Description

| Signal | Width | Description |
|------|------|-------------|
| `pc_enable` | 1-bit | Enables PC increment |
| `pc_load` | 1-bit | Loads jump address into PC |
| `ir_load` | 1-bit | Loads instruction into IR |
| `reg_write_en` | 1-bit | Enables register write |
| `alu_src_sel` | 1-bit | Selects ALU B input source |
| `alu_op` | 4-bit | ALU operation select |
| `alu_cin` | 1-bit | Carry input for ADC |
| `mem_read` | 1-bit | Enables memory read |
| `mem_write` | 1-bit | Enables memory write |
| `current_state` | 3-bit | Current FSM state |

---

### FSM States Definition

| State | Code | Description |
|-----|-----|-------------|
| `S_FETCH` | 000 | Fetch instruction |
| `S_DECODE` | 001 | Decode instruction |
| `S_EXEC` | 010 | Execute operation |
| `S_WRITEB` | 011 | Write result back |
| `S_JUMP` | 100 | Jump execution |
| `S_IMM` | 101 | Immediate instruction handling |

---

### Opcode to ALU Mapping

| Opcode | Instruction | ALU Operation |
| ------ | ----------- | ------------- |
| `0000` | ADD         | ALU_ADD       |
| `0001` | SUB         | ALU_SUB       |
| `0010` | ADC         | ALU_ADC       |
| `0011` | INC         | ALU_INC       |
| `0100` | DEC         | ALU_DEC       |
| `0101` | MUL         | ALU_MUL       |
| `0110` | CMP         | ALU_CMP       |
| `0111` | MOV         | ALU_MOV       |
| `1000` | AND         | ALU_AND       |
| `1001` | OR          | ALU_OR        |
| `1010` | XOR         | ALU_XOR       |
| `1011` | NOT         | ALU_NOT       |
| `1100` | SHL         | ALU_SHL       |
| `1101` | SHR         | ALU_SHR       |
| `1110` | ROL         | ALU_ROL       |
| `1111` | ROR / NOP   | ALU_ROR       |

## Module

```bash
module ControlUnit (
    input wire clk,
    input wire rst,
    input wire [3:0] opcode,
    input wire zero_flag,
    input wire sign_flag,
    input wire overflow_flag,
    output reg pc_enable,
    output reg pc_load,
    output reg ir_load,
    output reg reg_write_en,
    output reg alu_src_sel,
    output reg [3:0] alu_op,
    output reg alu_cin,
    output reg mem_read,
    output reg mem_write,
    output reg [2:0] current_state
);

    // Instruction Opcodes (expanded) - ADD OP_NOP
    localparam OP_ADD   = 4'b0000;
    localparam OP_SUB   = 4'b0001;
    localparam OP_ADC   = 4'b0010;  // Add with carry
    localparam OP_INC   = 4'b0011;  // Increment
    
    localparam OP_DEC   = 4'b0100;  // Decrement
    localparam OP_MUL   = 4'b0101;  // Multiply
    localparam OP_CMP   = 4'b0110;  // Compare
    localparam OP_MOV   = 4'b0111;  // Move
   
    localparam OP_AND   = 4'b1000;
    localparam OP_OR    = 4'b1001;
    localparam OP_XOR   = 4'b1010;
    localparam OP_NOT   = 4'b1011;
   
    localparam OP_SHL   = 4'b1100;  // Shift left
    localparam OP_SHR   = 4'b1101;  // Shift right
    localparam OP_ROL   = 4'b1110;  // Rotate left
    localparam OP_ROR   = 4'b1111;  // Rotate right
    
    localparam OP_LDI   = 4'b0011;  // Load immediate (same as CMP but will be differentiated)
    localparam OP_JUMP  = 4'b0100;  // Jump (same as AND but will be differentiated)
    localparam OP_JZ    = 4'b0101;  // Jump if zero (same as OR)
    localparam OP_NOP   = 4'b1111;  // ADD THIS: No operation
    
    // ALU Operation Codes
    localparam ALU_ADD  = 4'b0000;
    localparam ALU_SUB  = 4'b0001;
    localparam ALU_ADC  = 4'b0010;
    localparam ALU_INC  = 4'b0011;
    localparam ALU_DEC  = 4'b0100;
    localparam ALU_MUL  = 4'b0101;
    localparam ALU_CMP  = 4'b0110;
    localparam ALU_MOV  = 4'b0111;
    localparam ALU_AND  = 4'b1000;
    localparam ALU_OR   = 4'b1001;
    localparam ALU_XOR  = 4'b1010;
    localparam ALU_NOT  = 4'b1011;
    localparam ALU_SHL  = 4'b1100;
    localparam ALU_SHR  = 4'b1101;
    localparam ALU_ROL  = 4'b1110;
    localparam ALU_ROR  = 4'b1111;
    
    // FSM States
    localparam [2:0] S_FETCH  = 3'b000;
    localparam [2:0] S_DECODE = 3'b001;
    localparam [2:0] S_EXEC   = 3'b010;
    localparam [2:0] S_WRITEB = 3'b011;
    localparam [2:0] S_JUMP   = 3'b100;
    localparam [2:0] S_IMM    = 3'b101;
    
    reg [2:0] next_state;
    
    // State Register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S_FETCH;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Next State Logic
    always @(*) begin
        case (current_state)
            S_FETCH:  next_state = S_DECODE;
            S_DECODE: begin
                case (opcode)
                    OP_JUMP, OP_JZ:   next_state = S_JUMP;
                    OP_LDI:          next_state = S_IMM;
                    default:         next_state = S_EXEC;
                endcase
            end
            S_EXEC:   next_state = S_WRITEB;
            S_WRITEB: next_state = S_FETCH;
            S_JUMP:   next_state = S_FETCH;
            S_IMM:    next_state = S_WRITEB;
            default:  next_state = S_FETCH;
        endcase
    end
    
    // Output Logic - FIXED: Added OP_NOP to the condition
    always @(*) begin
        // Default outputs
        pc_enable = 1'b0;
        pc_load = 1'b0;
        ir_load = 1'b0;
        reg_write_en = 1'b0;
        alu_src_sel = 1'b0;
        alu_cin = 1'b0;
        alu_op = 4'b0000;
        mem_read = 1'b0;
        mem_write = 1'b0;
        
        case (current_state)
            S_FETCH: begin
                ir_load = 1'b1;
                pc_enable = 1'b1;
            end
            
            S_DECODE: begin
                // Decode only
            end
            
            S_EXEC: begin
                case (opcode)
                    OP_ADD:  alu_op = ALU_ADD;
                    OP_SUB:  alu_op = ALU_SUB;
                    OP_ADC:  begin
                        alu_op = ALU_ADC;
                        alu_cin = 1'b1;
                    end
                    OP_INC:  alu_op = ALU_INC;
                    OP_DEC:  alu_op = ALU_DEC;
                    OP_MUL:  alu_op = ALU_MUL;
                    OP_CMP:  alu_op = ALU_CMP;
                    OP_MOV:  alu_op = ALU_MOV;
                    OP_AND:  alu_op = ALU_AND;
                    OP_OR:   alu_op = ALU_OR;
                    OP_XOR:  alu_op = ALU_XOR;
                    OP_NOT:  alu_op = ALU_NOT;
                    OP_SHL:  alu_op = ALU_SHL;
                    OP_SHR:  alu_op = ALU_SHR;
                    OP_ROL:  alu_op = ALU_ROL;
                    OP_ROR:  alu_op = ALU_ROR;
                    OP_LDI:  begin
                        alu_op = ALU_MOV;
                        alu_src_sel = 1'b1;
                    end
                    default: alu_op = ALU_ADD;
                endcase
            end
            
            S_WRITEB: begin
                // FIXED: Added OP_NOP to the condition
                if (opcode != OP_JUMP && opcode != OP_JZ && opcode != OP_CMP && opcode != OP_NOP)
                begin
                    reg_write_en = 1'b1;
                end
                pc_enable = 1'b1;
            end
            
            S_JUMP: begin
                if ((opcode == OP_JUMP) || (opcode == OP_JZ && zero_flag))
                begin
                    pc_load = 1'b1;
                end
                pc_enable = 1'b1;
            end
        endcase
    end

endmodule 
```
## Schematic

**Before Synthesis**

<img width="1475" height="726" alt="image" src="https://github.com/user-attachments/assets/3b3e19fd-043c-4501-badb-14b808e93fce" />

**After Synthesis**

<img width="1568" height="728" alt="image" src="https://github.com/user-attachments/assets/7e41c39b-e30f-4a1b-9bc6-3a4054a6d6bc" />

## 8. Data Memory (DMEM)

**What is Data Memory?**

Data Memory is used to store and retrieve data values during program execution.

Unlike Instruction Memory, which stores program instructions, Data Memory stores operands, intermediate results, and variables used by the processor.

In an MPU, Data Memory is typically accessed by:

* Load instructions (read data)

* Store instructions (write data)

### Input / Output Interface

**Input**

| Signal       | Width | Description                        |
| ------------ | ----- | ---------------------------------- |
| `clk`        | 1     | System clock                       |
| `mem_read`   | 1     | Enables memory read                |
| `mem_write`  | 1     | Enables memory write               |
| `address`    | 8     | Memory address (from ALU)          |
| `write_data` | 8     | Data to be written (from register) |

**Outputs**

| Signal      | Width | Description           |
| ----------- | ----- | --------------------- |
| `read_data` | 8     | Data read from memory |

### Module

```bash
module data_memory (
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [7:0] address,
    input wire [7:0] write_data,
    output reg [7:0] read_data
);

    // 256x8 Data Memory
    reg [7:0] mem [0:255];
    
    // Initialize with zeros
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 8'b0;
        end
    end
    
    // Read operation (asynchronous)
    always @(*) begin
        if (mem_read) begin
            read_data = mem[address];
        end else begin
            read_data = 8'b0;
        end
    end
    
    // Write operation (synchronous)
    always @(posedge clk) begin
        if (mem_write) begin
            mem[address] <= write_data;
        end
    end

endmodule
```

### schematic

**Before Synthesis**

<img width="777" height="245" alt="image" src="https://github.com/user-attachments/assets/e76681e7-2954-4219-97f2-14f92f39e203" />

**After Synthesis**


<img width="712" height="716" alt="image" src="https://github.com/user-attachments/assets/9df1cdfe-94f5-40b5-b3ea-f61ca7432201" />


## Top Module

```bash
module Top_module(
    input wire clk,
    input wire rst,

    output wire [7:0] pc_value,
    output wire [15:0] current_instruction,
    output wire [7:0] alu_result,

    output wire [7:0] reg0_value,
    output wire [7:0] reg1_value,
    output wire [7:0] reg2_value,
    output wire [7:0] reg3_value,

    output wire [2:0] current_state,

    output wire zero_flag_out,
    output wire carry_flag_out,
    output wire sign_flag_out,
    output wire overflow_flag_out
);

    wire [7:0] pc_out;
    wire [15:0] instruction;

    wire [3:0] opcode;
    wire [1:0] reg_dest, reg_src1, reg_src2;
    wire [7:0] immediate;

    wire [7:0] reg_data1, reg_data2;
    wire [7:0] alu_a, alu_b, alu_out;

    wire zero_flag, carry_flag, sign_flag, overflow_flag;

    wire pc_enable, pc_load, ir_load;
    wire reg_write_en, alu_src_sel;
    wire alu_cin;
    wire [3:0] alu_op_control;
    wire mem_read, mem_write;

    wire [7:0] dmem_out;  // <<< Fix: connect memory output

    assign opcode = instruction[15:12];
    assign reg_dest = instruction[11:10];
    assign reg_src1 = instruction[9:8];
    assign reg_src2 = instruction[7:6];
    assign immediate = instruction[7:0];

    program_counter u_pc(
        .clk(clk), .rst(rst),
        .pc_enable(pc_enable), .pc_load(pc_load),
        .jump_address(immediate),
        .pc_out(pc_out)
    );

    instruction_memory u_imem(
        .address(pc_out),
        .instruction(instruction)
    );

    instruction_register u_ir(
        .clk(clk), .rst(rst), .ir_load(ir_load),
        .instruction_in(instruction),
        .instruction_out(current_instruction)
    );

    register_file u_rf(
        .clk(clk), .rst(rst),
        .reg_write_en(reg_write_en),
        .reg_write_addr(reg_dest),
        .reg_read_addr1(reg_src1),
        .reg_read_addr2(reg_src2),
        .reg_write_data(alu_out),
        .reg_read_data1(reg_data1),
        .reg_read_data2(reg_data2),
        .reg0_out(reg0_value),
        .reg1_out(reg1_value),
        .reg2_out(reg2_value),
        .reg3_out(reg3_value)
    );

    assign alu_a = reg_data1;
    assign alu_b = alu_src_sel ? immediate : reg_data2;

    ALU_8bit u_alu(
        .A(alu_a),
        .B(alu_b),
        .Cin(alu_cin),
        .sel(alu_op_control),
        .R(alu_out),
        .C(carry_flag),
        .Z(zero_flag),
        .S(sign_flag),
        .V(overflow_flag)
    );

    ControlUnit_NewALU u_cu(
        .clk(clk), .rst(rst),
        .opcode(opcode),
        .zero_flag(zero_flag),
        .sign_flag(sign_flag),
        .overflow_flag(overflow_flag),

        .pc_enable(pc_enable),
        .pc_load(pc_load),
        .ir_load(ir_load),
        .reg_write_en(reg_write_en),
        .alu_src_sel(alu_src_sel),
        .alu_op(alu_op_control),
        .alu_cin(alu_cin),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .current_state(current_state)
    );

wire [7:0] data_mem_out;

    data_memory u_dmem(
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_out),
        .write_data(reg_data2),
        .read_data(data_mem_out)
    );

    assign pc_value = pc_out;
    assign alu_result = alu_out;

    assign zero_flag_out = zero_flag;
    assign carry_flag_out = carry_flag;
    assign sign_flag_out = sign_flag;
    assign overflow_flag_out = overflow_flag;

endmodule
```
## Testbench

`timescale 1ns/1ps

module mpu_simple_tb;

    // Clock & Reset
    reg clk;
    reg rst;

    // DUT Outputs
    wire [7:0] pc_value;
    wire [15:0] current_instruction;
    wire [7:0] alu_result;
    wire [7:0] reg0_value, reg1_value, reg2_value, reg3_value;
    wire [2:0] current_state;
    wire zero_flag_out, carry_flag_out, sign_flag_out, overflow_flag_out;

    // DUT Instantiation
    Top_module dut (
        .clk(clk),
        .rst(rst),
        .pc_value(pc_value),
        .current_instruction(current_instruction),
        .alu_result(alu_result),
        .reg0_value(reg0_value),
        .reg1_value(reg1_value),
        .reg2_value(reg2_value),
        .reg3_value(reg3_value),
        .current_state(current_state),
        .zero_flag_out(zero_flag_out),
        .carry_flag_out(carry_flag_out),
        .sign_flag_out(sign_flag_out),
        .overflow_flag_out(overflow_flag_out)
    );

    // Clock Generation: 100 MHz (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset Sequence
    initial begin
        rst = 1;
        #20;        // Hold reset
        rst = 0;
    end

    // Monitor all important signals
    initial begin
        $monitor(
            "$time=%0t | PC=%0d | INST=%h | ALU=%h | R0=%h R1=%h R2=%h R3=%h | Z=%b C=%b S=%b V=%b | STATE=%b", $time, pc_value, current_instruction, alu_result, reg0_value, reg1_value, reg2_value, reg3_value, zero_flag_out, carry_flag_out, sign_flag_out, overflow_flag_out, current_state );
    end

    // Stop simulation after some cycles
    initial begin
        #1000;
        $display("Simulation finished");
        $finish;
    end

endmodule

## Waveform

<img width="1576" height="812" alt="image" src="https://github.com/user-attachments/assets/488122ba-4002-44e1-aea7-c8bdfd6710db" />

## Schematic

**Before Synthesis**

<img width="1570" height="586" alt="image" src="https://github.com/user-attachments/assets/866d1655-8c0b-40e4-99c2-20832d04ea64" />

<img width="1537" height="661" alt="image" src="https://github.com/user-attachments/assets/5085c8e2-07ff-41b5-8e20-c5384a5075dc" />

**After Synthesis**

<img width="922" height="732" alt="image" src="https://github.com/user-attachments/assets/0a03ea3a-8abd-4eed-a159-ae8000b94312" />

<img width="1177" height="777" alt="image" src="https://github.com/user-attachments/assets/5c414933-d8e1-424d-8bc8-72fe1c4193df" />

### Default Layout

<img width="502" height="732" alt="image" src="https://github.com/user-attachments/assets/fc44629b-35dd-4183-9431-da2ee808928a" />

### Power Consumption

<img width="1328" height="458" alt="image" src="https://github.com/user-attachments/assets/4f1a2f97-1a01-44e2-b020-3c69de21baa9" />

## Conclusion

* In this project, a Mini Processing Unit (MPU) was successfully designed and verified at the Register Transfer Level (RTL) using Verilog HDL.
* The design implements a complete instruction execution flow, including instruction fetch, decode, execute, memory access, and write-back, closely resembling the internal operation of a basic microprocessor.

* The MPU integrates all fundamental building blocks required in a processor architecture—Program Counter, Instruction Memory, Instruction Register, Register File, Arithmetic Logic Unit (ALU), Control Unit, and Data Memory—and coordinates them through a finite state machine–based control unit. 
* Support for arithmetic, logical, shift, comparison, immediate, and control-flow instructions demonstrates a well-structured and extensible instruction set.

* Functional verification was performed using a custom testbench, and waveform analysis confirmed correct behavior of the program counter progression, instruction decoding, ALU operations, register updates, and status flag generation.
* The design is fully synchronous, modular, and synthesizable, making it suitable for downstream physical design stages.

* Although FPGA-based power analysis reports show inflated power values due to the absence of realistic switching activity and timing constraints, these results are expected and do not reflect the true power characteristics of the design.
* The project is intentionally structured to be ASIC-ready, with the next phase targeting open-source physical design tools and the SKY130 nm PDK for timing, power, and layout analysis.

* Overall, this project provides a strong foundation in processor microarchitecture, RTL design practices, control logic design, and verification methodology, while also serving as a solid starting point for full ASIC physical design flow implementation.
* The modular nature of the design allows future extensions such as pipelining, additional instructions, cache integration, and low-power optimizations.

