# Όνομα του εκτελέσιμου
TARGET = myParser

# Πηγαία αρχεία
LEX = myhtml.l
YACC = myhtml.y

# Παραγόμενα αρχεία
LEX_C = lex.yy.c
YACC_C = myhtml.tab.c
YACC_H = myhtml.tab.h

CC = gcc
CFLAGS = -Wall

all: $(TARGET)

$(TARGET): $(YACC_C) $(LEX_C) main.c
	$(CC) $(CFLAGS) -o $(TARGET) $(YACC_C) $(LEX_C) main.c

$(YACC_C) $(YACC_H): $(YACC)
	bison -d $(YACC)

$(LEX_C): $(LEX)
	flex $(LEX)

clean:
	rm -f $(TARGET) $(LEX_C) $(YACC_C) $(YACC_H)