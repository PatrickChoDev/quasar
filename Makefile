# Makefile for Verilator-based testing

# Default directories
HDL_DIR := hdl
BUILD_DIR := build
OBJ_DIR := $(BUILD_DIR)/obj
VERILATED_DIR := $(BUILD_DIR)/verilated
TEST_DIR := tests

# Default files
SUB_HDL_DIRS := $(shell find $(HDL_DIR) -type d)

# Tools and flags
VERILATOR := verilator
VERILATOR_FLAGS := --trace --binary --exe --timing
VERILATOR_INCLUDE_FLAGS := $(addprefix -I, $(SUB_HDL_DIRS))
CXX := g++
CXXFLAGS := -std=c++11 -Wall -Wextra -g

MODULE := top/top

# Default targets
.PHONY: all clean verilate test
all: $(VERILATED_DIR)/V$(MODULE)

# Verilator targets
verilated_files := $(addprefix $(VERILATED_DIR)/, V$(MODULE).cpp V$(MODULE)__ALL.a)
$(verilated_files): $(HDL_DIR)/$(MODULE).sv
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INCLUDE_FLAGS) -Mdir $(VERILATED_DIR) $(HDL_DIR)/$(MODULE).sv

$(VERILATED_DIR)/V$(MODULE): $(verilated_files) $(TEST_DIR)/$(MODULE)_tb.cpp
	$(CXX) $(CXXFLAGS) -I$(VERILATED_DIR) -I$(HDL_DIR) $(TEST_DIR)/$(MODULE)_tb.cpp $(verilated_files) -o $@

# Test target
test: $(VERILATED_DIR)/V$(MODULE)
	$(VERILATED_DIR)/V$(MODULE)


# Clean target
clean:
	rm -rf $(BUILD_DIR)
