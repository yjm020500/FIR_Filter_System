module fir_filter_2d_top_4(clk, rst_n,
                            input_data1, input_data2, input_data3, input_data4,
							valid_dmac, tc_set, 
						    output_data1, output_data2, output_data3, output_data4,
							valid_core);

input clk, rst_n, valid_dmac, tc_set;

input[23:0] input_data1, input_data2, input_data3, input_data4;

output valid_core;
output[23:0] output_data1,output_data2,output_data3,output_data4;

fir_filter_2d UFF1 (.clk(clk), .rst_n(rst_n), .input_data(input_data1), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data1), .valid_core(valid_core));
fir_filter_2d UFF2 (.clk(clk), .rst_n(rst_n), .input_data(input_data2), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data2), .valid_core(valid_core));
fir_filter_2d UFF3 (.clk(clk), .rst_n(rst_n), .input_data(input_data3), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data3), .valid_core(valid_core));
fir_filter_2d UFF4 (.clk(clk), .rst_n(rst_n), .input_data(input_data4), .valid_dmac(valid_dmac), .tc_set(tc_set), .output_data(output_data4), .valid_core(valid_core));

endmodule