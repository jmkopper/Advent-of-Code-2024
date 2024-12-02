#include <stdio.h>
#include <stdlib.h>

#define MAX_VAL 100000

int read_input(const char* fn, int** lefts, int** rights) {
    // read `fn` into the left and right buffers
    // returns the number of elements
    int i = 0;
    int current_val = 0;
    int left = 1;
    int n = 0;
    FILE* fp = fopen(fn, "r");

    while (1) {
        char c = fgetc(fp);
        if (c == '\n') {
            n++;
        } else if (c == EOF) {
            break;
        }
    }
    rewind(fp);

    *lefts = malloc(sizeof(int) * n);
    *rights = malloc(sizeof(int) * n);

    while (1) {
        char c = fgetc(fp);

        if (c == ' ' && left == 1) {
            left = 0;
            (*lefts)[i] = current_val;
            current_val = 0;
        } else if (c == '\n') {
            (*rights)[i] = current_val;
            current_val = 0;
            left = 1;
            i += 1;
        } else if (c >= 48 && c <= 57) {
            current_val *= 10;
            current_val += c - '0';
        }

        if (c == EOF) {
            break;
        }
    }

    return n;
}

int cmp_ints(const void* a, const void* b) {
    return *(int*)a - *(int*)b;
}

int part1(int* lefts, int* rights, int n) {
    int sum = 0;
    qsort(lefts, n, sizeof(int), cmp_ints);
    qsort(rights, n, sizeof(int), cmp_ints);

    for (int i = 0; i < n; i++) {
        if (lefts[i] < rights[i]) {
            sum += rights[i] - lefts[i];
        } else {
            sum += lefts[i] - rights[i];
        }
    }

    return sum;
}

int part2(int* lefts, int* rights, int n) {
    int sum = 0;
    int counts[MAX_VAL] = {0};

    for (int i = 0; i < n; i++) {
        counts[rights[i]]++;
    }

    for (int i = 0; i < n; i++) {
        sum += counts[lefts[i]] * lefts[i];
    }

    return sum;
}

int main(int argc, char **argv) {
    int *lefts;
    int *rights;
    int n = read_input(argv[1], &lefts, &rights);

    int p1 = part1(lefts, rights, n);
    int p2 = part2(lefts, rights, n);
    
    printf("Part 1: %d\n", p1);
    printf("Part 2: %d\n", p2);
}
