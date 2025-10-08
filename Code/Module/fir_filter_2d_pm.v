module fir_filter_2d_pm( 
					//Clock
					clk, rst_n,
					//Input
					input_data, valid_dmac, tc_set,
					//Output
					output_data, valid_core
						);
//-------------------------parameters---------------------------//
parameter IDLE_S = 2'b00;
parameter TC_SET_S = 2'b01;
parameter CALC_S = 2'b10;
parameter WAIT_S = 2'b11;

parameter N = 240; // 입력 240bit 받고 안에서 분리
parameter M = 8; // r,g,b 8bit
parameter Q = 9; // Queue size
parameter S = 21; // Mac data size
	
//---------------------Signal & Registers----------------------//

//Clock 
input clk;
input rst_n;
	
//Input
input valid_dmac;
input tc_set;
input [N-1:0] input_data;
	
//Output
output reg [N-1:0] output_data;
output reg valid_core;
	
	
reg tc_write, tc_en, mac_en, mac_clr, output_en;

reg [1:0] ps;
reg [1:0] ns; // state

reg [N-1:0] demux_tc;
reg [N-1:0] demux_img; //Demux's output

reg [3:0] front_ptr;
reg [3:0] rear_ptr; // Queue pointer

reg [M-1:0] filter_tc_r [Q-1:0]; 
reg [M-1:0] filter_tc_g [Q-1:0]; 
reg [M-1:0] filter_tc_b [Q-1:0]; // r,g,b Queues 

reg signed [M-1:0] filter_tc_out_r; 
reg signed [M-1:0] filter_tc_out_g; 
reg signed [M-1:0] filter_tc_out_b; // Tc_FIFO's output 

reg signed [S-1:0] mac_r1, mac_g1, mac_b1; // Mac's output
reg signed [S-1:0] mac_r2, mac_g2, mac_b2;
reg signed [S-1:0] mac_r3, mac_g3, mac_b3;
reg signed [S-1:0] mac_r4, mac_g4, mac_b4;
reg signed [S-1:0] mac_r5, mac_g5, mac_b5;
reg signed [S-1:0] mac_r6, mac_g6, mac_b6;
reg signed [S-1:0] mac_r7, mac_g7, mac_b7;
reg signed [S-1:0] mac_r8, mac_g8, mac_b8;
reg signed [S-1:0] mac_r9, mac_g9, mac_b9;
reg signed [S-1:0] mac_r10, mac_g10, mac_b10;

//-------------------------------------------------------------//
//FSM
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) ps <= IDLE_S;
  else ps <= ns;
end

always @(*) begin
  case(ps)
    IDLE_S : if (valid_dmac == 0) ns <= IDLE_S;
	         else if (tc_set == 1 && valid_dmac == 1) ns <= TC_SET_S;
			 else ns <= CALC_S;
	TC_SET_S : if ((valid_dmac == 0) || (tc_set == 1 && valid_dmac == 1)) ns <= TC_SET_S;
	           else ns <= CALC_S;
	CALC_S : if ((tc_set == 0 && valid_dmac == 1) || (tc_set == 1 && valid_dmac == 1)) ns <= CALC_S;
	         else ns <= WAIT_S;
    WAIT_S : ns <= IDLE_S;
  endcase
end

