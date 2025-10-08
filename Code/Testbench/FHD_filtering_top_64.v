`timescale 1ns / 100ps
module FHD_filtering_top_64;

parameter IW = 1920; // 이미지 폭
parameter IH = 1080; // 이미지 높이
parameter RGB = 24; // RGB 24비트
parameter DW = 8; // R, G, B 8비트
parameter NE = IW*IH*3; // R, G, B 개수
parameter IMG = IW*IH; // 이미지 픽셀 수
parameter D = 64;
parameter DIV = IMG*9 / 64;
parameter IMG_FILE = "fir_src_img_1920x1080.rgb";
// parameter TC_FILE = "filter_tap.dat"; // 굳이 할 필요 있을까
parameter F = 3; // 필터 크기 F * F 

parameter OUTPUT_FILE = "fir_dest_img_1920x1080_top_64.rgb";


// -------------------------------------------------------------------- 
reg [RGB-1:0] memory_r [0:IMG-1];
reg [RGB-1:0] FHD_image_pixels [0:IH-1][0:IW-1]; // 이미지 reshape 결과물

reg [RGB-1:0] Get_pixels_to_filtering [0:(F*F-1)]; // 9개 픽셀 가져올 memories

integer f, g;
integer m = 0;


// -------------------------------------------------------------------- 
reg [RGB-1:0] all_input_data [0:(IMG*9)+9];
reg [RGB-1:0] tap_coefficient [0:8];

integer j, k;
integer z; // input_data 생성 이동 변수
integer x = 9; // input_data 생성 이동 변수

reg [RGB-1:0] new_div_input [0:D-1][0:DIV-1]; // 16개로 나눠지는 배열 (2차원)
integer div; // all_input_data 나누는 개수 이동 변수
integer div_input_size; // 한 배열 당 들어가는 데이터 수
integer div_input_cap = 9; // tap_coefficient 빼고 loop 시작

// -------------------------------------------------------------------- 
integer input_cnt = 0;
integer div_input_data_cap = 0;

integer output_cnt = 0;

reg [RGB-1:0] new_div_output [0:D-1][0:(IMG/D)-1];
reg [RGB-1:0] final_output [0:IMG-1];
integer oo;
integer oop;
integer o = 0;
integer ori, dest;

// -------------------------------------------------------------------- 

reg clk, rst_n;
reg [RGB-1:0] input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8, input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16; // input image or filter
reg [RGB-1:0] input_data17, input_data18, input_data19, input_data20, input_data21, input_data22, input_data23, input_data24, input_data25, input_data26, input_data27, input_data28, input_data29, input_data30, input_data31, input_data32;
reg [RGB-1:0] input_data33, input_data34, input_data35, input_data36, input_data37, input_data38, input_data39, input_data40, input_data41, input_data42, input_data43, input_data44, input_data45, input_data46, input_data47, input_data48;
reg [RGB-1:0] input_data49, input_data50, input_data51, input_data52, input_data53, input_data54, input_data55, input_data56, input_data57, input_data58, input_data59, input_data60, input_data61, input_data62, input_data63, input_data64; 
reg tc_set, valid_dmac; // input signal
wire valid_core;
wire [RGB-1:0] output_data1, output_data2, output_data3, output_data4, output_data5, output_data6, output_data7, output_data8, output_data9, output_data10, output_data11, output_data12, output_data13, output_data14, output_data15, output_data16;
wire [RGB-1:0] output_data17, output_data18, output_data19, output_data20, output_data21, output_data22, output_data23, output_data24, output_data25, output_data26, output_data27, output_data28, output_data29, output_data30, output_data31, output_data32;
wire [RGB-1:0] output_data33, output_data34, output_data35, output_data36, output_data37, output_data38, output_data39, output_data40, output_data41, output_data42, output_data43, output_data44, output_data45, output_data46, output_data47, output_data48;
wire [RGB-1:0] output_data49, output_data50, output_data51, output_data52, output_data53, output_data54, output_data55, output_data56, output_data57, output_data58, output_data59, output_data60, output_data61, output_data62, output_data63, output_data64;

integer p; // valid_dmac 이동 변수


fir_filter_2d_top_64 UFFT (.clk(clk), .rst_n(rst_n),
                           .input_data1(input_data1), .input_data2(input_data2), .input_data3(input_data3), .input_data4(input_data4),
						   .input_data5(input_data5), .input_data6(input_data6), .input_data7(input_data7), .input_data8(input_data8),
                           .input_data9(input_data9), .input_data10(input_data10) ,.input_data11(input_data11), .input_data12(input_data12),
						   .input_data13(input_data13), .input_data14(input_data14), .input_data15(input_data15), .input_data16(input_data16),
						   .input_data17(input_data17), .input_data18(input_data18), .input_data19(input_data19), .input_data20(input_data20), 
						   .input_data21(input_data21), .input_data22(input_data22), .input_data23(input_data23), .input_data24(input_data24), 
						   .input_data25(input_data25), .input_data26(input_data26), .input_data27(input_data27), .input_data28(input_data28), 
						   .input_data29(input_data29), .input_data30(input_data30), .input_data31(input_data31), .input_data32(input_data32),
						   .input_data33(input_data33), .input_data34(input_data34), .input_data35(input_data35), .input_data36(input_data36), 
						   .input_data37(input_data37), .input_data38(input_data38), .input_data39(input_data39), .input_data40(input_data40), 
						   .input_data41(input_data41), .input_data42(input_data42), .input_data43(input_data43), .input_data44(input_data44), 
						   .input_data45(input_data45), .input_data46(input_data46), .input_data47(input_data47), .input_data48(input_data48),
						   .input_data49(input_data49), .input_data50(input_data50), .input_data51(input_data51), .input_data52(input_data52), 
						   .input_data53(input_data53), .input_data54(input_data54), .input_data55(input_data55), .input_data56(input_data56), 
						   .input_data57(input_data57), .input_data58(input_data58), .input_data59(input_data59), .input_data60(input_data60), 
						   .input_data61(input_data61), .input_data62(input_data62), .input_data63(input_data63), .input_data64(input_data64),
						   .valid_dmac(valid_dmac), .tc_set(tc_set), 
						   .output_data1(output_data1), .output_data2(output_data2), .output_data3(output_data3), .output_data4(output_data4),
						   .output_data5(output_data5), .output_data6(output_data6), .output_data7(output_data7), .output_data8(output_data8),
						   .output_data9(output_data9), .output_data10(output_data10), .output_data11(output_data11), .output_data12(output_data12),
						   .output_data13(output_data13), .output_data14(output_data14), .output_data15(output_data15), .output_data16(output_data16),
                           .output_data17(output_data17), .output_data18(output_data18), .output_data19(output_data19), .output_data20(output_data20), 
						   .output_data21(output_data21), .output_data22(output_data22), .output_data23(output_data23), .output_data24(output_data24), 
						   .output_data25(output_data25), .output_data26(output_data26), .output_data27(output_data27), .output_data28(output_data28), 
						   .output_data29(output_data29), .output_data30(output_data30), .output_data31(output_data31), .output_data32(output_data32),
                           .output_data33(output_data33), .output_data34(output_data34), .output_data35(output_data35), .output_data36(output_data36), 
						   .output_data37(output_data37), .output_data38(output_data38), .output_data39(output_data39), .output_data40(output_data40), 
						   .output_data41(output_data41), .output_data42(output_data42), .output_data43(output_data43), .output_data44(output_data44), 
						   .output_data45(output_data45), .output_data46(output_data46), .output_data47(output_data47), .output_data48(output_data48),
                           .output_data49(output_data49), .output_data50(output_data50), .output_data51(output_data51), .output_data52(output_data52), 
						   .output_data53(output_data53), .output_data54(output_data54), .output_data55(output_data55), .output_data56(output_data56), 
						   .output_data57(output_data57), .output_data58(output_data58), .output_data59(output_data59), .output_data60(output_data60), 
						   .output_data61(output_data61), .output_data62(output_data62), .output_data63(output_data63), .output_data64(output_data64),						   
						   .valid_core(valid_core));
				   
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
  for (p=0; p<(IMG/64)-1; p=p+1) begin
    #80 valid_dmac = 1'b1;
	#180 valid_dmac = 1'b0;
  end
  
  #20;
  
  for (oo=0; oo<D; oo=oo+1) begin
    for (oop=0; oop<IMG/64; oop=oop+1) begin
      final_output[o] = new_div_output[oo][oop];
	  o = o + 1;
	end
  end
    
  dest = $fopen(OUTPUT_FILE, "wb");
  for (ori=0; ori<IMG; ori=ori+1) begin
	$fwrite(dest, "%c%c%c", final_output[ori][23-:8], final_output[ori][15-:8], final_output[ori][7-:8]);
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
  

  for (div=0; div<D; div=div+1) begin
    for (div_input_size=0; div_input_size<DIV; div_input_size=div_input_size+1) begin
	  new_div_input[div][div_input_size] = all_input_data[div_input_cap];
	  div_input_cap = div_input_cap + 1;
	end
  end
end

// -------------------------------------------------------------------- 


// input_data 신호 만들기 ----------------------------------
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    input_data1 = 24'bz;
	input_data2 = 24'bz;
	input_data3 = 24'bz;
	input_data4 = 24'bz;
	input_data5 = 24'bz;
	input_data6 = 24'bz;
	input_data7 = 24'bz;
	input_data8 = 24'bz;
	input_data9 = 24'bz;
	input_data10 = 24'bz;
	input_data11 = 24'bz;
	input_data12 = 24'bz;
	input_data13 = 24'bz;
	input_data14 = 24'bz;
	input_data15 = 24'bz;
	input_data16 = 24'bz;
	input_data17 = 24'bz;
	input_data18 = 24'bz;
	input_data19 = 24'bz;
	input_data20 = 24'bz;
	input_data21 = 24'bz;
	input_data22 = 24'bz;
	input_data23 = 24'bz;
	input_data24 = 24'bz;
	input_data25 = 24'bz;
	input_data26 = 24'bz;
	input_data27 = 24'bz;
	input_data28 = 24'bz;
	input_data29 = 24'bz;
	input_data30 = 24'bz;
	input_data31 = 24'bz;
	input_data32 = 24'bz;
	input_data33 = 24'bz;
	input_data34 = 24'bz;
	input_data35 = 24'bz;
	input_data36 = 24'bz;
	input_data37 = 24'bz;
	input_data38 = 24'bz;
	input_data39 = 24'bz;
	input_data40 = 24'bz;
	input_data41 = 24'bz;
	input_data42 = 24'bz;
	input_data43 = 24'bz;
	input_data44 = 24'bz;
	input_data45 = 24'bz;
	input_data46 = 24'bz;
	input_data47 = 24'bz;
	input_data48 = 24'bz;
	input_data49 = 24'bz;
	input_data50 = 24'bz;
	input_data51 = 24'bz;
	input_data52 = 24'bz;
	input_data53 = 24'bz;
	input_data54 = 24'bz;
	input_data55 = 24'bz;
	input_data56 = 24'bz;
	input_data57 = 24'bz;
	input_data58 = 24'bz;
	input_data59 = 24'bz;
	input_data60 = 24'bz;
	input_data61 = 24'bz;
	input_data62 = 24'bz;
	input_data63 = 24'bz;
	input_data64 = 24'bz;
	
	
  end
  else begin
    if(valid_dmac == 1 && tc_set == 1) begin
      input_data1 = all_input_data[input_cnt];
	  input_data2 = all_input_data[input_cnt];
	  input_data3 = all_input_data[input_cnt];
	  input_data4 = all_input_data[input_cnt];
	  input_data5 = all_input_data[input_cnt];
	  input_data6 = all_input_data[input_cnt];
	  input_data7 = all_input_data[input_cnt];
	  input_data8 = all_input_data[input_cnt];
	  input_data9 = all_input_data[input_cnt];
	  input_data10 = all_input_data[input_cnt];
	  input_data11 = all_input_data[input_cnt];
	  input_data12 = all_input_data[input_cnt];
	  input_data13 = all_input_data[input_cnt];
	  input_data14 = all_input_data[input_cnt];
	  input_data15 = all_input_data[input_cnt];
	  input_data16 = all_input_data[input_cnt];
	  input_data17 = all_input_data[input_cnt];
	  input_data18 = all_input_data[input_cnt];
	  input_data19 = all_input_data[input_cnt];
	  input_data20 = all_input_data[input_cnt];
	  input_data21 = all_input_data[input_cnt];
	  input_data22 = all_input_data[input_cnt];
	  input_data23 = all_input_data[input_cnt];
	  input_data24 = all_input_data[input_cnt];
	  input_data25 = all_input_data[input_cnt];
	  input_data26 = all_input_data[input_cnt];
	  input_data27 = all_input_data[input_cnt];
	  input_data28 = all_input_data[input_cnt];
	  input_data29 = all_input_data[input_cnt];
	  input_data30 = all_input_data[input_cnt];
	  input_data31 = all_input_data[input_cnt];
	  input_data32 = all_input_data[input_cnt];
	  input_data33 = all_input_data[input_cnt];
  	  input_data34 = all_input_data[input_cnt];
	  input_data35 = all_input_data[input_cnt];
	  input_data36 = all_input_data[input_cnt];
	  input_data37 = all_input_data[input_cnt];
	  input_data38 = all_input_data[input_cnt];
	  input_data39 = all_input_data[input_cnt];
	  input_data40 = all_input_data[input_cnt];
	  input_data41 = all_input_data[input_cnt];
	  input_data42 = all_input_data[input_cnt];
	  input_data43 = all_input_data[input_cnt];
	  input_data44 = all_input_data[input_cnt];
	  input_data45 = all_input_data[input_cnt];
	  input_data46 = all_input_data[input_cnt];
	  input_data47 = all_input_data[input_cnt];
	  input_data48 = all_input_data[input_cnt];
	  input_data49 = all_input_data[input_cnt];
	  input_data50 = all_input_data[input_cnt];
	  input_data51 = all_input_data[input_cnt];
	  input_data52 = all_input_data[input_cnt];
	  input_data53 = all_input_data[input_cnt];
	  input_data54 = all_input_data[input_cnt];
	  input_data55 = all_input_data[input_cnt];
	  input_data56 = all_input_data[input_cnt];
	  input_data57 = all_input_data[input_cnt];
	  input_data58 = all_input_data[input_cnt];
	  input_data59 = all_input_data[input_cnt];
	  input_data60 = all_input_data[input_cnt];
	  input_data61 = all_input_data[input_cnt];
	  input_data62 = all_input_data[input_cnt];
	  input_data63 = all_input_data[input_cnt];
	  input_data64 = all_input_data[input_cnt];
      input_cnt = input_cnt + 1;
	end
	else if(valid_dmac == 1) begin
	  input_data1 = new_div_input[0][div_input_data_cap];
	  input_data2 = new_div_input[1][div_input_data_cap];
	  input_data3 = new_div_input[2][div_input_data_cap];
	  input_data4 = new_div_input[3][div_input_data_cap];
	  input_data5 = new_div_input[4][div_input_data_cap];
	  input_data6 = new_div_input[5][div_input_data_cap];
	  input_data7 = new_div_input[6][div_input_data_cap];
	  input_data8 = new_div_input[7][div_input_data_cap];
	  input_data9 = new_div_input[8][div_input_data_cap];
	  input_data10 = new_div_input[9][div_input_data_cap];
	  input_data11 = new_div_input[10][div_input_data_cap];
	  input_data12 = new_div_input[11][div_input_data_cap];
	  input_data13 = new_div_input[12][div_input_data_cap];
	  input_data14 = new_div_input[13][div_input_data_cap];
	  input_data15 = new_div_input[14][div_input_data_cap];
	  input_data16 = new_div_input[15][div_input_data_cap];
	  input_data17 = new_div_input[16][div_input_data_cap];
	  input_data18 = new_div_input[17][div_input_data_cap];
	  input_data19 = new_div_input[18][div_input_data_cap];
	  input_data20 = new_div_input[19][div_input_data_cap];
	  input_data21 = new_div_input[20][div_input_data_cap];
	  input_data22 = new_div_input[21][div_input_data_cap];
	  input_data23 = new_div_input[22][div_input_data_cap];
	  input_data24 = new_div_input[23][div_input_data_cap];
	  input_data25 = new_div_input[24][div_input_data_cap];
	  input_data26 = new_div_input[25][div_input_data_cap];
	  input_data27 = new_div_input[26][div_input_data_cap];
	  input_data28 = new_div_input[27][div_input_data_cap];
	  input_data29 = new_div_input[28][div_input_data_cap];
	  input_data30 = new_div_input[29][div_input_data_cap];
	  input_data31 = new_div_input[30][div_input_data_cap];
	  input_data32 = new_div_input[31][div_input_data_cap];
	  input_data33 = new_div_input[32][div_input_data_cap];
  	  input_data34 = new_div_input[33][div_input_data_cap];
	  input_data35 = new_div_input[34][div_input_data_cap];
	  input_data36 = new_div_input[35][div_input_data_cap];
	  input_data37 = new_div_input[36][div_input_data_cap];
	  input_data38 = new_div_input[37][div_input_data_cap];
	  input_data39 = new_div_input[38][div_input_data_cap];
	  input_data40 = new_div_input[39][div_input_data_cap];
	  input_data41 = new_div_input[40][div_input_data_cap];
	  input_data42 = new_div_input[41][div_input_data_cap];
	  input_data43 = new_div_input[42][div_input_data_cap];
	  input_data44 = new_div_input[43][div_input_data_cap];
	  input_data45 = new_div_input[44][div_input_data_cap];
	  input_data46 = new_div_input[45][div_input_data_cap];
	  input_data47 = new_div_input[46][div_input_data_cap];
	  input_data48 = new_div_input[47][div_input_data_cap];
	  input_data49 = new_div_input[48][div_input_data_cap];
	  input_data50 = new_div_input[49][div_input_data_cap];
	  input_data51 = new_div_input[50][div_input_data_cap];
	  input_data52 = new_div_input[51][div_input_data_cap];
	  input_data53 = new_div_input[52][div_input_data_cap];
	  input_data54 = new_div_input[53][div_input_data_cap];
	  input_data55 = new_div_input[54][div_input_data_cap];
	  input_data56 = new_div_input[55][div_input_data_cap];
	  input_data57 = new_div_input[56][div_input_data_cap];
	  input_data58 = new_div_input[57][div_input_data_cap];
	  input_data59 = new_div_input[58][div_input_data_cap];
	  input_data60 = new_div_input[59][div_input_data_cap];
	  input_data61 = new_div_input[60][div_input_data_cap];
	  input_data62 = new_div_input[61][div_input_data_cap];
	  input_data63 = new_div_input[62][div_input_data_cap];
	  input_data64 = new_div_input[63][div_input_data_cap];
	  
	  div_input_data_cap = div_input_data_cap + 1;
	end
	else begin
	  input_data1 = 24'bz;
	  input_data2 = 24'bz;
	  input_data3 = 24'bz;
	  input_data4 = 24'bz;
	  input_data5 = 24'bz;
	  input_data6 = 24'bz;
	  input_data7 = 24'bz;
	  input_data8 = 24'bz;
	  input_data9 = 24'bz;
	  input_data10 = 24'bz;
	  input_data11 = 24'bz;
	  input_data12 = 24'bz;
	  input_data13 = 24'bz;
	  input_data14 = 24'bz;
	  input_data15 = 24'bz;
	  input_data16 = 24'bz;
	  input_data17 = 24'bz;
	  input_data18 = 24'bz;
	  input_data19 = 24'bz;
	  input_data20 = 24'bz;
	  input_data21 = 24'bz;
	  input_data22 = 24'bz;
	  input_data23 = 24'bz;
	  input_data24 = 24'bz;
	  input_data25 = 24'bz;
	  input_data26 = 24'bz;
	  input_data27 = 24'bz;
	  input_data28 = 24'bz;
	  input_data29 = 24'bz;
	  input_data30 = 24'bz;
	  input_data31 = 24'bz;
	  input_data32 = 24'bz;
	  input_data33 = 24'bz;
	  input_data34 = 24'bz;
	  input_data35 = 24'bz;
	  input_data36 = 24'bz;
	  input_data37 = 24'bz;
	  input_data38 = 24'bz;
	  input_data39 = 24'bz;
	  input_data40 = 24'bz;
	  input_data41 = 24'bz;
	  input_data42 = 24'bz;
	  input_data43 = 24'bz;
	  input_data44 = 24'bz;
	  input_data45 = 24'bz;
	  input_data46 = 24'bz;
	  input_data47 = 24'bz;
	  input_data48 = 24'bz;
	  input_data49 = 24'bz;
	  input_data50 = 24'bz;
	  input_data51 = 24'bz;
	  input_data52 = 24'bz;
	  input_data53 = 24'bz;
	  input_data54 = 24'bz;
	  input_data55 = 24'bz;
	  input_data56 = 24'bz;
	  input_data57 = 24'bz;
	  input_data58 = 24'bz;
	  input_data59 = 24'bz;
	  input_data60 = 24'bz;
	  input_data61 = 24'bz;
	  input_data62 = 24'bz;
	  input_data63 = 24'bz;
	  input_data64 = 24'bz;
    end
  end
end


// .rgb 파일 만들기 위한 ouput_data 임시 저장 메모리 만들기 ----------------------------------
always @(negedge valid_dmac) begin
  #40;
  new_div_output[0][output_cnt] = output_data1;
  new_div_output[1][output_cnt] = output_data2;
  new_div_output[2][output_cnt] = output_data3;
  new_div_output[3][output_cnt] = output_data4;
  new_div_output[4][output_cnt] = output_data5;
  new_div_output[5][output_cnt] = output_data6;
  new_div_output[6][output_cnt] = output_data7;
  new_div_output[7][output_cnt] = output_data8;
  new_div_output[8][output_cnt] = output_data9;
  new_div_output[9][output_cnt] = output_data10;
  new_div_output[10][output_cnt] = output_data11;
  new_div_output[11][output_cnt] = output_data12;
  new_div_output[12][output_cnt] = output_data13;
  new_div_output[13][output_cnt] = output_data14;
  new_div_output[14][output_cnt] = output_data15;
  new_div_output[15][output_cnt] = output_data16;
  new_div_output[16][output_cnt] = output_data17;
  new_div_output[17][output_cnt] = output_data18;
  new_div_output[18][output_cnt] = output_data19;
  new_div_output[19][output_cnt] = output_data20;
  new_div_output[20][output_cnt] = output_data21;
  new_div_output[21][output_cnt] = output_data22;
  new_div_output[22][output_cnt] = output_data23;
  new_div_output[23][output_cnt] = output_data24;
  new_div_output[24][output_cnt] = output_data25;
  new_div_output[25][output_cnt] = output_data26;
  new_div_output[26][output_cnt] = output_data27;
  new_div_output[27][output_cnt] = output_data28;
  new_div_output[28][output_cnt] = output_data29;
  new_div_output[29][output_cnt] = output_data30;
  new_div_output[30][output_cnt] = output_data31;
  new_div_output[31][output_cnt] = output_data32;
  new_div_output[32][output_cnt] = output_data33;
  new_div_output[33][output_cnt] = output_data34;
  new_div_output[34][output_cnt] = output_data35;
  new_div_output[35][output_cnt] = output_data36;
  new_div_output[36][output_cnt] = output_data37;
  new_div_output[37][output_cnt] = output_data38;
  new_div_output[38][output_cnt] = output_data39;
  new_div_output[39][output_cnt] = output_data40;
  new_div_output[40][output_cnt] = output_data41;
  new_div_output[41][output_cnt] = output_data42;
  new_div_output[42][output_cnt] = output_data43;
  new_div_output[43][output_cnt] = output_data44;
  new_div_output[44][output_cnt] = output_data45;
  new_div_output[45][output_cnt] = output_data46;
  new_div_output[46][output_cnt] = output_data47;
  new_div_output[47][output_cnt] = output_data48;
  new_div_output[48][output_cnt] = output_data49;
  new_div_output[49][output_cnt] = output_data50;
  new_div_output[50][output_cnt] = output_data51;
  new_div_output[51][output_cnt] = output_data52;
  new_div_output[52][output_cnt] = output_data53;
  new_div_output[53][output_cnt] = output_data54;
  new_div_output[54][output_cnt] = output_data55;
  new_div_output[55][output_cnt] = output_data56;
  new_div_output[56][output_cnt] = output_data57;
  new_div_output[57][output_cnt] = output_data58;
  new_div_output[58][output_cnt] = output_data59;
  new_div_output[59][output_cnt] = output_data60;
  new_div_output[60][output_cnt] = output_data61;
  new_div_output[61][output_cnt] = output_data62;
  new_div_output[62][output_cnt] = output_data63;
  new_div_output[63][output_cnt] = output_data64;
  
  output_cnt = output_cnt + 1;
end

endmodule



