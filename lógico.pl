% "Este símbolo (*) representa la prescencia de un factor de desconocemos y/ó no importa por el principio de universo cerrado, seguido de una justificación de su uso."

%mira(Serie, Persona).
mira(himym, juan).
mira(futurama, juan).
mira(got, juan).
mira(starWars, nico).
mira(starWars, maiu).
mira(onePiece, maiu).
mira(got, maiu).
mira(got, nico).
mira(hoc, gaston).
mira(got, pedro).
% (*) "Alf no tiene tiempo de ver ninguna."

%esPopular(Serie).
esPopular(got).
esPopular(hoc).
esPopular(starWars).

%quiereVer(Persona, Serie).
quiereVer(juan, hoc).
quiereVer(aye, got).
quiereVer(gaston, himym).

%episodioTemporada(Serie, Temporada, Episodios).
episodiosTemporada(got, 3, 12).
episodiosTemporada(got, 2, 10).
episodiosTemporada(himym, 1, 23).
episodiosTemporada(drHouse, 8, 16).
% (*) "Se desconocen los episodios de Mad Men."

%paso(Serie, Temporada, Episodio, Lo que paso).
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).
paso(got, 3, 2, plotTwist(suenio)).
paso(got, 3, 2, plotTwist(sinPiernas)).
paso(got, 3, 12, plotTwist(fuego)).
paso(got, 3, 12, plotTwist(boda)).
paso(superCampeones, 9, 9, plotTwist(suenio)).
paso(superCampeones, 9, 9, plotTwist(coma)).
paso(superCampeones, 9, 9, plotTwist(sinPiernas)).
paso(drHouse, 8, 7, plotTwist(coma)).
paso(drHouse, 8, 7, plotTwist(pastillas)).

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(nico, juan, futurama, muerte(seymourDiera)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).
leDijo(pedro, aye, got, relacion(amistad, tyrion, dragon)).
leDijo(pedro, nico, got, relacion(parentesco, tyrion, dragon)).

%esSpoiler/2
esSpoiler(Serie, Spoiler):-
	paso(Serie, _, _, Spoiler).
% "En este enunciado se pueden hacer tanto consultas específicas como existenciales gracias a la inversibilidad y el polimorfismo de la variable Spoiler que sirve tanto para functores de anidación 1 (muerte) y anidación 3 (relacion)."

%leSpoileo/3
leSpoileo(Spoilero, Spoileado, SerieSpoileada) :-
	esSpoiler(SerieSpoileada, Spoiler),
	leDijo(Spoilero, Spoileado, SerieSpoileada, Spoiler),
	miraOQuiereVer(Spoileado, SerieSpoileada).
% "Este enunciado también puede hacer tanto consultas existenciales como específicas ya que también es inversible y la variable Spoiler es polimórfica."

miraOQuiereVer(Persona, Serie) :-
	mira(Serie, Persona).

miraOQuiereVer(Persona, Serie) :-
	quiereVer(Persona, Serie).

%televidenteResponsable/1
televidenteResponsable(Televidente) :-
	miraOQuiereVer(Televidente, _),
	not(leSpoileo(Televidente, _, _)).

%vieneZafando/2
vieneZafando(Persona, Serie) :-
	miraOQuiereVer(Persona, Serie),
	esPopularOFuerte(Serie),
	not(leSpoileo(_, Persona, Serie)).

esPopularOFuerte(Serie) :-
	esPopular(Serie).

esPopularOFuerte(Serie) :-
	episodiosTemporada(Serie, _, _),
	paso(Serie, Temporada, _, _),
	forall(paso(Serie, Temporada, _, Algo), esFuerte(Algo)).

esFuerte(muerte(_)).

esFuerte(relacion(parentesco, _, _)).

esFuerte(relacion(amorosa, _, _)).

esFuerte(plotTwist(Clave)) :-
	paso(Serie, Temporada, Episodio, plotTwist(Clave)),
	episodiosTemporada(Serie, Temporada, Episodio),
	not(esCliche(Clave)).

