module apb_tb;
    logic        PCLK;
    logic        PRESETn;
    logic        PSEL;
    logic        PENABLE;
    logic        PWRITE;
    logic [7:0]  PADDR;
    logic [31:0] PWDATA;
    logic [31:0] PRDATA;
    logic        PREADY;
    logic        PSLVERR;
    apb_slave dut (
        .PCLK    (PCLK),
        .PRESETn (PRESETn),
        .PSEL    (PSEL),
        .PENABLE (PENABLE),
        .PWRITE  (PWRITE),
        .PADDR   (PADDR),
        .PWDATA  (PWDATA),
        .PRDATA  (PRDATA),
        .PREADY  (PREADY),
        .PSLVERR (PSLVERR)
    );
    initial begin
        PCLK = 1'b0;
        forever #5 PCLK = ~PCLK;
    end
    class apb_transaction;
        rand bit        write;
        rand bit [7:0]  addr;
        rand bit [31:0] data;
        constraint write_constraint {
            write dist {
                1'b0 := 50,
                1'b1 := 50
            };
        }
        constraint address_constraint {
            addr inside {[0:255]};

        }
        constraint data_constraint {
            data inside {
                [32'h00000000 : 32'h000000FF],
                [32'h00000100 : 32'h0000FFFF],
                [32'hFFFF0000 : 32'hFFFFFFFF]
            };
        }
    endclass
