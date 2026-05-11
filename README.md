# AXI Master and Slave Implementation (RTL Project)

## Overview

This project contains a beginner-friendly implementation of:

* AXI Master
* AXI Slave

written in Verilog HDL.

The design focuses on understanding:

* AXI handshaking
* VALID/READY protocol
* Read and write transactions
* Payload stability
* Sequential RTL timing
* Channel independence
* Basic AXI-Lite style communication

This implementation is intended for learning and educational purposes.

---

# AXI Protocol Basics

AXI (Advanced eXtensible Interface) is part of the ARM AMBA protocol family.

AXI communication happens through independent channels using VALID and READY handshakes.

A transfer occurs only when:

```text
VALID = 1 and READY = 1
```

Each channel operates independently.

---

# AXI Channels Used

## Write Address Channel

| Signal  | Direction      | Description             |
| ------- | -------------- | ----------------------- |
| AWADDR  | Master → Slave | Write address           |
| AWVALID | Master → Slave | Address valid           |
| AWREADY | Slave → Master | Slave ready for address |

---

## Write Data Channel

| Signal | Direction      | Description                |
| ------ | -------------- | -------------------------- |
| WDATA  | Master → Slave | Write data                 |
| WVALID | Master → Slave | Write data valid           |
| WREADY | Slave → Master | Slave ready for write data |

---

## Write Response Channel

| Signal | Direction      | Description               |
| ------ | -------------- | ------------------------- |
| BRESP  | Slave → Master | Write response            |
| BVALID | Slave → Master | Response valid            |
| BREADY | Master → Slave | Master ready for response |

---

## Read Address Channel

| Signal  | Direction      | Description                  |
| ------- | -------------- | ---------------------------- |
| ARADDR  | Master → Slave | Read address                 |
| ARVALID | Master → Slave | Read address valid           |
| ARREADY | Slave → Master | Slave ready for read address |

---

## Read Data Channel

| Signal | Direction      | Description                |
| ------ | -------------- | -------------------------- |
| RDATA  | Slave → Master | Read data                  |
| RRESP  | Slave → Master | Read response              |
| RVALID | Slave → Master | Read data valid            |
| RREADY | Master → Slave | Master ready for read data |

---

# Project Architecture

## Master Responsibilities

The AXI Master:

* Initiates transactions
* Sends addresses
* Sends write data
* Receives responses
* Receives read data

The master controls VALID signals.

---

## Slave Responsibilities

The AXI Slave:

* Accepts addresses
* Stores data into registers
* Returns responses
* Sends read data

The slave controls READY and response generation.

---

# Internal Slave Register Bank

The slave contains:

```verilog
reg [31:0] Registers [3:0];
```

This creates:

* 4 registers
* each 32 bits wide

Address mapping:

| Address | Register     |
| ------- | ------------ |
| 0       | Registers[0] |
| 1       | Registers[1] |
| 2       | Registers[2] |
| 3       | Registers[3] |

---

# Write Transaction Flow

## Step 1 — Address Phase

The master:

* loads AWADDR
* asserts AWVALID

The slave:

* asserts AWREADY

Write address handshake:

```text
AWVALID && AWREADY
```

---

## Step 2 — Data Phase

The master:

* places WDATA
* asserts WVALID

The slave:

* asserts WREADY

Write data handshake:

```text
WVALID && WREADY
```

The slave stores the data into the internal register bank.

---

## Step 3 — Response Phase

The slave:

* generates BRESP
* asserts BVALID

The master:

* asserts BREADY

Response handshake:

```text
BVALID && BREADY
```

---

# Read Transaction Flow

## Step 1 — Read Address Phase

The master:

* places ARADDR
* asserts ARVALID

The slave:

* asserts ARREADY

Handshake:

```text
ARVALID && ARREADY
```

---

## Step 2 — Read Data Phase

The slave:

* places RDATA
* asserts RVALID

The master:

* asserts RREADY

Handshake:

```text
RVALID && RREADY
```

The master captures the read data.

---

# Important RTL Concepts Learned

## 1. VALID/READY Handshaking

Data transfer occurs only when:

```text
VALID && READY
```

---

## 2. Payload Stability

Signals like:

* AWADDR
* WDATA
* ARADDR

must remain stable while VALID is active.

---

## 3. Channel Independence

AXI channels are independent.

Examples:

* AWVALID belongs only to the write-address channel
* WVALID belongs only to the write-data channel
* ARVALID belongs only to the read-address channel

Each VALID signal must be cleared after its own handshake completes.

---

## 4. Sequential Timing

The design uses:

```verilog
always @(posedge ACLK)
```

This means all updates occur synchronously on clock edges.

---

## 5. Nonblocking Assignments

The project uses:

```verilog
<=
```

for sequential RTL logic.

This avoids race conditions and models flip-flop behavior correctly.

---

# Beginner Design Limitations

This implementation is educational and simplified.

Current limitations:

* Single transaction handling
* No burst transfers
* No transaction IDs
* No pipelining
* No FIFOs
* No arbitration
* No FSM-based scheduling
* No concurrent transaction support
* No protection against overlapping requests

---

# Possible Future Improvements

## Intermediate Improvements

* Add FSM control
* Add transaction busy flags
* Add pipelining
* Add buffering/FIFOs
* Add burst support
* Add byte strobes
* Add parameterized address/data width

---

## Advanced Improvements

* AXI4 full implementation
* AXI interconnect
* DMA controller
* Cache controller
* RISC-V integration
* Multi-master arbitration
* Out-of-order transactions
* Verification using SystemVerilog/UVM

---

# Simulation Suggestions

Recommended simulators:

* ModelSim
* QuestaSim
* Vivado Simulator
* Icarus Verilog
* Verilator

---

# Example Beginner Test Cases

## Write Test

1. Send write address
2. Send write data
3. Receive write response
4. Verify register contents

---

## Read Test

1. Send read address
2. Receive read data
3. Verify returned data

---

## Error Test

1. Access invalid address
2. Verify BRESP/RRESP error handling

---

# Skills Demonstrated

This project demonstrates understanding of:

* Verilog HDL
* RTL design
* AXI protocol basics
* Synchronous digital design
* Handshake protocols
* Timing-aware RTL coding
* Register-based storage
* Master/slave communication

---

# Learning Outcome

This project is a strong beginner foundation for:

* RTL Design Engineering
* FPGA Engineering
* SoC Integration
* Design Verification

It also builds understanding required for advanced protocols and industrial VLSI design.

---

# Author

AXI Master and Slave educational implementation developed as part of RTL and VLSI learning.
