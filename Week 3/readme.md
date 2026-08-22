# SystemVerilog Verification – Constrained Random & Coverage

## Overview

This repository contains SystemVerilog-based verification tasks developed as part of the **INSPIRE IC Design / SystemVerilog Verification Lab**.

The project focuses on:

1. Generating constrained-random test vectors for an ALU.
2. Implementing APB bus transaction verification with manual functional coverage and untested scenario analysis.

The testbenches are designed to work with **Vivado 2018.2 XSim**, which does not support SystemVerilog `covergroup`. Therefore, manual coverage counters are used for the APB coverage task.

---

## Task 1 – Constrained Random Test Vectors for ALU

### Objective

To verify an 8-bit Arithmetic Logic Unit (ALU) using constrained-random test vectors and automatically check the DUT output against a reference model.

### ALU Operations

| Opcode | Operation |
|--------|-----------|
| `000` | ADD |
| `001` | SUB |
| `010` | AND |
| `011` | OR |
| `100` | XOR |

### Features

- 8-bit operands
- Constrained-random input generation
- Random ALU operation selection
- Reference model for output verification
- Automatic PASS/ERROR checking
- Operand coverage
- Opcode coverage
- Result coverage
- Carry/Borrow coverage
- Untested scenario analysis

### Files

```text
Task_1_ALU/
├── alu.sv
└── alu_tb.sv
