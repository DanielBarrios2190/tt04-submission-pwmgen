`timescale 1ns / 1ps

module tt_um_db_PWM(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset

    );
    parameter BITS_duty = 5;
    wire clk_in = clk;
    wire rst = !rst_n;
    wire [BITS_duty:0] duty  = ui_in;
    wire pwm_out;

	
    reg [BITS_duty:0] q_reg, d_reg;
    reg [BITS_duty:0] d_next, q_next;

    always @(posedge clk_in, negedge rst) begin
        if(rst || (q_reg >= 2**(BITS_duty)-1)) begin
            q_reg <= 0;
            d_reg <= 0;
        end else begin
            q_reg <= q_next;
            d_reg <= d_next;
        end
    end
            
    always @(*) begin
        q_next <= q_reg + 1;
        d_next <= (q_reg < duty);
    end
    
    assign uo_out[0] = d_reg;

endmodule
