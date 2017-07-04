module FSM(start, clock, resetn, reset, enable, load);
	parameter WAIT_STATE = 2'b00, WORK_STATE = 2'b01, END_STATE = 2'b11;
	input start, clock, resetn;
	output reset, enable, load;
	reg [1:0] current_state, next_state;
	reg [3:0] counter;

	always@(*)
	begin
	case(current_state)
		WAIT_STATE:
			if (start) next_state <= WORK_STATE;
			else next_state <= WAIT_STATE;
		WORK_STATE:
			if (counter == 4'd8) next_state <= END_STATE;
			else next_state <= WORK_STATE;
		END_STATE:
			if (~start) next_state <= WAIT_STATE;
			else next_state <= END_STATE;
		default:
			next_state <= 2'bxx;
	endcase
	end

	always@(posedge clock or negedge resetn)
	begin
	if (~resetn)
		begin
		current_state <= WAIT_STATE;
		counter = 'd0;
		end
	else
		begin
		current_state <= next_state;
		if (current_state == WAIT_STATE)
			counter <= 'd0;
		else if (current_state == WORK_STATE)
			counter <= counter + 1'b1;
		end
	end

	assign reset = (current_state == WAIT_STATE) & start;
	assign load = (current_state == WAIT_STATE) & start;
	assign enable = load | (current_state == WORK_STATE);
endmodule