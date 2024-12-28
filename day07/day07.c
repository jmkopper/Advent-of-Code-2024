#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int next_power_of_10(long n) {
    if (n < 10) {
        return 10;
    } else if (n < 100) {
        return 100;
    }
    return 1000;
}


int try_ops(long* line, long target, int idx, int try_concat) {
    long v = line[idx];
    if (idx == 0) {
        if (target == v) {
            return 1;
        }
        return 0;
    }

    if (v > target) {
        return 0;
    }

    int m = 0;
    if (target % v == 0) {
        m = try_ops(line, target/v, idx-1, try_concat);
    }

    int a = try_ops(line, target-v, idx-1, try_concat);

    if (try_concat == 0) {
        return a + m;
    }

    int c = 0;
    int np = next_power_of_10(v);
    long n = target % np;
    if (n == v) {
        c = try_ops(line, target/np, idx-1, try_concat);
    }

    return a + m + c;
}


void parse(long* p1, long* p2, char* buffer) {
    *p1 = 0;
    *p2 = 0;

    // using a fixed-size array big enough to hold everything
    long res[30];
    long target;

    char* endptr;
    long num;
    char* ptr;
    int idx;
    char* line = strtok(buffer, "\n");

    // iterate over the lines
    while (line != NULL) {
        // compute the target and array
        idx = 0;
        ptr = line;
        target = strtol(ptr, &endptr, 10);
        ptr = endptr + 2; // move ptr past the colon
        while (ptr != NULL) {
            num = strtol(ptr, &endptr, 10);
            if (ptr == endptr) {
                break;
            }

            // append the next number to the array
            res[idx++] = num;

            // gobble whitespace
            ptr = endptr;
            while(ptr[0] == ' ')
                ptr++;
        }

        // look for solutions
        if (try_ops(res, target, idx-1, 0) > 0) {
            (*p1) += target;
            (*p2) += target;
        } else if (try_ops(res, target, idx-1, 1) > 0) {
            (*p2) += target;
        }

        line = strtok(NULL, "\n");
    }
}


void main() {
    char* buffer = 0;
    long length;

    FILE* f = fopen("input.txt", "rb");

    if (f) {
        fseek(f, 0, SEEK_END);
        length = ftell(f);
        fseek(f, 0, SEEK_SET);
        buffer = malloc(length) + 1; // +1 for null-termination
        if (buffer) {
            fread(buffer, 1, length, f);
        }

        fclose(f);
        buffer[length] = '\0'; // fread doesn't add \0 on its own
    }

    if (!buffer) {
        return;
    }

    long p1, p2;
    parse(&p1, &p2, buffer);
    printf("Part 1: %ld\nPart 2: %ld\n", p1, p2);
}
