grammar JavaRecognizer; compilationUnit
	:	
		
		
		(	packageDefinition|	EPSILON
		)

		
		( importDefinition )*

		
		
		( typeDefinition )*

		EOF
	;



packageDefinition: annotations p='package' identifier SEMI
	;




importDefinition: i='import' ('static')? identifierStar SEMI
	;



typeDefinition: m=modifiers
		( classDefinition
		| enumDefinition
		| interfaceDefinition
		| annotationTypeDefinition
		)
	|	SEMI
	;


declaration: m=modifiers t=typeSpec v=variableDefinitions
	;



typeSpec: classTypeSpec
	| builtInTypeSpec
	;


referenceTypeSpec: classTypeSpec
	| arrayTypeSpec
	;





classTypeSpec: classOrInterfaceType
		(lb=LBRACK RBRACK
		)*
	;

classOrInterfaceType: IDENT typeArguments
		(DOT
			IDENT typeArguments
		)*
	;

typeArguments: (
			lt=LT
			typeArgument
			(COMMA typeArgument
			)*

			(   
				
				typeArgumentsEnd
			)?
		)|	EPSILON;


typeArgument
	:	(	q=QUESTION
			( 
				'extends' referenceTypeSpec
			|	'super' referenceTypeSpec
			)?
		)
	|	referenceTypeSpec
	;



typeArgumentsEnd: (	GT
		|	SR
		|	BSR
		)
	;



builtInTypeSpec: builtInType
		(lb=LBRACK RBRACK
		)*
	;


arrayTypeSpec: builtInType
		(lb=LBRACK RBRACK
		)+
	;



type
	:	classOrInterfaceType
	|	builtInType
	;


builtInType
	:	'void'
	|	'boolean'
	|	'byte'
	|	'char'
	|	'short'
	|	'int'
	|	'float'
	|	'long'
	|	'double'
	;



identifier
	:	IDENT  ( DOT IDENT )*
	;

identifierStar
	:	IDENT
		( DOT IDENT )*
		( DOT STAR  )?
	;







modifiers
	:	( modifier | annotation )*
	;


modifier
	:	'private'
	|	'public'
	|	'protected'
	|	'static'
	|	'transient'
	|	'final'
	|	'abstract'
	|	'native'
	|	'threadsafe'
	|	'synchronized'

	|	'volatile'
	|	'strictfp'
	;


enumDefinition: ENUM IDENT
		
		ic=implementsClause
		
		eb=enumBlock
	;





enumBlock
	:	LCURLY 
			( enumConst ( COMMA enumConst )* )?
			( COMMA )?	
			( SEMI ( classField | SEMI )* )?
		RCURLY
	;



enumConst
	:	annotations IDENT enumConstInit ( classBlock )?
	;


enumConstInit
	:	lp=LPAREN argList RPAREN
	|	EPSILON;


annotationTypeDefinition: AT 'interface' IDENT
		
		ab=annotationBlock
	;



annotationBlock
	:	LCURLY
			( annotationField | SEMI )*
		RCURLY
	;

annotationField: mods=modifiers
		(	it=innerTypeDef
		|	ts=typeSpec
			(	i=IDENT LPAREN RPAREN dv=defaultValue SEMI
			|	v=variableDefinitions SEMI
			)
		)
	;


defaultValue
	:	( 'default' annotationMemberValue )?
	;

annotations
	:	( annotation )*
	;

annotation
	:	AT identifier annotationInit
	;


annotationInit
	:	(	lp=LPAREN
			(	annotationMemberInit
				( COMMA annotationMemberInit )*
			|	annotationMemberValue
			|	EPSILON)
			RPAREN
		)
	|	EPSILON;

annotationMemberInit
	:	IDENT ASSIGN annotationMemberValue
	;

annotationMemberValue
	:	annotation
	|	conditionalExpression
	|	annotationMemberArrayInitializer
	;



annotationMemberArrayInitializer
	:	lc=LCURLY
			(	annotationMemberValue
				(
					
					
					
					
					COMMA annotationMemberValue
				)*
			)?
			(COMMA)?
		RCURLY
	;


classDefinition: 'class' IDENT
		
		tp=typeParameters
		
		sc=superClassClause
		
		ic=implementsClause
		
		cb=classBlock
	;

superClassClause: ( 'extends' classOrInterfaceType )?
	;


interfaceDefinition: 'interface' IDENT
		
		tp=typeParameters
		
		ie=interfaceExtends
		
		ib=interfaceBlock
	;

typeParameters: (
			lt=LT
			typeParameter (COMMA typeParameter)*
			(typeArgumentsEnd)?
		)|	EPSILON;