always @(*) begin
  case(ps)
    IDLE_S : if (valid_dmac == 0) begin
			      mac_clr <= 1;
			      mac_en <= 0;
			      tc_en <= 0;
			      tc_write <= 0;
			      output_en <= 0;
			      valid_core <= 0;
			    end
	          else if (tc_set == 1 && valid_dmac == 1) begin
			      mac_clr <= 0;
			      mac_en <= 0;
			      tc_en <= 1;
			      tc_write <= 1;
			      output_en <= 0;
			      valid_core <= 0;
			    end
			    else begin
			      mac_clr <= 0;
			      mac_en <= 1;
			      tc_en <= 1;
			      tc_write <= 0;
			      output_en <= 0;
			      valid_core <= 0;
			    end
	TC_SET_S : if (tc_set == 1 && valid_dmac == 1) begin
	               mac_clr <= 0;
			       mac_en <= 0;
			       tc_en <= 1;
			       tc_write <= 1;
			       output_en <= 0;
			       valid_core <= 0;
			     end
			     else if (tc_set == 0 && valid_dmac == 1) begin
			       mac_clr <= 0;
			       mac_en <= 1;
			       tc_en <= 1;
			       tc_write <= 0;
			       output_en <= 0;
			       valid_core <= 0;
			     end
			     else begin
			       mac_clr <= 0;
			       mac_en <= 0;
			       tc_en <= 0;
			       tc_write <= 0;
			       output_en <= 0;
			       valid_core <= 0;
			     end 
	CALC_S : if (valid_dmac == 0) begin
	           mac_clr <= 0;
			     mac_en <= 0;
			     tc_en <= 0;
			     tc_write <= 0;
			     output_en <= 1;
			     valid_core <= 0;
			   end
	         else if (tc_set == 0 && valid_dmac == 1) begin
	           mac_clr <= 0;
			     mac_en <= 1;
			     tc_en <= 1;
			     tc_write <= 0;
			     output_en <= 0;
			     valid_core <= 0;
			   end
			   else begin
			     mac_clr <= 0;
			     mac_en <= 0;
			     tc_en <= 0;
			     tc_write <= 0;
			     output_en <= 0;
			     valid_core <= 0;
			   end
	WAIT_S : begin 
	           mac_clr <= 1;
			     mac_en <= 0;
			     tc_en <= 0;
			     tc_write <= 0;
			     output_en <= 0;
			     valid_core <= 1;
				end 
  endcase
end
   
//-------------------------------------------------------------//

//Design here!
	
// Demux
always @(*) begin
  if(tc_write == 0) begin
    demux_img <= input_data;
	demux_tc <= 240'b0;
  end 
  else begin
    demux_img <= 240'b0;
	demux_tc <= input_data;
  end
end
	
// TC_FIFO
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    front_ptr <= -4'b0001;
	rear_ptr <= 4'b0000;
  end
  
  else begin
    if(tc_en == 1 && tc_write == 1) begin
      front_ptr <= front_ptr;
	  if (rear_ptr >= Q-1) rear_ptr <= 0;
	  else rear_ptr <= rear_ptr + 1'b1;
	  filter_tc_r[rear_ptr] <= $signed(demux_tc[7:0]);
      filter_tc_g[rear_ptr] <= $signed(demux_tc[15:8]);
      filter_tc_b[rear_ptr] <= $signed(demux_tc[23:16]);
    end
    else if (tc_en == 1 && tc_write == 0) begin
      rear_ptr <= rear_ptr;
	  if (front_ptr >= Q-1) front_ptr <= 0;
	  else front_ptr <= front_ptr + 1'b1;
    end
    else begin
      rear_ptr <= rear_ptr;
	  front_ptr <= front_ptr;
    end
  end
end

always @(*) begin
  filter_tc_out_r <= filter_tc_r[front_ptr];
  filter_tc_out_g <= filter_tc_g[front_ptr];
  filter_tc_out_b <= filter_tc_b[front_ptr];
end

	//---------------------------MAC-------------------------------//
	//240bit씩(24비트 10개)
