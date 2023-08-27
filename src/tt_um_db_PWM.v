`timescale 1ns / 1ps

module tt_um_db_PWM(
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to 
    
    );

    parameter BITS_duty = 3;

    reg [BITS_duty:0] cnt;
    wire [BITS_duty:0] duty;

    assign duty = ui_in [3:0];
    
    
    always @(posedge clk) begin
      if(rst_n) begin      
        if((cnt >= (2**BITS_duty)-1))
            cnt <= 0;
        else begin     
            cnt <= cnt + 1;
        end

      end else begin
         cnt <= 0;
      end
    end
    
    assign uo_out[0] = (cnt < duty);
    

endmodule

