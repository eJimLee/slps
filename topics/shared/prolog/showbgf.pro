:- ensure_loaded('ll.pro').


:- 
   current_prolog_flag(argv,Argv),
   append(_,['--',LgfFile],Argv),
   loadXml(LgfFile,Xml),
   xmlToG(Xml,G),
   ppG(G),
   halt.
