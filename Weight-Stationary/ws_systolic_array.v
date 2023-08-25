`include "processing_element.v"

module ws_systolic_array # (
    parameter DATA_WIDTH = 8
)
(
    input                           clk         ,
    input                           rstn        ,

    input                           i_start     ,

    input       [DATA_WIDTH-1 : 0]  i_w_col_1   ,   // Input Weight Column 1
    input       [DATA_WIDTH-1 : 0]  i_w_col_2   ,   // Input Weight Column 2
    input       [DATA_WIDTH-1 : 0]  i_w_col_3   ,   // Input Weight Column 3
    input       [DATA_WIDTH-1 : 0]  i_w_col_4   ,   // Input Weight Column 4

    input       [DATA_WIDTH-1 : 0]  i_f_row_1   ,   // Input Feature Map Row 1
    input       [DATA_WIDTH-1 : 0]  i_f_row_2   ,   // Input Feature Map Row 2
    input       [DATA_WIDTH-1 : 0]  i_f_row_3   ,   // Input Feature Map Row 3
    input       [DATA_WIDTH-1 : 0]  i_f_row_4   ,   // Input Feature Map Row 4

    output    [2*DATA_WIDTH-1 : 0]  o_p_col_1   ,   // Output Partial Sum Column 1
    output    [2*DATA_WIDTH-1 : 0]  o_p_col_2   ,   // Output Partial Sum Column 2
    output    [2*DATA_WIDTH-1 : 0]  o_p_col_3   ,   // Output Partial Sum Column 3
    output    [2*DATA_WIDTH-1 : 0]  o_p_col_4       // Output Partial Sum Column 4

);

    parameter              [1 : 0]  ST_IDLE = 2'b00,    // IDLE State
                                    ST_LOAD = 2'b01,    // Load Weight State
                                    ST_OPER = 2'b10;    // MAC Operation State

    wire        [DATA_WIDTH-1 : 0]  w_f_row_11, w_f_row_12, w_f_row_13;                 // Wire Feature map Row 
    wire        [DATA_WIDTH-1 : 0]  w_f_row_21, w_f_row_22, w_f_row_23;                 // Wire Feature map Row 
    wire        [DATA_WIDTH-1 : 0]  w_f_row_31, w_f_row_32, w_f_row_33;                 // Wire Feature map Row 
    wire        [DATA_WIDTH-1 : 0]  w_f_row_41, w_f_row_42, w_f_row_43;                 // Wire Feature map Row 
    
    wire        [DATA_WIDTH-1 : 0]  w_w_col_11, w_w_col_12, w_w_col_13, w_w_col_14;     // Wire Weight Column
    wire        [DATA_WIDTH-1 : 0]  w_w_col_21, w_w_col_22, w_w_col_23, w_w_col_24;     // Wire Weight Column
    wire        [DATA_WIDTH-1 : 0]  w_w_col_31, w_w_col_32, w_w_col_33, w_w_col_34;     // Wire Weight Column

    wire      [2*DATA_WIDTH-1 : 0]  w_p_col_11, w_p_col_12, w_p_col_13, w_p_col_14;     // Wire Partial Sum Column
    wire      [2*DATA_WIDTH-1 : 0]  w_p_col_21, w_p_col_22, w_p_col_23, w_p_col_24;     // Wire Partial Sum Column
    wire      [2*DATA_WIDTH-1 : 0]  w_p_col_31, w_p_col_32, w_p_col_33, w_p_col_34;     // Wire Partial Sum Column

    reg                   [15 : 0]  pre_load;                   // Load Weight enable signal

    reg                    [1 : 0]  r_cnt;                      // Counter Register

    reg                    [1 : 0]  curr_state, next_state;     // State Register 


    // State Always Block
    always @ (posedge clk) begin
        if (!rstn)  curr_state <= ST_IDLE;
        else        curr_state <= next_state;
    end

    // Counter Logic
    always @ (posedge clk) begin
        if  (!rstn) 
            r_cnt <= 'h0;
        else if (curr_state == ST_LOAD) // Operates only when Stage is ST_LOAD
            r_cnt <= r_cnt + 1'b1;
        else                            // Clear when Stage is not ST_LOAD
            r_cnt <= 'h0;
    end

    
    always @ (*) begin
        next_state  = ST_IDLE;
        pre_load    = 16'h00;
        case (curr_state)
            ST_IDLE :   next_state = (i_start) ? ST_LOAD : ST_IDLE;
                        
            ST_LOAD :   begin
                            pre_load = 16'hFFFF;    // Turn on weight load enable signal 
                            next_state = (r_cnt == 2'd3) ? ST_OPER : ST_LOAD;
                        end 
            ST_OPER :   begin
                            pre_load = 16'h0000;    // Turn off weight load enable signal
                            next_state = (i_start) ? ST_LOAD : ST_OPER;
                        end 
        endcase
    end


    // synthesis translate_off
    reg                   [55 : 0]  debug_state;
    always @ (*) begin
        case (curr_state)
            ST_IDLE : debug_state = "ST_IDLE";
            ST_LOAD : debug_state = "ST_LOAD";
            ST_OPER : debug_state = "ST_OPER";
        endcase
    end
    // synthesis translate_on
    

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_11 (
        .clk        (clk                    ),
        .rstn       (rstn                   ),

        .i_psum     ({ 2*DATA_WIDTH{1'b0} } ),
        .i_fmap     (i_f_row_1              ),
        .i_weight   (i_w_col_1              ),

        .i_load     (pre_load[0]            ),

        .o_psum     (w_p_col_11             ),
        .o_fmap     (w_f_row_11             ),
        .o_weight   (w_w_col_11             )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_12 (
        .clk        (clk                    ),
        .rstn       (rstn                   ),

        .i_psum     ({ 2*DATA_WIDTH{1'b0} } ),
        .i_fmap     (w_f_row_11             ),
        .i_weight   (i_w_col_2              ),

        .i_load     (pre_load[1]            ),

        .o_psum     (w_p_col_12             ),
        .o_fmap     (w_f_row_12             ),
        .o_weight   (w_w_col_12             )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_13 (
        .clk        (clk                    ),
        .rstn       (rstn                   ),

        .i_psum     ({ 2*DATA_WIDTH{1'b0} } ),
        .i_fmap     (w_f_row_12             ),
        .i_weight   (i_w_col_3              ),

        .i_load     (pre_load[2]            ),

        .o_psum     (w_p_col_13             ),
        .o_fmap     (w_f_row_13             ),
        .o_weight   (w_w_col_13             )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_14 (
        .clk        (clk                    ),
        .rstn       (rstn                   ),

        .i_psum     ({ 2*DATA_WIDTH{1'b0} } ),
        .i_fmap     (w_f_row_13             ),
        .i_weight   (i_w_col_4              ),

        .i_load     (pre_load[3]            ),

        .o_psum     (w_p_col_14             ),
        .o_fmap     (                       ),
        .o_weight   (w_w_col_14             )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_21 (
        .clk        (clk                    ),
        .rstn       (rstn                   ),

        .i_psum     (w_p_col_11             ),
        .i_fmap     (i_f_row_2              ),
        .i_weight   (w_w_col_11             ),

        .i_load     (pre_load[4]            ),

        .o_psum     (w_p_col_21             ),
        .o_fmap     (w_f_row_21             ),
        .o_weight   (w_w_col_21             )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_22 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_12  ),
        .i_fmap     (w_f_row_21  ),
        .i_weight   (w_w_col_12  ),

        .i_load     (pre_load[5] ),

        .o_psum     (w_p_col_22  ),
        .o_fmap     (w_f_row_22  ),
        .o_weight   (w_w_col_22  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_23 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_13  ),
        .i_fmap     (w_f_row_22  ),
        .i_weight   (w_w_col_13  ),

        .i_load     (pre_load[6] ),

        .o_psum     (w_p_col_23  ),
        .o_fmap     (w_f_row_23  ),
        .o_weight   (w_w_col_23  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_24 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_14  ),
        .i_fmap     (w_f_row_23  ),
        .i_weight   (w_w_col_14  ),

        .i_load     (pre_load[7] ),

        .o_psum     (w_p_col_24  ),
        .o_fmap     (            ),
        .o_weight   (w_w_col_24  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_31 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_21  ),
        .i_fmap     (i_f_row_3   ),
        .i_weight   (w_w_col_21  ),

        .i_load     (pre_load[8] ),

        .o_psum     (w_p_col_31  ),
        .o_fmap     (w_f_row_31  ),
        .o_weight   (w_w_col_31  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_32 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_22  ),
        .i_fmap     (w_f_row_31  ),
        .i_weight   (w_w_col_22  ),

        .i_load     (pre_load[9] ),

        .o_psum     (w_p_col_32  ),
        .o_fmap     (w_f_row_32  ),
        .o_weight   (w_w_col_32  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_33 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_23  ),
        .i_fmap     (w_f_row_32  ),
        .i_weight   (w_w_col_23  ),

        .i_load     (pre_load[10]),

        .o_psum     (w_p_col_33  ),
        .o_fmap     (w_f_row_33  ),
        .o_weight   (w_w_col_33  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_34 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_24  ),
        .i_fmap     (w_f_row_33  ),
        .i_weight   (w_w_col_24  ),

        .i_load     (pre_load[11]),

        .o_psum     (w_p_col_34  ),
        .o_fmap     (            ),
        .o_weight   (w_w_col_34  )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_41 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_31  ),
        .i_fmap     (i_f_row_4   ),
        .i_weight   (w_w_col_31  ),

        .i_load     (pre_load[12]),

        .o_psum     (o_p_col_1   ),
        .o_fmap     (w_f_row_41  ),
        .o_weight   (            )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_42 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_32  ),
        .i_fmap     (w_f_row_41  ),
        .i_weight   (w_w_col_32  ),

        .i_load     (pre_load[13]),

        .o_psum     (o_p_col_2   ),
        .o_fmap     (w_f_row_42  ),
        .o_weight   (            )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_43 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_33  ),
        .i_fmap     (w_f_row_42  ),
        .i_weight   (w_w_col_33  ),

        .i_load     (pre_load[14]),

        .o_psum     (o_p_col_3   ),
        .o_fmap     (w_f_row_43  ),
        .o_weight   (            )
    );

    processing_element # (.DATA_WIDTH(DATA_WIDTH)) PE_44 (
        .clk        (clk         ),
        .rstn       (rstn        ),

        .i_psum     (w_p_col_34  ),
        .i_fmap     (w_f_row_43  ),
        .i_weight   (w_w_col_34  ),

        .i_load     (pre_load[15]),

        .o_psum     (o_p_col_4   ),
        .o_fmap     (            ),
        .o_weight   (            )
    );

endmodule