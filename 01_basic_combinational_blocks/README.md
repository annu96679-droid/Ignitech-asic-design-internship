# Design and simulate foundational digital circuits using Verilog RTL.

## 1. Multiplexer (4:1)

A 4:1 Multiplexer (MUX) is a fundamental combinational digital circuit that selects one out of four input signals based on two select lines and forwards it to a single output.
This project demonstrates the complete digital design flow of a 4:1 MUX using Verilog HDL, including:

    * RTL design

    * Functional simulation

    * RTL schematic (before synthesis)

    * Technology-mapped schematic (after synthesis)
    
## Block Diagram:

<img width="602" height="499" alt="image" src="https://github.com/user-attachments/assets/1bfeaaf9-7264-4255-8dc4-1af712fde7f3" />

## Theory of 4:1 Multiplexer
A 4:1 multiplexer consists of:
- **4 data inputs**: `I0, I1, I2, I3`
- **2 select lines**: `S1, S0`
- **1 output**: `Y`

### Truth Table

| S1 | S0 | Output |
|----|----|--------|
| 0  | 0  | Y = I0 |
| 0  | 1  | Y = I1 |
| 1  | 0  | Y = I2 |
| 1  | 1  | Y = I3 |

## Module:

- Implemented using **combinational logic**
- Written using `always @(*)` and `case` statement
- Fully synthesizable and latch-free design
  
<img width="1618" height="864" alt="Screenshot 2025-12-09 154248" src="https://github.com/user-attachments/assets/c416a2a3-8fba-469c-956c-784b46e8e888" />

# Testbench :

- A testbench applies all combinations of select lines and input data
- Output is observed using `$monitor` or waveform viewer

<img width="1624" height="863" alt="Screenshot 2025-12-09 154403" src="https://github.com/user-attachments/assets/5bd374fd-ab05-4b2d-9f28-5bcee72f7ac3" />

# Waveform :

<img width="1624" height="867" alt="Screenshot 2025-12-09 154438" src="https://github.com/user-attachments/assets/f1531ebc-b321-4f9d-93ba-6bebbb21e791" />

# Schematic :

**Before synthesis:**

### Description
The RTL schematic represents the **logical structure inferred from Verilog code** before technology mapping.

### Characteristics
- Technology independent
- Shows multiplexing behavior
- Helps verify combinational logic structure
  
<img width="1630" height="869" alt="Screenshot 2025-12-09 154511" src="https://github.com/user-attachments/assets/5ac4bf43-adb8-451b-a77b-d3caf58f3f1e" />

**After Synthesis:**

### Description
The post-synthesis schematic shows the **actual gate-level implementation**.

### Comparison

| RTL Schematic | Post-Synthesis Schematic |
|--------------|--------------------------|
| Behavioral | Structural |
| Technology independent | Technology dependent |
| High-level blocks | Logic gates / MUX cells |

<img width="1577" height="813" alt="Screenshot 2025-12-09 154526" src="https://github.com/user-attachments/assets/2df369bd-fc92-499c-ab62-54d7e0b0c891" />

##  Tools Used
- Verilog HDL
- Xilinx Vivado (Simulation & Synthesis)
- GTKWave (optional waveform analysis)

---

##  Learning Outcomes
- Understanding multiplexer operation
- Writing synthesizable Verilog code
- Functional verification using testbench
- RTL vs post-synthesis schematic comparison
- Introduction to digital design flow

---

##  Applications of Multiplexers
- Data routing
- Bus selection
- ALU input selection
- Control logic
- Communication systems

##  Verification Status
✔ RTL Simulation – Passed  
✔ Synthesis – Successful 

# 2. Priority Encoder – Verilog Design, Simulation & Synthesis

## Project Overview
This project implements a **Priority Encoder** using **Verilog HDL** and demonstrates the complete digital design flow:
- RTL design
- Functional simulation
- RTL schematic (before synthesis)
- Post-synthesis schematic (after synthesis)

A priority encoder assigns **priority to higher-order inputs**. If multiple inputs are high simultaneously, the encoder outputs the binary code of the **highest-priority active input**.

---

##  Theory of Priority Encoder

### What is a Priority Encoder?
A **priority encoder** is a combinational circuit that converts multiple input lines into a binary code, giving **priority** to one input over others.

Example:  
In a **4-to-2 priority encoder**, if multiple inputs are `1`, the **highest-index input** is encoded.

---

##  Inputs and Outputs (4-to-2 Priority Encoder)

<img width="700" height="300" alt="image" src="https://github.com/user-attachments/assets/29abc8a2-2e82-4cb7-bd91-adc142af636c" />


