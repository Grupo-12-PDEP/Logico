% Este símbolo (*) representa la prescencia de un factor de desconocemos y/ó no importa por el principio de universo cerrado, seguido de una justificación de su uso.

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
% "En este enunciado se pueden hacer tanto consultas específicas como existenciales gracias a la inversibilidad."

%leSpoileo/3
leSpoileo(Spoilero, Spoileado, SerieSpoileada) :-
	esSpoiler(SerieSpoileada, Spoiler),
	leDijo(Spoilero, Spoileado, SerieSpoileada, Spoiler),
	mira(SerieSpoileada, Spoileado).

leSpoileo(Spoilero, Spoileado, SerieSpoileada) :-
	esSpoiler(SerieSpoileada, Spoiler),
	leDijo(Spoilero, Spoileado, SerieSpoileada, Spoiler),
	quiereVer(Spoileado, SerieSpoileada).
% "Este enunciado también puede hacer tanto consultas existenciales como específicas ya que también es inversible."

%televidenteResponsable/1
televidenteResponsable(Televidente) :-
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
	paso(Serie, _, _, Algo),
	Algo \= relacion(amistad, _, _).
