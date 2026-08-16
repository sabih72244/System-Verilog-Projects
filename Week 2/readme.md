# APB Bus Transaction Testbench using SystemVerilog OOP

## Overview

This project implements an **APB (Advanced Peripheral Bus) transaction testbench** using **SystemVerilog Object-Oriented Programming (OOP)** concepts. The testbench verifies APB read and write transactions using a layered verification architecture.

## Objectives

* Implement an APB interface with master/slave connectivity.
* Design an APB slave memory module.
* Create an OOP-based layered testbench.
* Generate APB transactions using SystemVerilog classes.
* Drive transactions to the DUT using a driver.
* Monitor APB bus activity.
* Verify read/write operations using a scoreboard.
* Simulate and analyze APB waveforms.

## Testbench Architecture

The testbench consists of the following components:

* **Transaction:** Represents an APB read/write transaction.
* **Generator:** Creates APB transaction objects.
* **Driver:** Converts transactions into APB bus signals.
* **Monitor:** Observes APB bus activity and collects results.
* **Scoreboard:** Compares actual read data with expected data.
* **Environment:** Connects and manages all verification components.
* **DUT:** APB slave containing a 16-location × 32-bit memory.

### Data Flow

```text
Generator
    |
    v
Transaction
    |
    v
Driver
    |
    v
APB Interface
    |
    v
APB Slave (DUT)
    |
    v
Monitor
    |
    v
Scoreboard
```

## APB Signals

| Signal  | Description            |
| ------- | ---------------------- |
| PCLK    | APB clock              |
| PRESETn | Active-low reset       |
| PSEL    | Peripheral select      |
| PENABLE | Access phase enable    |
| PWRITE  | Read/write control     |
| PADDR   | Address                |
| PWDATA  | Write data             |
| PRDATA  | Read data              |
| PREADY  | Transfer ready         |
| PSLVERR | Slave error indication |

## APB Transfer

An APB transfer consists of two main phases:

1. **Setup Phase:** `PSEL = 1`, `PENABLE = 0`
2. **Access Phase:** `PSEL = 1`, `PENABLE = 1`

After the access phase, the bus returns to the idle state.

## Technologies Used

* SystemVerilog
* Object-Oriented Programming
* APB Protocol
* Vivado Simulator 2018.2
* Mailbox
* Virtual Interface
* Randomization
* Functional Verification

## Project Files

```text
apb_bus_transaction/
│
├── apb_all.sv
├── tb.sv
└── README.md
```

`apb_all.sv` contains the APB interface, slave, transaction, generator, driver, monitor, scoreboard, and environment.

`tb.sv` contains the top-level testbench and simulation control.

## Verification

The testbench verifies:

* APB write transactions
* APB read transactions
* Address and data transfer
* APB setup and access phases
* Expected versus actual read data
* Scoreboard PASS/FAIL results

## Simulation Result

The APB transactions are successfully simulated in Vivado. The waveform can be used to observe `PCLK`, `PRESETn`, `PSEL`, `PENABLE`, `PWRITE`, `PADDR`, `PWDATA`, `PRDATA`, `PREADY`, and `PSLVERR`.

## Conclusion

The project demonstrates how **SystemVerilog OOP concepts** can be used to create a structured and reusable APB verification environment. The layered testbench successfully generates, drives, monitors, and checks APB bus transactions.
