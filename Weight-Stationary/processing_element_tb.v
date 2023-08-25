`timescale 1ns/100ps

module processing_element_tb;

    parameter DATA_WIDTH = 8;

    reg                                         clk;
    reg                                         rstn;

    reg                   [2*DATA_WIDTH-1 : 0]  i_psum;
    reg                     [DATA_WIDTH-1 : 0]  i_fmap;
    reg                     [DATA_WIDTH-1 : 0]  i_weight;

    reg                                         i_load;

    output                [2*DATA_WIDTH-1 : 0]  o_psum;    
    output                  [DATA_WIDTH-1 : 0]  o_fmap;
    output                  [DATA_WIDTH-1 : 0]  o_weight;


    //============================
    // Module Instance
    //============================
    processing_element #(.DATA_WIDTH(DATA_WIDTH)) u_pe (
        .clk        (clk        ),
        .rstn       (rstn       ),
        .i_psum     (i_psum     ),
        .i_fmap     (i_fmap     ),
        .i_weight   (i_weight   ),
        .i_load     (i_load     ),
        .o_psum     (o_psum     ),
        .o_fmap     (o_fmap     ),
        .o_weight   (o_weight   )
    );

    //============================
    // Init Task
    //============================
    task init;
        begin
            clk             = 'h0;
            rstn            = 'h1;
            i_psum          = 'h0;
            i_fmap          = 'h0;
            i_weight        = 'h0;
            i_load          = 'h0;
        end
    endtask


    //============================
    // Reset On/Off Task
    //============================
    task reset;
        input integer delay;
        begin
            repeat (delay) @ (posedge clk);
            rstn = 0;
            repeat (delay) @ (posedge clk);
            rstn = 1;
            repeat (delay) @ (posedge clk);
        end
    endtask

    //============================
    // Load Weight Task
    //============================
    task load_weight;
        begin
            i_weight <= 'd5;
            i_load   <= 1'b1;
            @ (posedge clk);
            i_weight <= 'd0;
            i_load   <= 1'b0;
            
        end
    endtask

    //============================
    // Drive Input Task
    //============================
    task drive_input;
        integer i;

        begin            
            for (i = 0; i < 16; i = i + 1) begin
                i_psum <= 'd0;
                i_fmap <= i + 1;
                @ (posedge clk);
            end
        end
    endtask


    //============================
    // Test Task
    //============================
    task test;
        begin
            load_weight();
            drive_input();
            @ (posedge clk);
        end
    endtask


    //============================
    // Clock Declaration (100MHz)
    //============================
    always #5 clk = ~clk;


    //============================
    // Test
    //============================
    initial begin
        init();
        reset(20);

        repeat (1) test();
    
        repeat (10) @ (posedge clk);
        $finish;
    end


    //============================
    // Waveform Dump
    //============================
    initial begin
        $dumpfile("./vcd/processing_element.vcd");
        $dumpvars(0);    
    end


endmodule