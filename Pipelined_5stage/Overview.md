
# Discussions

 **1. Fetch Cycle Datapath**
 
The Fetch cycle is the first stage of instruction execution process. The main goal of the fetch cycle is to retrieve the next instruction from memory so        that it can be decoded and executed by the processor.
     
**2. Decode Cycle Datapath** 

The decode cycle in a is the second stage of instruction execution. The main objective of this stage is to interpret       the fetched instruction and prepare      the necessary inputs (registers, control signals) for subsequent stages.

**3. Execution Cycle Datapath**

The Execution cycle is the third stage of instruction execution process. Its main role is to perform the arithmetic or logical   operation dictated by the          instruction, calculate memory addresses for load/store operations, or determine the outcome of a branch.
    
**4. Memory Read/Write Cycle Datapath**

The Memory Read or Write Cycle is the fourth stage of instruction execution process. This stage is responsible for interacting with data memory during load     or store instructions. If the instruction is not a memory operation, this stage is skipped, and the processor moves to the writeback stage.

**5. Write Back Cycle Datapath**

The Writeback cycle is the fifth and final stage of instruction execution process. The main purpose of this stage is to write the result of an instruction (whether it be from an arithmetic operation or a memory load) back to the destination register.

**Note: Hazard Unit**

**Hazard units** in a pipeline processor are responsible for detecting and resolving hazards that can occur when executing instructions in a pipelined         
architecture. 
**Hazards** can cause incorrect program execution or reduce performance by stalling the pipeline. 
- There are three primary types of hazards: **data hazards, control hazards, and structural hazards**. 


    **Structural Hazard**
1. Hardware does not support the execution of instruction in same clock cycle.
2. Without having Two memories RISC-V pipelining architecture will have structural hazard.

     **Data Hazard**
1. Data to be executed is not available.
2. May occur when pipeline is stalled.
3. Solve by using forwarding or bypassing technique.

    **Solution to Data Hazard.**
1. Solving Data Hazards with nops
2. Solving Data Hazard with Forwarding / Bypassing

