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

    reg [BITS_duty:0] d_cnt, q_cnt;
    reg pwm_d, pwm_q;

    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
         d_cnt <=0;
         pwm_d <=0;
        end else begin
         q_cnt <= d_cnt;
         pwm_q <= pwm_d;
        end
    end
    
            
    always @(*) begin
        if((q_cnt >= (2**BITS_duty)-1))
            d_cnt = 0;
        else 
            d_cnt = q_cnt + 1;
        pwm_d = (q_cnt < duty);
    end
    
    assign uo_out[0] = pwm_q;

endmodule
