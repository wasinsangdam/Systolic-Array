module processing_element # (
    parameter DATA_WIDTH = 8
)
(
    input                               clk     ,
    input                               rstn    ,

    input       [2*DATA_WIDTH-1 : 0]    i_psum  ,   // Input Partial Sum
    input         [DATA_WIDTH-1 : 0]    i_fmap  ,   // Input Feature Map
    input         [DATA_WIDTH-1 : 0]    i_weight,   // Input Weight

    input                               i_load  ,   // Load Weight Enable signal

    output      [2*DATA_WIDTH-1 : 0]    o_psum  ,   // Output Partial Sum
    output        [DATA_WIDTH-1 : 0]    o_fmap  ,   // Output Feature Map
    output        [DATA_WIDTH-1 : 0]    o_weight    // Output Weight
);

    reg         [2*DATA_WIDTH-1 : 0]    r_psum;     // Register Partial Sum
    reg           [DATA_WIDTH-1 : 0]    r_fmap;     // Register Feature Map
    reg           [DATA_WIDTH-1 : 0]    r_weight;   // Register Weight


    // Do MAC operation when i_load is 0, clear register when i_load is 1  
    always @ (posedge clk) begin
        if      (!rstn)     r_psum <= 'h0;  
        else if (!i_load)   r_psum <= i_fmap * r_weight + i_psum;
        else if (i_load)    r_psum <= 'h0;
    end


    // Read input only i_load signal is 0
    always @ (posedge clk) begin
        if      (!rstn)     r_fmap <= 'h0;
        else if (!i_load)   r_fmap <= i_fmap;
    end

    // Read weight only i_load signal is 1
    always @ (posedge clk) begin
        if      (!rstn)     r_weight <= 'h0;
        else if (i_load)    r_weight <= i_weight;
    end

    assign o_psum   = r_psum;
    assign o_fmap   = r_fmap;
    assign o_weight = r_weight;

endmodule