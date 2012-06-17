@contributor{Vadim Zaytsev - vadim@grammarware.net - SWAT, CWI}
module extract::RascalSyntax2BGF

import lang::rascal::\syntax::RascalRascal;
import lang::rascal::grammar::definition::Modules;
import Grammar;
import ParseTree;
import syntax::BGF;
import io::WriteBGF;
import normal::BGF;
import String;

import IO;

public void main(list[str] args)
{
	str gs = trim(readFile(|cwd:///|+args[0]));
	str name = split("\n",split("module ",gs)[1])[0];
	writeBGF(normalise(grammar2grammar(modules2grammar(name,{parse(#Module,gs)}))),|cwd:///|+args[1]);
	println("Extraction completed.");
}

public void main()
{
	Module pt = parse(#Module,|project://fl/src/Concrete.rsc|);
	Grammar g = modules2grammar("Concrete", {pt});
	//Grammar g = module2grammar("Concrete", {pt});
	iprintln(g);
	iprintln(grammar2grammar(g));
}

BGFGrammar grammar2grammar(Grammar::\grammar(set[Symbol] starts, map[Symbol sort, Production def] rules))
 = syntax::BGF::grammar ([symbol2str(s) | s <- starts], [*rule2prods(rules[s]) | s <- rules, sort(_) := s]);

str symbol2str(lex(str s)) = "<s>"; 
str symbol2str(\start(sort(str s))) = "<s>";
str symbol2str(sort(str s)) = "<s>";
str symbol2str(layouts(str s)) = "";
str symbol2str(keywords(str s)) = "";
default str symbol2str(Symbol s) = "<s>";

list[BGFProduction] rule2prods(ParseTree::choice(lex(str s), _)) = [];
list[BGFProduction] rule2prods(ParseTree::choice(sort(str s), set[Production] ps))
	= [prod2prod(p) | p <- ps];

default list[BGFProduction] rule2prods(Production def)
	= [production("", "UNKNOWN", syntax::BGF::terminal("<def>"))];

default BGFProduction prod2prod(prod(label(str lab, sort(str nt)), list[Symbol] rhs, _))
	= production(lab, nt, rhs2expr(rhs));

default BGFProduction prod2prod(prod(sort(str nt), list[Symbol] rhs, _))
	= production("", nt, rhs2expr(rhs));

default BGFProduction prod2prod(Production def) = production("", "?", syntax::BGF::epsilon());

BGFExpression rhs2expr([Symbol s]) = symbol2expr(s);
BGFExpression rhs2expr(list[Symbol] seq) = syntax::BGF::sequence([symbol2expr(s) | s <- seq, layouts(_) !:= s]);

BGFExpression symbol2expr(\sort(str x)) = syntax::BGF::nonterminal(x);
BGFExpression symbol2expr(conditional(\sort(str x),{except(_)})) = syntax::BGF::nonterminal(x); // cannot represent better in BGF
BGFExpression symbol2expr(\lex(str x)) = syntax::BGF::nonterminal(x);
BGFExpression symbol2expr(ParseTree::\lit("\n")) = syntax::BGF::terminal("\\n"); //hack?
BGFExpression symbol2expr(ParseTree::\lit(str x)) = syntax::BGF::terminal(x);
BGFExpression symbol2expr(\iter-seps(Symbol item, list[Symbol] seps)) = iterseps2expr(item,[s | s <- seps, layouts(_) !:= s]);
default BGFExpression symbol2expr(Symbol s) = epsilon();

BGFExpression iterseps2expr(Symbol item, []) = syntax::BGF::plus(symbol2expr(item));
BGFExpression iterseps2expr(Symbol item, [Symbol sep]) = seplistplus(symbol2expr(item), symbol2expr(sep));
default BGFExpression iterseps2expr(Symbol item, list[Symbol] seps) = seplistplus(symbol2expr(item), syntax::BGF::sequence([symbol2expr(sep) | sep <- seps]));
