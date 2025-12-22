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