//mac_1
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r1 <= 21'b0;
	mac_g1 <= 21'b0;
    mac_b1 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r1 <= 21'b0;
	  mac_g1 <= 21'b0;
	  mac_b1 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r1 <= mac_r1 + filter_tc_out_r * $signed( { 1'b0, demux_img[7:0] } );
      mac_g1 <= mac_g1 + filter_tc_out_g * $signed( { 1'b0, demux_img[15:8] } );
      mac_b1 <= mac_b1 + filter_tc_out_b * $signed( { 1'b0, demux_img[23:16] } );
    end
  
    else begin
      mac_r1 <= mac_r1;
	  mac_g1 <= mac_g1;
	  mac_b1 <= mac_b1;
    end
  end
end
	
//mac_2
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r2 <= 21'b0;
	mac_g2 <= 21'b0;
    mac_b2 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r2 <= 21'b0;
	  mac_g2 <= 21'b0;
	  mac_b2 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r2 <= mac_r2 + filter_tc_out_r * $signed( { 1'b0, demux_img[31:24] } );
      mac_g2 <= mac_g2 + filter_tc_out_g * $signed( { 1'b0, demux_img[39:32] } );
      mac_b2 <= mac_b2 + filter_tc_out_b * $signed( { 1'b0, demux_img[47:40] } );
    end
  
    else begin
      mac_r2 <= mac_r2;
	  mac_g2 <= mac_g2;
	  mac_b2 <= mac_b2;
    end
  end
end
	
//mac_3
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r3 <= 21'b0;
	mac_g3 <= 21'b0;
    mac_b3 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r3 <= 21'b0;
	  mac_g3 <= 21'b0;
	  mac_b3 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r3 <= mac_r3 + filter_tc_out_r * $signed( { 1'b0, demux_img[55:48] } );
      mac_g3 <= mac_g3 + filter_tc_out_g * $signed( { 1'b0, demux_img[63:56] } );
      mac_b3 <= mac_b3 + filter_tc_out_b * $signed( { 1'b0, demux_img[71:64] } );
    end
  
    else begin
      mac_r3 <= mac_r3;
	  mac_g3 <= mac_g3;
	  mac_b3 <= mac_b3;
    end
  end
end

//mac_4
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r4 <= 21'b0;
	mac_g4 <= 21'b0;
    mac_b4 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r4 <= 21'b0;
	  mac_g4 <= 21'b0;
	  mac_b4 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r4 <= mac_r4 + filter_tc_out_r * $signed( { 1'b0, demux_img[79:72] } );
      mac_g4 <= mac_g4 + filter_tc_out_g * $signed( { 1'b0, demux_img[87:80] } );
      mac_b4 <= mac_b4 + filter_tc_out_b * $signed( { 1'b0, demux_img[95:88] } );
    end
  
    else begin
      mac_r4 <= mac_r4;
	  mac_g4 <= mac_g4;
	  mac_b4 <= mac_b4;
    end
  end
end
	
//mac_5
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r5 <= 21'b0;
	mac_g5 <= 21'b0;
    mac_b5 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r5 <= 21'b0;
	  mac_g5 <= 21'b0;
	  mac_b5 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r5 <= mac_r5 + filter_tc_out_r * $signed( { 1'b0, demux_img[103:96] } );
      mac_g5 <= mac_g5 + filter_tc_out_g * $signed( { 1'b0, demux_img[111:104] } );
      mac_b5 <= mac_b5 + filter_tc_out_b * $signed( { 1'b0, demux_img[119:112] } );
    end
  
    else begin
      mac_r5 <= mac_r5;
	  mac_g5 <= mac_g5;
	  mac_b5 <= mac_b5;
    end
  end
end 
	
//mac_6
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r6 <= 21'b0;
	mac_g6 <= 21'b0;
    mac_b6 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r6 <= 21'b0;
	  mac_g6 <= 21'b0;
	  mac_b6 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r6 <= mac_r6 + filter_tc_out_r * $signed( { 1'b0, demux_img[127:120] } );
      mac_g6 <= mac_g6 + filter_tc_out_g * $signed( { 1'b0, demux_img[135:128] } );
      mac_b6 <= mac_b6 + filter_tc_out_b * $signed( { 1'b0, demux_img[143:136] } );
    end
  
    else begin
      mac_r6 <= mac_r6;
	  mac_g6 <= mac_g6;
	  mac_b6 <= mac_b6;
    end
  end
end 
	
//mac_7
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r7 <= 21'b0;
	mac_g7 <= 21'b0;
    mac_b7 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r7 <= 21'b0;
	  mac_g7 <= 21'b0;
	  mac_b7 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r7 <= mac_r7 + filter_tc_out_r * $signed( { 1'b0, demux_img[151:144] } );
      mac_g7 <= mac_g7 + filter_tc_out_g * $signed( { 1'b0, demux_img[159:152] } );
      mac_b7 <= mac_b7 + filter_tc_out_b * $signed( { 1'b0, demux_img[167:160] } );
    end
  
    else begin
      mac_r7 <= mac_r7;
	  mac_g7 <= mac_g7;
	  mac_b7 <= mac_b7;
    end
  end
end 
	
//mac_8
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r8 <= 21'b0;
	mac_g8 <= 21'b0;
    mac_b8 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r8 <= 21'b0;
	  mac_g8 <= 21'b0;
	  mac_b8 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r8 <= mac_r8 + filter_tc_out_r * $signed( { 1'b0, demux_img[175:168] } );
      mac_g8 <= mac_g8 + filter_tc_out_g * $signed( { 1'b0, demux_img[183:176] } );
      mac_b8 <= mac_b8 + filter_tc_out_b * $signed( { 1'b0, demux_img[191:184] } );
    end
  
    else begin
      mac_r8 <= mac_r8;
	  mac_g8 <= mac_g8;
	  mac_b8 <= mac_b8;
    end
  end
end 
	
//mac_9
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r9 <= 21'b0;
	mac_g9 <= 21'b0;
    mac_b9 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r9 <= 21'b0;
	  mac_g9 <= 21'b0;
	  mac_b9 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r9 <= mac_r9 + filter_tc_out_r * $signed( { 1'b0, demux_img[199:192] } );
      mac_g9 <= mac_g9 + filter_tc_out_g * $signed( { 1'b0, demux_img[207:200] } );
      mac_b9 <= mac_b9 + filter_tc_out_b * $signed( { 1'b0, demux_img[215:208] } );
    end
  
    else begin
      mac_r9 <= mac_r9;
	  mac_g9 <= mac_g9;
	  mac_b9 <= mac_b9;
    end
  end
end 
	
//mac_10
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r10 <= 21'b0;
	mac_g10 <= 21'b0;
    mac_b10 <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r10 <= 21'b0;
	  mac_g10 <= 21'b0;
	  mac_b10 <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r10 <= mac_r10 + filter_tc_out_r * $signed( { 1'b0, demux_img[223:216] } );
      mac_g10 <= mac_g10 + filter_tc_out_g * $signed( { 1'b0, demux_img[231:224] } );
      mac_b10 <= mac_b10 + filter_tc_out_b * $signed( { 1'b0, demux_img[239:232] } );
    end
  
    else begin
      mac_r10 <= mac_r10;
	  mac_g10 <= mac_g10;
	  mac_b10 <= mac_b10;
    end
  end
end 
	
	//----------------------Saturation_and_Output_reg------------------------//
	//10개의 mac으로 부터 받는 saturation block
//----------------------Saturation_and_Output_reg_from_mac1------------------------//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) output_data <= 1'b0;
  else if(output_en==1) begin
    if(mac_r1[20]==1) output_data[7:0] <= 0;
	else if(mac_r1[19:0]>255) output_data[7:0] <= 8'b11111111; //255
    else output_data[7:0] <= mac_r1[7:0];
		
	if(mac_g1[20]==1) output_data[15:8] <= 0;
	else if(mac_g1[19:0]>255) output_data[15:8] <= 8'b11111111; //255
    else output_data[15:8] <= mac_g1[7:0];
		
	if(mac_b1[20]==1) output_data[23:16] <= 0;
	else if(mac_b1[19:0]>255) output_data[23:16] <= 8'b11111111; //255
    else output_data[23:16] <= mac_b1[7:0];
  end
  else output_data <= output_data;
end
	
//----------------------Saturation_and_Output_reg_from_mac2------------------------//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) output_data <= 1'b0;
  else if(output_en==1) begin
    if(mac_r2[20]==1) output_data[31:24] <= 0;
	else if(mac_r2[19:0]>255) output_data[31:24] <= 8'b11111111; //255
    else output_data[31:24] <= mac_r2[7:0];
		
	if(mac_g2[20]==1) output_data[39:32] <= 0;
	else if(mac_g2[19:0]>255) output_data[39:32] <= 8'b11111111; //255
    else output_data[39:32] <= mac_g2[7:0];
		
	if(mac_b2[20]==1) output_data[47:40] <= 0;
	else if(mac_b2[19:0]>255) output_data[47:40] <= 8'b11111111; //255
    else output_data[47:40] <= mac_b2[7:0];
  end
  else output_data <= output_data;
end
	
//----------------------Saturation_and_Output_reg_from_mac3------------------------//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) output_data <= 1'b0;
  else if(output_en==1) begin
    if(mac_r3[20]==1) output_data[55:48] <= 0;
	else if(mac_r3[19:0]>255) output_data[55:48] <= 8'b11111111; //255
    else output_data[55:48] <= mac_r3[7:0];
		
	if(mac_g3[20]==1) output_data[63:56] <= 0;
	else if(mac_g3[19:0]>255) output_data[63:56] <= 8'b11111111; //255
    else output_data[63:56] <= mac_g3[7:0];
		
	if(mac_b3[20]==1) output_data[71:64] <= 0;
	else if(mac_b3[19:0]>255) output_data[71:64] <= 8'b11111111; //255
    else output_data[71:64] <= mac_b3[7:0];
  end
  else output_data <= output_data;
end
	
//----------------------Saturation_and_Output_reg_from_mac4------------------------//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) output_data <= 1'b0;
  else if(output_en==1) begin
    if(mac_r4[20]==1) output_data[79:72] <= 0;
	else if(mac_r4[19:0]>255) output_data[79:72] <= 8'b11111111; //255
    else output_data[79:72] <= mac_r4[7:0];
		
	if(mac_g4[20]==1) output_data[87:80] <= 0;
    else if(mac_g4[19:0]>255) output_data[87:80] <= 8'b11111111; //255
    else output_data[87:80] <= mac_g4[7:0];
		
	if(mac_b4[20]==1) output_data[95:88] <= 0;
	else if(mac_b4[19:0]>255) output_data[95:88] <= 8'b11111111; //255
    else output_data[95:88] <= mac_b4[7:0];
  end
  else output_data <= output_data;
end
	
//----------------------Saturation_and_Output_reg_from_mac5------------------------//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) output_data <= 1'b0;
  else if(output_en==1) begin
    if(mac_r5[20]==1) output_data[103:96] <= 0;
	else if(mac_r5[19:0]>255) output_data[103:96] <= 8'b11111111; //255
    else output_data[103:96] <= mac_r5[7:0];
		
	if(mac_g5[20]==1) output_data[111:104] <= 0;
	else if(mac_g5[19:0]>255) output_data[111:104] <= 8'b11111111; //255
    else output_data[111:104] <= mac_g5[7:0];
		
	if(mac_b5[20]==1) output_data[119:112] <= 0;
	else if(mac_b5[19:0]>255) output_data[119:112] <= 8'b11111111; //255
    else output_data[119:112] <= mac_b5[7:0];
  end
  else output_data <= output_data;
end
	
//----------------------Saturation_and_Output_reg_from_mac6------------------------//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) output_data <= 1'b0;
  else if(output_en==1) begin
    if(mac_r6[20]==1) output_data[127:120] <= 0;
	else if(mac_r6[19:0]>255) output_data[127:120] <= 8'b11111111; //255
    else output_data[127:120] <= mac_r6[7:0];
		
	if(mac_g6[20]==1) output_data[135:128] <= 0;
	else if(mac_g6[19:0]>255) output_data[135:128] <= 8'b11111111; //255
    else output_data[135:128] <= mac_g6[7:0];
		
	if(mac_b6[20]==1) output_data[143:136] <= 0;
	else if(mac_b6[19:0]>255) output_data[143:136] <= 8'b11111111; //255
    else output_data[143:136] <= mac_b6[7:0];
  end
  else output_data <= output_data;
end
	
//----------------------Saturation_and_Output_reg_from_mac7------------------------//
	always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) output_data <= 1'b0;
        else if(output_en==1) begin
            if(mac_r7[20]==1) output_data[151:144] <= 0;
	        else if(mac_r7[19:0]>255) output_data[151:144] <= 8'b11111111; //255
            else output_data[151:144] <= mac_r7[7:0];
		
		    if(mac_g7[20]==1) output_data[159:152] <= 0;
	        else if(mac_g7[19:0]>255) output_data[159:152] <= 8'b11111111; //255
            else output_data[159:152] <= mac_g7[7:0];
		
	        if(mac_b7[20]==1) output_data[167:160] <= 0;
	        else if(mac_b7[19:0]>255) output_data[167:160] <= 8'b11111111; //255
            else output_data[167:160] <= mac_b7[7:0];
	    end
	    else output_data <= output_data;
    end
	
//----------------------Saturation_and_Output_reg_from_mac8------------------------//
	always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) output_data <= 1'b0;
        else if(output_en==1) begin
            if(mac_r8[20]==1) output_data[175:168] <= 0;
	        else if(mac_r8[19:0]>255) output_data[175:168] <= 8'b11111111; //255
            else output_data[175:168] <= mac_r8[7:0];
		
		    if(mac_g8[20]==1) output_data[183:176] <= 0;
	        else if(mac_g8[19:0]>255) output_data[183:176] <= 8'b11111111; //255
            else output_data[183:176] <= mac_g8[7:0];
		
	        if(mac_b8[20]==1) output_data[191:184] <= 0;
	        else if(mac_b8[19:0]>255) output_data[191:184] <= 8'b11111111; //255
            else output_data[191:184] <= mac_b8[7:0];
	    end
	    else output_data <= output_data;
    end
	
//----------------------Saturation_and_Output_reg_from_mac9------------------------//
	always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) output_data <= 1'b0;
        else if(output_en==1) begin
            if(mac_r9[20]==1) output_data[199:192] <= 0;
	        else if(mac_r9[19:0]>255) output_data[199:192] <= 8'b11111111; //255
            else output_data[199:192] <= mac_r9[7:0];
		
		    if(mac_g9[20]==1) output_data[207:200] <= 0;
	        else if(mac_g9[19:0]>255) output_data[207:200] <= 8'b11111111; //255
            else output_data[207:200] <= mac_g9[7:0];
		
	        if(mac_b9[20]==1) output_data[215:208] <= 0;
	        else if(mac_b9[19:0]>255) output_data[215:208] <= 8'b11111111; //255
            else output_data[215:208] <= mac_b9[7:0];
	    end
	    else output_data <= output_data;
    end
	
//----------------------Saturation_and_Output_reg_from_mac10------------------------//
	always @(posedge clk or negedge rst_n)
    begin
        if(!rst_n) output_data <= 1'b0;
        else if(output_en==1) begin
            if(mac_r10[20]==1) output_data[223:216] <= 0;
	        else if(mac_r10[19:0]>255) output_data[223:216] <= 8'b11111111; //255
            else output_data[223:216] <= mac_r10[7:0];
		
		    if(mac_g10[20]==1) output_data[231:224] <= 0;
	        else if(mac_g10[19:0]>255) output_data[231:224] <= 8'b11111111; //255
            else output_data[231:224] <= mac_g10[7:0];
		
	        if(mac_b10[20]==1) output_data[239:232] <= 0;
	        else if(mac_b10[19:0]>255) output_data[239:232] <= 8'b11111111; //255
            else output_data[239:232] <= mac_b10[7:0];
	    end
	    else output_data <= output_data;
    end

endmodule