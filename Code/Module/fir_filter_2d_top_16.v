module fir_filter_2d_top_16(clk, rst_n,
                            input_data1, input_data2, input_data3, input_data4,
							input_data5, input_data6, input_data7, input_data8,
                            input_data9, input_data10 ,input_data11, input_data12,
							input_data13, input_data14, input_data15, input_data16,
							valid_dmac, tc_set, 
						    output_data1, output_data2, output_data3, output_data4,
							output_data5, output_data6,output_data7,output_data8,
							output_data9, output_data10, output_data11, output_data12,
							output_data13, output_data14, output_data15, output_data16, 
							valid_core);

input clk, rst_n, valid_dmac, tc_set;

input[23:0] input_data1, input_data2, input_data3, input_data4, input_data5, input_data6, input_data7, input_data8;
input[23:0] input_data9, input_data10, input_data11, input_data12, input_data13, input_data14, input_data15, input_data16;

output valid_core;
output[23:0] output_data1,output_data2,output_data3,output_data4,output_data5,output_data6,output_data7,output_data8;
output[23:0] output_data9,output_data10,output_data11,output_data12,output_data13,output_data14,output_data15,output_data16;

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

endmodule