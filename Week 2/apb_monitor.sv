class apb_monitor;

    virtual apb_if vif;

    mailbox #(apb_transaction) mon2scb;

    function new(
        virtual apb_if vif,
        mailbox #(apb_transaction) mon2scb
    );

        this.vif = vif;
        this.mon2scb = mon2scb;

    endfunction

    task run();

        apb_transaction tr;

        forever begin

            @(posedge vif.PCLK);

            if (vif.PSEL && vif.PENABLE && vif.PREADY) begin

                tr = new();

                tr.write = vif.PWRITE;
                tr.addr  = vif.PADDR;
                tr.data  = vif.PWDATA;

                if (!vif.PWRITE)
                    tr.rdata = vif.PRDATA;

                mon2scb.put(tr);

                tr.display("MONITOR");

            end

        end

    endtask

endclass