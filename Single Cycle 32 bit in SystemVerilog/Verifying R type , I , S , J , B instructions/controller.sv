

module controller ( 	input logic [6:0] op ,
		             input logic zero,
			     input logic [2:0] funct3 ,
			     input logic funct7 ,
			     output logic PCSrc , ALUSrc,
			     output logic [1:0] ResultSrc ,
			     output logic MemWrite,
			     output logic RegWrite , jump ,
			     output logic [1:0] ImmSrc,
			     output logic [3:0] ALUControl 
			     );

	
        logic [1:0] ALUop;
        logic Branch;
	
	maindecoder md(  .op(op) , 
	               	.Branch(Branch)  , 
			 .ALUSrc(ALUSrc) ,
		         .MemWrite(MemWrite),
		         .ImmSrc(ImmSrc),
		         .RegWrite(RegWrite),
		         .jump(jump),
		         .ALUOp(ALUop),
			 .ResultSrc(ResultSrc)
		      );

       		      

       ALUdecoder ad(  .op(op) ,
	               .funct3(funct3),
		       .funct7(funct7),
		       .ALUop(ALUop),
		       .ALUControl(ALUControl) 
		     );

	               
	assign  PCSrc = zero & Branch;
endmodule	
	
	
module maindecoder(	input logic [6:0] op ,
	                   
		             output logic Branch, ALUSrc,
			     output logic [1:0] ResultSrc ,
			     output logic MemWrite,
			     output logic RegWrite , jump ,
			     output logic [1:0] ImmSrc,
			     output logic [1:0] ALUOp );

	//output would be control signals complete output is of 11 bit		     
	logic [10:0] control;
	assign {RegWrite , ImmSrc , ALUSrc,MemWrite , ResultSrc , Branch,ALUOp,jump} = control;

        always_comb
	    casex(op)
	        //regwrite_Immsrc_ALUsrc_MEmwrite_ResultSrc_branch_AluOP_jump
		7'b0000011: control = 11'b1_00_1_0_01_0_00_0; //lw
		7'b0100011: control = 11'b0_01_1_1_xx_0_00_0; //sw
		7'b0110011: control = 11'b1_xx_0_0_00_0_10_0;  //r type
		7'b1100011: control = 11'b0_10_0_0_xx_1_01_0;  //beq
		7'b0010011: control = 11'b1_00_1_0_00_0_10_0;  //I type
		7'b1101111: control = 11'b1_11_x_0_10_0_xx_1;  //jal
		default: control = 11'bx_xx_x_x_xx_x_xx_x;
	endcase
endmodule


module ALUdecoder ( input logic [1:0]ALUop ,
                    input logic [2:0] funct3,
		    input logic funct7,
		    input logic [6:0]op ,
		    output logic [3:0] ALUControl );

//	logic [1:0] RtypeSub;

        //assign RtypeSub = funct7 & op5;
//	assign RtypeSub = {op5 , funct7};	

	always_comb
		case(ALUop)
			//lw, sw addi force ADD 
			2'b00: ALUControl = 4'b0000;  //add
		        //Beq force sub	
			2'b01: ALUControl = 4'b0001; //sub
			// R type depends on funct3 
			2'b10: begin
				
		        	case(funct3)
					3'b000:begin
						if(funct7) ALUControl=4'b0001;
						else ALUControl = 4'b0000;
			                	end
					3'b001: ALUControl = 4'b0101;  //SLL	
				                               
			                3'b010: ALUControl=4'b1000; //slt , slti
		                        3'b110: ALUControl=4'b0011; //or , ori
					3'b101: ALUControl = (funct7)?4'b0111:4'b0110; //SRA , SRL
		                        3'b111: ALUControl = 4'b0010; //or , ori
		                     default: ALUControl= 4'b0000;
		                 endcase
			 end
			default:ALUControl = 4'b0000;	 
	        endcase
endmodule


