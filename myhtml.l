
%option noyywrap nounput noinput
%{
#include "myhtml.tab.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

int line_num = 1;

%}

%x COMMENT
%%
[\n]                { line_num++; }
"<!--"             { BEGIN(COMMENT); }
<COMMENT>"-->"     { BEGIN(INITIAL); }
<COMMENT>.|\n      { /* consume comment content */ }

"<input"   {return INPUT_OPEN; }
"/>"       {return SELF_CLOSE; }

"<MYHTML>"         { return MYHTML_OPEN; }
"</MYHTML>"        { return MYHTML_CLOSE; }

"<head>"           { return HEAD_OPEN; }
"</head>"          { return HEAD_CLOSE; }

"<body>"           { return BODY_OPEN; }
"</body>"          { return BODY_CLOSE; }

"<title>"          { return TITLE_OPEN; }
"</title>"         { return TITLE_CLOSE; }

"<meta"            { return META_OPEN; }
">"                { return TAG_END; }


"<p"               { return P_OPEN; }
"</p>"             { return P_CLOSE; }

"<a"               { return A_OPEN; }
"</a>"             { return A_CLOSE; }

"<img"             { return IMG_OPEN; }

"<form"            { return FORM_OPEN; }
"</form>"          { return FORM_CLOSE; }

"<label"           { return LABEL_OPEN; }
"</label>"         { return LABEL_CLOSE; }

"<div"             { return DIV_OPEN; }
"</div>"           { return DIV_CLOSE; }

"id="              { return ID_ATTR; }
"href="            { return HREF_ATTR; }
"src="             { return SRC_ATTR; }
"alt="             { return ALT_ATTR; }
"type="            { return TYPE_ATTR; }
"value="           { return VALUE_ATTR; }
"for="             { return FOR_ATTR; }
"style="           { return STYLE_ATTR; }
"width="           { return WIDTH_ATTR; }
"height="          { return HEIGHT_ATTR; }
"charset="         { return CHARSET_ATTR; }
"name="            { return NAME_ATTR; }
"content="         { return CONTENT_ATTR; }


\"([^\"\n]*)\"     { yylval.str = strdup(yytext); return STRING; }
\'([^\'\n]*)\'     { yylval.str = strdup(yytext); return STRING; }

[0-9]+             { yylval.num = atoi(yytext); return NUMBER; }
[ \t\r]+           { /* skip whitespace */ }

[a-zA-Z0-9_!@#$%^&*-]+  { yylval.str = strdup(yytext); return TEXT; }
.                  { printf("Λάθος χαρακτήρας στη γραμμή %d: %s\n", line_num, yytext); exit(1); }
%%