% "Testing primera entrega."

	:- begin_tests(sonSpoiler).
		test(esSpoilerLaMuerteDeEmperorParaStarWars, nondet) :-
			esSpoiler(starWars, muerte(emperor)).
		test(noEsSpoilerLaMuerteDePedroParaStarWars, fail) :-
			esSpoiler(starWars, muerte(pedro)).
		test(esSpoilerElPerentescoEntreAnakinYElReyDeStarWars, nondet) :-
			esSpoiler(starWars, relacion(parentesco, anakin, rey)).
		test(noEsSpoilerElParentescoEntreAnakinYLavessiDeStarWars, fail) :-
			esSpoiler(starWars, relacion(parentesco, anakin, lavessi)).
	:- end_tests(sonSpoiler).

	:- begin_tests(lesSpoilearon).
		test(quienesSpoilearon, set(Spoileros == [nico, gaston, pedro])) :-
			leSpoileo(Spoileros, _, _).
	:- end_tests(lesSpoilearon).

	:- begin_tests(sonTelevidentesResponsables).
		test(televidentesResponsables, set(Televidentes == [juan, aye, maiu])) :-
			televidenteResponsable(Televidentes).
		test(gastonNoEsTelevidenteResponsable, fail) :-
			televidenteResponsable(gaston).
		test(nicoNoEsTelevidenteResponsable, fail) :-
			televidenteResponsable(nico).
	:- end_tests(sonTelevidentesResponsables).

	:- begin_tests(vienenZafando).
		test(maiuNoVieneZafandoConNingunaSerie, fail) :-
			vieneZafando(maiu, _).
		test(seriesConLasQueVieneZafandoJuan, set(Series == [himym, got, hoc])) :-
			vieneZafando(juan, Series).
		test(nicoVieneZafandoConStarWars, nondet) :-
			vieneZafando(nico, starWars).
	:- end_tests(vienenZafando).

%malaGente/1
malaGente(Spoilero) :-
	leDijo(Spoilero, _, _, _),
	forall(habloCon(Spoilero, Spoileado), leSpoileo(Spoilero, Spoileado, _)).

malaGente(Spoilero):-
	leDijo(Spoilero,_,Serie,_),
	not(mira(Serie,Spoilero)).


habloCon(Spoilero, Spoileado) :-
	leDijo(Spoilero, Spoileado, _, _).

esCliche(Clave) :-
	paso(Serie, _, _, plotTwist(Clave)),
	forall(paso(Serie, _, _, plotTwist(Claves)), pasoEnOtrasSeries(Serie, Claves)).

pasoEnOtrasSeries(Serie, Claves) :-
	paso(OtraSerie, _, _, plotTwist(Claves)),
	OtraSerie \= Serie.

%sucesoFuerte/2
sucesoFuerte(Serie, AlgoFuerte) :-
	paso(Serie, _, _, AlgoFuerte),
	esFuerte(AlgoFuerte).


%3 Punto C: Popularidad

popular(Serie):-
	popularidad(Serie, PopuDeSerie),
	popularidad(starWars, PopuDeStarWars),
	PopuDeSerie >= PopuDeStarWars.

popular(houseOfCards).

popularidad(Serie, Popu):-
	cuantosMiran(Serie, MiranSerie),
	cuantasConversaciones(Serie, Conversaciones),
	Popu is MiranSerie * Conversaciones.

cuantosMiran(Serie, Cantidad):-
	miran(Serie, Espectadores),
	length(Espectadores, Cantidad).

miran(Serie, Espectadores):-
	mira(Serie,_),
	findall(Espectador, mira(Serie, Espectador), Espectadores).

cuantasConversaciones(Serie, Cantidad):-
	hablan(Serie, Conversaciones),
	length(Conversaciones, Cantidad).

hablan(Serie, Conversaciones):-
	mira(Serie,_),
	findall(Hablador, leDijo(Hablador, _ , Serie, _), Conversaciones).
















%fin
