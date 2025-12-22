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

## 🧩 Circuit Diagram Explanation

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

## 🛠️ RTL Design (Verilog HDL)
- Implemented using `always @(*)`
- Priority enforced using `if-else` structure
- Fully combinational and synthesizable
- No latches inferred

<img width="1620" height="863" alt="Screenshot 2025-12-09 171102" src="https://github.com/user-attachments/assets/e1c1b04b-a9fe-47d6-be3d-69fa077c05b7" />
<img width="1631" height="867" alt="Screenshot 2025-12-09 171113" src="https://github.com/user-attachments/assets/7751d1b7-5297-48e4-ac60-26507556b38e" />
<img width="1626" height="863" alt="Screenshot 2025-12-09 171122" src="https://github.com/user-attachments/assets/c4e3561b-bc7f-4da5-801e-9ec066349c48" />

---

## ▶️ Functional Simulation

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

## 🧩 RTL Schematic (Before Synthesis)

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

## ⚙️ Synthesis

### Description
Synthesis maps the RTL logic into:
- Basic logic gates
- Optimized combinational structures
- Target FPGA/ASIC standard cells

---

## 🧱 Post-Synthesis Schematic (After Synthesis)

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


## 🧰 Tools Used
- Verilog HDL
- Xilinx Vivado (Simulation & Synthesis)
- GTKWave (optional)

---

## 🎯 Learning Outcomes
- Understanding priority-based encoding
- Writing synthesizable priority logic
- Verifying combinational circuits
- RTL vs gate-level comparison
- Digital design fundamentals

---

## 📌 Applications of Priority Encoder
- Interrupt controllers
- Arbitration logic
- Keyboard encoding
- Resource scheduling
- CPU control units

---

## ✅ Verification Status
✔ RTL Simulation – Passed  
✔ Synthesis – Successful  

---





