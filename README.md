# RISC-V 32-bit Processor Implementation in Verilog
This project implements a 32-bit RISC-V processor in Verilog HDL, featuring both single-cycle and 5-stage pipelined architectures. The implementation supports the RV32I base integer instruction set architecture (ISA) version 2.0, providing a comprehensive educational and research platform for understanding processor design principles.

## Core Features

1. 32-bit RISC-V RV32I ISA compliance supporting base integer instructions

2. Dual implementation approach: Single-cycle and 5-stage pipelined versions

3. Complete instruction set support for six instruction types:

         R-Type (Register-Register operations)

         I-Type (Immediate operations)

         S-Type (Store operations)

         B-Type (Branch operations)

         J-Type (Jump operations)

         U-Type (Upper immediate operations)

4. Pipelined Architecture
The 5-stage pipeline implementation divides instruction execution into the following stages :

         1. Instruction Fetch (IF) - Retrieves instructions from memory
  
         2. Instruction Decode (ID) - Decodes 32-bit instructions and reads registers

         3. Instruction Execute (EX) - Performs arithmetic operations and determines next PC

         4. Memory Access (MEM) - Handles memory read/write operations
         5. Write Back (WB) - Writes results back to register file

5. Hazard Handling
The pipelined implementation includes a comprehensive hazard detection and resolution unit that handles :

         1. Data hazards through operand forwarding logic

         2. Control hazards via pipeline flushing mechanisms

         3. Structural hazards through proper resource management


## Performance Characteristics Difference

| Aspect/Feature         | Single-Cycle Implementation   | Pipelined Implementation                                         |
|------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------|
| Control Logic                                  | Simple control logic with direct instruction execution           | Improved throughput with overlapped instruction execution  |
| Hardware Complexity                            | Lower hardware complexity suitable for basics     | higher due to additional Pipelined registers     |
| Clock Period                                   | Higher clock period due to critical path through all stages      | Lower clock period means shorter Critical path per stage        |
| Throughput                                     |  Lower (one instruction per cycle) |              Improved throughput with overlapped instruction execution across multiple Stages        |
| Hazard Handling  | Not required |  Needs branch prediction , forwarding  and pipeline flushing for Correctness  |
## Testing and Verification

1. Tested using Bubble Sort algorithm in C and complied in RISC V assembly 
2. Waveform based inspection using Vivado

## Educational Applications
 This implementation serves as an excellent platform for :

1. Computer architecture education demonstrating fundamental processor concepts

2. Digital design learning with practical Verilog HDL examples

3. RISC-V ISA exploration using the open-source instruction set

4. Performance analysis comparing single-cycle vs. pipelined approaches