- Inputs: `I3, I2, I1, I0`  
  (`I3` has the highest priority)
- Outputs:
  - `Y1, Y0` → encoded output
  - `V` → valid output (indicates at least one input is high)

---

##  Truth Table (Priority Based)

| I3 | I2 | I1 | I0 | Y1 | Y0 | V |
|----|----|----|----|----|----|---|
| 0  | 0  | 0  | 0  |  X |  X | 0 |
| 0  | 0  | 0  | 1  |  0 |  0 | 1 |
| 0  | 0  | 1  | X  |  0 |  1 | 1 |
| 0  | 1  | X  | X  |  1 |  0 | 1 |
| 1  | X  | X  | X  |  1 |  1 | 1 |

 `X` = Don’t care (lower-priority inputs are ignored)

---

##  Boolean Expressions

Y1 = I3 + I2
Y0 = I3 + (~I2 & I1)
V = I3 + I2 + I1 + I0


These equations ensure that:
- Higher-priority inputs dominate
- Lower-priority inputs are ignored if a higher one is active

---

## Circuit Diagram Explanation

The priority encoder is implemented using:
- AND gates
- OR gates
- NOT gates

### Working Principle:
1. The highest-priority input is checked first
2. If it is active, lower inputs are ignored
3. Output bits are generated using combinational logic
4. Valid bit confirms whether any input is active

---

## RTL Design (Verilog HDL)
- Implemented using `always @(*)`
- Priority enforced using `if-else` structure
- Fully combinational and synthesizable
- No latches inferred

<img width="1620" height="863" alt="Screenshot 2025-12-09 171102" src="https://github.com/user-attachments/assets/e1c1b04b-a9fe-47d6-be3d-69fa077c05b7" />
<img width="1631" height="867" alt="Screenshot 2025-12-09 171113" src="https://github.com/user-attachments/assets/7751d1b7-5297-48e4-ac60-26507556b38e" />
<img width="1626" height="863" alt="Screenshot 2025-12-09 171122" src="https://github.com/user-attachments/assets/c4e3561b-bc7f-4da5-801e-9ec066349c48" />

---

## Functional Simulation

### Objective
To verify correct priority behavior when multiple inputs are active.

### Simulation Method
- Apply different combinations of inputs
- Observe encoded output and valid bit
- Confirm highest-priority input is always selected

<img width="1619" height="865" alt="Screenshot 2025-12-09 171130" src="https://github.com/user-attachments/assets/34be781d-e967-439e-a2fc-94c22c86be45" />


### Result
- Correct priority encoding verified
- Valid signal works correctly

---

## RTL Schematic (Before Synthesis)

### Description
The RTL schematic shows:
- Priority logic structure
- Conditional decision paths
- Technology-independent representation

<img width="1619" height="863" alt="Screenshot 2025-12-09 171140" src="https://github.com/user-attachments/assets/ce8acb6c-28db-479f-a86e-aa53a46e7114" />

### Purpose
- Verify logic correctness
- Ensure no unintended storage elements

---

## Synthesis

### Description
Synthesis maps the RTL logic into:
- Basic logic gates
- Optimized combinational structures
- Target FPGA/ASIC standard cells

---

## Post-Synthesis Schematic (After Synthesis)

### Description
Shows the **actual hardware realization** after synthesis.

### Comparison

| RTL Schematic | Post-Synthesis Schematic |
|--------------|--------------------------|
| Behavioral | Structural |
| Abstract logic | Gate-level implementation |
| Technology independent | Technology dependent |

<img width="1629" height="870" alt="Screenshot 2025-12-09 171333" src="https://github.com/user-attachments/assets/6f1ba972-670f-4e0e-ac63-379fbd999609" />

---


## Tools Used
- Verilog HDL
- Xilinx Vivado (Simulation & Synthesis)
- GTKWave (optional)

---

## Learning Outcomes
- Understanding priority-based encoding
- Writing synthesizable priority logic
- Verifying combinational circuits
- RTL vs gate-level comparison
- Digital design fundamentals

---

## Applications of Priority Encoder
- Interrupt controllers
- Arbitration logic
- Keyboard encoding
- Resource scheduling
- CPU control units

---

## Verification Status
✔ RTL Simulation – Passed  
✔ Synthesis – Successful  

---

 # 3. 4-Bit Arithmetic Logic Unit (ALU) – Verilog Design, Simulation & Synthesis

## Project Overview
This project implements a **4-bit Arithmetic Logic Unit (ALU)** using **Verilog HDL** and demonstrates the complete digital design flow:
- RTL design
- Functional simulation
- RTL schematic (before synthesis)
- Post-synthesis schematic (after synthesis)

