class apb_environment;

    apb_generator  gen;
    apb_driver     drv;
    apb_monitor    mon;
    apb_scoreboard scb;

    mailbox #(apb_transaction) gen2drv;
    mailbox #(apb_transaction) mon2scb;

    virtual apb_if vif;

    function new(
        virtual apb_if vif
    );

        this.vif = vif;

        gen2drv = new();
        mon2scb = new();

        gen = new(gen2drv, 20);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2scb);
        scb = new(mon2scb);

    endfunction

    task run();

        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none

    endtask

endclass