apb_transaction trans;
    integer read_count;
    integer write_count;
    integer low_addr_count;
    integer mid_addr_count;
    integer high_addr_count;
    integer top_addr_count;
    integer zero_data_count;
    integer low_data_count;
    integer mid_data_count;
    integer high_data_count;
    integer setup_count;
    integer access_count;
    integer ready_count;
    integer not_ready_count;
    integer error_count;
    integer no_error_count;
    integer read_low;
    integer read_mid;
    integer read_high;
    integer read_top;
    integer write_low;
    integer write_mid;
    integer write_high;
    integer write_top;
    task update_coverage;
        begin
        if (PWRITE)
                write_count = write_count + 1;
            else
                read_count = read_count + 1;
            if (PADDR <= 8'd63)
                low_addr_count = low_addr_count + 1;
            else if (PADDR <= 8'd127)
                mid_addr_count = mid_addr_count + 1;
            else if (PADDR <= 8'd191)
                high_addr_count = high_addr_count + 1;
            else
                top_addr_count = top_addr_count + 1;
            if (PWDATA == 32'h00000000)
                zero_data_count = zero_data_count + 1;
            else if (PWDATA <= 32'h000000FF)
                low_data_count = low_data_count + 1;
            else if (PWDATA <= 32'h0000FFFF)
                mid_data_count = mid_data_count + 1;
            else
                high_data_count = high_data_count + 1;
            if (PREADY)
                ready_count = ready_count + 1;
            else
                not_ready_count = not_ready_count + 1;
            if (PSLVERR)
                error_count = error_count + 1;
            else
                no_error_count = no_error_count + 1;
            if (!PWRITE) begin
                if (PADDR <= 8'd63)
                    read_low = read_low + 1;
                else if (PADDR <= 8'd127)
                    read_mid = read_mid + 1;
                else if (PADDR <= 8'd191)
                    read_high = read_high + 1;
                else
                    read_top = read_top + 1;
            end
            else begin
                if (PADDR <= 8'd63)
                    write_low = write_low + 1;
                else if (PADDR <= 8'd127)
                    write_mid = write_mid + 1;
                else if (PADDR <= 8'd191)
                    write_high = write_high + 1;
                else
                    write_top = write_top + 1;
            end
        end
    endtask
    task apb_write;
        input [7:0] address;
        input [31:0] data;
        begin
            @(posedge PCLK);
            PSEL    <= 1'b1;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b1;
            PADDR   <= address;
            PWDATA  <= data;
            setup_count = setup_count + 1;
            @(posedge PCLK);

            PENABLE <= 1'b1;

            access_count = access_count + 1;


            // Wait for slave ready

            wait(PREADY == 1'b1);


            // Sample coverage

            #1;

            update_coverage();


            @(posedge PCLK);

            // End transaction

            PSEL    <= 1'b0;
            PENABLE <= 1'b0;

        end

    endtask


    //==================================================
    // APB READ
    //==================================================

    task apb_read;

        input [7:0] address;

        begin

            //==========================================
            // SETUP PHASE
            //==========================================

            @(posedge PCLK);

            PSEL    <= 1'b1;
            PENABLE <= 1'b0;
            PWRITE  <= 1'b0;
            PADDR   <= address;
            PWDATA  <= 32'h00000000;

            setup_count = setup_count + 1;


            //==========================================
            // ACCESS PHASE
            //==========================================

            @(posedge PCLK);

            PENABLE <= 1'b1;

            access_count = access_count + 1;


            // Wait for PREADY

            wait(PREADY == 1'b1);


            #1;

            update_coverage();


            $display(
                "READ: ADDR = %h, DATA = %h, ERROR = %b",
                address,
                PRDATA,
                PSLVERR
            );


            @(posedge PCLK);

            PSEL    <= 1'b0;
            PENABLE <= 1'b0;

        end

    endtask


    //==================================================
    // INITIALIZE
    //==================================================

    initial begin

        read_count  = 0;
        write_count = 0;

        low_addr_count  = 0;
        mid_addr_count  = 0;
        high_addr_count = 0;
        top_addr_count  = 0;

        zero_data_count = 0;
        low_data_count  = 0;
        mid_data_count  = 0;
        high_data_count = 0;

        setup_count  = 0;
        access_count = 0;

        ready_count     = 0;
        not_ready_count = 0;

        error_count    = 0;
        no_error_count = 0;

        read_low  = 0;
        read_mid  = 0;
        read_high = 0;
        read_top   = 0;

        write_low  = 0;
        write_mid  = 0;
        write_high = 0;
        write_top   = 0;

    end


    //==================================================
    // MAIN TEST
    //==================================================

    initial begin

        trans = new();


        // Initial signals

        PSEL    = 1'b0;
        PENABLE = 1'b0;
        PWRITE  = 1'b0;
        PADDR   = 8'h00;
        PWDATA  = 32'h00000000;


        //==============================================
        // RESET
        //==============================================

        PRESETn = 1'b0;

        repeat(2)
            @(posedge PCLK);

        PRESETn = 1'b1;


        $display("");
        $display("==========================================");
        $display("       APB CONSTRAINED RANDOM TEST");
        $display("==========================================");


        //==============================================
        // RANDOM TRANSACTIONS
        //==============================================

        repeat(500) begin

            if (!trans.randomize()) begin

                $display("ERROR: Randomization failed");

                $finish;

            end


            if (trans.write) begin

                $display(
                    "WRITE: ADDR = %h DATA = %h",
                    trans.addr,
                    trans.data
                );

                apb_write(
                    trans.addr,
                    trans.data
                );

            end

            else begin

                apb_read(
                    trans.addr
                );

            end

        end


        //==============================================
        // DIRECTED ERROR TEST
        //==============================================

        $display("");
        $display("Running directed error transaction...");

        apb_read(8'hFF);


        //==============================================
        // COVERAGE REPORT
        //==============================================

        #20;

        $display("");
        $display("==========================================");
        $display("           APB COVERAGE REPORT");
        $display("==========================================");


        $display("");
        $display("READ / WRITE COVERAGE");
        $display("------------------------------------------");

        $display("READ  : %0d hits", read_count);
        $display("WRITE : %0d hits", write_count);


        $display("");
        $display("ADDRESS COVERAGE");
        $display("------------------------------------------");

        $display("LOW  [0-63]     : %0d",
                 low_addr_count);

        $display("MID  [64-127]   : %0d",
                 mid_addr_count);

        $display("HIGH [128-191]  : %0d",
                 high_addr_count);

        $display("TOP  [192-255]  : %0d",
                 top_addr_count);


        $display("");
        $display("DATA COVERAGE");
        $display("------------------------------------------");

        $display("ZERO DATA       : %0d",
                 zero_data_count);

        $display("LOW DATA        : %0d",
                 low_data_count);

        $display("MID DATA        : %0d",
                 mid_data_count);

        $display("HIGH DATA       : %0d",
                 high_data_count);


        $display("");
        $display("APB PHASE COVERAGE");
        $display("------------------------------------------");

        $display("SETUP PHASE     : %0d",
                 setup_count);

        $display("ACCESS PHASE    : %0d",
                 access_count);


        $display("");
        $display("READY COVERAGE");
        $display("------------------------------------------");

        $display("READY            : %0d",
                 ready_count);

        $display("NOT READY        : %0d",
                 not_ready_count);


        $display("");
        $display("ERROR COVERAGE");
        $display("------------------------------------------");

        $display("NO ERROR         : %0d",
                 no_error_count);

        $display("ERROR            : %0d",
                 error_count);


        //==============================================
        // CROSS COVERAGE
        //==============================================

        $display("");
        $display("==========================================");
        $display("       READ/WRITE x ADDRESS");
        $display("==========================================");

        $display("");

        $display("READ  + LOW      : %0d", read_low);
        $display("READ  + MID      : %0d", read_mid);
        $display("READ  + HIGH     : %0d", read_high);
        $display("READ  + TOP      : %0d", read_top);

        $display("");

        $display("WRITE + LOW      : %0d", write_low);
        $display("WRITE + MID      : %0d", write_mid);
        $display("WRITE + HIGH     : %0d", write_high);
        $display("WRITE + TOP      : %0d", write_top);


        //==============================================
        // UNTESTED SCENARIOS
        //==============================================

        $display("");
        $display("==========================================");
        $display("       UNTESTED SCENARIO ANALYSIS");
        $display("==========================================");


        // READ / WRITE

        if (read_count == 0)
            $display("WARNING: READ transaction untested.");

        if (write_count == 0)
            $display("WARNING: WRITE transaction untested.");


        // ADDRESS

        if (low_addr_count == 0)
            $display("WARNING: LOW address range untested.");

        if (mid_addr_count == 0)
            $display("WARNING: MID address range untested.");

        if (high_addr_count == 0)
            $display("WARNING: HIGH address range untested.");

        if (top_addr_count == 0)
            $display("WARNING: TOP address range untested.");


        // DATA

        if (zero_data_count == 0)
            $display("WARNING: ZERO data scenario untested.");

        if (low_data_count == 0)
            $display("WARNING: LOW data scenario untested.");

        if (mid_data_count == 0)
            $display("WARNING: MID data scenario untested.");

        if (high_data_count == 0)
            $display("WARNING: HIGH data scenario untested.");


        // ERROR

        if (error_count == 0)
            $display("WARNING: APB ERROR scenario untested.");


        // CROSS COVERAGE

        if (read_low == 0)
            $display("WARNING: READ + LOW address untested.");

        if (read_mid == 0)
            $display("WARNING: READ + MID address untested.");

        if (read_high == 0)
            $display("WARNING: READ + HIGH address untested.");

        if (read_top == 0)
            $display("WARNING: READ + TOP address untested.");


        if (write_low == 0)
            $display("WARNING: WRITE + LOW address untested.");

        if (write_mid == 0)
            $display("WARNING: WRITE + MID address untested.");

        if (write_high == 0)
            $display("WARNING: WRITE + HIGH address untested.");

        if (write_top == 0)
            $display("WARNING: WRITE + TOP address untested.");


        $display("");
        $display("==========================================");
        $display("          TEST COMPLETED");
        $display("==========================================");


        $finish;

    end

endmodule