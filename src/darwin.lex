%name DarwinLexer;

%let digit = [0-9];
%let int = {digit}+;
%let alpha = [a-zA-Z];
%let id = {alpha}({alpha} | {digit})*;
%let str = ["]{id}["];
%let primitivo = ("int"|"string"|"boolean"|"float");
%let tuple = "tuple" "(" ({primitivo} ("," {primitivo}){1,9} ")" );
%let lista = ("sample of "({primitivo}|{tuple}));  
%let tipo = ({primitivo}|{tuple}|{lista});
%let true = "true";
%let false = "false";
%let boolean = ({true}|{false});
%let float = {int}["."]({int}+|{digit}("e"|"E"){int});
%let valPrim = ({int} | {str} | {boolean} | {float});
%let tupleVal = ( "(" {valPrim} ("," {valPrim}){1,9} ")" );
%let empty = "{}";
%let intList = ({empty} | "{" {int} ("," {int})* "}" );
%let floatList = ({empty} | "{" {float} ("," {float})* "}" );
%let booleanList = ({empty} | "{" {boolean} ("," {boolean})* "}" );
%let strList = ({empty} | "{" {str} ("," {str})* "}" );
%let tupleList = ({empty} | "{" {tupleVal} ("," {tupleVal})* "}" );
%defs (
    structure T = DarwinTokens
    type lex_result = T.token
    fun eof() = T.EOF
);

"variables" => ( T.KW_variables );
"title" => ( T.KW_title );
"commands" => ( T.KW_comands );
"print" => ( T.KW_Print );
"sum" => ( T.KW_SUM );
"prod" => ( T.KW_PROD );
"toString" => ( T.KW_TOSTRING );
"end variables" => ( T.KW_endvars );
"mean" => ( T.KW_MEAN );
"correlation" => ( T.KW_CORR );
"median" => ( T.KW_MEDIAN );
"stdDeviation" => ( T.KW_STDEV );
"variance" => ( T.KW_VAR );
"get" => ( T.KW_GET );
"linearRegression" => (T.KW_LINREG);
"covariance" => (T.KW_COV);
{tipo} => ( T.TIPO yytext );
{id} => ( T.ID yytext );
{str} => (T.STR yytext);
{int} => ( T.NUM (valOf (Int.fromString yytext)) );
{float} => ( T.REAL (valOf (Real.fromString yytext)) );
{boolean} => ( T.BOOL (valOf (Bool.fromString yytext)) );
{intList} => (T.SINT (Grammar.toIntList (Grammar.tokenize yytext)));
{floatList} => (T.SFLOAT (Grammar.toFloatList (Grammar.tokenize yytext)));
{booleanList} => (T.SBOOL (Grammar.toBoolList (Grammar.tokenize yytext)));
{strList} => ( T.SSTRING (Grammar.tokenize yytext));
"if" => ( T.KW_IF );
"then" => ( T.KW_THEN );
"else" => ( T.KW_ELSE );
"while" => ( T.KW_WHILE );
"do" => ( T.KW_DO );
"end" => ( T.KW_END );
"=" => ( T.EQ );
"==" => ( T.EEQ );
";" => ( T.SEMI);
"+" => ( T.PLUS );
"-" => ( T.MINUS );
"*" => ( T.TIMES );
"/" => ( T.DIV );
"(" => ( T.LP );
")" => ( T.RP );
"." => ( T.DOT );
"&&" => ( T.AND );
"||" => ( T.OR );
"!" => ( T.NOT );
">=" => ( T.GEQ );
"<=" => ( T.LEQ );
">=" => ( T.GT );
"<=" => ( T.LT );
"!=" => ( T.NEQ );
"{}" => ( T.EMPTY );
"," => ( T.COMMA );
" " | \n | \t => ( continue() );
"terminate"   => ( T.KW_terminate ); 
.		=> (print (concat ["Unexpected character: '", yytext,
			           "'\n"]); continue());