The ALU performs **arithmetic, logical, and shift operations** on two 4-bit inputs based on **four select lines** and generates standard status flags.

---

## Theory of 4-Bit ALU

### What is an ALU?
An **Arithmetic Logic Unit (ALU)** is a core digital block used in processors and controllers to perform:
- Arithmetic operations (add, subtract, increment, etc.)
- Logical operations (AND, OR, XOR, NOT)
- Shift and rotate operations

---

##  Inputs and Outputs

<img width="317" height="159" alt="image" src="https://github.com/user-attachments/assets/972276bf-c1ce-4050-9791-26fcc17532e4" />

## Inputs

| Signal | Width | Description |
|------|------|------------|
| `A` | 4-bit | Operand A |
| `B` | 4-bit | Operand B |
| `Cin` | 1-bit | Carry input |
| `sel` | 4-bit | Operation select |

---

## Outputs

| Signal | Width | Description |
|------|------|------------|
| `R` | 4-bit | Result |
| `C` | 1-bit | Carry / Borrow flag |
| `Z` | 1-bit | Zero flag |
| `S` | 1-bit | Sign flag |
| `V` | 1-bit | Overflow flag |


---

## ALU Operation Table (4 Select Lines)

| Sel[3:0] | Operation | Description |
|---------|----------|-------------|
| 0000 | ADD | R = A + B |
| 0001 | SUB | R = A − B |
| 0010 | ADD + Carry | R = A + B + Cin |
| 0011 | INC | R = A + 1 |
| 0100 | DEC | R = A − 1 |
| 0101 | MUL | R = A × B (lower 4 bits) |
| 0110 | COMPARE | A − B (flags only) |
| 0111 | PASS B | R = B |
| 1000 | AND | R = A & B |
| 1001 | OR | R = A \| B |
| 1010 | XOR | R = A ^ B |
| 1011 | NOT | R = ~A |
| 1100 | LSL | Logical shift left |
| 1101 | LSR | Logical shift right |
| 1110 | ROL | Rotate left |
| 1111 | ROR | Rotate right |

---

## Status Flags Description

- **Carry (C)**: Indicates carry out or borrow
- **Zero (Z)**: Set when result is zero
- **Sign (S)**: MSB of result (signed indication)
- **Overflow (V)**: Indicates signed overflow

---

## RTL Design (Verilog HDL)
- Implemented using **combinational logic**
- Uses `always @(*)` and `case` statement
- Arithmetic, logic, and shift units are integrated
- Fully synthesizable, latch-free design
```verilog
module ALU_4bit(A,B,Cin,sel,R,C,Z,S,V);
input [3:0] A;
input [3:0] B;
input Cin;
input [3:0] sel;

output reg [3:0] R;
output reg C;    // carry flag
output reg Z;    // zero flag
output reg S;    // sign flag
output reg V;    // overflow flag

reg [4:0] temp;  // for carry and overflow

always @(*) begin
    // default values
    R = 4'b0; 
    C = 1'b0;
    V = 1'b0;

    case (sel)

        // Arithmetic operations
        4'b0000: begin                // ADD
            temp = A + B;
            R = temp[3:0];
            C = temp[4];
            V = (A[3] == B[3]) && (R[3] != A[3]);
        end

        4'b0001: begin                // SUB
            temp = A - B;
            R = temp[3:0];
            C = temp[4];
            V = (A[3] != B[3]) && (R[3] != A[3]);
        end

        4'b0010: begin                // ADD with Carry
            temp = A + B + Cin;
            R = temp[3:0];
            C = temp[4];
            V = (A[3] == B[3]) && (R[3] != A[3]);
        end

        4'b0011: begin                // Increment
            temp = A + 1;
            R = temp[3:0];
            C = temp[4];
        end

        4'b0100: begin                // Decrement
            temp = A - 1;
            R = temp[3:0];
            C = temp[4];
        end

        4'b0101: begin                // Multiply
            temp = A * B;
            R = temp[3:0];
            C = temp[4];
        end

        4'b0110: begin                // Compare (A - B), flags only
            temp = A - B;
            R = 4'b0000;
            C = temp[4];
            V = (A[3] != B[3]) && (temp[3] != A[3]);
        end

        4'b0111: begin                // Pass B
            R = B;
        end

        // Logical operations
        4'b1000: R = A & B;            // AND
        4'b1001: R = A | B;            // OR
        4'b1010: R = A ^ B;            // XOR
        4'b1011: R = ~A;               // NOT

        // Shift / Rotate operations
        4'b1100: R = A << 1;           // Logical left shift
        4'b1101: R = A >> 1;           // Logical right shift
        4'b1110: R = {A[2:0], A[3]};   // Rotate left
        4'b1111: R = {A[0], A[3:1]};   // Rotate right

        default: R = 4'b0000;
    endcase

    // Flag generation
    Z = (R == 4'b0000);
    S = R[3];

end
endmodule
```
---

