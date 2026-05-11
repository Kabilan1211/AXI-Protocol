module axiSlave(
    input wire ACLK,
    input wire ARESETN,

    // Write Address
    input wire[1:0] AWADDR,
    input wire AWVALID,
    output reg AWREADY,

    // Write Data
    input wire[31:0] WDATA,
    input wire WVALID,
    output reg WREADY,

    // Write Response
    output reg[1:0] BRESP,
    output reg BVALID,
    input wire BREADY,

    // Read Address
    input wire[1:0] ARADDR,
    input wire ARVALID,
    output reg ARREADY,

    // Read Data
    output reg[31:0] RDATA,
    output reg[1:0] RRESP,
    output reg RVALID,
    input wire RREADY
);

reg [31:0] Registers [3:0];
reg [1:0] ReadAddr, WriteAddr;
integer i;
reg WADDRVALID, RADDRVALID;

always @(posedge ACLK) begin
    if(!ARESETN) begin
        AWREADY <= 1;
        WREADY <= 0;
        BRESP <= 0;
        BVALID <= 0;
        ARREADY <= 1;
        RDATA <= 0;
        RRESP <= 0;
        RVALID <= 0;
        WADDRVALID <= 0;
        RADDRVALID <= 0;

        for(i=0; i<4; i++)
            Registers[i] <= 0;

    end 
    else begin

        // WRITE ADDRESS
        if(AWVALID && AWREADY) begin
            WriteAddr <= AWADDR;
            WADDRVALID <= 1;
            AWREADY <= 0;
            WREADY <= 1;
        end


        
        // WRITE DATA
        if(WREADY && WVALID && WADDRVALID) begin
            
            if(WriteAddr < 4) begin
                Registers[WriteAddr] <= WDATA;
                BRESP <= 2'b00;
                BVALID <= 1;
                WADDRVALID <= 0;
                WREADY <= 0;
            end
            else begin
                BRESP <= 2'b11;
                BVALID <= 1;
                WADDRVALID <= 0;
                WREADY <= 0;
            end
        end

        // WRITE RESPONSE COMPLETE HANDSHAKE
        if(BVALID && BREADY) begin
            BVALID <= 0;
            AWREADY <= 1;
        end

        // READ ADDRESS 
        if(ARREADY && ARVALID) begin
            ReadAddr <= ARADDR;
            ARREADY <= 0;
            RADDRVALID <= 1;
        end

        // READ DATA
        if(RADDRVALID) begin
            if(ReadAddr < 4) begin
                RDATA <= Registers[ReadAddr];
                RRESP <= 2'b00;
                RVALID <= 1;
            end
            else begin
                RDATA <= 0;
                RRESP <= 2'b11;
                RVALID <= 1;
            end
        RADDRVALID <= 0;
        end

        // READ DATA HANDSHAKE COMPLETION
        if(RVALID && RREADY) begin
            RVALID <= 0;
            ARREADY <= 1;
        end
    end
end

endmodule