typeParameter
	:	IDENT
		(   
			'extends' classOrInterfaceType
			(BAND classOrInterfaceType)*
		)?
	;


interfaceBlock
	:	LCURLY
			( interfaceField | SEMI )*
		RCURLY
	;



classBlock
	:	LCURLY
			( classField | SEMI )*
		RCURLY
	;


interfaceExtends
	:	(
		e='extends'
		classOrInterfaceType ( COMMA classOrInterfaceType )*
		)?
	;


implementsClause
	:	(
			i='implements' classOrInterfaceType
							( COMMA classOrInterfaceType )*
		)?
	;


innerTypeDef: (	ed=enumDefinition

		|	cd=classDefinition

		|	id=interfaceDefinition

		|	ad=annotationTypeDefinition
		)
		;

memberDef: t=typeSpec  
		(	IDENT  

			
			LPAREN param=parameterDeclarationList RPAREN

			rt=declaratorBrackets

			
			
			(tc=throwsClause)?

			( SEMI | s2=compoundStatement)
		|	v=variableDefinitions SEMI 
		)
	;




interfaceField: mods=modifiers
		(	it=innerTypeDef
		|	tp=typeParameters md=memberDef
		)
	;


classField: mods=modifiers
		(	it=innerTypeDef

		|	tp=typeParameters
			(	h=ctorHead s=constructorBody

			|	md=memberDef
			)
		)

	
	|	'static' s3=compoundStatement

	
	|	s4=compoundStatement
	;

constructorBody
	:	lc=LCURLY
			( explicitConstructorInvocation)?
			(statement)*
		RCURLY
	;


explicitConstructorInvocation
	:	typeArguments
		(	'this' lp1=LPAREN argList RPAREN SEMI
		|	'super' lp2=LPAREN argList RPAREN SEMI
		)
	;

variableDefinitions: variableDeclarator
		(	COMMA
			variableDeclarator
		)*
	;


variableDeclarator: id=IDENT d=declaratorBrackets v=varInitializer
	;

declaratorBrackets: (lb=LBRACK RBRACK)*;

varInitializer
	:	( ASSIGN initializer )?
	;


arrayInitializer
	:	lc=LCURLY
			(	initializer
				(
					
					
					
					
					COMMA initializer
				)*
			)?
			(COMMA)?
		RCURLY
	;



initializer
	:	expression
	|	arrayInitializer
	;




ctorHead
	:	IDENT  

		
		LPAREN parameterDeclarationList RPAREN

		
		(throwsClause)?
	;


throwsClause
	:	'throws' identifier ( COMMA identifier )*
	;



parameterDeclarationList
	:	( parameterDeclaration ( COMMA parameterDeclaration )* )?
	;





parameterDeclaration: pm=parameterModifier t=typeSpec ( el=ELLIPSIS )? id=IDENT
		pd=declaratorBrackets
	;


parameterModifier
	:	( 'final' | annotation )*
	;










compoundStatement
	:	lc=LCURLY
			
			(statement)*
		RCURLY
	;


statement
	
	:	compoundStatement

	
	
	
	
	|	declaration SEMI|	expression SEMI

	
	|	m=modifiers ( enumDefinition |	classDefinition )

	
	|	IDENT c=COLON statement

	
	|	'if' LPAREN expression RPAREN statement
		(
			
			
			
			'else' statement
		)?

	
	|	'for'
			LPAREN
			(
				parameterDeclaration COLON expression|
				forInit SEMI   
				forCond	SEMI   
				forIter         
			)
			RPAREN
			statement                     

	
	|	'while' LPAREN expression RPAREN statement

	
	|	'do' statement 'while' LPAREN expression RPAREN SEMI

	
	|	'break' (IDENT)? SEMI

	
	|	'continue' (IDENT)? SEMI

	
	|	'return' (expression)? SEMI

	
	|	'switch' LPAREN expression RPAREN LCURLY
			( casesGroup )*
		RCURLY

	
	|	tryBlock

	
	|	'throw' expression SEMI

	
	|	'synchronized' LPAREN expression RPAREN compoundStatement

	
	|	ASSERT expression ( COLON expression )? SEMI

	
	|	s=SEMI
	;

casesGroup
	:	(	
			
			
			
			aCase
		)+
		caseSList
	;

aCase
	:	('case' expression | 'default') COLON
	;

caseSList
	:	(statement)*
	;


forInit
		
	:	(	declaration|	expressionList
		)?
	;

forCond
	:	(expression)?
	;

forIter
	:	(expressionList)?
	;


tryBlock
	:	'try' compoundStatement
		(handler)*
		( finallyClause )?
	;

