AS=arm-none-eabi-as
LD=arm-none-eabi-ld
OBJCOPY=arm-none-eabi-objcopy
GDB=arm-none-eabi-gdb
STFLASH=st-flash
STUTIL=st-util

ASFLAGS=-mcpu=cortex-m0 -mthumb -g
LDFLAGS=-T linker.ld -e vtable

BUILD=build
TARGET=$(BUILD)/workshop.bin
ELF=$(BUILD)/workshop.elf

SRCS=$(wildcard src/*.s)
OBJS=$(patsubst %.s, $(BUILD)/%.o, $(notdir $(SRCS)))

.PHONY: all
all: $(BUILD) $(TARGET)

# Create build directory
$(BUILD):
	mkdir -p $(BUILD)

# Make flash image
$(TARGET): $(ELF)
	$(OBJCOPY) -O binary $< $@

# Link ELF
$(ELF): $(OBJS)
	$(LD) -o $@ $^ $(LDFLAGS)

# Assemble sources
$(BUILD)/%.o: src/%.s
	$(AS) -o $@ $< $(ASFLAGS)

# Clean build files
.PHONY: clean
clean:
	rm -r $(BUILD)

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
