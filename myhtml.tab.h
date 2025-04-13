/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     STRING = 258,
     TEXT = 259,
     NUMBER = 260,
     MYHTML_OPEN = 261,
     MYHTML_CLOSE = 262,
     HEAD_OPEN = 263,
     HEAD_CLOSE = 264,
     BODY_OPEN = 265,
     BODY_CLOSE = 266,
     TITLE_OPEN = 267,
     TITLE_CLOSE = 268,
     META_OPEN = 269,
     P_OPEN = 270,
     P_CLOSE = 271,
     A_OPEN = 272,
     A_CLOSE = 273,
     IMG_OPEN = 274,
     FORM_OPEN = 275,
     FORM_CLOSE = 276,
     INPUT_OPEN = 277,
     TAG_END = 278,
     SELF_CLOSE = 279,
     LABEL_OPEN = 280,
     LABEL_CLOSE = 281,
     DIV_OPEN = 282,
     DIV_CLOSE = 283,
     ID_ATTR = 284,
     HREF_ATTR = 285,
     SRC_ATTR = 286,
     ALT_ATTR = 287,
     TYPE_ATTR = 288,
     VALUE_ATTR = 289,
     FOR_ATTR = 290,
     STYLE_ATTR = 291,
     WIDTH_ATTR = 292,
     HEIGHT_ATTR = 293,
     CHARSET_ATTR = 294,
     NAME_ATTR = 295,
     CONTENT_ATTR = 296
   };
#endif
/* Tokens.  */
#define STRING 258
#define TEXT 259
#define NUMBER 260
#define MYHTML_OPEN 261
#define MYHTML_CLOSE 262
#define HEAD_OPEN 263
#define HEAD_CLOSE 264
#define BODY_OPEN 265
#define BODY_CLOSE 266
#define TITLE_OPEN 267
#define TITLE_CLOSE 268
#define META_OPEN 269
#define P_OPEN 270
#define P_CLOSE 271
#define A_OPEN 272
#define A_CLOSE 273
#define IMG_OPEN 274
#define FORM_OPEN 275
#define FORM_CLOSE 276
#define INPUT_OPEN 277
#define TAG_END 278
#define SELF_CLOSE 279
#define LABEL_OPEN 280
#define LABEL_CLOSE 281
#define DIV_OPEN 282
#define DIV_CLOSE 283
#define ID_ATTR 284
#define HREF_ATTR 285
#define SRC_ATTR 286
#define ALT_ATTR 287
#define TYPE_ATTR 288
#define VALUE_ATTR 289
#define FOR_ATTR 290
#define STYLE_ATTR 291
#define WIDTH_ATTR 292
#define HEIGHT_ATTR 293
#define CHARSET_ATTR 294
#define NAME_ATTR 295
#define CONTENT_ATTR 296




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 32 "myhtml.y"
{
    char* str;
    int num;
}
/* Line 1529 of yacc.c.  */
#line 136 "myhtml.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