finallyClause
	:	'finally' compoundStatement
	;


handler
	:	'catch' LPAREN parameterDeclaration RPAREN compoundStatement
	;





































expression
	:	assignmentExpression
	;



expressionList
	:	expression (COMMA expression)*
	;



assignmentExpression
	:	conditionalExpression
		(	(	ASSIGN
			|	PLUS_ASSIGN
			|	MINUS_ASSIGN
			|	STAR_ASSIGN
			|	DIV_ASSIGN
			|	MOD_ASSIGN
			|	SR_ASSIGN
			|	BSR_ASSIGN
			|	SL_ASSIGN
			|	BAND_ASSIGN
			|	BXOR_ASSIGN
			|	BOR_ASSIGN
			)
			assignmentExpression
		)?
	;



conditionalExpression
	:	logicalOrExpression
		( QUESTION assignmentExpression COLON conditionalExpression )?
	;



logicalOrExpression
	:	logicalAndExpression (LOR logicalAndExpression)*
	;



logicalAndExpression
	:	inclusiveOrExpression (LAND inclusiveOrExpression)*
	;



inclusiveOrExpression
	:	exclusiveOrExpression (BOR exclusiveOrExpression)*
	;



exclusiveOrExpression
	:	andExpression (BXOR andExpression)*
	;



andExpression
	:	equalityExpression (BAND equalityExpression)*
	;



equalityExpression
	:	relationalExpression ((NOT_EQUAL | EQUAL) relationalExpression)*
	;



relationalExpression
	:	shiftExpression
		(	(	(	LT
				|	GT
				|	LE
				|	GE
				)
				shiftExpression
			)*
		|	'instanceof' typeSpec
		)
	;



shiftExpression
	:	additiveExpression ((SL | SR | BSR) additiveExpression)*
	;



additiveExpression
	:	multiplicativeExpression ((PLUS | MINUS) multiplicativeExpression)*
	;



multiplicativeExpression
	:	unaryExpression ((STAR | DIV | MOD ) unaryExpression)*
	;

unaryExpression
	:	INC unaryExpression
	|	DEC unaryExpression
	|	MINUS unaryExpression
	|	PLUS unaryExpression
	|	unaryExpressionNotPlusMinus
	;

unaryExpressionNotPlusMinus
	:	BNOT unaryExpression
	|	LNOT unaryExpression

		
	|	lpb=LPAREN builtInTypeSpec RPAREN
		unaryExpression|	lp=LPAREN classTypeSpec RPAREN
		unaryExpressionNotPlusMinus|	postfixExpression
	;


postfixExpression
	:
		primaryExpression

		(
			DOT 'this'

		|	DOT ta1=typeArguments
			(	IDENT
				(	lp=LPAREN
					argList
					RPAREN
				)?
			|	'super'
				(	
					lp3=LPAREN
					argList
					RPAREN
				|	DOT ta2=typeArguments IDENT
					(	lps=LPAREN
						argList
						RPAREN
					)?
				)
			)
		|	DOT newExpression
		|	lb=LBRACK expression RBRACK
		)*

		(	
			
			in=INC
	 	|	de=DEC
		)?
 	;


primaryExpression
	:	identPrimary ( DOT 'class' )?
	|	constant
	|	'true'
	|	'false'
	|	'null'
	|	newExpression
	|	'this'
	|	'super'
	|	LPAREN assignmentExpression RPAREN
		
	|	builtInType
		( lbt=LBRACK RBRACK )*
		DOT 'class'
	;


identPrimary
	:	ta1=typeArguments
		IDENT
		
		
		
		(
			DOT ta2=typeArguments IDENT
		|	EPSILON)*
		(
			(	lp=LPAREN
				argList RPAREN
			)
		|	( lbc=LBRACK RBRACK
			)+
		)?
	;


newExpression
	:	'new' typeArguments type
		(	LPAREN argList RPAREN (classBlock)?

			
			
			
			
			
			
			

		|	newArrayDeclarator (arrayInitializer)?
		)
	;

argList
	:	(	expressionList
		|	EPSILON
			)
	;

newArrayDeclarator
	:	(
			
			
			
			
			
			lb=LBRACK
				(expression)?
			RBRACK
		)+
	;

