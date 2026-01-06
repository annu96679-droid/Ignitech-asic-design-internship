🟢 Project Overview

This project implements a synthesizable and parameterized Priority Encoder in Verilog and takes it through the complete VLSI backend design flow:

✔ RTL Design
✔ Functional Verification (Simulation)
✔ Synthesis
✔ Floorplanning
✔ Placement
✔ Clock Tree Synthesis (CTS)
✔ Routing
✔ STA / Timing Closure
✔ GDSII Generation

The design is created to be technology-independent, reusable, and suitable for ASIC and FPGA flows.


# 8-Bit Priority Encoder — Design & Working

🔹 Introduction

A Priority Encoder is a digital circuit that takes multiple input signals and outputs the binary index of the highest-priority active input.

In an 8-bit priority encoder, the inputs are

𝑖
𝑛
[
7
:
0
]
in[7:0]

and the output is a 3-bit encoded value, because

2
3
=
8
2
3
=8

Priority Rule (in this design):

Bit 7 has the highest priority, Bit 0 has the lowest priority

If multiple inputs are 1, the encoder selects the highest-numbered input.

The encoder also produces a valid flag (V) that indicates whether any input is active.

 # 📊 Truth Table (8-bit Priority Behavior)

| Input Vector (in[7:0]) | Highest Priority Bit | Output (out[2:0]) | V |
| ---------------------- | -------------------- | ----------------- | - |
| 00000000               | No active input      | 000               | 0 |
| 00000001               | bit0                 | 000               | 1 |
| 00000100               | bit2                 | 010               | 1 |
| 00011000               | bit4                 | 100               | 1 |
| 01010110               | bit6                 | 110               | 1 |
| 10000000               | bit7                 | 111               | 1 |

Notice:

Even if multiple bits are 1,
only the highest-priority one is encoded

Example
01010110 → highest 1 = bit6 → output = 110
