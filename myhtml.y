%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex(void);
void yyerror(const char *s);
extern int line_num;

%}

%union {
    char* str;
    int num;
}

%type <str> quoted_string
%token <str> STRING TEXT
%token <num> NUMBER

%token MYHTML_OPEN MYHTML_CLOSE
%token HEAD_OPEN HEAD_CLOSE
%token BODY_OPEN BODY_CLOSE
%token TITLE_OPEN TITLE_CLOSE
%token META_OPEN

%token P_OPEN P_CLOSE
%token A_OPEN A_CLOSE
%token IMG_OPEN
%token FORM_OPEN FORM_CLOSE
%token INPUT_OPEN TAG_END SELF_CLOSE
%token LABEL_OPEN LABEL_CLOSE
%token DIV_OPEN DIV_CLOSE

%token ID_ATTR HREF_ATTR SRC_ATTR ALT_ATTR TYPE_ATTR VALUE_ATTR FOR_ATTR STYLE_ATTR
%token WIDTH_ATTR HEIGHT_ATTR CHARSET_ATTR NAME_ATTR CONTENT_ATTR

%start document

%%

document:
    myhtml_element
;

myhtml_element:
    MYHTML_OPEN head_opt body MYHTML_CLOSE
;

head_opt:
    head
    | /* empty */
;

head:
    HEAD_OPEN head_content HEAD_CLOSE
;

head_content:
    title meta_list
;

meta_list:
    meta meta_list
    | /* empty */
;

title:
    TITLE_OPEN text TITLE_CLOSE
;

meta:
    META_OPEN meta_charset TAG_END
    | META_OPEN meta_name_content TAG_END
;

meta_charset:
    CHARSET_ATTR quoted_string
;

meta_name_content:
    NAME_ATTR quoted_string CONTENT_ATTR quoted_string
;

body:
    BODY_OPEN body_content BODY_CLOSE
;

body_content:
    body_element body_content
    | /* empty */
;

body_element:
    p
    | a
    | img
    | form
    | div
    | comment
;

p:
    P_OPEN p_attr_opt TAG_END text_opt P_CLOSE
;

p_attr_opt:
   id_attr style_attr
    | style_attr id_attr
    | id_attr
    | style_attr
    | /* empty */
;

a:
    A_OPEN a_attrs TAG_END a_content A_CLOSE
;

a_attrs:
    HREF_ATTR quoted_string
    | STYLE_ATTR quoted_string
    | HREF_ATTR quoted_string STYLE_ATTR quoted_string
    | STYLE_ATTR quoted_string HREF_ATTR quoted_string
    | /* empty */
;

a_content:
    text_opt
    | img
    | text_opt img
    | img text_opt
    | text_opt img text_opt
;

img:
    IMG_OPEN img_attrs SELF_CLOSE
;

img_attrs:
     img_attr  img_attrs
      | /* empty */
;

img_attr:
    SRC_ATTR quoted_string 
    |ALT_ATTR quoted_string
    |WIDTH_ATTR NUMBER
    |HEIGHT_ATTR NUMBER
;  

form:
    FORM_OPEN form_attr_opt TAG_END form_content FORM_CLOSE
;

form_attr_opt:
id_attr style_attr
    | style_attr id_attr
    | id_attr
    | style_attr
    | /* empty */
;

form_content:
    form_element form_content
    | /* empty */
;
form_element:
    input
    | label

input:
    INPUT_OPEN  input_attr_list SELF_CLOSE

input_attr_list:
    input_attr input_attr_list
    | /* empty */
;

input_attr:
    TYPE_ATTR quoted_string
    | ID_ATTR quoted_string
    | VALUE_ATTR quoted_string
    | style_attr
;

label:
    LABEL_OPEN label_attr_list TAG_END text_opt LABEL_CLOSE
;

label_attr_list:
    label_attr label_attr_list
  | /* empty */
;

label_attr:
    id_attr
  | for_attr
  | style_attr
;

div:
    DIV_OPEN div_attr_opt TAG_END div_content DIV_CLOSE
;

div_attr_opt:
    id_attr style_attr
    | style_attr id_attr
    | id_attr
    | style_attr
    | /* empty */
;

div_content:
    body_content
;

id_attr:
    ID_ATTR quoted_string
;

for_attr:
    FOR_ATTR quoted_string
;

style_attr:
    STYLE_ATTR quoted_string
;

quoted_string:
     STRING 
;

text_opt:
    text
    | /*empty*/
;

text:
    TEXT text
    | STRING text
    | 
;

comment:
   STRING
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Σφάλμα στη γραμμή %d: %s\n", line_num, s);
    exit(1);
}
