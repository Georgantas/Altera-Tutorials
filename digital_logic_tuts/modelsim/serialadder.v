module serialadder(A, B, start, resetn, clock, sum);
	input [7:0] A, B;
	input resetn, start, clock;
	output [8:0] sum;

	wire [7:0] A_reg,B_reg;
	reg cin;
	
	wire reset, enable, load;
	wire bit_sum, bit_carry;

	FSM my_control(start, clock, resetn, reset, enable, load);

	shift_reg reg_A( clock, 1'b0, A, 1'b0, enable, load, A_reg);
	shift_reg reg_B( clock, 1'b0, B, 1'b0, enable, load, B_reg);

	assign {bit_carry, bit_sum} = A_reg[0] + B_reg[0] + cin;

	always @(posedge clock)
	begin
	if (enable)
		if (reset)
			cin <= 1'b0;
		else
			cin <= bit_carry;
	end

	shift_reg reg_sum( clock, reset, 9'd0, bit_sum, enable, 1'b0, sum);
		defparam reg_sum.n = 9;
endmodule
