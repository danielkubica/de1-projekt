GHDL = ghdl
TOP  = counter_tb
BUILD_DIR = build

all:
	mkdir -p $(BUILD_DIR)
	$(GHDL) -i --workdir=$(BUILD_DIR) ../hdl/*.vhd ../tb/*.vhd
	$(GHDL) -m --workdir=$(BUILD_DIR) $(TOP)
	$(GHDL) -r  --workdir=$(BUILD_DIR) $(TOP) --vcd=./$(BUILD_DIR)/result.vcd

view:
	gtkwave ./$(BUILD_DIR)/result.vcd

clean:
	rm -rf $(BUILD_DIR)
	$(GHDL) --clean