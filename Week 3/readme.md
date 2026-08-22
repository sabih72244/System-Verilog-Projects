# SystemVerilog Verification Tasks

## Tasks

### Task 1: Constrained-Random Testing for ALU

**Generate constrained-random test vectors for an ALU.**

This task implements an 8-bit ALU and verifies its functionality using constrained-random test vectors. The ALU supports:

- Addition
- Subtraction
- AND
- OR
- XOR

The testbench uses SystemVerilog classes, randomization, constraints, a reference model, and self-checking mechanisms to verify the ALU output.

---

### Task 2: APB Bus Transaction Coverage

**Add coverage groups to an APB bus transaction testbench. Generate a coverage report and analyze untested scenarios.**

This task implements an APB slave and a SystemVerilog testbench to generate constrained-random APB read and write transactions.

The verification includes:

- Read and Write transaction testing
- Address range coverage
- Data coverage
- APB Setup and Access phase analysis
- PREADY and PSLVERR analysis
- Read/Write and Address cross coverage
- Coverage report generation
- Untested scenario analysis

> **Note:** Vivado 2018.2 XSim does not support SystemVerilog `covergroup`. Therefore, manual coverage counters are used to collect and analyze coverage scenarios.

---

## Files

```text
├── alu.sv
├── alu_tb.sv
├── apb_slave.sv
├── apb_tb.sv
└── README.md
