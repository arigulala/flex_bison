%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>   
#define MAX_IDS 1000
int submit_count = 0;
int last_element_is_submit = 0;
int has_error = 0;
char* ids_seen[MAX_IDS];
int ids_count = 0;
void yyerror(const char *s);
extern int yylex(void);
extern int is_valid_url(const char *url);
extern int is_valid_href(const char *href);
extern int is_valid_type(const char *type);
extern int line_num;

int is_valid_type(const char *type) {
    return (
        strcmp(type, "text") == 0 ||
        strcmp(type, "checkbox") == 0 ||
        strcmp(type, "radio") == 0 ||
        strcmp(type, "submit") == 0
    );
}

int id_exists(const char* id) {
    for (int i = 0; i < ids_count; i++) {
        if (strcmp(ids_seen[i], id) == 0)
            return 1;
    }
    return 0;
}

void add_id(const char* id) {
    if (ids_count >= MAX_IDS) {
        fprintf(stderr, "Σφάλμα: Υπέρβαση μέγιστου αριθμού id.\n");
        exit(1);
    }
    ids_seen[ids_count++] = strdup(id);
}

%}

%union {
    char* str;
    int num;
}

%type <str> text
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
    TITLE_OPEN text TITLE_CLOSE {
        if (strlen($2) > 60) {
            fprintf(stderr, "Σφάλμα: Το περιεχόμενο του <title> υπερβαίνει τους 60 χαρακτήρες.\n");
            has_error = 1;
        }
    }
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
    P_OPEN p_attr TAG_END text_opt P_CLOSE
;

p_attr:
   id_attr p_opt_attr
    | p_opt_attr id_attr
    
;

p_opt_attr:
    style_attr
    | /* empty */
;

a:
    A_OPEN a_attrs TAG_END a_content A_CLOSE
;

a_attrs:
   
    | id_attr href_attr
    | href_attr id_attr
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
    src_attr alt_attr id_attr img_opt_attrs
  | src_attr id_attr alt_attr img_opt_attrs
  | alt_attr id_attr src_attr img_opt_attrs
  | alt_attr src_attr id_attr img_opt_attrs
  | id_attr alt_attr src_attr img_opt_attrs
  | id_attr src_attr alt_attr img_opt_attrs
;

img_opt_attrs:
    img_opt_attr img_opt_attrs
    | /* empty */
;

img_opt_attr:
    width_attr
    | height_attr
;

form:
    FORM_OPEN form_attr_opt TAG_END form_content FORM_CLOSE
;

form_attr_opt:
      id_attr form_opt_attr
    | form_opt_attr id_attr
    
;

form_opt_attr:
    style_attr
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
    INPUT_OPEN input_attrs SELF_CLOSE
;

input_attrs:
    type_attr id_attr input_opt_attrs
    | id_attr type_attr input_opt_attrs
;
input_opt_attrs:
    input_opt_attr input_opt_attrs
    | /* empty */
;

input_opt_attr:
    value_attr
    | style_attr
;

label:
    LABEL_OPEN label_attrs TAG_END text_opt LABEL_CLOSE
;

label_attrs:
    id_attr for_attr label_opt_attr
    | for_attr id_attr label_opt_attr
;

label_opt_attr:
    style_attr
    | /* empty */
;

div:
    DIV_OPEN div_attr_opt TAG_END div_content DIV_CLOSE
;

div_attr_opt:
    id_attr div_opt_attr
    | div_opt_attr id_attr
   
;
div_opt_attr:
    style_attr
    | /* empty */
;
div_content:
    body_content
;

id_attr:
    ID_ATTR quoted_string {
        if (id_exists($2)) {
            fprintf(stderr, "Σφάλμα: Το id \"%s\" έχει ήδη χρησιμοποιηθεί.\n", $2);
            has_error = 1;
        } else {
            add_id($2);
        }
        free($2); // αν χρησιμοποιείς strdup στον lexer
    }
;

for_attr:
    FOR_ATTR quoted_string
;

style_attr:
    STYLE_ATTR quoted_string
;

src_attr:
    SRC_ATTR quoted_string{
        if (!is_valid_url($2)) {
    fprintf(stderr, "Σφάλμα: Η τιμή του src είναι μη έγκυρη: %s\n", $2);
    has_error = 1;
  }
}
;

alt_attr:
    ALT_ATTR quoted_string
;

width_attr:
    WIDTH_ATTR NUMBER
;

height_attr:
    HEIGHT_ATTR NUMBER
;

value_attr:
    VALUE_ATTR quoted_string 
;

type_attr:
    TYPE_ATTR quoted_string {
        char *type_value = strndup($2 + 1, strlen($2) - 2);

        if (!is_valid_type(type_value)) {
            printf("Σφάλμα: Μη αποδεκτή τιμή για type: \"%s\"\n", type_value);
            has_error = 1;
        }

        if (submit_count > 1) {
            printf("Σφάλμα: Υπάρχουν παραπάνω από ένα input type=\"submit\".\n");
            has_error = 1;
        }

        if (submit_count == 1 && !last_element_is_submit) {
            printf("Σφάλμα: Το input type=\"submit\" πρέπει να είναι το τελευταίο στοιχείο.\n");
            has_error = 1;
        }

        if (strcmp(type_value, "submit") == 0) {
            submit_count++;
            last_element_is_submit = 1;
        } else {
            last_element_is_submit = 0;
        }

        free(type_value);  // Προαιρετικά για αποφυγή memory leak
    }
;

href_attr:
  HREF_ATTR quoted_string {
        if (!is_valid_href($2)) {
            printf("Σφάλμα: Η τιμή του href είναι μη έγκυρη: \"%s\"\n", $2);
            has_error = 1;
        }
    }
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
    | /*empty*/
;

comment:
   STRING
;

%%
void yyerror(const char *s) {
    fprintf(stderr, "Σφάλμα στη γραμμή %d: %s\n", line_num, s);
    exit(1);
}