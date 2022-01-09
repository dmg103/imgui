###############################################################
##### MACROS
###############################################################
#$(1) : Compiler
#$(2) : Object file to generate
#$(3) : Source file
#$(4) : Additional dependencies
#$(5) : Flags
define COMPILE
$(2): $(3) $(4)
	$(1) -c -o $(2) $(3) $(5)
endef

#$(1) : Source file
define SOURCE2OBJ
$(patsubst %.cpp, %.o, $(patsubst ./%, ./obj/%, $(1)))
endef

#$(1) : Source file
define SOURCE2HEADER
$(patsubst %.cpp, %.h, $(1))
endef

###############################################################
##### VARIABLES
###############################################################
APP     := libImgui.a
OSLIB   := a
AR      := ar
ARFLAGS := -crs
RANLIB  := ranlib
CC      := g++
CCFLAGS := -std=c++20 -O3
MKDIR   := mkdir -p

###############################################################
##### DIRECTORIES
###############################################################
OS_ARCH_BINDIR := ./bin/
BIN            := ./bin/$(APP)
OBJDIRS        := obj obj/backends

###############################################################
##### LIBRARIES AND INCLUDES
###############################################################
LIBDIR  := -I../glfw/include
LIBDIR  += -I./ -I./backends
INCDIRS := $(LIBDIR)

###############################################################
##### FILES
###############################################################

IMGUI_DIR  := .
ALLCPPSNOH := $(IMGUI_DIR)/imgui_draw.cpp $(IMGUI_DIR)/imgui_tables.cpp $(IMGUI_DIR)/imgui_widgets.cpp
ALLCPPSH   := $(IMGUI_DIR)/backends/imgui_impl_glfw.cpp $(IMGUI_DIR)/backends/imgui_impl_opengl3.cpp $(IMGUI_DIR)/imgui.cpp 
ALLCPPS    := $(ALLCPPSNOH) $(ALLCPPSH) 
ALLOBJS    := $(foreach F,$(ALLCPPS),$(call SOURCE2OBJ,$(F)))

###############################################################
##### TARGETS
###############################################################

$(BIN): $(OBJDIRS) $(OS_ARCH_BINDIR) $(ALLOBJS)
	@echo "==== Linking $(APP) ===="
	@echo "$(BIN)"
	$(AR) $(ARFLAGS) $(BIN) $(ALLOBJS)
	$(RANLIB) $(BIN)


###############################################################
##### BUILD FILE RULES
###############################################################

$(foreach F,$(ALLCPPSH),$(eval $(call COMPILE,$(CC),$(call SOURCE2OBJ,$(F)),$(F),$(call SOURCE2HEADER,$(F)),$(CCFLAGS) $(INCDIRS))))
$(foreach F,$(ALLCPPSNOH),$(eval $(call COMPILE,$(CC),$(call SOURCE2OBJ,$(F)),$(F),,$(CCFLAGS) $(INCDIRS))))

$(OBJDIRS):
	@echo "==== Creating $(APP) obj directories ===="
	@$(MKDIR) $(OBJDIRS)

$(OS_ARCH_BINDIR):
	@echo "==== Creating $(APP) bin directories ===="
	@$(MKDIR) $(OS_ARCH_BINDIR)

.PHONY: info clean

info:
	$(info $(ALLCPPS))
	$(info $(ALLOBJS))	
	$(info $(OBJDIRS))

clean:
	@echo "==== Cleaning IMGUI ===="
	@rm -rf ./obj
	@rm -rf ./bin

