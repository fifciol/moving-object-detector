# Toolchain prefix (i.e arm-elf- -> arm-elf-gcc.exe)
TCHAIN_PREFIX = 
REMOVE_CMD=rm

# Directory for output files (lst, obj, dep, elf, sym, map, hex, bin etc.)
OUTDIR = build

# Target file name (without extension).
TARGET = moving-object-detector

# Define programs and commands.
CXX     = $(TCHAIN_PREFIX)g++
REMOVE  = $(REMOVE_CMD) -f

CXXFLAGS += \
	-I include \
	-I multithreading \
    -I $(OPENCV_DIR)/include

CXXFLAGS += \
	-O0 -g \
	-Wall -Wextra -Wcast-align -Wpointer-arith -Wredundant-decls -Wshadow \
    -std=c++11

LDFLAGS = \
    -lpthread -lopencv_imgcodecs -lopencv_videoio -lopencv_highgui -lopencv_core -lopencv_imgproc -lopencv_objdetect -lm

LIBS += \
    -L $(OPENCV_DIR)/lib

CXXSOURCE = \
    src/main.cpp \
	
HEADERS = \
	multithreading/active_object.h \

# List of all source files without directory and file-extension
ALLSRC = $(notdir $(basename $(CXXSOURCE)))
# Define all object files.
ALLOBJ     = $(addprefix $(OUTDIR)/, $(addsuffix .o, $(ALLSRC)))
# Define all listing files (used for make clean)
LSTFILES   = $(addprefix $(OUTDIR)/, $(addsuffix .lst, $(ALLSRC)))
# Define all depedency-files (used for make clean)
DEPFILES   = $(addprefix $(OUTDIR)/dep/, $(addsuffix .o.d, $(ALLSRC)))

.PHONY : all clean createdirs build send astyle

all: createdirs build

bin: $(OUTDIR)/$(TARGET).bin

build: bin

$(ALLOBJ) : Makefile $(HEADERS) $(LDSCRIPT)

# Link: create BIN output file from object files
.SECONDARY : $(TARGET).bin
.PRECIOUS : $(ALLOBJ)
%.bin:  $(ALLOBJ)
	$(CXX) $(ALLOBJ) $(SYSROOT) --output $@ $(LIBS) $(LDFLAGS)

#Compile: create object files from CXX source files
define COMPILE_CXX_TEMPLATE
$(OUTDIR)/$(notdir $(basename $(1))).o : $(1)
	$(CXX) -c $$(CFLAGS) $$(CXXFLAGS) $$< -o $$@
endef
$(foreach src, $(CXXSOURCE), $(eval $(call COMPILE_CXX_TEMPLATE, $(src))))

# Create output directories
createdirs:
	-@mkdir $(OUTDIR) 2>/dev/null || echo "" >/dev/null
	-@mkdir $(OUTDIR)/dep 2>/dev/null || echo "" >/dev/null

# Target: clean project
clean:
	$(REMOVE) $(OUTDIR)/$(TARGET).bin
	$(REMOVE) $(ALLOBJ)
	$(REMOVE) $(LSTFILES)

