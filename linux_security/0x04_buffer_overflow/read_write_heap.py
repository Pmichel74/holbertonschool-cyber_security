#!/usr/bin/env python3
"""
Script to find and replace a string in the heap memory of a running process.

Usage:
    ./read_write_heap.py pid search_string replace_string

Arguments:
    pid: The process ID to inspect
    search_string: The string to search for in the heap
    replace_string: The string to replace it with
"""

import sys


def print_usage_and_exit():
    """Display usage message and exit."""
    print(f"Usage: {sys.argv[0]} pid search_string replace_string")
    sys.exit(1)


def read_maps(pid):
    """
    Read /proc/[pid]/maps and find the heap zone.

    Args:
        pid: Process ID as string

    Returns:
        tuple: (heap_start, heap_end) as integers, or (None, None) on error
    """
    try:
        # Open the process maps file (memory map)
        # /proc/ = Linux system directory (fixed)
        # {pid} = process number (variable, e.g., 6515)
        # maps = file containing memory zones (fixed)
        with open(f'/proc/{pid}/maps', 'r') as maps_file:
            # Iterate through each line of the maps file
            for line in maps_file:
                # Look for the line containing [heap]
                if '[heap]' in line:
                    # Format: start_address-end_address permissions ...
                    # Example: 555e646df000-555e64700000 rw-p 00000000 00:00 0
                    addresses = line.split()[0]
                    heap_start, heap_end = addresses.split('-')

                    # Convert hexadecimal addresses to integers
                    heap_start = int(heap_start, 16)
                    heap_end = int(heap_end, 16)

                    return heap_start, heap_end

        # If we reach here, the heap was not found
        print(f"Error: Unable to find heap for PID {pid}")
        return None, None

    except FileNotFoundError:
        print(f"Error: Process {pid} not found")
        return None, None
    except PermissionError:
        print(f"Error: Permission denied to access process {pid}")
        return None, None


def search_and_replace(pid, search_str, replace_str, heap_start, heap_end):
    """
    Search and replace a string in the process heap.

    Args:
        pid: Process ID as string
        search_str: String to search for
        replace_str: String to replace with
        heap_start: Start address of heap
        heap_end: End address of heap

    Returns:
        bool: True if successful, False otherwise
    """
    try:
        # Open /proc/[pid]/mem in binary read/write mode
        # 'rb+' = read binary + write (read AND write in binary mode)
        with open(f'/proc/{pid}/mem', 'rb+', 0) as mem_file:
            # Seek to the beginning of the heap
            mem_file.seek(heap_start)

            # Read all heap content
            heap_size = heap_end - heap_start
            heap_data = mem_file.read(heap_size)

            # Convert strings to bytes (binary format)
            search_bytes = bytes(search_str, 'ASCII')
            replace_bytes = bytes(replace_str, 'ASCII')

            # Search for the string in the heap
            offset = heap_data.find(search_bytes)

            if offset == -1:
                return False

            # Calculate absolute address in memory
            address = heap_start + offset

            # Seek to the string address
            mem_file.seek(address)

            # Write the new string (+ null terminator for C)
            mem_file.write(replace_bytes + b'\0')

            return True

    except PermissionError:
        print("Permission denied")
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False


def main():
    """Main function."""
    # Check arguments
    if len(sys.argv) != 4:
        print_usage_and_exit()

    # Get arguments
    pid = sys.argv[1]
    search_str = sys.argv[2]
    replace_str = sys.argv[3]

    # Find the heap
    heap_start, heap_end = read_maps(pid)

    # Check if heap was found
    if heap_start is None:
        sys.exit(1)

    # Perform replacement
    search_and_replace(pid, search_str, replace_str, heap_start, heap_end)


main()
