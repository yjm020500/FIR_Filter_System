module fir_filter_2d( 
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

parameter N = 24; // 24bit
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

reg signed [S-1:0] mac_r, mac_g, mac_b; // Mac's output

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
	demux_tc <= 24'b0;
  end 
  else begin
    demux_img <= 24'b0;
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
      filter_tc_g[rear_ptr] <= $signed(demux_tc[7:0]);
      filter_tc_b[rear_ptr] <= $signed(demux_tc[7:0]);
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

// Mac
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    mac_r <= 21'b0;
	mac_g <= 21'b0;
    mac_b <= 21'b0;
  end
  else begin
    if (mac_clr == 1) begin
      mac_r <= 21'b0;
	  mac_g <= 21'b0;
	  mac_b <= 21'b0;
    end
  
    else if (mac_clr == 0 && mac_en == 1) begin
      mac_r <= mac_r + filter_tc_out_r * $signed( { 1'b0, demux_img[7:0] } );
      mac_g <= mac_g + filter_tc_out_g * $signed( { 1'b0, demux_img[15:8] } );
      mac_b <= mac_b + filter_tc_out_b * $signed( { 1'b0, demux_img[23:16] } );
    end
  
    else begin
      mac_r <= mac_r;
	  mac_g <= mac_g;
	  mac_b <= mac_b;
    end
  end
end

// Saturation_and_Output_reg
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) output_data <= 24'b0;
  else begin 
    if (output_en == 1) begin
      if (mac_r[20] == 1) output_data[7:0] <= 0;
	  else if (mac_r[19:0] > 255) output_data[7:0] <= 8'b11111111;
	  else output_data[7:0] <= mac_r[7:0];
	
	  if(mac_g[20] == 1) output_data[15:8] <= 0;
	  else if (mac_g[19:0] > 255) output_data[15:8] <= 8'b11111111;
	  else output_data[15:8] <= mac_g[7:0];
	
	  if(mac_b[20] == 1) output_data[23:16] <= 0;
	  else if (mac_b[19:0] > 255) output_data[23:16] <= 8'b11111111;
	  else output_data[23:16] <= mac_b[7:0];
    end
    else output_data <= output_data;
  end
end

endmodule