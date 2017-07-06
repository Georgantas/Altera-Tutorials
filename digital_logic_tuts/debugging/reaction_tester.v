module reaction_tester (CLOCK_50, KEY, HEX0, HEX1, HEX2, HEX3, LEDG);
	input CLOCK_50;
	input [2:0] KEY;
	output wire [0:6] HEX0, HEX1, HEX2, HEX3;
	output wire [0:0] LEDG;
	wire [3:0] BCD3, BCD2, BCD1, BCD0;
	wire reset, request_test, stop_test, clear;
	wire run, start_test, test_active, enable_bcd, sec_100th;
	assign reset = !KEY[0];
	assign request_test = !KEY[1];
	assign stop_test = !KEY[2];
	assign clear = reset | stop_test;
	assign enable_bcd = test_active & sec_100th;
	assign LEDG[0] = test_active;
	control_ff run_signal (CLOCK_50, request_test, clear, run);
	control_ff test_signal (CLOCK_50, start_test, clear, test_active);
	hundredth hundredth_sec (CLOCK_50, enable_bcd, sec_100th);
	delay_counter foursec_delay (CLOCK_50, clear, run, start_test);
	BCD_counter bcdcount (CLOCK_50, request_test, enable_bcd, BCD3, BCD2, BCD1, BCD0);
	bcd7seg digit3 (BCD3, HEX3);
	bcd7seg digit2 (BCD2, HEX2);
	bcd7seg digit1 (BCD1, HEX1);
	bcd7seg digit0 (BCD0, HEX0);
endmodule

module control_ff (Clock, ff_in, Clear, Q);
	input Clock, ff_in, Clear;
	output reg Q;
	always @(posedge Clock)
		if (Clear)
			Q <= 0;
		else
			Q <= ff_in | Q;
endmodule

module delay_counter (Clock, Clear, Enable, Start);
	input Clock, Clear, Enable;
	output wire Start;
	reg [27:0] delay_count;
	always @(posedge Clock)
		if (Clear)
			delay_count <= 0;
		else if (Enable)
			delay_count <= delay_count + 1;
	assign Start = delay_count[27];
endmodule

module hundredth (Clock, Load, pulse_500k);
	input Clock, Load;
	output wire pulse_500k;
	reg [19:0] count_500k;
	always @(posedge Clock)
		if (Load)
			count_500k <= 20'h7A120;
		else
			count_500k <= count_500k - 1;
	assign pulse_500k = (count_500k == 20'h00000);
endmodule

module BCD_counter (Clock, Clear, Enable, BCD3, BCD2, BCD1, BCD0);
	input Clock, Clear, Enable;
	output wire [3:0] BCD3, BCD2, BCD1, BCD0;
	wire [4:1] Carry;
	BCD_stage stage0 (Clock, Clear, Enable, BCD0, Carry[1]);
	BCD_stage stage1 (Clock, Clear, (Carry[1] & Enable), BCD1, Carry[2]);
	BCD_stage stage2 (Clock, Clear, (Carry[2] & Carry[1] & Enable), BCD2, Carry[3]);
	BCD_stage stage3 (Clock, Clear, (Carry[3] & Carry[2] & Carry[1] & Enable), BCD3, Carry[4]);
endmodule

module BCD_stage (Clock, Clear, Ecount, BCDq, Value9);
	input Clock, Clear, Ecount;
	output reg [3:0] BCDq;
	output reg Value9;
	always @(posedge Clock)
	begin
		if (Clear)
			BCDq <= 0;
		else if (Ecount)
		begin
			if (BCDq == 4'b1001)
				BCDq <= 0;
			else
				BCDq <= BCDq + 1;
		end
	end
	always @(BCDq)
		if (BCDq == 4'b1001)
			Value9 <= 1'b1;
		else
			Value9 <= 1'b0;
endmodule


module bcd7seg (bcd, display);
	input [3:0] bcd;
	output reg [0:6] display;
always @(bcd)
	case (bcd)
		4'h0: display = 7'b0000001;
		4'h1: display = 7'b1001111;
		4'h2: display = 7'b0010010;
		4'h3: display = 7'b0000110;
		4'h4: display = 7'b1001100;
		4'h5: display = 7'b0100100;
		4'h6: display = 7'b1100000;
		4'h7: display = 7'b0001111;
		4'h8: display = 7'b0000000;
		4'h9: display = 7'b0001100;
		default: display = 7'bx;
	endcase
endmodule
