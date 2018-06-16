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
episodiosTemporada(got, tercera, 12).
episodiosTemporada(got, segunda, 10).
episodiosTemporada(himym, primera, 23).
episodiosTemporada(drHouse, octava, 16).
% (*) "Se desconocen los episodios de Mad Men."

%paso(Serie, Temporada, Episodio, Lo que paso).
paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

%leDijo/4
leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)).
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).

%esSpoiler/2
esSpoiler(Serie, Spoiler):-
	paso(Serie, _, _, Spoiler).
% "En este enunciado se pueden hacer tanto consultas específicas como existenciales gracias a la inversibilidad y el polimorfismo de la variable Spoiler que sirve tanto para functores de anidación 1 (muerte) y anidación 3 (relacion)."

%leSpoileo/3
leSpoileo(Spoilero, Spoileado, SerieSpoileada) :-
	esSpoiler(SerieSpoileada, Spoiler),
	leDijo(Spoilero, Spoileado, SerieSpoileada, Spoiler),
	mira(SerieSpoileada, Spoileado).

leSpoileo(Spoilero, Spoileado, SerieSpoileada) :-
	esSpoiler(SerieSpoileada, Spoiler),
	leDijo(Spoilero, Spoileado, SerieSpoileada, Spoiler),
	quiereVer(Spoileado, SerieSpoileada).
% "Este enunciado también puede hacer tanto consultas existenciales como específicas ya que también es inversible y la variable Spoiler es polimórfica."

%televidenteResponsable/1
televidenteResponsable(Televidente) :-
	mira(_, Televidente),
	not(leSpoileo(Televidente, _, _)).

televidenteResponsable(Televidente) :-
	quiereVer(Televidente, _),
	not(leSpoileo(Televidente, _, _)).

%vieneZafando/2
vieneZafando(Persona, Serie) :-
	mira(Serie, Persona),
	esPopularOInteresante(Serie),
	not(leSpoileo(_, Persona, Serie)).

vieneZafando(Persona, Serie) :-
	quiereVer(Persona, Serie),
	esPopularOInteresante(Serie),
	not(leSpoileo(_, Persona, Serie)).

esPopularOInteresante(Serie) :-
	esPopular(Serie).

esPopularOInteresante(Serie) :-
	paso(Serie, _, _, muerte(_)).

esPopularOInteresante(Serie) :-
	paso(Serie, _, _, relacion(amorosa, _, _)).

esPopularOInteresante(Serie) :-
	paso(Serie, _, _, relacion(parentesco, _, _)).

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
		test(quienesLeSpoilearonAMaiu, set(Spoileros == [nico, gaston])) :-
			leSpoileo(Spoileros, maiu, _).
	:- end_tests(lesSpoilearon).

	:- begin_tests(sonTelevidentesResponsables).
		test(televidentesResponsables, set(Televidentes == [juan, aye, maiu])) :-
			televidenteResponsable(Televidentes).
		test(televidentesNoResponsables, set(Televidentes == [gaston, nico]), fail) :-
			televidenteResponsable(Televidentes).
	:- end_tests(sonTelevidentesResponsables).

	:-begin_tests(vienenZafando).
		test(maiuNoVieneZafandoConNingunaSerie, fail) :-
			vieneZafando(maiu, _).
		test(seriesConLasQueVieneZafandoJuan, set(Series == [himym, got, hoc]) :-
			vieneZafando(juan, Series).
		test(nicoVieneZafandoConStarWars, nondet) :-
			vieneZafando(nico, starWars).
	:- end_tests(vienenZafando).
