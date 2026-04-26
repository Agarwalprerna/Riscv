`include "Datapath.sv"
`include "controller.sv"

module riscvsingle (  input logic clk ,rst,
	               output logic [31:0] PC , 
		       input logic [31:0] Instr,
		       output logic MemWrite ,
		       output logic [31:0] ALUResult , writedata ,
		       input logic [31:0] ReadData );

		logic ALUSrc , RegWrite , jump , zero;
	        logic [1:0] ResultSrc , ImmSrc;
	        logic [3:0] ALUControl ;	


		       
          controller C( .op(Instr[6:0]) , 
		         .funct3(Instr[14:12]) ,
			 .funct7(Instr[30]) ,
			 .zero(zero) , 
			 .PCSrc(PCSrc) ,
			 .ALUSrc(ALUSrc) , 
			 .MemWrite(MemWrite) ,
			 .RegWrite(RegWrite) , 
			 .jump(jump) ,
			 .ImmSrc(ImmSrc) ,
			 .ResultSrc(ResultSrc) ,
			 .ALUControl(ALUControl)
			 );



	 Datapath dp( .clk(clk) ,
		      .rst(rst) ,
		       .PCSrc(PCSrc) , 
		       .ALUSrc(ALUSrc) ,
		       .ALUControl(ALUControl) ,
		       .ResultSrc(ResultSrc) , 
		       .ImmSrc(ImmSrc) ,
		       .RegWrite(RegWrite) ,
		       .zero(zero) ,
		       .ALUResult(ALUResult) ,
		       .writedata(writedata) ,
		       .PC(PC) , 
		       .ReadData(ReadData)  ,
		       .Instr(Instr)
		       );






endmodule


