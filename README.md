# AXI4 Protocol Verification Using UVM

A SystemVerilog-based verification project focused on verifying the **AMBA AXI4 protocol** using the **Universal Verification Methodology (UVM)**.

## Overview

The Advanced eXtensible Interface 4 (AXI4) is part of the AMBA protocol family developed by Arm. It is widely used in System-on-Chip (SoC) architectures to enable high-performance communication between hardware components.

This project focuses on developing a UVM-based verification environment to simulate and analyze AXI4 protocol behavior.

The main objective is to explore functional verification principles, understand UVM testbench architecture, and evaluate protocol behavior through simulation, waveform analysis, and coverage reporting.

## Project Objectives

- Understand the AMBA AXI4 protocol and its communication mechanisms.
- Develop a structured verification environment using SystemVerilog and UVM.
- Organize RTL, testbench, UVM components, and simulation files.
- Execute simulations and analyze signal-level behavior.
- Generate and inspect verification and coverage reports.
- Gain practical experience with hardware verification methodologies.

## Repository Structure

```text
AXI4-Protocol-Verification-Using-UVM/
│
├── rtl/                  # RTL design files
├── tb/                   # Testbench file
├── uvm/                  # UVM verification components
├── sim/                  # Simulation files and scripts
│
├── test_waveform.png     # Simulation waveform
├── uvm_output.png        # UVM simulation output
├── uvm_report.png        # UVM report
├── coverage_report.png   # Coverage report
│
└── README.md
```

## Technologies and Tools

| Technology | Purpose |
|---|---|
| SystemVerilog | Hardware description and verification |
| UVM | Structured verification environment |
| AXI4 | Communication protocol |
| QuestaSim | HDL simulation and debugging |
| Functional Coverage | Verification coverage analysis |

## AXI4 Protocol Overview

AXI4 uses five independent communication channels:

| Channel | Description |
|---|---|
| AW | Write Address |
| W | Write Data |
| B | Write Response |
| AR | Read Address |
| R | Read Data |

Communication relies on the VALID/READY handshake mechanism, allowing independent control of transaction transfers between communicating components.

## UVM Verification Architecture

The verification environment follows the UVM methodology, which provides a modular and reusable approach to hardware verification.

The main UVM concepts include:

- **Sequence Items:** Represent transactions.
- **Sequences:** Generate verification stimulus.
- **Sequencer:** Controls transaction flow.
- **Driver:** Converts transactions into interface-level signals.
- **Monitor:** Observes interface activity.
- **Agent:** Groups verification components.
- **Environment:** Organizes and connects verification components.
- **Scoreboard:** Checks expected versus observed behavior.
- **Tests:** Configure and execute verification scenarios.

## Simulation Results

The following screenshots illustrate the simulation and verification results obtained using QuestaSim.

### 1. Simulation Waveform

The waveform provides a signal-level view of the simulation, allowing inspection of AXI4 signals and their timing behavior.

<p align="center">
  <img src="test_waveform.png" alt="AXI4 Simulation Waveform" width="900">
</p>

### 2. UVM Simulation Output

The simulation output displays the UVM messages generated during test execution.

<p align="center">
  <img src="uvm_output.png" alt="UVM Simulation Output" width="900">
</p>

### 3. UVM Verification Report

The UVM report provides information about the simulation execution and verification messages.

<p align="center">
  <img src="uvm_report.png" alt="UVM Verification Report" width="900">
</p>

### 4. Functional Coverage Report

The coverage report provides a visual overview of the collected verification coverage.

<p align="center">
  <img src="coverage_report.png" alt="Functional Coverage Report" width="900">
</p>

## Getting Started

### Prerequisites

- QuestaSim or another simulator supporting SystemVerilog and UVM.
- SystemVerilog language support.
- An available UVM library compatible with your simulator.

## Learning Outcomes

- AXI4 protocol fundamentals.
- SystemVerilog-based verification.
- UVM testbench architecture.
- Transaction-based verification.
- Modular and reusable verification components.
- Simulation debugging and waveform analysis.
- Functional coverage and verification reporting.
