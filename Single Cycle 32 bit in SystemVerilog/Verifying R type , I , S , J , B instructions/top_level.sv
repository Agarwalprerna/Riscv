`include "riscvsingle.sv"
//`include "riscvtest.txt"

module top_level ( input logic clk ,rst , output logic [31:0] WriteData , DataAdr , output logic MemWrite);

     
	logic [31:0] Instr , PC , ReadData;

	riscvsingle rvsingle(.clk(clk) , .rst(rst), 
	                      .PC(PC) , 
			       .Instr(Instr)  ,
			       .MemWrite(MemWrite) , 
			       .ALUResult(DataAdr) ,
			       .writedata(WriteData) ,
			       .ReadData(ReadData) 
			       );

          



	//instruction memory
	Instrmem Instrmem( .Addr(PC) , .machine_code(Instr) );

        //Data memory
	Datamem	 Datamem( .Addr(DataAdr) , .WE(MemWrite) , .clk(clk) , .WD(WriteData) , .RD(ReadData) , .rst(rst) );


endmodule






	module Instrmem( input logic [31:0] Addr , output logic [31:0] machine_code);

	    //memory
	    logic [31:0] RAM[63:0] ; //locations could be larger but taking here 64

	   // initial 
	//
	//	    $readmemh("riscvtest.txt", RAM); //load hex file 

	initial begin
		RAM[0] = 32'h0062E233;
		RAM[1] = 32'h0062E233;
		RAM[2] = 32'h0064A423;
		RAM[3] = 32'hFFC4A303;
		RAM[4] = 32'h00720163;
		RAM[5] = 32'h004000EF;
	end

	    assign machine_code = RAM[Addr[31:2]];   //why 0 and 1 bit left see microarchietecture   //for word aligned

	 endmodule


	 module Datamem( input logic clk , WE ,rst,
		         input logic [31:0] Addr ,WD ,
			 output logic [31:0] RD 
			 ); 

	      //memory 
	      logic [31:0] RAM[100:0]; 

	      always_ff @(posedge clk) begin
		      if(rst) begin
           	 // initial begin
		         for(int i =0 ; i<=100 ; i++)
			   RAM[i] <= 32'd0;
                      end
		   //then set specific locations
		      else if (!rst) begin
		           RAM[0] = 32'd0;  //byte address 0
		           RAM[1] = 32'd2;  //bytre addr 4
		           RAM[2] = 32'd7;   //byte addr 8
		           RAM[3] = 32'd0;   //byte addr 12
            
	              end
	           //write 
                   //always_ff @(posedge clk)

	               else  if(WE) 
			       RAM[Addr[31:2]] <= WD;
	       end

	    //read 
            assign RD = RAM[Addr[31:2]]; 
   
	   
		   
	endmodule

