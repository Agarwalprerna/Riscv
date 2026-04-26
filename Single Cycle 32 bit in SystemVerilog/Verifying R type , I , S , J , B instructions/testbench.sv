`include "top_level.sv"
//`include "riscvtest.txt"  wrong locate this in working directory 

module testbench();
      logic clk ;
      logic rst;
      logic [31:0] WriteData , DataAdr;
      logic MemWrite;

      //intantiate design to be tested
      top_level dut ( clk , rst, WriteData , DataAdr , MemWrite);

      initial clk = 0;
      always #5 clk = ~clk;

      //initialize test
      initial begin
	      rst <= 1;
	      #10;
	      rst <= 0;
      end


      //check datamemory whether content is stored or not
      always @(negedge clk) begin
	      if(MemWrite) begin
		      if(DataAdr == 100 & WriteData ===25) begin
			      $display("simulation succedded");
			      //$stop;
		      end else begin
                              $display("simulation failed");
			     // $stop;
		      end
	      end
      end
  endmodule






