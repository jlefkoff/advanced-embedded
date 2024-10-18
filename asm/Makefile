AS=arm-none-eabi-as
LD=arm-none-eabi-ld
OBJCOPY=arm-none-eabi-objcopy
GDB=arm-none-eabi-gdb
STFLASH=st-flash
STUTIL=st-util

ASFLAGS=-mcpu=cortex-m0 -mthumb -g
LDFLAGS=-T linker.ld -e vtable

BUILDDIR=build
TARGET=$(BUILDDIR)/rad.bin
ELF=$(BUILDDIR)/rad.elf

SRCS=$(wildcard src/*.s)
OBJS=$(patsubst %.s, $(BUILDDIR)/%.o, $(notdir $(SRCS)))

.PHONY: all
all: $(BUILDDIR) $(TARGET)

# Create build directory
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# Make flash image
$(TARGET): $(ELF)
	$(OBJCOPY) -O binary $< $@

# Link ELF
$(ELF): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)

# Assemble sources
$(BUILDDIR)/%.o: src/%.s
	$(AS) -o $@ $< $(ASFLAGS)

# Clean build files
.PHONY: clean
clean:
	rm -r $(BUILDDIR)

# Flash to device
.PHONY: flash
flash:
	$(STFLASH) write $(TARGET) 0x8000000

# Connect with GDB
.PHONY: debug
debug:
	$(STUTIL) &
	$(GDB) -ex 'target extended-remote localhost:4242' -ex 'load' $(ELF)
	kill %1
