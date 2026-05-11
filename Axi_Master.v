module AxiMaster(
    input wire ACLK,
    input wire ARESETN,

    // WRITE ADDRESS
    input wire [1:0] TBAWADDR,
    output reg [1:0] AWADDR,
    input wire TBAWVALID,
    output reg AWVALID,
    input wire AWREADY,

    // WRITE DATA
    input wire [31:0] TBWDATA,
    output reg [31:0] WDATA,
    input wire UPDATEWDATA,
    output reg WVALID,
    input wire WREADY,

    // WRITE RESPONSE
    input wire [1:0] BRESP,
    input wire BVALID,
    output reg BREADY,
    output reg [1:0] TBBRESP,

    // READ ADDRESS
    input wire [1:0] TBARADDR,
    output reg [1:0] ARADDR,
    input wire TBARVALID,
    output reg ARVALID,
    input wire ARREADY,

    //READ DATA
    output reg RREADY,
    input wire [31:0] RDATA,
    input wire [1:0] RRESP,
    input wire RVALID,
    output reg [31:0] TBRDATA,
    output reg [1:0] TBRRESP
);

always @(posedge ACLK) begin
    if(!ARESETN) begin
        AWADDR <= 0;
        AWVALID <= 0;
        WDATA <= 0;
        WVALID <= 0;
        BREADY <= 0;
        TBBRESP <= 0;
        ARADDR <= 0;
        ARVALID <= 0;
        RREADY <= 0;
        TBRDATA <= 0;
        TBRRESP <= 0;
    end
    else begin
        
        // VALID UPDATE
        if(TBAWVALID) begin
            AWVALID <= 1;
            AWADDR <= TBAWADDR;
        end

        if(TBAWVALID && UPDATEWDATA)
            WDATA <= TBWDATA;

        if(TBARVALID) begin
            ARVALID <= 1;
            ARADDR <= TBARADDR;
        end
        if(AWVALID && AWREADY) begin
            WVALID <= 1;
            AWVALID <= 0;
        end

        if(WVALID && WREADY) begin
            BREADY <= 1;
            WVALID <= 0;
        end

        if(BREADY && BVALID) begin
            TBBRESP <= BRESP;
            BREADY <= 0;
        end

        if(ARREADY && ARVALID) begin
            RREADY <= 1;
            ARVALID <= 0;
        end

        if(RREADY && RVALID) begin
            TBRRESP <= RRESP;
            TBRDATA <= RDATA;
            RREADY <= 0;
        end

    end
end

endmodule