constant
	:	NUM_INT
	|	CHAR_LITERAL
	|	STRING_LITERAL
	|	NUM_FLOAT
	|	NUM_LONG
	|	NUM_DOUBLE
	;
	

	QUESTION		:	'?'		;
	LPAREN			:	'('		;
	RPAREN			:	')'		;
	LBRACK			:	'['		;
	RBRACK			:	']'		;
	LCURLY			:	'{'		;
	RCURLY			:	'}'		;
	COLON			:	':'		;
	COMMA			:	','		;
	DOT				:	'.'		;
	ELLIPSIS		:	'...'	;
	ASSIGN			:	'='		;
	EQUAL			:	'=='	;
	LNOT			:	'!'		;
	BNOT			:	'~'		;
	NOT_EQUAL		:	'!='	;
	DIV				:	'/'		;
	DIV_ASSIGN		:	'/='	;
	PLUS			:	'+'		;
	PLUS_ASSIGN		:	'+='	;
	INC				:	'++'	;
	MINUS			:	'-'		;
	MINUS_ASSIGN	:	'-='	;
	DEC				:	'--'	;
	STAR			:	'*'		;
	STAR_ASSIGN		:	'*='	;
	MOD				:	'%'		;
	MOD_ASSIGN		:	'%='	;
	SR				:	'>>'	;
	SR_ASSIGN		:	'>>='	;
	BSR				:	'>>>'	;
	BSR_ASSIGN		:	'>>>='	;
	GE				:	'>='	;
	GT				:	'>'		;
	SL				:	'<<'	;
	SL_ASSIGN		:	'<<='	;
	LE				:	'<='	;
	LT				:	'<'		;
	BXOR			:	'^'		;
	BXOR_ASSIGN		:	'^='	;
	BOR				:	'|'		;
	BOR_ASSIGN		:	'|='	;
	LOR				:	'||'	;
	BAND			:	'&'		;
	BAND_ASSIGN		:	'&='	;
	LAND			:	'&&'	;
	SEMI			:	';'		;
	AT				:	'@'		;



	WS	:	(	' '
			|	'\t'
			|	'\f'
				
			|	(	'\r\n'  
				|	'\r'    
				|	'\n'    
				)
			)+;



	
	CHAR_LITERAL
		:	'\'' ( ESC | BGF_STRING ) '\''
		;

	
	STRING_LITERAL
		:	'"' (ESC|BGF_STRING)* '"'
		;


	
	
	
	
	
	
	
	
	ESC
		:	'\\'
			(	'n'
			|	'r'
			|	't'
			|	'b'
			|	'f'
			|	'"'
			|	'\''
			|	'\\'
			|	('u')+ HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
			|	('0'|'1'|'2'|'3')
				(
					('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7')
					(
						('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7')
					)?
				)?
			|	('4'|'5'|'6'|'7')
				(
					('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7')
				)?
			)
		;


	
	HEX_DIGIT
		:	(('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9')|('A'|'B'|'C'|'D'|'E'|'F')|('a'|'b'|'c'|'d'|'e'|'f'))
		;


	
	
	
	IDENT
		:	(('a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'|'k'|'l'|'m'|'n'|'o'|'p'|'q'|'r'|'s'|'t'|'u'|'v'|'w'|'x'|'y'|'z')|('A'|'B'|'C'|'D'|'E'|'F'|'G'|'H'|'I'|'J'|'K'|'L'|'M'|'N'|'O'|'P'|'Q'|'R'|'S'|'T'|'U'|'V'|'W'|'X'|'Y'|'Z')|'_'|'$')
		(('a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'|'k'|'l'|'m'|'n'|'o'|'p'|'q'|'r'|'s'|'t'|'u'|'v'|'w'|'x'|'y'|'z')|('A'|'B'|'C'|'D'|'E'|'F'|'G'|'H'|'I'|'J'|'K'|'L'|'M'|'N'|'O'|'P'|'Q'|'R'|'S'|'T'|'U'|'V'|'W'|'X'|'Y'|'Z')|'_'|('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9')|'$')*;



	NUM_INT

		:	'.'
			(	'.' '.'
			|	(	(('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'))+ (EXPONENT)? (f1=FLOAT_SUFFIX)?)?
			)

		|	(	'0' 
				(	('x'|'X')
					(	
						
						
						
						
						
						HEX_DIGIT
					)+

				|	
					(('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'))+|	(('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'))+									
				)?
			|	(('1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9')) (('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'))*)
			(	('l'|'L')

			
			|
				(	'.' (('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'))* (EXPONENT)? (f2=FLOAT_SUFFIX)?
				|	EXPONENT (f3=FLOAT_SUFFIX)?
				|	f4=FLOAT_SUFFIX
				)
			)?
		;


	
	EXPONENT
		:	('e'|'E') ('+'|'-')? (('0'|'1'|'2'|'3'|'4'|'5'|'6'|'7'|'8'|'9'))+
		;


	FLOAT_SUFFIX
		:	'f'|'F'|'d'|'D'
		;