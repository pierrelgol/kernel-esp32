# Toolchain and utilities
ZIG      = zig
LD       = xtensa-esp32s3-elf-gcc
OBJCOPY  = xtensa-esp32s3-elf-objcopy
ESPTOOL  = esptool.py

# Flashing config
PORT     = /dev/ttyUSB0
BAUD     = 460800
CHIP     = esp32

# Targets
TARGET_ELF     = kernel.elf
TARGET_OBJ     = main.o
TARGET_BIN     = kernel.bin               
TARGET_IMG     = kernel_image.bin         

# Default target
.DEFAULT_GOAL := re

.PHONY: all re clean fclean flash flash-raw flash-image monitor

# Build everything
all: $(TARGET_IMG)

# Rebuild everything
re: fclean all

# Compile Zig source to object file
$(TARGET_OBJ): main.zig
	$(ZIG) build-obj $< -OReleaseSmall -target xtensa-freestanding-none -mcpu=$(CHIP)

# Link the object file into an ELF
$(TARGET_ELF): $(TARGET_OBJ) linker.ld
	$(LD) -nostdlib -Wl,--no-check-sections -Wl,-static -Wl,-Tlinker.ld -o $@ $(TARGET_OBJ)

# Convert ELF to raw binary
$(TARGET_BIN): $(TARGET_ELF)
	$(OBJCOPY) -O binary $< $@

# Convert ELF to ESP bootable image
$(TARGET_IMG): $(TARGET_ELF)
	$(ESPTOOL) --chip $(CHIP) elf2image --output $@ $<

# Flash the elf2image output
flash: flash-image

# Flash image (bootable)
flash-image: $(TARGET_IMG)
	$(ESPTOOL) --chip $(CHIP) --port $(PORT) --baud $(BAUD) write_flash 0x10000 $(TARGET_IMG)

# (Optional) Flash raw binary directly (useful for testing)
flash-raw: $(TARGET_BIN)
	$(ESPTOOL) --chip $(CHIP) --port $(PORT) --baud $(BAUD) write_flash 0x10000 $(TARGET_BIN)

# Serial monitor
monitor:
	screen $(PORT) 115200

# Clean intermediate files
clean:
	rm -f *.o *.elf *.bin

# Full clean
fclean: clean
	rm -rf zig-cache zig-out
