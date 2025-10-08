module fir_filter_2d_top_64(clk, rst_n,
                            input_data1, input_data2, input_data3, input_data4,
							input_data5, input_data6, input_data7, input_data8,
                            input_data9, input_data10 ,input_data11, input_data12,
							input_data13, input_data14, input_data15, input_data16,
							input_data17, input_data18, input_data19, input_data20, 
							input_data21, input_data22, input_data23, input_data24,
							input_data25, input_data26, input_data27, input_data28, 
							input_data29, input_data30, input_data31, input_data32,
							input_data33, input_data34, input_data35, input_data36, 
							input_data37, input_data38, input_data39, input_data40,
							input_data41, input_data42, input_data43, input_data44, 
							input_data45, input_data46, input_data47, input_data48,
							input_data49, input_data50, input_data51, input_data52, 
							input_data53, input_data54, input_data55, input_data56,
							input_data57, input_data58, input_data59, input_data60, 
							input_data61, input_data62, input_data63, input_data64,
							valid_dmac, tc_set, 
						    output_data1, output_data2, output_data3, output_data4,
							output_data5, output_data6,output_data7,output_data8,
							output_data9, output_data10, output_data11, output_data12,
							output_data13, output_data14, output_data15, output_data16, 
							output_data17, output_data18, output_data19, output_data20, 
							output_data21, output_data22, output_data23, output_data24,
							output_data25, output_data26, output_data27, output_data28, 
							output_data29, output_data30, output_data31, output_data32,
							output_data33, output_data34, output_data35, output_data36, 
							output_data37, output_data38, output_data39, output_data40,
							output_data41, output_data42, output_data43, output_data44, 
							output_data45, output_data46, output_data47, output_data48,
							output_data49, output_data50, output_data51, output_data52, 
							output_data53, output_data54, output_data55, output_data56,
							output_data57, output_data58, output_data59, output_data60, 
							output_data61, output_data62, output_data63, output_data64,
							valid_core);

input clk, rst_n, valid_dmac, tc_set;

input[23:0] input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8;
input[23:0] input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16;
input[23:0] input_data17, input_data18, input_data19, input_data20, input_data21, input_data22, input_data23, input_data24;
input[23:0] input_data25, input_data26, input_data27, input_data28, input_data29, input_data30, input_data31, input_data32;
input[23:0] input_data33, input_data34, input_data35, input_data36, input_data37, input_data38, input_data39, input_data40; 
input[23:0] input_data41, input_data42, input_data43, input_data44, input_data45, input_data46, input_data47, input_data48;
input[23:0] input_data49, input_data50, input_data51, input_data52, input_data53, input_data54, input_data55, input_data56; 
input[23:0] input_data57, input_data58, input_data59, input_data60, input_data61, input_data62, input_data63, input_data64;

output valid_core;
output[23:0] output_data1,output_data2,output_data3,output_data4,output_data5,output_data6,output_data7,output_data8;
output[23:0] output_data9,output_data10,output_data11,output_data12,output_data13,output_data14,output_data15,output_data16;
output[23:0] output_data17, output_data18, output_data19, output_data20, output_data21, output_data22, output_data23, output_data24;
output[23:0] output_data25, output_data26, output_data27, output_data28, output_data29, output_data30, output_data31, output_data32;
output[23:0] output_data33, output_data34, output_data35, output_data36, output_data37, output_data38, output_data39, output_data40;
output[23:0] output_data41, output_data42, output_data43, output_data44, output_data45, output_data46, output_data47, output_data48;
output[23:0] output_data49, output_data50, output_data51, output_data52, output_data53, output_data54, output_data55, output_data56;
output[23:0] output_data57, output_data58, output_data59, output_data60, output_data61, output_data62, output_data63, output_data64;