## Testbench

This testbench verifies the **functional correctness of the 4-bit ALU** by applying different **operation select codes (`sel`)** while keeping the operands constant.  
All arithmetic, logical, shift, rotate, and compare operations are validated, along with status flags.


```
module alu_tb(); 
reg [3:0] A, B;
reg Cin; 
reg [3:0] sel;
wire [3:0] R;
wire C,Z,S,V;

 ALU_4bit A1(.A(A), .B(B), .Cin(Cin), .sel(sel), .R(R), .C(C), .Z(Z), .S(S), .V(V));
 
 initial
 begin
       $monitor("$time = %t | A = %b | B = %b | Cin = %b || sel = %b | R = %b | C = %b | Z = %b | S = %b | V = %b",$time,A,B,Cin,sel,R,C,Z,S,V);
       
Cin = 0; A = 4'b0011; B = 4'b0001;

   sel = 4'b0000; // ADD
#5 sel = 4'b0001; // SUB
#5 sel = 4'b0010; // ADD with carry
#5 sel = 4'b0011; // INC
#5 sel = 4'b0100; // DEC
#5 sel = 4'b0101; // MUL
#5 sel = 4'b0110; // COMPARE
#5 sel = 4'b0111; //pass
#5 sel = 4'b1000; // AND
#5 sel = 4'b1001; //OR
#5 sel = 4'b1010; //XOR
#5 sel = 4'b1011; //NOT
#5 sel = 4'b1100; // LSL
#5 sel = 4'b1101; //LSR
#5 sel = 4'b1110; // ROL
#5 sel = 4'b1111; //ROR
$finish;
end
endmodule
```
## Functional Simulation

### Objective
To verify the correctness of all ALU operations and flags.

### Simulation Method
- Apply various values to `A`, `B`, `Cin`, and `Sel`
- Observe `R` and status flags using `$monitor` or waveforms

<img width="1632" height="863" alt="image" src="https://github.com/user-attachments/assets/d58e78ef-36f6-4bbc-a3b6-27c220e2bc38" />

### Result
- All arithmetic, logic, and shift operations behave correctly
- Flags update as expected

---

## RTL Schematic (Before Synthesis)


### Description
The RTL schematic represents:
- High-level ALU structure
- Arithmetic, logic, and shifter blocks
- Technology-independent design

<img width="1630" height="910" alt="Screenshot 2025-12-23 015926" src="https://github.com/user-attachments/assets/3d599397-65e5-4d83-96a2-9cc3df07751d" />

### Purpose
- Validate logical structure
- Ensure correct combinational modeling
- Confirm no unintended latches

---

##  Synthesis

### Description
Synthesis converts the RTL ALU design into a **gate-level netlist** using the target FPGA/ASIC library.

### Key Points
- Logic optimization performed
- Arithmetic blocks mapped efficiently
- Flag logic synthesized correctly

---

## Post-Synthesis Schematic (After Synthesis)

<img width="1633" height="870" alt="Screenshot 2025-12-23 020227" src="https://github.com/user-attachments/assets/02e9b5c0-d3a5-49c3-9a64-88fc254294d6" />

### Description
The post-synthesis schematic shows:
- Actual logic gates and adders
- Optimized data paths
- Technology-mapped implementation

### Comparison

| RTL Schematic | Post-Synthesis Schematic |
|--------------|--------------------------|
| Behavioral | Structural |
| Abstract blocks | Logic gates |
| Technology independent | Technology dependent |

---

## Tools Used
- Verilog HDL
- Xilinx Vivado (Simulation & Synthesis)
- GTKWave (optional waveform viewing)

---

## Learning Outcomes
- Understanding ALU architecture
- Designing combinational datapaths
- Status flag generation
- RTL to gate-level flow
- Debugging and verification techniques

---

##  Applications of ALU
- Microprocessors
- Microcontrollers
- Digital signal processing
- Control units
- FPGA-based systems

---

##  Verification Status
✔ RTL Simulation – Passed  
✔ Synthesis – Successful  

---

# 4. D Flip-Flop – Verilog Design, Simulation & Synthesis

##  Project Overview
This project demonstrates the design and implementation of a **D (Data) Flip-Flop** using **Verilog HDL**, covering the complete digital design flow:
- RTL design
- Functional simulation
- RTL schematic (before synthesis)
- Post-synthesis schematic (after synthesis)

