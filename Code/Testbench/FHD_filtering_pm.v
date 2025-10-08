`timescale 1ns / 100ps
module FHD_filtering_pm;

parameter IW = 1920; // 이미지 폭
parameter IH = 1080; // 이미지 높이
parameter RGB = 24; // RGB 24비트
parameter RGBTEN = 24*10; // RGB 24비트 - 10개씩
parameter DW = 8; // R, G, B 8비트
parameter NE = IW*IH*3; // R, G, B 개수
parameter IMG = IW*IH; // 이미지 픽셀 수
// parameter IMG_FILE = "fir_src_img_1920x1080.rgb";
// parameter TC_FILE = "filter_tap.dat"; // 굳이 할 필요 있을까
parameter F = 3; // 필터 크기 F * F 

parameter OUTPUT_FILE = "fir_dest_img_1920x1080_pm.rgb";


// -------------------------------------------------------------------- 
reg [RGB-1:0] memory_r [0:IMG-1];
reg [RGB-1:0] FHD_image_pixels [0:IH-1][0:IW-1]; // 이미지 reshape 결과물

reg [RGB-1:0] Get_pixels_to_filtering [0:(F*F-1)]; // 9개 픽셀 가져올 memories

integer f, g;
integer m = 0;


// -------------------------------------------------------------------- 
reg [RGB-1:0] all_input_data [0:(IMG*9)+9 - 1];
reg [RGB-1:0] tap_coefficient [0:8];

integer j, k;
integer z; // input_data 생성 이동 변수
integer x = 9; // input_data 생성 이동 변수

integer mk_cnt = 0; // 240 bit input 생성 이동 변수
integer dd;
integer input_cnt_get;
reg [RGBTEN-1:0] mk_new_input [0:(IMG*9)/10 - 1];

// -------------------------------------------------------------------- 
integer input_cnt = 0;


reg [RGBTEN-1:0] all_output_data [0:IMG/10 - 1] ;
integer output_cnt = 0;

integer ori, dest;

// -------------------------------------------------------------------- 

reg clk, rst_n;
reg [RGBTEN-1:0] input_data; // input image or filter
reg tc_set, valid_dmac; // input signal
wire valid_core;
wire [RGBTEN-1:0] output_data;

integer p; // valid_dmac 이동 변수

fir_filter_2d_pm UFFPM (.clk(clk), .rst_n(rst_n),
                   .input_data(input_data), .valid_dmac(valid_dmac), .tc_set(tc_set), 
				   .output_data(output_data), .valid_core(valid_core));
				   
// 신호 제어 ----------------------------------				   
initial begin 
      clk = 1'b0;
      rst_n = 1'b0;
  #10 rst_n = 1'b1;
end

always #10 clk = ~clk; // clock rate 설정

initial begin
  #10010 valid_dmac = 1'b1;
  #360 valid_dmac = 1'b0;
  for (p=0; p<IMG/10; p=p+1) begin
    #80 valid_dmac = 1'b1;
	#180 valid_dmac = 1'b0;
  end
  
  #20;
  
  dest = $fopen(OUTPUT_FILE, "wb");
  for (ori=0; ori<IMG/10; ori=ori+1) begin
	$fwrite(dest, "%c%c%c", all_output_data[ori][239-:8], all_output_data[ori][231-:8], all_output_data[ori][223-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][215-:8], all_output_data[ori][207-:8], all_output_data[ori][199-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][191-:8], all_output_data[ori][183-:8], all_output_data[ori][175-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][167-:8], all_output_data[ori][159-:8], all_output_data[ori][151-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][143-:8], all_output_data[ori][135-:8], all_output_data[ori][127-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][119-:8], all_output_data[ori][111-:8], all_output_data[ori][103-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][95-:8], all_output_data[ori][87-:8], all_output_data[ori][79-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][71-:8], all_output_data[ori][63-:8], all_output_data[ori][55-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][47-:8], all_output_data[ori][39-:8], all_output_data[ori][31-:8]);
	$fwrite(dest, "%c%c%c", all_output_data[ori][23-:8], all_output_data[ori][15-:8], all_output_data[ori][7-:8]);
  end
  $fclose(dest);
  
  #1000 $stop;
end

initial begin
  #10010 tc_set = 1'b1;
  #180 tc_set = 1'b0;
end
// -------------------------------------------------------------------- 

// FHD 이미지 픽셀값 추출 (from , rgb file)
/*
integer i, r, dest_fd;
integer n = 0;

// reg [DW-1:0] memory [0:NE-1];
reg [DW-1:0] read_data;

reg [DW-1:0] R;
reg [DW-1:0] G;
reg [DW-1:0] B;

reg [RGB-1:0] memory_r [0:IMG-1];

initial begin
  dest_fd = $fopen(IMG_FILE, "rb");
  for (i=0; i<NE; i=i+1) begin
    r = $fread(read_data, dest_fd);
	if (r < 0) $display("Data read error \n");
	else begin
	  if (i % 3 == 0) R = read_data;
	  else if (i % 3 == 1) G = read_data;
	  else begin
	    B = read_data;
	    $display("%h ", {R, G, B});
	    memory_r[n] = {R, G, B}; // 3번에 한번씩만 memory_r 에 값 저장
	    n = n + 1;
	  end
	end
  end
  $fclose(dest_fd);
end

endmodule 
*/

// 이미지 FHD 형식으로 reshape
initial begin
  for (f=0; f<IH; f=f+1) begin
    for (g=0; g<IW; g=g+1) begin
      FHD_image_pixels[f][g] = memory_r[m];
	  m = m + 1;
    end
  end

/* 이미지 픽셀 확인 
  $display("Reshaped 2D memory");
  for (j=0; j<IH; j=j+1) begin
    for (k=0; k<IW; k=k+1) begin
	  $display("%h ", FHD_image_pixels[j][k]);
	end
	$display("");
  end
*/
end

// 필터링할 이미지 가져와 input_data 만들기 ----------------------------------
initial begin
  // tap co. 저장
  tap_coefficient[0] = 24'h020202;
  tap_coefficient[1] = 24'h010101;
  tap_coefficient[2] = 24'h000000;
  tap_coefficient[3] = 24'h010101;
  tap_coefficient[4] = 24'h000000;
  tap_coefficient[5] = 24'hffffff;
  tap_coefficient[6] = 24'h000000;
  tap_coefficient[7] = 24'hffffff;
  tap_coefficient[8] = 24'hfefefe;
  
  for (x=0; x<9; x=x+1) all_input_data[x] = tap_coefficient[x];
  
  // target pixel 9개 가져오기
  for (j=0; j<IH; j=j+1) begin
    for (k=0; k<IW; k=k+1) begin
      if (j == 0 || k == 0) Get_pixels_to_filtering[0] = 24'b0;
	  else Get_pixels_to_filtering[0] = FHD_image_pixels[j-1][k-1];
	
	  if (j == 0) Get_pixels_to_filtering[1] = 24'b0;
	  else Get_pixels_to_filtering[1] = FHD_image_pixels[j-1][k];
	
	  if (j == 0 || k == IW-1) Get_pixels_to_filtering[2] = 24'b0;
	  else Get_pixels_to_filtering[2] = FHD_image_pixels[j-1][k+1];
	
	  if (k == 0) Get_pixels_to_filtering[3] = 24'b0;
	  else Get_pixels_to_filtering[3] = FHD_image_pixels[j][k-1];
	
	  Get_pixels_to_filtering[4] = FHD_image_pixels[j][k];

      if (k == IW-1) Get_pixels_to_filtering[5] = 24'b0;
	  else Get_pixels_to_filtering[5] = FHD_image_pixels[j][k+1];
	
	  if (j == IH-1 || k == 0) Get_pixels_to_filtering[6] = 24'b0;
	  else Get_pixels_to_filtering[6] = FHD_image_pixels[j+1][k-1];
	  
	  if (j == IH-1) Get_pixels_to_filtering[7] = 24'b0;
	  else Get_pixels_to_filtering[7] = FHD_image_pixels[j+1][k];
	  
	  if (j == IH-1 || k == IW-1) Get_pixels_to_filtering[8] = 24'b0;
	  else Get_pixels_to_filtering[8] = FHD_image_pixels[j+1][k+1];
	  
	  for (z=0; z<9; z=z+1) begin
	    all_input_data[x] = Get_pixels_to_filtering[z];
		x = x + 1;
      end
    end	  
  end

  for (dd=9; dd<(IMG*9); dd=dd+90) begin
    for (input_cnt_get=0; input_cnt_get<9; input_cnt_get=input_cnt_get+1) begin
	  mk_new_input[mk_cnt][239-:24] = all_input_data[dd+9*0+input_cnt_get];
	  mk_new_input[mk_cnt][215-:24] = all_input_data[dd+9*1+input_cnt_get];
	  mk_new_input[mk_cnt][191-:24] = all_input_data[dd+9*2+input_cnt_get];
	  mk_new_input[mk_cnt][167-:24] = all_input_data[dd+9*3+input_cnt_get];
	  mk_new_input[mk_cnt][143-:24] = all_input_data[dd+9*4+input_cnt_get];
	  mk_new_input[mk_cnt][119-:24] = all_input_data[dd+9*5+input_cnt_get];
	  mk_new_input[mk_cnt][95-:24] = all_input_data[dd+9*6+input_cnt_get];
	  mk_new_input[mk_cnt][71-:24] = all_input_data[dd+9*7+input_cnt_get];
	  mk_new_input[mk_cnt][47-:24] = all_input_data[dd+9*8+input_cnt_get];
	  mk_new_input[mk_cnt][23-:24] = all_input_data[dd+9*9+input_cnt_get];
		
	  mk_cnt = mk_cnt + 1;
	end
  end
  
/*   	mk_new_input[mk_cnt][239-:24] = all_input_data[new_input_cnt+9];
	mk_new_input[mk_cnt][215-:24] = all_input_data[new_input_cnt+8];
	mk_new_input[mk_cnt][191-:24] = all_input_data[new_input_cnt+7];
	mk_new_input[mk_cnt][167-:24] = all_input_data[new_input_cnt+6];
	mk_new_input[mk_cnt][143-:24] = all_input_data[new_input_cnt+5];
	mk_new_input[mk_cnt][119-:24] = all_input_data[new_input_cnt+4];
	mk_new_input[mk_cnt][95-:24] = all_input_data[new_input_cnt+3];
	mk_new_input[mk_cnt][71-:24] = all_input_data[new_input_cnt+2];
	mk_new_input[mk_cnt][47-:24] = all_input_data[new_input_cnt+1];
	mk_new_input[mk_cnt][23-:24] = all_input_data[new_input_cnt]; */
end
// -------------------------------------------------------------------- 


// input_data 신호 만들기 ----------------------------------
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) input_data = 240'bz;
  else begin
    if(valid_dmac == 1 && tc_set == 1) begin
      input_data = all_input_data[input_cnt];
      input_cnt = input_cnt + 1;
	end
	
	else if (valid_dmac == 1) begin
      // mk_new_input 넣기
	  input_data = mk_new_input[input_cnt-9];
	  input_cnt = input_cnt + 1;
	end
	
	else input_data = 240'bz;
  end
end

// .rgb 파일 만들기 위한 ouput_data 임시 저장 메모리 만들기 ----------------------------------
always @(negedge valid_dmac) begin
  #40;
  all_output_data[output_cnt] = output_data;
  // all_output_data[output_cnt][23:16] = output_data[7:0];
  // all_output_data[output_cnt][15:8] = output_data[15:8];
  // all_output_data[output_cnt][7:0] = output_data[23:16];
  output_cnt = output_cnt + 1;
end

endmodule



