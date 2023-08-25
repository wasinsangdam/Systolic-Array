`timescale 1ns/100ps

module ws_systolic_array_tb;

    parameter DATA_WIDTH = 8;

    reg                                 clk;
    reg                                 rstn;

    reg                                 i_start;

    reg              [DATA_WIDTH-1 : 0] i_w_col_1;
    reg              [DATA_WIDTH-1 : 0] i_w_col_2;
    reg              [DATA_WIDTH-1 : 0] i_w_col_3;
    reg              [DATA_WIDTH-1 : 0] i_w_col_4;

    reg              [DATA_WIDTH-1 : 0] i_f_row_1;
    reg              [DATA_WIDTH-1 : 0] i_f_row_2;
    reg              [DATA_WIDTH-1 : 0] i_f_row_3;
    reg              [DATA_WIDTH-1 : 0] i_f_row_4;

    wire           [2*DATA_WIDTH-1 : 0] o_p_col_1; 
    wire           [2*DATA_WIDTH-1 : 0] o_p_col_2; 
    wire           [2*DATA_WIDTH-1 : 0] o_p_col_3; 
    wire           [2*DATA_WIDTH-1 : 0] o_p_col_4;

    //=======================================
    // Internal Variables (Data Array)
    //=======================================
    reg                     [DATA_WIDTH-1 : 0]  r_w_col_1[0 : 15];
    reg                     [DATA_WIDTH-1 : 0]  r_w_col_2[0 : 15];
    reg                     [DATA_WIDTH-1 : 0]  r_w_col_3[0 : 15];
    reg                     [DATA_WIDTH-1 : 0]  r_w_col_4[0 : 15];

    reg                     [DATA_WIDTH-1 : 0]  r_f_row_1[0 : 63];
    reg                     [DATA_WIDTH-1 : 0]  r_f_row_2[0 : 63];
    reg                     [DATA_WIDTH-1 : 0]  r_f_row_3[0 : 63];
    reg                     [DATA_WIDTH-1 : 0]  r_f_row_4[0 : 63];

    //=======================================
    // Internal Variables (File Descriptors)
    //=======================================
    integer     f_f_row_1, f_f_row_2, f_f_row_3, f_f_row_4;
    integer     f_w_col_1, f_w_col_2, f_w_col_3, f_w_col_4;

    integer     i, status;


    //=======================================
    // Module Instance  
    //=======================================
    ws_systolic_array #(.DATA_WIDTH(DATA_WIDTH)) u_ws_sa (
        .clk        (clk        ),
        .rstn       (rstn       ),

        .i_start    (i_start    ),

        .i_w_col_1  (i_w_col_1  ),
        .i_w_col_2  (i_w_col_2  ),
        .i_w_col_3  (i_w_col_3  ),
        .i_w_col_4  (i_w_col_4  ),

        .i_f_row_1  (i_f_row_1  ),
        .i_f_row_2  (i_f_row_2  ),
        .i_f_row_3  (i_f_row_3  ),
        .i_f_row_4  (i_f_row_4  ),

        .o_p_col_1  (o_p_col_1  ),
        .o_p_col_2  (o_p_col_2  ),
        .o_p_col_3  (o_p_col_3  ),
        .o_p_col_4  (o_p_col_4  )

    );


    //=======================================
    // Read Input Data from txt file  
    //=======================================
    task read_input_row;
        begin
            f_f_row_1 = $fopen("./data/input_row1.txt", "r");
            f_f_row_2 = $fopen("./data/input_row2.txt", "r");
            f_f_row_3 = $fopen("./data/input_row3.txt", "r");
            f_f_row_4 = $fopen("./data/input_row4.txt", "r");

            i = 0;
            while (!$feof(f_f_row_1)) begin
                status = $fscanf(f_f_row_1, "%d", r_f_row_1[i]);
                i = i + 1;
            end

            i = 0;
            while (!$feof(f_f_row_2)) begin
                status = $fscanf(f_f_row_2, "%d\n", r_f_row_2[i]);
                i = i + 1;
            end

            i = 0;
            while (!$feof(f_f_row_3)) begin
                status = $fscanf(f_f_row_3, "%d\n", r_f_row_3[i]);
                i = i + 1;
            end

            i = 0;
            while (!$feof(f_f_row_4)) begin
                status = $fscanf(f_f_row_4, "%d\n", r_f_row_4[i]);
                i = i + 1;
            end

            $fclose(f_f_row_1);
            $fclose(f_f_row_2);
            $fclose(f_f_row_3);
            $fclose(f_f_row_4);
        end
    endtask

    //=======================================
    // Read Weight Data from txt file  
    //=======================================
    task read_weight_col;
        begin
            f_w_col_1 = $fopen("./data/weight_col1.txt", "r");
            f_w_col_2 = $fopen("./data/weight_col2.txt", "r");
            f_w_col_3 = $fopen("./data/weight_col3.txt", "r");
            f_w_col_4 = $fopen("./data/weight_col4.txt", "r");

            i = 0;
            while (!$feof(f_w_col_1)) begin
                status = $fscanf(f_f_row_1, "%d", r_w_col_1[i]);
                i = i + 1;
            end

            i = 0;
            while (!$feof(f_w_col_2)) begin
                status = $fscanf(f_f_row_2, "%d\n", r_w_col_2[i]);
                i = i + 1;
            end

            i = 0;
            while (!$feof(f_w_col_3)) begin
                status = $fscanf(f_f_row_3, "%d\n", r_w_col_3[i]);
                i = i + 1;
            end

            i = 0;
            while (!$feof(f_w_col_4)) begin
                status = $fscanf(f_f_row_4, "%d\n", r_w_col_4[i]);
                i = i + 1;
            end

            $fclose(f_w_col_1);
            $fclose(f_w_col_2);
            $fclose(f_w_col_3);
            $fclose(f_w_col_4);
        end
    endtask

    //============================
    // Init Task
    //============================
    task init;
        begin
            clk             = 'h0;
            rstn            = 'h1;

            i_start         = 'h0;

            i_w_col_1       = 'h0;
            i_w_col_2       = 'h0;
            i_w_col_3       = 'h0;
            i_w_col_4       = 'h0;

            i_f_row_1       = 'h0;
            i_f_row_2       = 'h0;
            i_f_row_3       = 'h0;
            i_f_row_4       = 'h0;
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
    // Turn on Start Signal
    //============================
    task start;
        begin
            i_start = 1'b1;
            @ (posedge clk);
            i_start = 1'b0;
        end
    endtask

    //============================
    // Drive All Weights
    //============================
    task drive_weight;
        input   integer     num;
        begin
            fork
                drive_weight_col_1(4 * num);
                drive_weight_col_2(4 * num);
                drive_weight_col_3(4 * num);
                drive_weight_col_4(4 * num);
            join
        end
    endtask

    //============================
    // Drive Column 1 Weights
    //============================
    task drive_weight_col_1;
        input   integer     index;
        begin
            i_w_col_1 <= r_w_col_1[index];
            @ (posedge clk);
            i_w_col_1 <= r_w_col_1[index + 1];
            @ (posedge clk);
            i_w_col_1 <= r_w_col_1[index + 2];
            @ (posedge clk);
            i_w_col_1 <= r_w_col_1[index + 3];
            @ (posedge clk);
            i_w_col_1 <= 'h0;
        end
    endtask

    //============================
    // Drive Column 2 Weights
    //============================
    task drive_weight_col_2;
        input   integer     index;
        begin
            i_w_col_2 <= r_w_col_2[index];
            @ (posedge clk);
            i_w_col_2 <= r_w_col_2[index + 1];
            @ (posedge clk);
            i_w_col_2 <= r_w_col_2[index + 2];
            @ (posedge clk);
            i_w_col_2 <= r_w_col_2[index + 3];
            @ (posedge clk);
            i_w_col_2 <= 'h0;
        end
    endtask

    //============================
    // Drive Column 3 Weights
    //============================
    task drive_weight_col_3;
        input   integer     index;
        begin
            i_w_col_3 <= r_w_col_3[index];
            @ (posedge clk);
            i_w_col_3 <= r_w_col_3[index + 1];
            @ (posedge clk);
            i_w_col_3 <= r_w_col_3[index + 2];
            @ (posedge clk);
            i_w_col_3 <= r_w_col_3[index + 3];
            @ (posedge clk);
            i_w_col_3 <= 'h0;
        end
    endtask

    //============================
    // Drive Column 4 Weights
    //============================
    task drive_weight_col_4;
        input   integer     index;
        begin
            i_w_col_4 <= r_w_col_4[index];
            @ (posedge clk);
            i_w_col_4 <= r_w_col_4[index + 1];
            @ (posedge clk);
            i_w_col_4 <= r_w_col_4[index + 2];
            @ (posedge clk);
            i_w_col_4 <= r_w_col_4[index + 3];
            @ (posedge clk);
            i_w_col_4 <= 'h0;
        end
    endtask

    //============================
    // Drive All Input
    //============================
    task drive_input;
        input   integer     test_num;

        begin
            fork
                drive_input_row_1(test_num);
                drive_input_row_2(test_num);
                drive_input_row_3(test_num);
                drive_input_row_4(test_num);
            join
        end
    endtask

    //============================
    // Drive Row 1 Input FMAP
    //============================
    task drive_input_row_1;
        input   integer     test_num;

        integer k;
        begin
            for (k = 0; k < 16; k = k + 1) begin
                i_f_row_1 <= r_f_row_1[test_num * 16 + k];
                @ (posedge clk);
            end
            i_f_row_1 <= 'h0;

        end
    endtask

    //============================
    // Drive Row 2 Input FMAP
    //============================
    task drive_input_row_2;
        input   integer     test_num;
        integer k;
        begin
            repeat(1) @ (posedge clk);
            for (k = 0; k < 16; k = k + 1) begin
                i_f_row_2 <= r_f_row_2[test_num * 16 + k];
                @ (posedge clk);
            end
            i_f_row_2 <= 'h0;
        end
    endtask

    //============================
    // Drive Row 3 Input FMAP
    //============================
    task drive_input_row_3;
        input   integer     test_num;

        integer k;
        begin
            repeat(2) @ (posedge clk);

            for (k = 0; k < 16; k = k + 1) begin
                i_f_row_3 <= r_f_row_3[test_num * 16 + k];
                @ (posedge clk);
            end
            i_f_row_3 <= 'h0;
        end
    endtask

    //============================
    // Drive Row 4 Input FMAP
    //============================
    task drive_input_row_4;
        input   integer     test_num;

        integer k;
        begin
            repeat(3) @ (posedge clk);

            for (k = 0; k < 16; k = k + 1) begin
                i_f_row_4 <= r_f_row_4[test_num * 16 + k];
                @ (posedge clk);
            end
            i_f_row_4 <= 'h0;
        end
    endtask


    //============================
    // Test Task
    //============================
    task test;
        input   integer     test_num;

        begin
            start();
            drive_weight(test_num);
            drive_input(test_num);
            
            repeat (2) @ (posedge clk);
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
        read_input_row();
        read_weight_col();
        
        reset(20);

        for (i = 0; i < 4; i = i + 1) 
            test(i);
    
        repeat (100) @ (posedge clk);
        $finish;
    end


    //============================
    // Waveform Dump
    //============================
    initial begin
        $dumpfile("./vcd/ws_systolic_array_tb.vcd");
        $dumpvars(0);    
    end


endmodule