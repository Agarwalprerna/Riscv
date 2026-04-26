

module Datapath (  input logic clk , rst , 
	           input logic PCSrc , ALUSrc , 
		   input logic [3:0] ALUControl ,
		   input logic [1:0] ResultSrc,
		   input logic [1:0] ImmSrc,
		   input logic RegWrite,
		   output logic zero,
		   output logic [31:0] ALUResult , writedata ,
		   output logic [31:0] PC, 
		   input logic [31:0] ReadData ,
		   input logic [31:0] Instr
		   );

 
          //internal signals
	  logic [31:0] PCNext , PCplus4 , PCTarget ;
          logic [31:0] ImmExt ;
          logic [31:0] SrcA , SrcB;
          logic [31:0] Result;




	//next PC logic 
	flopr #(32) pcreg( clk , rst, PCNext , PC);
	adder pcaddr4( PC , 32'd4 , PCplus4);
	adder pcaddrbranch( PC , ImmExt , PCTarget);
	mux2x1 #(32) pcmux( .a1(PCplus4) , .a2(PCTarget) , .sel(PCSrc) , .y(PCNext));


         //register file logic 
          registerfile rf( .clk(clk) ,
		           .rst(rst) ,
			   .wr_en(RegWrite) , 
		             .rs1_addr(Instr[19:15]) ,
			     .rs2_addr(Instr[24:20]),
			      .rd_addr(Instr[11:7]) ,
			      .RD1(SrcA) ,
			      .RD2(writedata)  
			      ,.datain(Result)
			      );



	 //extend immediate value logic 

           extend ext( .instr(Instr[31:7]) , .ImmSrc(ImmSrc) , .ImmExt(ImmExt) );


	   //ALU logic 
	   mux2x1 #(32) Reg_to_ALU( writedata , ImmExt , ALUSrc ,SrcB );
	   ALU alu ( .A(SrcA) , .B(SrcB) , .opcode(ALUControl), .aluresult(ALUResult) , .zero(zero) );
	   mux3x1 #(32) resultmux( .a1(ALUResult) , .a2(ReadData) ,.a3(PCplus4) , .sel(ResultSrc) , .y(Result) );

 
 endmodule 




	module flopr #(parameter WIDTH =8) (input logic clk ,rst,
		                            input logic [WIDTH-1:0] d,
					    output logic [WIDTH-1:0] q );
              always_ff @(posedge clk or posedge rst)
                      if(rst) q<=0;
                      else q<= d;
       endmodule

       module adder( input [31:0] a , b,output [31:0] y);
           assign y = a+b;
      endmodule

	                    
       //2x1 mux 
      module mux2x1 #(parameter WIDTH = 8) (input logic [WIDTH-1:0] a1 ,a2,
	                                  input logic sel,
					  output logic [WIDTH-1:0] y);
	   assign y = sel?a2:a1;
	   endmodule


      module extend( input logic [31:7] instr,
                     input logic [1:0] ImmSrc , 
                     output logic [31:0] ImmExt );
    
              always_comb
                      case(ImmSrc)
	                   2'b00: ImmExt = { {20{instr[31]}} , instr[31:20] };  //I type
                           2'b01: ImmExt = { {20{instr[31]}} , instr[31:25], instr[11:7]};    // S type
                           2'b10: ImmExt = { {20{instr[31]}} , instr[7] , instr[30:25] , instr[11:8] ,1'b0 };   //B type
                           2'b11: ImmExt = { {12{instr[31]}} , instr[19:12] , instr[20] , instr[30:21] , 1'b0 };  // J type
			   default: ImmExt = 32'bx;
		   endcase
	endmodule


   
	module mux3x1 #(parameter WIDTH = 8) ( input logic [WIDTH-1:0] a1 ,a2,a3 ,input logic [1:0] sel , output logic [WIDTH-1:0] y );
	 
	    assign y = (sel==2'b01) ?a2:( (sel==2'b00)?a1 :a3);
        endmodule

          
	  module ALU(input [31:0] A , B,
		         input [3:0] opcode , 
			    output reg [31:0] aluresult ,
			    output zero);
	      
	      always @(*)begin
                      case(opcode)
			    
	                   // 3'b000: aluresult = A+B;
                            //3'b001: aluresult = A-B;
			    //3'b010: aluresult = $signed(A) < $signed(B) ? 32'd1:32'd0; //SLT
			    //3'b011: aluresult = A<<B[4:0] ; //SLL
			    //3'b100: aluresult = A>>B[4:0] ;//SRL
			    //3'b101: aluresult = A ^ B; //Xor
                            //3'b110:  aluresult = A&B;
                            //3'b111: aluresult = A|B;
			    
			    4'b0000: aluresult = A+B;
			    4'b0001: aluresult = A-B;
                            4'b0010: aluresult = A&B;
                            4'b0011: aluresult = A|B;
                            4'b0100: aluresult = A^B;
                            4'b0101: aluresult = A<<B[4:0];
                            4'b0110: aluresult = A>>B[4:0];
                            4'b0111: aluresult = ($signed(A) <$signed(B))? 32'b1:32'b0;
			    4'b1000: aluresult = (A < B)? 32'b1: 32'b0;

			    default: aluresult = 32'b0;

		    endcase
	    end
	    assign zero =( aluresult == 32'b0);
	    endmodule

                            			    
          module registerfile( input clk ,rst, wr_en ,
		                 input [4:0] rs1_addr, rs2_addr , rd_addr ,
				 input [31:0] datain ,
				 output [31:0] RD1 , RD2 );

		reg [31:0] REG[0:31] ;

        //we can initialize register file 
//	initial begin
              // for(int i=0 ;i<32;i++)
                //
		      // REG[0] = 32'd0;
		       //REG[1]= 32'd3;
		       //REG[2] = 32'd2;
		       //REG[3] = 32'd9;
		       //REG[4] = 32'd6;
		       //REG[5] = 32'd6;
		       //REG[6] = 32'd10;
		       //REG[7] = 32'd0;
		       //REG[8] = 32'd0;
		       //REG[9] = 32'd4;
	      


//        end

	assign RD1 = (rs1_addr!= 0)? REG[rs1_addr] :0;
        assign RD2 = (rs2_addr!= 0)? REG[rs2_addr] :0;


	always @(posedge clk) begin
		if(rst)begin
			for(int i=0 ;i<32;i++)
				REG[i] <= 32'b0;
                end
                else if(!rst) begin
		       REG[0] = 32'd0;
		       REG[1]= 32'd3;
		       REG[2] = 32'd2;
		       REG[3] = 32'd9;
		       REG[4] = 32'd0;
		       REG[5] = 32'd6;
		       REG[6] = 32'd10;
		       REG[7] = 32'd0;
		       REG[8] = 32'd0;
		       REG[9] = 32'd4;
	      
  	
		end
		else if( wr_en && rd_addr!=0)begin
			REG[rd_addr] <= datain;
		end
	end
	endmodule


	        		    