fir_filter_2d UFF1 (.clk(clk), .rst_n(rst_n), .input_data(input_data1), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data1), .valid_core(valid_core));
fir_filter_2d UFF2 (.clk(clk), .rst_n(rst_n), .input_data(input_data2), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data2), .valid_core(valid_core));
fir_filter_2d UFF3 (.clk(clk), .rst_n(rst_n), .input_data(input_data3), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data3), .valid_core(valid_core));
fir_filter_2d UFF4 (.clk(clk), .rst_n(rst_n), .input_data(input_data4), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data4), .valid_core(valid_core));
fir_filter_2d UFF5 (.clk(clk), .rst_n(rst_n), .input_data(input_data5), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data5), .valid_core(valid_core));
fir_filter_2d UFF6 (.clk(clk), .rst_n(rst_n), .input_data(input_data6), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data6), .valid_core(valid_core));
fir_filter_2d UFF7 (.clk(clk), .rst_n(rst_n), .input_data(input_data7), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data7), .valid_core(valid_core));
fir_filter_2d UFF8 (.clk(clk), .rst_n(rst_n), .input_data(input_data8), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data8), .valid_core(valid_core));
fir_filter_2d UFF9 (.clk(clk), .rst_n(rst_n), .input_data(input_data9), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data9), .valid_core(valid_core));
fir_filter_2d UFF10 (.clk(clk), .rst_n(rst_n), .input_data(input_data10), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data10), .valid_core(valid_core));
fir_filter_2d UFF11 (.clk(clk), .rst_n(rst_n), .input_data(input_data11), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data11), .valid_core(valid_core));
fir_filter_2d UFF12 (.clk(clk), .rst_n(rst_n), .input_data(input_data12), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data12), .valid_core(valid_core));
fir_filter_2d UFF13 (.clk(clk), .rst_n(rst_n), .input_data(input_data13), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data13), .valid_core(valid_core));
fir_filter_2d UFF14 (.clk(clk), .rst_n(rst_n), .input_data(input_data14), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data14), .valid_core(valid_core));
fir_filter_2d UFF15 (.clk(clk), .rst_n(rst_n), .input_data(input_data15), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data15), .valid_core(valid_core));
fir_filter_2d UFF16 (.clk(clk), .rst_n(rst_n), .input_data(input_data16), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data16), .valid_core(valid_core));
fir_filter_2d UFF17 (.clk(clk), .rst_n(rst_n), .input_data(input_data17), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data17), .valid_core(valid_core));
fir_filter_2d UFF18 (.clk(clk), .rst_n(rst_n), .input_data(input_data18), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data18), .valid_core(valid_core));
fir_filter_2d UFF19 (.clk(clk), .rst_n(rst_n), .input_data(input_data19), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data19), .valid_core(valid_core));
fir_filter_2d UFF20 (.clk(clk), .rst_n(rst_n), .input_data(input_data20), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data20), .valid_core(valid_core));
fir_filter_2d UFF21 (.clk(clk), .rst_n(rst_n), .input_data(input_data21), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data21), .valid_core(valid_core));
fir_filter_2d UFF22 (.clk(clk), .rst_n(rst_n), .input_data(input_data22), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data22), .valid_core(valid_core));
fir_filter_2d UFF23 (.clk(clk), .rst_n(rst_n), .input_data(input_data23), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data23), .valid_core(valid_core));
fir_filter_2d UFF24 (.clk(clk), .rst_n(rst_n), .input_data(input_data24), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data24), .valid_core(valid_core));
fir_filter_2d UFF25 (.clk(clk), .rst_n(rst_n), .input_data(input_data25), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data25), .valid_core(valid_core));
fir_filter_2d UFF26 (.clk(clk), .rst_n(rst_n), .input_data(input_data26), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data26), .valid_core(valid_core));
fir_filter_2d UFF27 (.clk(clk), .rst_n(rst_n), .input_data(input_data27), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data27), .valid_core(valid_core));
fir_filter_2d UFF28 (.clk(clk), .rst_n(rst_n), .input_data(input_data28), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data28), .valid_core(valid_core));
fir_filter_2d UFF29 (.clk(clk), .rst_n(rst_n), .input_data(input_data29), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data29), .valid_core(valid_core));
fir_filter_2d UFF30 (.clk(clk), .rst_n(rst_n), .input_data(input_data30), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data30), .valid_core(valid_core));
fir_filter_2d UFF31 (.clk(clk), .rst_n(rst_n), .input_data(input_data31), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data31), .valid_core(valid_core));
fir_filter_2d UFF32 (.clk(clk), .rst_n(rst_n), .input_data(input_data32), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data32), .valid_core(valid_core));
fir_filter_2d UFF33 (.clk(clk), .rst_n(rst_n), .input_data(input_data33), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data33), .valid_core(valid_core));
fir_filter_2d UFF34 (.clk(clk), .rst_n(rst_n), .input_data(input_data34), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data34), .valid_core(valid_core));
fir_filter_2d UFF35 (.clk(clk), .rst_n(rst_n), .input_data(input_data35), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data35), .valid_core(valid_core));
fir_filter_2d UFF36 (.clk(clk), .rst_n(rst_n), .input_data(input_data36), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data36), .valid_core(valid_core));
fir_filter_2d UFF37 (.clk(clk), .rst_n(rst_n), .input_data(input_data37), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data37), .valid_core(valid_core));
fir_filter_2d UFF38 (.clk(clk), .rst_n(rst_n), .input_data(input_data38), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data38), .valid_core(valid_core));
fir_filter_2d UFF39 (.clk(clk), .rst_n(rst_n), .input_data(input_data39), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data39), .valid_core(valid_core));
fir_filter_2d UFF40 (.clk(clk), .rst_n(rst_n), .input_data(input_data40), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data40), .valid_core(valid_core));
fir_filter_2d UFF41 (.clk(clk), .rst_n(rst_n), .input_data(input_data41), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data41), .valid_core(valid_core));
fir_filter_2d UFF42 (.clk(clk), .rst_n(rst_n), .input_data(input_data42), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data42), .valid_core(valid_core));
fir_filter_2d UFF43 (.clk(clk), .rst_n(rst_n), .input_data(input_data43), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data43), .valid_core(valid_core));
fir_filter_2d UFF44 (.clk(clk), .rst_n(rst_n), .input_data(input_data44), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data44), .valid_core(valid_core));
fir_filter_2d UFF45 (.clk(clk), .rst_n(rst_n), .input_data(input_data45), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data45), .valid_core(valid_core));
fir_filter_2d UFF46 (.clk(clk), .rst_n(rst_n), .input_data(input_data46), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data46), .valid_core(valid_core));
fir_filter_2d UFF47 (.clk(clk), .rst_n(rst_n), .input_data(input_data47), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data47), .valid_core(valid_core));
fir_filter_2d UFF48 (.clk(clk), .rst_n(rst_n), .input_data(input_data48), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data48), .valid_core(valid_core));
fir_filter_2d UFF49 (.clk(clk), .rst_n(rst_n), .input_data(input_data49), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data49), .valid_core(valid_core));
fir_filter_2d UFF50 (.clk(clk), .rst_n(rst_n), .input_data(input_data50), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data50), .valid_core(valid_core));
fir_filter_2d UFF51 (.clk(clk), .rst_n(rst_n), .input_data(input_data51), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data51), .valid_core(valid_core));
fir_filter_2d UFF52 (.clk(clk), .rst_n(rst_n), .input_data(input_data52), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data52), .valid_core(valid_core));
fir_filter_2d UFF53 (.clk(clk), .rst_n(rst_n), .input_data(input_data53), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data53), .valid_core(valid_core));
fir_filter_2d UFF54 (.clk(clk), .rst_n(rst_n), .input_data(input_data54), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data54), .valid_core(valid_core));
fir_filter_2d UFF55 (.clk(clk), .rst_n(rst_n), .input_data(input_data55), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data55), .valid_core(valid_core));
fir_filter_2d UFF56 (.clk(clk), .rst_n(rst_n), .input_data(input_data56), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data56), .valid_core(valid_core));
fir_filter_2d UFF57 (.clk(clk), .rst_n(rst_n), .input_data(input_data57), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data57), .valid_core(valid_core));
fir_filter_2d UFF58 (.clk(clk), .rst_n(rst_n), .input_data(input_data58), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data58), .valid_core(valid_core));
fir_filter_2d UFF59 (.clk(clk), .rst_n(rst_n), .input_data(input_data59), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data59), .valid_core(valid_core));
fir_filter_2d UFF60 (.clk(clk), .rst_n(rst_n), .input_data(input_data60), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data60), .valid_core(valid_core));
fir_filter_2d UFF61 (.clk(clk), .rst_n(rst_n), .input_data(input_data61), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data61), .valid_core(valid_core));
fir_filter_2d UFF62 (.clk(clk), .rst_n(rst_n), .input_data(input_data62), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data62), .valid_core(valid_core));
fir_filter_2d UFF63 (.clk(clk), .rst_n(rst_n), .input_data(input_data63), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data63), .valid_core(valid_core));
fir_filter_2d UFF64 (.clk(clk), .rst_n(rst_n), .input_data(input_data64), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data64), .valid_core(valid_core));

endmodule