module fifo_tb();
reg clock,reset_n,write_en,read_en,soft_reset,lfd_state;
reg [7:0] data_in;
wire empty,full;
wire[7:0] data_out;
integer j;

fifo DUT(.clock(clock),.reset_n(read_en),.write_en(write_en),.read_en(read_en),.soft_reset(soft_reset),.data_in(data_in),.lfd_state(lfd_state),.data_out(data_out),.full(full),.empty(empty));

always 
begin 
#5;
clock = 0;
#5
clock =~clock;
end

task rst_dut();
	begin
	@(negedge clock)
	reset_n = 1'b0;
	@(negedge clock)
	reset_n = 1'b1;
	end
endtask


task soft_rst();
	begin
	@(negedge clock)
	soft_reset = 1'b1;
	@(negedge clock)
	soft_reset = 1'b0;
	end
endtask

task write();
	reg[7:0]payload,parity ,header;
	reg[5:0]payload_len;
	reg[1:0]addrs;
begin
	@(negedge clock)
	addrs = 2'b10;
	payload_len = 6'd14;
	lfd_state = 1'b1;
	write_en = 1'b1;
	header = {payload_len,parity};
	data_in = header;
	for(j=0;j<payload_len;j=j+1)

    begin
    
    @(negedge clock);
		lfd_state = 1'b0;
		write_en = 1'b1;
		payload={$random}%256;
		data_in=payload;
    end
	@(negedge clock)
		lfd_state = 1'b0;
		write_en = 1'b1;
		payload={$random}%256;
		data_in=parity;
    end
endtask

task read();
begin
	read_en = 1'b1;
end
endtask

initial
begin
	rst_dut;
	soft_rst;
	write;
#30
read;
#300
$finish;
end
initial
begin
	$monitor("clock=%b,reset_n=%b,write_en=%b,read_en=%b,data_in=%b,lfd_state=%b,data_out=%b,full=%b,empty=%b",clock,reset_n,write_en,read_en,data_in,data_out,lfd_state,full,empty);
end
endmodule	











