module shift_reg( clock, reset, data, bit_in, enable, load, q);
	parameter n = 8;
	input clock, reset, bit_in, enable, load;
	input [n-1:0] data;
	output reg [n-1:0] q;
	always@(posedge clock)
	begin
		if (enable)
			if (reset)
				q <= 'd0;
			else
			begin
				if (load)
					q <= data;
				else
				begin
					q[n-2:0] <= q[n-1:1];
					q[n-1] <= bit_in;
				end
			end
	end
endmodule