A D flip-flop is a **clocked sequential circuit** that stores **one bit of data** and updates its output only on a specific clock edge.

---

## Theory of D Flip-Flop

### What is a D Flip-Flop?
A **D flip-flop** captures the value present at its **D (data) input** on the **active edge of the clock** and holds that value at the output until the next clock edge.

- `D` → Data input  
- `CLK` → Clock input  
- `Q` → Stored output  

---

##  Operation (Positive Edge Triggered)

| Clock Edge | D | Q (Next State) |
|------------|---|----------------|
| ↑ (posedge) | 0 | 0 |
| ↑ (posedge) | 1 | 1 |
| No edge | X | Q (holds previous value) |

The output **changes only at the clock edge**, not continuously.

---

##  Characteristic Equation
The behavior of a D flip-flop is described by: Q(next) = D


This simplicity is why D flip-flops are the **most widely used storage elements** in digital systems.

---

## Circuit Diagram Explanation

A D flip-flop can be built using:
- Two latches (Master–Slave configuration), or
- Edge-triggered logic internally

### Working Principle:
1. On the **active clock edge**, the input `D` is sampled
2. The sampled value is transferred to output `Q`
3. Output remains constant until the next active edge

---

## 🛠️ RTL Design (Verilog HDL)
- Implemented using **edge-triggered always block**
- Uses `posedge clk`
- Fully synthesizable sequential logic
- No combinational loops or latches

<img width="1622" height="864" alt="Screenshot 2025-12-09 173305" src="https://github.com/user-attachments/assets/2d0d2722-d94c-4d03-b0c3-a1b92f21a741" />

Example behavior:
- At every rising edge of `clk`, `Q` updates to `D`
- Between clock edges, output is stable

---
## Testbench

<img width="1627" height="866" alt="Screenshot 2025-12-09 173317" src="https://github.com/user-attachments/assets/b0782bcf-e503-4ff1-8c67-fc84e71c9cf6" />
<img width="1630" height="865" alt="Screenshot 2025-12-09 173329" src="https://github.com/user-attachments/assets/8b57f1e7-81d1-409d-a3bb-f8dfc3f5e6b6" />

## Functional Simulation

### Objective
To verify correct **edge-triggered behavior** of the D flip-flop.

### Simulation Method
- Apply a periodic clock
- Change `D` input between clock edges
- Observe `Q` only changing at clock edges

<img width="1620" height="866" alt="Screenshot 2025-12-09 173354" src="https://github.com/user-attachments/assets/d6ce78fb-aab9-4aa4-aea6-7f2f4e580c23" />

### Result
- `Q` updates exactly at the clock edge
- No glitches or unintended transitions

---

## RTL Schematic (Before Synthesis)

### Description
The RTL schematic represents:
- Flip-flop inference
- Clocked storage element
- Technology-independent structure

<img width="1621" height="868" alt="Screenshot 2025-12-09 173338" src="https://github.com/user-attachments/assets/453e87d2-fc61-475c-a756-750809bd5021" />

### Purpose
- Verify that a **flip-flop (not a latch)** is inferred
- Check correct clock connectivity

---

## Synthesis

### Description
Synthesis maps the RTL flip-flop into:
- FPGA flip-flop primitives, or
- Standard-cell DFFs in ASIC flow

### Key Points
- Clock is preserved
- Storage element is optimized
- Timing constraints apply to clock paths

---

## Post-Synthesis Schematic (After Synthesis)

### Description
The post-synthesis schematic shows:
- Actual DFF cells
- Clock routing connections
- Technology-mapped implementation

<img width="1575" height="815" alt="Screenshot 2025-12-09 173558" src="https://github.com/user-attachments/assets/92ad2d9e-3a8d-4972-88de-23bcc954af6a" />

### Comparison

| RTL Schematic | Post-Synthesis Schematic |
|--------------|--------------------------|
| Behavioral | Structural |
| Abstract DFF | Technology DFF cell |
| Tool-inferred | Library-mapped |

---


## Tools Used
- Verilog HDL
- Xilinx Vivado (Simulation & Synthesis)
- GTKWave (optional waveform viewing)

---

## Learning Outcomes
- Understanding sequential logic
- Clocked storage behavior
- Edge-triggered design
- Difference between latch and flip-flop
- RTL to gate-level design flow

---

## Applications of D Flip-Flop
- Registers
- Counters
- Shift registers
- Pipeline stages
- State machines

---

## Verification Status
✔ RTL Simulation – Passed  
✔ Synthesis – Successful  

---





