import java_cup.runtime.*;

%%

// DECLARATION SECTION


%class scanner
%unicode
%cup
%line
%column

%{
  private Symbol sym(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol sym(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
	
  }
%}

/* Useful */

comment1 = ("//" .*)
comment2 = "{{" ~ "}}"

/* Numbers */

uint = 0 | [1-9][0-9]*
real = ("+"|"-")? ((0\.[0-9]*) |  [1-9][0-9]*\.[0-9]* | \.[0-9]+ | [1-9][0-9]*\. | 0\.)

/* Strings */

qstring = \" ~ \"

sep="***"

/* TOKEN 1 */
token1={hex}"*"{charact}{5}({charact}{2})*"-"(("****"("**")*)|({word}))?
//between 27A and 12b3
hex=(27[A-Fa-f]) | (2[89A-Fa-f][0-9A-Fa-f]) |([3-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]) 
  | (1[01][0-9A-Fa-f][0-9A-Fa-f]) | 12[0-9Aa][0-9A-Fa-f] | 12b[0-3]
charact=[A-Za-z]
word="Y"("X"("XX")*)"Y"

/* TOKEN 2 */
token2={ip}"-"{date1}
ip_num = (2(([0-4][0-9])| (5[0-5]))) | (1[0-9][0-9]) | ([1-9][0-9]) | ([0-9])
ip = {ip_num}"."{ip_num}"."{ip_num}"."{ip_num}
//05/10/2023 to 03/03/2024
date1=(0[5-9]"/"10"/"2023)  
  | ((([12][0-9])|(3[01]))"/"10"/"2023) 
  | (((0[1-9])|([1-2][0-9])|(30))"/"11"/"2023) 
  | (((0[1-9])|([1-2][0-9])|(3[01]))"/"12"/"2023) 
  | (((0[1-9])|([1-2][0-9])|(3[01]))"/"01"/"2024) 
  | (((0[1-9])|([1-2][0-9]))"/"02"/"2024) 
  | ((0[1-3])"/"03"/"2024) 

/* TOKEN 3 */
token3=({num}({separa}{num}){2}) | ({num}({separa}{num}){4}) 
num= ([1-9]([0-9]){3}) | ([1-9]([0-9]){5})
separa= "-" | "+"

%%
"euro" {return sym(sym.EURO);}
"%" {return sym(sym.PERC);}
{sep}   {return sym(sym.SEP);}
{token1}   {return sym(sym.TK1);}
{token2}   {return sym(sym.TK2);}
{token3}   {return sym(sym.TK3);}

{uint}   {return sym(sym.UINT, new Integer(yytext()));}
{real}   {return sym(sym.REAL, new Double(yytext()));}
{qstring}   {return sym(sym.QSTRING, new String(yytext()));}


","     {return sym(sym.CM);}
";"     {return sym(sym.S);}
"-"     {return sym(sym.MINUS);}

{comment1} {;}
{comment2} {;}
\r | \n | \r\n | " " | \t {;}

. { System.out.println("Scanner Error: " + yytext()) ;}