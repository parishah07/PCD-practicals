#ifndef EXPR_H
#define EXPR_H

typedef struct Expr {
    char* place;
} Expr;

/* Label & temporary counters */
static int temp_count = 0;
static int label_count = 0;

static char* newtemp() {
    static char temp[10];
    sprintf(temp, "t%d", ++temp_count);
    return strdup(temp);
}

static char* newlabel() {
    static char label[10];
    sprintf(label, "L%d", ++label_count);
    return strdup(label);
}

#endif
