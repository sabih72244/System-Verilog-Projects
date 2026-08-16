class apb_driver;

    virtual apb_if vif;

    mailbox #(apb_transaction) gen2drv;

    function new(
        virtual apb_if vif,
        mailbox #(apb_transaction) gen2drv
    );

        this.vif = vif;
        this.gen2drv = gen2drv;

    endfunction

    task reset();

        vif.PSEL    <= 0;
        vif.PENABLE <= 0;
        vif.PWRITE  <= 0;
        vif.PADDR   <= 0;
        vif.PWDATA  <= 0;

        @(posedge vif.PCLK);

    endtask

    task run();

        apb_transaction tr;

        forever begin

            gen2drv.get(tr);

            // SETUP phase
            @(posedge vif.PCLK);

            vif.PSEL    <= 1;
            vif.PENABLE <= 0;
            vif.PWRITE  <= tr.write;
            vif.PADDR   <= tr.addr;
            vif.PWDATA  <= tr.data;

            // ACCESS phase
            @(posedge vif.PCLK);

            vif.PENABLE <= 1;

            wait(vif.PREADY);

            @(posedge vif.PCLK);

            // IDLE phase
            vif.PSEL    <= 0;
            vif.PENABLE <= 0;

        end

    endtask

endclass