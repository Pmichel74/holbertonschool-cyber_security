# 0x04. Buffer Overflow - Heap Memory Manipulation 🔍

Welcome to the heap memory manipulation project! This is where things get interesting - we're going to peek into a running process's memory and change it on the fly.

## What Does This Do? 🤔

This project contains a Python script that can find and replace strings directly in the heap memory of a running process. Think of it like using "Find & Replace" in a text editor, except we're editing the actual RAM of a running program!

## Quick Start 🚀

### Step 1: Compile the Test Program

```bash
gcc -o main 0-main.c
```

### Step 2: Run the Target Process

```bash
./main
```

You'll see output like this:
```
[0] Holberton (0x55e8c9c012a0)
[1] Holberton (0x55e8c9c012a0)
[2] Holberton (0x55e8c9c012a0)
...
```

### Step 3: Hack the Memory! (in another terminal)

Find the process ID (PID) from the first terminal, then run:

```bash
sudo ./read_write_heap.py <PID> Holberton School
```

Watch the magic happen! The output in the first terminal should change to:
```
[15] School (0x55e8c9c012a0)
[16] School (0x55e8c9c012a0)
...
```

## Usage

```bash
./read_write_heap.py pid search_string replace_string
```

**Arguments:**
- `pid` - The process ID you want to target
- `search_string` - The text to search for (ASCII only)
- `replace_string` - What to replace it with (ASCII only)

**Exit Codes:**
- `0` - Success! 🎉
- `1` - Something went wrong (wrong usage, no permissions, string not found, etc.)

## How It Works 🔧

The script does some pretty cool stuff under the hood:

1. **Finds the Heap** - Reads `/proc/[PID]/maps` to locate where the heap lives in memory
2. **Opens Memory** - Accesses `/proc/[PID]/mem` to read the actual memory
3. **Searches** - Looks for your target string in the heap
4. **Replaces** - Overwrites the old string with the new one
5. **Pads** - Fills remaining space with null bytes if needed

## Important Notes ⚠️

### You Need Root Access

This script needs `sudo` because you're messing with another process's memory. That's serious business!

### Educational Purposes Only

This is a learning tool for understanding:
- How process memory works in Linux
- The `/proc` filesystem
- Memory manipulation techniques
- Security concepts

**Don't use this on production systems or processes you don't own!**

## Project Files 📁

### [read_write_heap.py](read_write_heap.py)

The main script that does all the heavy lifting:
- Locates the heap in process memory
- Searches for ASCII strings
- Replaces them in real-time
- Handles errors gracefully

### [0-main.c](0-main.c)

A simple test program that:
- Allocates "Holberton" on the heap using `strdup()`
- Prints the string and its memory address every second
- Runs forever (until you stop it or modify its memory!)

## What's the Heap? 🧠

The **heap** is a region of memory used for dynamic allocation. When a program calls `malloc()`, `calloc()`, or (in this case) `strdup()`, the memory comes from the heap. Unlike the stack, heap memory:
- Can be any size
- Sticks around until you free it
- Grows as your program needs more memory

## Troubleshooting 🔍

**"Permission denied"** - Use `sudo`!

**"No such process"** - Make sure the PID is correct and the process is still running

**String not found** - The string might not be in the heap, or you misspelled it

**Nothing happens** - Double-check you're using the right PID

## Cool Things to Try 💡

- Replace "Holberton" with longer strings and see what happens
- Try finding and replacing other strings you allocate
- Monitor `/proc/[PID]/maps` to see how memory regions are organized
- Experiment with different processes (be careful!)

## Under the Hood: /proc Filesystem 🐧

Linux's `/proc` filesystem is a virtual filesystem that provides a window into running processes:

- `/proc/[PID]/maps` - Shows all memory regions of the process
- `/proc/[PID]/mem` - Direct access to the process's memory
- Each running process gets its own directory

## Limitations 🚧

- Only works with ASCII strings
- Only searches the heap (not stack or other memory regions)
- Replacement can't be longer than the original string
- Requires the target process to have an active heap

## Security Considerations 🔒

Be aware that this script:
- Requires root privileges (powerful but dangerous)
- Can crash the target process if used incorrectly
- Could corrupt data in the process
- Should only be used in controlled testing environments

## Want to Learn More? 📚

Check out these resources:
- [proc(5) - Linux manual page](https://man7.org/linux/man-pages/man5/proc.5.html)
- [Memory Layout of C Programs](https://www.geeksforgeeks.org/memory-layout-of-c-program/)
- [Buffer Overflow Attacks](https://owasp.org/www-community/vulnerabilities/Buffer_Overflow)

## Author

Holberton School - Cyber Security Specialization

---

**Happy Hacking! 🎓**

Remember: With great power comes great responsibility. Use this knowledge wisely!
