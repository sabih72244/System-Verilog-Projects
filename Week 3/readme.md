# SystemVerilog Verification Tasks

## Overview

This repository contains two SystemVerilog verification tasks developed as part of the INSPIRE IC Design / SystemVerilog Verification Lab.

### Tasks

1. Generate constrained-random test vectors for an ALU.
2. Add coverage to an APB bus transaction testbench and analyze untested scenarios.

The testbenches are developed and simulated using **Xilinx Vivado 2018.2 XSim**.

---

## Task 1 – Constrained-Random Test Vectors for ALU

### Objective

To verify an 8-bit ALU using constrained-random test vectors and a self-checking testbench.

### ALU Operations

| Opcode | Operation |
|--------|-----------|
| `000` | ADD |
| `001` | SUB |
| `010` | AND |
| `011` | OR |
| `100` | XOR |

### Features

- 8-bit ALU
- Constrained-random input generation
- Random operation selection
- SystemVerilog class and constraints
- Reference model
- Automatic result checking
- Operand coverage analysis
- Opcode coverage analysis
- Carry/Borrow analysis
- Untested scenario detection

### Files

```text
alu.sv
alu_tb.sv
