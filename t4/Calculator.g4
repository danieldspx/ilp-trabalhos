grammar Calculator;

expression : term ((ADD | SUB) term)*;
term : factor ((MUL | DIV) factor)*;
factor : NUMBER | '(' expression ')';

ADD : '+';
SUB : '-';
MUL : '*';
DIV : '/';

NUMBER : [0-9]+;
WS : [ \t\r\n]+ -> skip;