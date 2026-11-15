import Foundation

enum MiniBook {
    static let categories = ["W domu", "W sklepie i supermarkecie", "W piekarni", "W restauracji", "W kawiarni", "Na ulicy", "W autobusie i pociągu", "Na dworcu", "U lekarza", "W aptece", "U dentysty", "W pracy", "Na budowie", "Rozmowy z szefem", "Rozmowy ze współpracownikami", "W urzędzie", "W banku", "Na poczcie", "Wynajem mieszkania", "Sąsiedzi", "Rodzina i znajomi", "Telefonowanie", "Umawianie spotkań", "Wolny czas", "Sport", "Pogoda", "Problemy i reklamacje", "Awaryjne sytuacje", "Podróże", "Niemieckie życie codzienne"]

    static let all: [MiniScene] = [
        MiniScene(
            id: "s001",
            title: "Zgubiony klucz",
            category: "W domu",
            level: "A1",
            situation: "Za dwadzieścia minut masz bus, a klucza nie ma w kurtce.",
            lines: [
            SayLine(id: "s001-0", who: "Ty", de: "Wo ist mein Schlüssel?", pl: "Gdzie jest mój klucz?"),
            SayLine(id: "s001-1", who: "Partner", de: "Schau mal auf dem Küchentisch.", pl: "Zobacz na stole w kuchni."),
            SayLine(id: "s001-2", who: "Ty", de: "Da liegt er, unter der Rechnung.", pl: "Leży tam, pod rachunkiem."),
            SayLine(id: "s001-3", who: "Partner", de: "Nimm ihn mit. Der Bus wartet nicht.", pl: "Weź go. Autobus nie czeka.")
            ],
            words: [
            Gloss(de: "der Schlüssel", pl: "klucz"),
            Gloss(de: "die Rechnung", pl: "rachunek")
            ],
            phrases: ["Wo ist mein Schlüssel?", "Der Bus wartet nicht."],
            note: "Pytanie o miejsce zaczyna się od wo, nie od gdzie w niemieckim szyku.",
            question: "Czego szukasz?",
            options: ["Klucza", "Portfela z kurtki", "Telefonu z kuchni"],
            answer: 0,
            replyPL: "Klucz leży na stole.",
            replyDE: "Der Schlüssel liegt auf dem Tisch."
        ),
        MiniScene(
            id: "s002",
            title: "Pralka nie kręci",
            category: "W domu",
            level: "A2",
            situation: "Pranie stoi w wodzie, a za godzinę wychodzisz na zmianę.",
            lines: [
            SayLine(id: "s002-0", who: "Ty", de: "Die Waschmaschine schleudert nicht.", pl: "Pralka nie odwirowuje."),
            SayLine(id: "s002-1", who: "Partner", de: "Hast du den Filter geprüft?", pl: "Sprawdziłeś filtr?"),
            SayLine(id: "s002-2", who: "Ty", de: "Noch nicht. Wo sitzt der?", pl: "Jeszcze nie. Gdzie on jest?"),
            SayLine(id: "s002-3", who: "Partner", de: "Unten rechts. Dreh ihn vorsichtig auf.", pl: "Na dole z prawej. Odkręć go ostrożnie.")
            ],
            words: [
            Gloss(de: "die Waschmaschine", pl: "pralka"),
            Gloss(de: "der Filter", pl: "filtr")
            ],
            phrases: ["Die Waschmaschine schleudert nicht.", "Hast du den Filter geprüft?"],
            note: "Schleudern to wirowanie. Samo waschen to tylko pranie.",
            question: "Co nie działa?",
            options: ["Wirowanie", "Piekarnik", "Ogrzewanie w pokoju"],
            answer: 0,
            replyPL: "Pralka nie odwirowuje.",
            replyDE: "Die Waschmaschine schleudert nicht."
        ),
        MiniScene(
            id: "s003",
            title: "Sąsiad i cisza",
            category: "W domu",
            level: "A2",
            situation: "Jest po dziesiątej, a u sąsiada gra muzyka.",
            lines: [
            SayLine(id: "s003-0", who: "Ty", de: "Können Sie die Musik etwas leiser machen?", pl: "Czy może pan trochę ściszyć muzykę?"),
            SayLine(id: "s003-1", who: "Sąsiad", de: "Oh, Entschuldigung. Ist es schon so spät?", pl: "Och, przepraszam. Już tak późno?"),
            SayLine(id: "s003-2", who: "Ty", de: "Ja. Ab zehn soll es ruhig sein.", pl: "Tak. Od dziesiątej ma być cicho."),
            SayLine(id: "s003-3", who: "Sąsiad", de: "Ich mache sofort leiser.", pl: "Zaraz ściszam.")
            ],
            words: [
            Gloss(de: "die Musik", pl: "muzyka"),
            Gloss(de: "die Ruhe", pl: "cisza")
            ],
            phrases: ["etwas leiser machen", "Ab zehn soll es ruhig sein."],
            note: "Prośbę do obcego zaczynasz od können Sie, nie od mach leiser.",
            question: "O co prosisz?",
            options: ["Żeby ściszył muzykę", "Żeby wyłączył ją całkiem", "Żeby przełożył na jutro"],
            answer: 0,
            replyPL: "Proszę ściszyć muzykę.",
            replyDE: "Können Sie die Musik leiser machen?"
        ),
        MiniScene(
            id: "s004",
            title: "Pleśń przy oknie",
            category: "W domu",
            level: "B1",
            situation: "W rogu okna jest czarna plama i pachnie wilgocią.",
            lines: [
            SayLine(id: "s004-0", who: "Ty", de: "An dem Fenster ist Schimmel.", pl: "Przy oknie jest pleśń."),
            SayLine(id: "s004-1", who: "Wynajmujący", de: "Lüften Sie morgens und abends.", pl: "Wietrz pan rano i wieczorem."),
            SayLine(id: "s004-2", who: "Ty", de: "Das mache ich schon. Die Wand bleibt nass.", pl: "Już tak robię. Ściana i tak jest mokra."),
            SayLine(id: "s004-3", who: "Wynajmujący", de: "Dann schicke ich am Donnerstag jemanden.", pl: "W takim razie w czwartek kogoś przyślę.")
            ],
            words: [
            Gloss(de: "der Schimmel", pl: "pleśń"),
            Gloss(de: "das Fenster", pl: "okno")
            ],
            phrases: ["An dem Fenster ist Schimmel.", "Die Wand bleibt nass."],
            note: "Schimmel mówisz wynajmującemu wprost. To nie jest zwykły brud.",
            question: "Co jest przy oknie?",
            options: ["Pleśń", "Nowa firanka", "Zepsuty zamek"],
            answer: 0,
            replyPL: "Przy oknie jest pleśń.",
            replyDE: "An dem Fenster ist Schimmel."
        ),
        MiniScene(
            id: "s005",
            title: "Zły jogurt",
            category: "W sklepie i supermarkecie",
            level: "A1",
            situation: "Przy kasie widzisz, że jogurt jest przeterminowany.",
            lines: [
            SayLine(id: "s005-0", who: "Ty", de: "Der Joghurt ist abgelaufen.", pl: "Jogurt jest przeterminowany."),
            SayLine(id: "s005-1", who: "Kasjer", de: "Nehmen Sie einen anderen aus dem Regal.", pl: "Weź pan inny z półki."),
            SayLine(id: "s005-2", who: "Ty", de: "Der ganz hinten ist auch abgelaufen.", pl: "Ten z tyłu też jest po dacie."),
            SayLine(id: "s005-3", who: "Kasjer", de: "Dann streiche ich ihn. Sie zahlen ihn nicht.", pl: "To go skreślam. Nie płaci pan za niego.")
            ],
            words: [
            Gloss(de: "der Joghurt", pl: "jogurt"),
            Gloss(de: "das Regal", pl: "półka")
            ],
            phrases: ["Der Joghurt ist abgelaufen.", "Sie zahlen ihn nicht."],
            note: "Abgelaufen to po dacie. Nie myl z geschlossen, czyli zamknięte.",
            question: "Co jest nie tak z jogurtem?",
            options: ["Jest po dacie", "Jest za drogi", "Nie ma paragonu"],
            answer: 0,
            replyPL: "Jogurt jest przeterminowany.",
            replyDE: "Der Joghurt ist abgelaufen."
        ),
        MiniScene(
            id: "s006",
            title: "Kaucja za butelkę",
            category: "W sklepie i supermarkecie",
            level: "A2",
            situation: "Chcesz oddać puste butelki przy automacie.",
            lines: [
            SayLine(id: "s006-0", who: "Ty", de: "Wo kann ich die Flaschen abgeben?", pl: "Gdzie mogę oddać butelki?"),
            SayLine(id: "s006-1", who: "Pracownik", de: "Der Automat ist neben dem Obst.", pl: "Automat jest obok owoców."),
            SayLine(id: "s006-2", who: "Ty", de: "Er nimmt den Bon nicht richtig.", pl: "Źle wciąga paragon... automat nie bierze butelki."),
            SayLine(id: "s006-3", who: "Pracownik", de: "Drehen Sie die Flasche. Der Code muss nach oben.", pl: "Obróć pan butelkę. Kod ma być u góry.")
            ],
            words: [
            Gloss(de: "die Flasche", pl: "butelka"),
            Gloss(de: "der Automat", pl: "automat"),
            Gloss(de: "der Bon", pl: "paragon")
            ],
            phrases: ["Wo kann ich die Flaschen abgeben?", "Der Code muss nach oben."],
            note: "Pfand oddajesz w automacie. Bon z automatu dajesz potem przy kasie.",
            question: "Gdzie oddajesz butelki?",
            options: ["Przy automacie obok owoców", "Przy kasach z tyłu", "Przy wejściu od parkingu"],
            answer: 0,
            replyPL: "Gdzie mogę oddać butelki?",
            replyDE: "Wo kann ich die Flaschen abgeben?"
        ),
        MiniScene(
            id: "s007",
            title: "Samoobsługowa kasa",
            category: "W sklepie i supermarkecie",
            level: "A2",
            situation: "Kasa pisze, że w torbie jest coś jeszcze.",
            lines: [
            SayLine(id: "s007-0", who: "Kasa", de: "Bitte den Artikel auf das Band legen.", pl: "Proszę położyć towar na taśmę."),
            SayLine(id: "s007-1", who: "Ty", de: "Das ist meine eigene Tasche.", pl: "To moja własna torba."),
            SayLine(id: "s007-2", who: "Obsługa", de: "Öffnen Sie sie bitte kurz.", pl: "Proszę ją na chwilę otworzyć."),
            SayLine(id: "s007-3", who: "Ty", de: "Hier, nur der Bon und der Schlüssel.", pl: "Proszę, tylko paragon i klucz."),
            SayLine(id: "s007-4", who: "Obsługa", de: "Alles klar. Sie können gehen.", pl: "W porządku. Może pan iść.")
            ],
            words: [
            Gloss(de: "die Tasche", pl: "torba"),
            Gloss(de: "der Artikel", pl: "towar")
            ],
            phrases: ["Das ist meine eigene Tasche.", "Sie können gehen."],
            note: "Eigene Tasche mówisz, gdy kasa bierze twoją siatkę za towar.",
            question: "Czego chce obsługa?",
            options: ["Żebyś otworzył torbę", "Żebyś zważył warzywa jeszcze raz", "Żebyś przyłożył kartę ponownie"],
            answer: 0,
            replyPL: "To moja własna torba.",
            replyDE: "Das ist meine eigene Tasche."
        ),
        MiniScene(
            id: "s008",
            title: "Bułki na rano",
            category: "W piekarni",
            level: "A1",
            situation: "Stoisz w kolejce i chcesz sześć bułek oraz chleb.",
            lines: [
            SayLine(id: "s008-0", who: "Ekspedientka", de: "Was darf es sein?", pl: "Czego sobie pan życzy?"),
            SayLine(id: "s008-1", who: "Ty", de: "Sechs Brötchen und ein Brot, bitte.", pl: "Sześć bułek i chleb, poproszę."),
            SayLine(id: "s008-2", who: "Ekspedientka", de: "Das normale Brot oder das dunkle?", pl: "Zwykły chleb czy ciemny?"),
            SayLine(id: "s008-3", who: "Ty", de: "Das dunkle. Zum Mitnehmen.", pl: "Ciemny. Na wynos.")
            ],
            words: [
            Gloss(de: "das Brötchen", pl: "bułka"),
            Gloss(de: "das Brot", pl: "chleb")
            ],
            phrases: ["Was darf es sein?", "Zum Mitnehmen."],
            note: "W piekarni słyszysz was darf es sein, nie was willst du haben.",
            question: "Co kupujesz?",
            options: ["Sześć bułek i ciemny chleb", "Cztery bułki i precle", "Tylko jeden mały chleb"],
            answer: 0,
            replyPL: "Sześć bułek, poproszę.",
            replyDE: "Sechs Brötchen, bitte."
        ),
        MiniScene(
            id: "s009",
            title: "Zamówienie na niedzielę",
            category: "W piekarni",
            level: "A2",
            situation: "Chcesz odebrać ciasto w niedzielę rano, a w niedzielę piekarnia krótko jest otwarta.",
            lines: [
            SayLine(id: "s009-0", who: "Ty", de: "Kann ich eine Torte für Sonntag bestellen?", pl: "Czy mogę zamówić tort na niedzielę?"),
            SayLine(id: "s009-1", who: "Ekspedientka", de: "Ja. Abholung ab acht. Um zwölf ist zu.", pl: "Tak. Odbiór od ósmej. O dwunastej zamykamy."),
            SayLine(id: "s009-2", who: "Ty", de: "Ich komme um neun. Für zehn Personen.", pl: "Przyjdę o dziewiątej. Dla dziesięciu osób."),
            SayLine(id: "s009-3", who: "Ekspedientka", de: "Name und Nummer, bitte.", pl: "Nazwisko i numer, poproszę.")
            ],
            words: [
            Gloss(de: "die Torte", pl: "tort"),
            Gloss(de: "die Abholung", pl: "odbiór")
            ],
            phrases: ["Kann ich eine Torte bestellen?", "Um zwölf ist zu."],
            note: "W niedzielę wiele piekarni zamyka się w południe. Um zwölf ist zu.",
            question: "Kiedy odbierasz tort?",
            options: ["W niedzielę o dziewiątej", "W poniedziałek wieczorem", "Od razu"],
            answer: 0,
            replyPL: "Czy mogę zamówić tort na niedzielę?",
            replyDE: "Kann ich eine Torte für Sonntag bestellen?"
        ),
        MiniScene(
            id: "s010",
            title: "Ostatni chleb",
            category: "W piekarni",
            level: "A1",
            situation: "Chcesz zwykły chleb, ale został tylko jeden mały.",
            lines: [
            SayLine(id: "s010-0", who: "Ty", de: "Haben Sie noch das normale Brot?", pl: "Ma pani jeszcze zwykły chleb?"),
            SayLine(id: "s010-1", who: "Ekspedientka", de: "Nur noch ein kleines. Das große ist aus.", pl: "Został tylko mały. Dużego już nie ma."),
            SayLine(id: "s010-2", who: "Ty", de: "Dann nehme ich das kleine.", pl: "To biorę ten mały."),
            SayLine(id: "s010-3", who: "Ekspedientka", de: "Möchten Sie es geschnitten?", pl: "Pokroić?")
            ],
            words: [
            Gloss(de: "das Brot", pl: "chleb"),
            Gloss(de: "geschnitten", pl: "pokrojony")
            ],
            phrases: ["Das große ist aus.", "Möchten Sie es geschnitten?"],
            note: "Aus przy towarze znaczy, że się skończył. Nie że sklep jest zamknięty.",
            question: "Jakiego chleba już nie ma?",
            options: ["Dużego", "Małego", "Słonego"],
            answer: 0,
            replyPL: "Biorę ten mały.",
            replyDE: "Dann nehme ich das kleine."
        ),
        MiniScene(
            id: "s011",
            title: "Stolik dla dwóch",
            category: "W restauracji",
            level: "A1",
            situation: "Wchodzisz bez rezerwacji i chcesz stolik przy oknie.",
            lines: [
            SayLine(id: "s011-0", who: "Kelner", de: "Haben Sie reserviert?", pl: "Ma pan rezerwację?"),
            SayLine(id: "s011-1", who: "Ty", de: "Nein. Haben Sie einen Tisch am Fenster?", pl: "Nie. Jest stolik przy oknie?"),
            SayLine(id: "s011-2", who: "Kelner", de: "Für zwei, ja. Folgen Sie mir.", pl: "Dla dwóch, tak. Proszę za mną."),
            SayLine(id: "s011-3", who: "Ty", de: "Danke. Die Karte, bitte.", pl: "Dziękuję. Kartę, poproszę.")
            ],
            words: [
            Gloss(de: "der Tisch", pl: "stolik"),
            Gloss(de: "die Karte", pl: "karta dań"),
            Gloss(de: "das Fenster", pl: "okno")
            ],
            phrases: ["Haben Sie reserviert?", "Die Karte, bitte."],
            note: "Karte w restauracji to menu, nie karta do płacenia. Karta płatnicza to die Karte zum Zahlen albo EC-Karte.",
            question: "Czy miałeś rezerwację?",
            options: ["Nie", "Tak, na ósmą", "Tak, na nazwisko Kacper"],
            answer: 0,
            replyPL: "Kartę, poproszę.",
            replyDE: "Die Karte, bitte."
        ),
        MiniScene(
            id: "s012",
            title: "Alergia na orzechy",
            category: "W restauracji",
            level: "A2",
            situation: "W daniu mogą być orzechy, a nie możesz ich jeść.",
            lines: [
            SayLine(id: "s012-0", who: "Ty", de: "Ist da Nuss drin? Ich vertrage keine Nüsse.", pl: "Są tam orzechy? Nie mogę jeść orzechów."),
            SayLine(id: "s012-1", who: "Kelner", de: "Im Salat ja. Ich frage in der Küche.", pl: "W sałatce tak. Zapytam w kuchni."),
            SayLine(id: "s012-2", who: "Ty", de: "Dann nehme ich lieber die Suppe.", pl: "To wolę zupę."),
            SayLine(id: "s012-3", who: "Kelner", de: "Die Suppe ist ohne Nüsse. Ich sage Bescheid.", pl: "Zupa jest bez orzechów. Powiem im.")
            ],
            words: [
            Gloss(de: "die Nuss", pl: "orzech"),
            Gloss(de: "die Suppe", pl: "zupa"),
            Gloss(de: "die Küche", pl: "kuchnia")
            ],
            phrases: ["Ich vertrage keine Nüsse.", "Die Suppe ist ohne Nüsse."],
            note: "Vertragen to znosić jedzenie. Nie myl z verstehen, czyli rozumieć.",
            question: "Czego nie możesz jeść?",
            options: ["Orzechów", "Zupy", "Chleba"],
            answer: 0,
            replyPL: "Nie mogę jeść orzechów.",
            replyDE: "Ich vertrage keine Nüsse."
        ),
        MiniScene(
            id: "s013",
            title: "Rachunek osobno",
            category: "W restauracji",
            level: "A2",
            situation: "Jecie w trzech i każdy płaci swoje.",
            lines: [
            SayLine(id: "s013-0", who: "Kelner", de: "Zusammen oder getrennt?", pl: "Razem czy osobno?"),
            SayLine(id: "s013-1", who: "Ty", de: "Getrennt, bitte. Ich zahle nur die Suppe.", pl: "Osobno, poproszę. Ja płacę tylko zupę."),
            SayLine(id: "s013-2", who: "Kelner", de: "Mit Karte oder bar?", pl: "Kartą czy gotówką?"),
            SayLine(id: "s013-3", who: "Ty", de: "Mit Karte. Eine Quittung, bitte.", pl: "Kartą. Pokwitowanie, poproszę.")
            ],
            words: [
            Gloss(de: "die Quittung", pl: "pokwitowanie"),
            Gloss(de: "die Karte", pl: "karta")
            ],
            phrases: ["Zusammen oder getrennt?", "Eine Quittung, bitte."],
            note: "Getrennt znaczy każdy swój rachunek. Quittung przyda się, gdy płaci firma.",
            question: "Jak płacisz?",
            options: ["Kartą, tylko za zupę", "Gotówką za wszystkich", "Bonem za obiad"],
            answer: 0,
            replyPL: "Osobno, poproszę.",
            replyDE: "Getrennt, bitte."
        ),
        MiniScene(
            id: "s014",
            title: "Kawa na mleku owsianym",
            category: "W kawiarni",
            level: "A1",
            situation: "Chcesz kawę, ale zwykle mleko źle ci służy.",
            lines: [
            SayLine(id: "s014-0", who: "Barista", de: "Was darf ich Ihnen bringen?", pl: "Co panu podać?"),
            SayLine(id: "s014-1", who: "Ty", de: "Einen Kaffee mit Hafermilch, bitte.", pl: "Kawę na mleku owsianym, poproszę."),
            SayLine(id: "s014-2", who: "Barista", de: "Zum Hiertrinken oder zum Mitnehmen?", pl: "Na miejscu czy na wynos?"),
            SayLine(id: "s014-3", who: "Ty", de: "Zum Mitnehmen. Nicht zu heiß.", pl: "Na wynos. Nie za gorącą.")
            ],
            words: [
            Gloss(de: "der Kaffee", pl: "kawa"),
            Gloss(de: "die Hafermilch", pl: "mleko owsiane")
            ],
            phrases: ["mit Hafermilch", "zum Mitnehmen"],
            note: "Zum Mitnehmen to na wynos. Zum Hiertrinken to na miejscu.",
            question: "Jaką kawę zamawiasz?",
            options: ["Na mleku owsianym, na wynos", "Czarną, na miejscu", "Herbatę"],
            answer: 0,
            replyPL: "Kawę na mleku owsianym, poproszę.",
            replyDE: "Einen Kaffee mit Hafermilch, bitte."
        ),
        MiniScene(
            id: "s015",
            title: "Hasło do wifi",
            category: "W kawiarni",
            level: "A2",
            situation: "Chcesz wysłać zdjęcie z budowy, a nie masz zasięgu.",
            lines: [
            SayLine(id: "s015-0", who: "Ty", de: "Wie ist das WLAN-Passwort?", pl: "Jakie jest hasło do wifi?"),
            SayLine(id: "s015-1", who: "Barista", de: "Es steht auf dem Bon.", pl: "Jest na paragonie."),
            SayLine(id: "s015-2", who: "Ty", de: "Bei mir verbindet es nicht.", pl: "U mnie się nie łączy."),
            SayLine(id: "s015-3", who: "Barista", de: "Nehmen Sie Gast, nicht Mitarbeiter.", pl: "Weź pan sieć Gast, nie Mitarbeiter.")
            ],
            words: [
            Gloss(de: "das Passwort", pl: "hasło"),
            Gloss(de: "das WLAN", pl: "wifi")
            ],
            phrases: ["Wie ist das WLAN-Passwort?", "Es steht auf dem Bon."],
            note: "Gast to sieć dla klientów. Mitarbeiter jest dla pracowników.",
            question: "Gdzie jest hasło?",
            options: ["Na paragonie", "Na drzwiach toalety", "W mailu od szefa"],
            answer: 0,
            replyPL: "Jakie jest hasło do wifi?",
            replyDE: "Wie ist das WLAN-Passwort?"
        ),
        MiniScene(
            id: "s016",
            title: "Droga na dworzec",
            category: "Na ulicy",
            level: "A1",
            situation: "Wysiadłeś o jeden przystanek za daleko.",
            lines: [
            SayLine(id: "s016-0", who: "Ty", de: "Entschuldigung, wo ist der Bahnhof?", pl: "Przepraszam, gdzie jest dworzec?"),
            SayLine(id: "s016-1", who: "Przechodzień", de: "Die nächste Straße links, dann geradeaus.", pl: "Następna ulica w lewo, potem prosto."),
            SayLine(id: "s016-2", who: "Ty", de: "Ist das weit zu Fuß?", pl: "Czy to daleko pieszo?"),
            SayLine(id: "s016-3", who: "Przechodzień", de: "Zehn Minuten. Die Ampel ist da vorne.", pl: "Dziesięć minut. Światła są tam z przodu.")
            ],
            words: [
            Gloss(de: "der Bahnhof", pl: "dworzec"),
            Gloss(de: "die Ampel", pl: "sygnalizacja")
            ],
            phrases: ["Wo ist der Bahnhof?", "Die nächste Straße links."],
            note: "Geradeaus to prosto. Links i rechts mówisz od razu, zanim ktoś zdąży odejść.",
            question: "Jak dojdziesz na dworzec?",
            options: ["W lewo, potem prosto", "Autobusem numer 9", "Z powrotem na budowę"],
            answer: 0,
            replyPL: "Gdzie jest dworzec?",
            replyDE: "Wo ist der Bahnhof?"
        ),
        MiniScene(
            id: "s017",
            title: "Zgubiony telefon",
            category: "Na ulicy",
            level: "A2",
            situation: "Telefon wypadł ci przy przystanku.",
            lines: [
            SayLine(id: "s017-0", who: "Ty", de: "Ich habe mein Handy verloren. Haben Sie es gesehen?", pl: "Zgubiłem telefon. Widział go pan?"),
            SayLine(id: "s017-1", who: "Przechodzień", de: "Am Wartehäuschen lag ein schwarzes.", pl: "Przy wiacie leżał czarny."),
            SayLine(id: "s017-2", who: "Ty", de: "Das ist meiner. Vielen Dank.", pl: "To mój. Dziękuję."),
            SayLine(id: "s017-3", who: "Przechodzień", de: "Prüfen Sie, ob er noch angeht.", pl: "Sprawdź, czy jeszcze się włącza.")
            ],
            words: [
            Gloss(de: "das Handy", pl: "telefon"),
            Gloss(de: "das Wartehäuschen", pl: "wiata")
            ],
            phrases: ["Ich habe mein Handy verloren.", "Ob er noch angeht."],
            note: "Handy to telefon komórkowy. Telefon w niemieckim często znaczy telefon stacjonarny.",
            question: "Co zgubiłeś?",
            options: ["Telefon", "Klucze od mieszkania", "Portfel"],
            answer: 0,
            replyPL: "Zgubiłem telefon.",
            replyDE: "Ich habe mein Handy verloren."
        ),
        MiniScene(
            id: "s018",
            title: "Objazd przy budowie",
            category: "Na ulicy",
            level: "B1",
            situation: "Chodnik jest zamknięty i nie wiesz, którędy obejść.",
            lines: [
            SayLine(id: "s018-0", who: "Ty", de: "Warum ist der Gehweg gesperrt?", pl: "Czemu chodnik jest zamknięty?"),
            SayLine(id: "s018-1", who: "Robotnik", de: "Wir heben ein Kabel aus. Gehen Sie auf der anderen Seite.", pl: "Wyciągamy kabel. Idź pan drugą stroną."),
            SayLine(id: "s018-2", who: "Ty", de: "Bis wann bleibt das so?", pl: "Do kiedy tak będzie?"),
            SayLine(id: "s018-3", who: "Robotnik", de: "Bis Freitag. Die Umleitung ist ausgeschildert.", pl: "Do piątku. Objazd jest oznaczony.")
            ],
            words: [
            Gloss(de: "der Gehweg", pl: "chodnik"),
            Gloss(de: "die Umleitung", pl: "objazd"),
            Gloss(de: "das Kabel", pl: "kabel")
            ],
            phrases: ["Der Gehweg ist gesperrt.", "Die Umleitung ist ausgeschildert."],
            note: "Gesperrt to zamknięte dla przejścia. Ausgeschildert znaczy, że są tabliczki.",
            question: "Dokąd masz iść?",
            options: ["Drugą stroną ulicy", "Przez wykop", "Z powrotem do domu na cały dzień"],
            answer: 0,
            replyPL: "Chodnik jest zamknięty.",
            replyDE: "Der Gehweg ist gesperrt."
        ),
        MiniScene(
            id: "s019",
            title: "Autobus ma opóźnienie",
            category: "W autobusie i pociągu",
            level: "A1",
            situation: "Szef pyta, czy jesteś już w drodze.",
            lines: [
            SayLine(id: "s019-0", who: "Szef", de: "Kommst du noch zur Frühschicht?", pl: "Dochodzisz jeszcze na poranną?"),
            SayLine(id: "s019-1", who: "Ty", de: "Der Bus hat Verspätung. Ich bin in zwanzig Minuten da.", pl: "Autobus ma opóźnienie. Będę za dwadzieścia minut."),
            SayLine(id: "s019-2", who: "Szef", de: "Gut. Fang an der Rampe an.", pl: "Dobrze. Zacznij przy rampie."),
            SayLine(id: "s019-3", who: "Ty", de: "Mache ich. Ich schreibe, wenn ich da bin.", pl: "Tak zrobię. Napiszę, jak będę na miejscu.")
            ],
            words: [
            Gloss(de: "die Verspätung", pl: "opóźnienie"),
            Gloss(de: "die Frühschicht", pl: "poranna zmiana"),
            Gloss(de: "die Rampe", pl: "rampa")
            ],
            phrases: ["Der Bus hat Verspätung.", "Fang an der Rampe an."],
            note: "Podajesz czas, nie sam fakt spóźnienia. In zwanzig Minuten da jest konkret.",
            question: "Kiedy będziesz?",
            options: ["Za dwadzieścia minut", "Jutro rano", "Po przerwie"],
            answer: 0,
            replyPL: "Autobus ma opóźnienie.",
            replyDE: "Der Bus hat Verspätung."
        ),
        MiniScene(
            id: "s020",
            title: "Kontrola biletu",
            category: "W autobusie i pociągu",
            level: "A2",
            situation: "Konduktor stoi przy tobie, a bilet masz w telefonie.",
            lines: [
            SayLine(id: "s020-0", who: "Konduktor", de: "Fahrscheine, bitte.", pl: "Bilety, poproszę."),
            SayLine(id: "s020-1", who: "Ty", de: "Ich habe ihn auf dem Handy.", pl: "Mam go w telefonie."),
            SayLine(id: "s020-2", who: "Konduktor", de: "Halten Sie ihn heller. Der Code ist unscharf.", pl: "Niech pan go rozjaśni. Kod jest niewyraźny."),
            SayLine(id: "s020-3", who: "Ty", de: "Jetzt. Der gilt bis Burgwedel.", pl: "Już. Ważny jest do Burgwedel.")
            ],
            words: [
            Gloss(de: "der Fahrschein", pl: "bilet"),
            Gloss(de: "der Code", pl: "kod")
            ],
            phrases: ["Fahrscheine, bitte.", "Der Code ist unscharf."],
            note: "Fahrschein i Ticket to bilet. Handy hell machen znaczy podnieść jasność.",
            question: "Gdzie masz bilet?",
            options: ["W telefonie", "Został w domu", "Kupujesz go dopiero u kierowcy"],
            answer: 0,
            replyPL: "Mam bilet w telefonie.",
            replyDE: "Ich habe den Fahrschein auf dem Handy."
        ),
        MiniScene(
            id: "s021",
            title: "Zły przystanek",
            category: "W autobusie i pociągu",
            level: "A2",
            situation: "Chciałeś wysiąść przy budowie, a autobus już ruszył.",
            lines: [
            SayLine(id: "s021-0", who: "Ty", de: "Hält der Bus an der Baustelle?", pl: "Czy autobus staje przy budowie?"),
            SayLine(id: "s021-1", who: "Kierowca", de: "Die Haltestelle heißt Nord, nicht Industrie.", pl: "Przystanek nazywa się Nord, nie Industrie."),
            SayLine(id: "s021-2", who: "Ty", de: "Ich bin eine zu weit gefahren.", pl: "Pojechałem o jeden za daleko."),
            SayLine(id: "s021-3", who: "Kierowca", de: "Steigen Sie hier aus und gehen Sie fünf Minuten zurück.", pl: "Wysiądź pan tutaj i pięć minut z powrotem.")
            ],
            words: [
            Gloss(de: "die Haltestelle", pl: "przystanek"),
            Gloss(de: "die Baustelle", pl: "budowa")
            ],
            phrases: ["eine zu weit gefahren", "fünf Minuten zurück"],
            note: "Nazwa przystanku bywa inna niż nazwa firmy. Pytaj o Haltestelle, nie tylko o Baustelle.",
            question: "Co masz zrobić?",
            options: ["Wysiąść i iść pięć minut z powrotem", "Jechać do końca trasy", "Wysiąść przy szpitalu"],
            answer: 0,
            replyPL: "Pojechałem o jeden przystanek za daleko.",
            replyDE: "Ich bin eine Haltestelle zu weit gefahren."
        ),
        MiniScene(
            id: "s022",
            title: "Zmiana peronu",
            category: "Na dworcu",
            level: "A1",
            situation: "Na tablicy peron skacze z 4 na 7.",
            lines: [
            SayLine(id: "s022-0", who: "Ty", de: "Von welchem Gleis fährt der Zug nach Hannover?", pl: "Z którego peronu jedzie pociąg do Hanoweru?"),
            SayLine(id: "s022-1", who: "Informacja", de: "Jetzt Gleis sieben, nicht vier.", pl: "Teraz peron siedem, nie cztery."),
            SayLine(id: "s022-2", who: "Ty", de: "Habe ich noch Zeit?", pl: "Mam jeszcze czas?"),
            SayLine(id: "s022-3", who: "Informacja", de: "Acht Minuten. Der Aufzug ist links.", pl: "Osiem minut. Winda jest po lewej.")
            ],
            words: [
            Gloss(de: "das Gleis", pl: "peron"),
            Gloss(de: "der Aufzug", pl: "winda")
            ],
            phrases: ["Jetzt Gleis sieben.", "Der Aufzug ist links."],
            note: "Gleis to peron albo tor. Bahnsteig też usłyszysz.",
            question: "Z którego peronu jedziesz?",
            options: ["Z siódmego", "Z czwartego", "Z pierwszego"],
            answer: 0,
            replyPL: "Z którego peronu jedzie pociąg?",
            replyDE: "Von welchem Gleis fährt der Zug?"
        ),
        MiniScene(
            id: "s023",
            title: "Spóźniony pociąg",
            category: "Na dworcu",
            level: "A2",
            situation: "Pociąg, którym wracasz ze zmiany, ma dwadzieścia minut opóźnienia.",
            lines: [
            SayLine(id: "s023-0", who: "Ty", de: "Hat der Zug nach Burgwedel Verspätung?", pl: "Czy pociąg do Burgwedel ma opóźnienie?"),
            SayLine(id: "s023-1", who: "Informacja", de: "Zwanzig Minuten. Er kommt auf Gleis zwei.", pl: "Dwadzieścia minut. Przyjedzie na drugi."),
            SayLine(id: "s023-2", who: "Ty", de: "Schaffe ich den Anschluss in Hannover noch?", pl: "Złapię jeszcze przesiadkę w Hanowerze?"),
            SayLine(id: "s023-3", who: "Informacja", de: "Knapp. Der Anschluss wartet nicht.", pl: "Ciasno. Przesiadka nie czeka.")
            ],
            words: [
            Gloss(de: "der Anschluss", pl: "przesiadka"),
            Gloss(de: "die Verspätung", pl: "opóźnienie")
            ],
            phrases: ["Hat der Zug Verspätung?", "Der Anschluss wartet nicht."],
            note: "Anschluss to przesiadka, nie podłączenie prądu.",
            question: "Ile ma opóźnienia?",
            options: ["Dwadzieścia minut", "Godzinę", "Nic, jest punktualny"],
            answer: 0,
            replyPL: "Pociąg ma dwadzieścia minut opóźnienia.",
            replyDE: "Der Zug hat zwanzig Minuten Verspätung."
        ),
        MiniScene(
            id: "s024",
            title: "Szafka na kask",
            category: "Na dworcu",
            level: "B1",
            situation: "Chcesz zostawić ciężką torbę, zanim pójdziesz na spotkanie.",
            lines: [
            SayLine(id: "s024-0", who: "Ty", de: "Wo sind die Schließfächer?", pl: "Gdzie są szafki?"),
            SayLine(id: "s024-1", who: "Ochrona", de: "Unten, neben der Toilette. Nur mit Karte.", pl: "Na dole, obok toalety. Tylko kartą."),
            SayLine(id: "s024-2", who: "Ty", de: "Wie lange kann die Tasche drin bleiben?", pl: "Jak długo torba może tam zostać?"),
            SayLine(id: "s024-3", who: "Ochrona", de: "Bis Mitternacht. Danach wird sie ausgeräumt.", pl: "Do północy. Potem ją wyjmują.")
            ],
            words: [
            Gloss(de: "das Schließfach", pl: "szafka"),
            Gloss(de: "die Tasche", pl: "torba")
            ],
            phrases: ["Wo sind die Schließfächer?", "Danach wird sie ausgeräumt."],
            note: "Schließfach to szafka na klucz albo kod. Nie myl z Schließzeit, czyli godziną zamknięcia.",
            question: "Do kiedy może zostać torba?",
            options: ["Do północy", "Tylko godzinę", "Trzy dni"],
            answer: 0,
            replyPL: "Gdzie są szafki?",
            replyDE: "Wo sind die Schließfächer?"
        ),
        MiniScene(
            id: "s025",
            title: "Ból pleców",
            category: "U lekarza",
            level: "A2",
            situation: "Plecy nie dają ci dźwigać i potrzebujesz zwolnienia.",
            lines: [
            SayLine(id: "s025-0", who: "Lekarz", de: "Was fehlt Ihnen?", pl: "Co panu dolega?"),
            SayLine(id: "s025-1", who: "Ty", de: "Mir tut der Rücken weh. Ich kann nicht heben.", pl: "Boli mnie plecy. Nie mogę dźwigać."),
            SayLine(id: "s025-2", who: "Lekarz", de: "Seit wann ist das so?", pl: "Od kiedy tak jest?"),
            SayLine(id: "s025-3", who: "Ty", de: "Seit Montag. Ich brauche eine Krankschreibung.", pl: "Od poniedziałku. Potrzebuję zwolnienia.")
            ],
            words: [
            Gloss(de: "der Rücken", pl: "plecy"),
            Gloss(de: "die Krankschreibung", pl: "zwolnienie")
            ],
            phrases: ["Mir tut der Rücken weh.", "Ich brauche eine Krankschreibung."],
            note: "Ból mówisz: mir tut ... weh. Zwolnienie to Krankschreibung, nie Rezept.",
            question: "Czego potrzebujesz?",
            options: ["Zwolnienia, bo bolą plecy", "Maści i kontroli za tydzień", "Tylko tabletki na dziś bez papieru"],
            answer: 0,
            replyPL: "Boli mnie plecy.",
            replyDE: "Mir tut der Rücken weh."
        ),
        MiniScene(
            id: "s026",
            title: "Termin na kontrolę",
            category: "U lekarza",
            level: "B1",
            situation: "Chcesz kontrolę rano, zanim zacznie się zmiana.",
            lines: [
            SayLine(id: "s026-0", who: "Ty", de: "Ich brauche einen Kontrolltermin.", pl: "Potrzebuję terminu na kontrolę."),
            SayLine(id: "s026-1", who: "Rejestracja", de: "Morgens oder nachmittags?", pl: "Rano czy po południu?"),
            SayLine(id: "s026-2", who: "Ty", de: "Morgens, vor der Schicht. Am besten um sieben.", pl: "Rano, przed zmianą. Najlepiej o siódmej."),
            SayLine(id: "s026-3", who: "Rejestracja", de: "Der Dritte um zehn nach sieben ist frei.", pl: "Trzeciego o dziesięć po siódmej jest wolne.")
            ],
            words: [
            Gloss(de: "der Termin", pl: "termin"),
            Gloss(de: "die Schicht", pl: "zmiana")
            ],
            phrases: ["Ich brauche einen Kontrolltermin.", "vor der Schicht"],
            note: "Mówisz, że termin ma być przed zmianą. Inaczej dadzą ci godzinę w środku roboty.",
            question: "Kiedy jest wolny termin?",
            options: ["Trzeciego krótko po siódmej", "Dziś w nocy", "Nie ma żadnego"],
            answer: 0,
            replyPL: "Potrzebuję terminu na kontrolę.",
            replyDE: "Ich brauche einen Kontrolltermin."
        ),
        MiniScene(
            id: "s027",
            title: "Ból gardła",
            category: "W aptece",
            level: "A1",
            situation: "Po nocnej boli cię gardło.",
            lines: [
            SayLine(id: "s027-0", who: "Ty", de: "Haben Sie etwas gegen Halsschmerzen?", pl: "Ma pan coś na ból gardła?"),
            SayLine(id: "s027-1", who: "Farmaceuta", de: "Zum Lutschen oder zum Trinken?", pl: "Do ssania czy do picia?"),
            SayLine(id: "s027-2", who: "Ty", de: "Zum Lutschen, ohne Zucker.", pl: "Do ssania, bez cukru."),
            SayLine(id: "s027-3", who: "Farmaceuta", de: "Alle zwei Stunden eine.", pl: "Co dwie godziny jedna.")
            ],
            words: [
            Gloss(de: "die Halsschmerzen", pl: "ból gardła"),
            Gloss(de: "die Packung", pl: "opakowanie")
            ],
            phrases: ["etwas gegen Halsschmerzen", "ohne Zucker"],
            note: "Gegen plus ból: gegen Halsschmerzen, gegen Kopfschmerzen.",
            question: "Na co jest lek?",
            options: ["Na ból gardła", "Na złamanie", "Na receptę dla dziecka"],
            answer: 0,
            replyPL: "Ma pan coś na ból gardła?",
            replyDE: "Haben Sie etwas gegen Halsschmerzen?"
        ),
        MiniScene(
            id: "s028",
            title: "E-recepta",
            category: "W aptece",
            level: "A2",
            situation: "Recepta jest w telefonie, a za tobą stoi kolejka.",
            lines: [
            SayLine(id: "s028-0", who: "Ty", de: "Ich habe ein E-Rezept auf dem Handy.", pl: "Mam e-receptę w telefonie."),
            SayLine(id: "s028-1", who: "Farmaceuta", de: "Legen Sie die Karte auf das Lesegerät.", pl: "Połóż pan kartę na czytnik."),
            SayLine(id: "s028-2", who: "Ty", de: "Die von der Krankenkasse oder die Bankkarte?", pl: "Tę z kasy chorych czy kartę bankową?"),
            SayLine(id: "s028-3", who: "Farmaceuta", de: "Die Gesundheitskarte. Die Bankkarte nicht.", pl: "Kartę ubezpieczenia. Nie kartę bankową.")
            ],
            words: [
            Gloss(de: "das E-Rezept", pl: "e-recepta"),
            Gloss(de: "die Gesundheitskarte", pl: "karta ubezpieczenia")
            ],
            phrases: ["Ich habe ein E-Rezept.", "Die Gesundheitskarte."],
            note: "Gesundheitskarte to karta kasy chorych. Karta z banku tu nie działa.",
            question: "Jaką kartę przykładasz?",
            options: ["Ubezpieczenia", "Bankową", "Biblioteczną"],
            answer: 0,
            replyPL: "Mam e-receptę w telefonie.",
            replyDE: "Ich habe ein E-Rezept auf dem Handy."
        ),
        MiniScene(
            id: "s029",
            title: "Nie mogę gryźć",
            category: "U dentysty",
            level: "A2",
            situation: "Ząb z lewej boli i nie gryziesz od wczoraj.",
            lines: [
            SayLine(id: "s029-0", who: "Dentysta", de: "Wo tut es weh?", pl: "Gdzie boli?"),
            SayLine(id: "s029-1", who: "Ty", de: "Hinten links. Ich kann nicht kauen.", pl: "Z tyłu z lewej. Nie mogę gryźć."),
            SayLine(id: "s029-2", who: "Dentysta", de: "Die Wurzel ist entzündet. Ich mache ein Bild.", pl: "Korzeń jest zapalony. Robię zdjęcie."),
            SayLine(id: "s029-3", who: "Ty", de: "Können Sie das heute noch behandeln?", pl: "Może pan to dziś jeszcze opatrzyć?")
            ],
            words: [
            Gloss(de: "der Zahn", pl: "ząb"),
            Gloss(de: "die Wurzel", pl: "korzeń")
            ],
            phrases: ["Ich kann nicht kauen.", "Die Wurzel ist entzündet."],
            note: "Kauen to gryźć. Weh tun zostaje przy bólu.",
            question: "Co jest nie tak?",
            options: ["Zapalony korzeń", "Tylko kamień", "Wizyta za rok"],
            answer: 0,
            replyPL: "Nie mogę gryźć.",
            replyDE: "Ich kann nicht kauen."
        ),
        MiniScene(
            id: "s030",
            title: "Termin po pracy",
            category: "U dentysty",
            level: "A2",
            situation: "Masz wrócić na plombę, ale rano jesteś na budowie.",
            lines: [
            SayLine(id: "s030-0", who: "Asystentka", de: "Der nächste Termin ist in zwei Wochen.", pl: "Następny termin jest za dwa tygodnie."),
            SayLine(id: "s030-1", who: "Ty", de: "Geht es nach sechzehn Uhr? Morgens arbeite ich.", pl: "Da się po szesnastej? Rano pracuję."),
            SayLine(id: "s030-2", who: "Asystentka", de: "Donnerstag um sechzehn Uhr.", pl: "Czwartek o szesnastej."),
            SayLine(id: "s030-3", who: "Ty", de: "Das passt. Ich komme nach der Schicht.", pl: "Pasuje. Przyjdę po zmianie.")
            ],
            words: [
            Gloss(de: "der Termin", pl: "termin"),
            Gloss(de: "die Schicht", pl: "zmiana")
            ],
            phrases: ["Das passt.", "nach der Schicht"],
            note: "Das passt znaczy, że godzina ci odpowiada.",
            question: "Kiedy wracasz do dentysty?",
            options: ["W czwartek o szesnastej", "Jutro o szóstej", "Wcale"],
            answer: 0,
            replyPL: "Pasuje. Przyjdę po zmianie.",
            replyDE: "Das passt. Ich komme nach der Schicht."
        ),
        MiniScene(
            id: "s031",
            title: "Korek przed zmianą",
            category: "W pracy",
            level: "A2",
            situation: "Stoisz na obwodnicy i nie zdążysz na szóstą.",
            lines: [
            SayLine(id: "s031-0", who: "Ty", de: "Ich stecke im Stau. Ich schaffe sechs Uhr nicht.", pl: "Stoję w korku. Nie dam rady na szóstą."),
            SayLine(id: "s031-1", who: "Szef", de: "Wie viel später?", pl: "O ile później?"),
            SayLine(id: "s031-2", who: "Ty", de: "Fünfzehn Minuten. Ich bin auf der Umgehung.", pl: "Piętnaście minut. Jestem na obwodnicy."),
            SayLine(id: "s031-3", who: "Szef", de: "Melde dich bei Tim, nicht bei mir.", pl: "Zgłoś się do Tima, nie do mnie.")
            ],
            words: [
            Gloss(de: "der Stau", pl: "korek"),
            Gloss(de: "die Umgehung", pl: "obwodnica")
            ],
            phrases: ["Ich stecke im Stau.", "Melde dich bei Tim."],
            note: "Podajesz minuty. Samo ich komme später nic szefowi nie mówi.",
            question: "O ile się spóźnisz?",
            options: ["O piętnaście minut", "O dwie godziny", "Nie przyjdziesz"],
            answer: 0,
            replyPL: "Stoję w korku.",
            replyDE: "Ich stecke im Stau."
        ),
        MiniScene(
            id: "s032",
            title: "Zostać do osiemnastej",
            category: "W pracy",
            level: "A2",
            situation: "Szef chce, żebyś został, aż przyjdzie ciężarówka.",
            lines: [
            SayLine(id: "s032-0", who: "Szef", de: "Kannst du heute länger bleiben?", pl: "Możesz dziś zostać dłużej?"),
            SayLine(id: "s032-1", who: "Ty", de: "Bis wann?", pl: "Do kiedy?"),
            SayLine(id: "s032-2", who: "Szef", de: "Bis achtzehn Uhr. Der Lkw kommt spät.", pl: "Do osiemnastej. Ciężarówka przyjedzie późno."),
            SayLine(id: "s032-3", who: "Ty", de: "Heute nicht. Ich muss zum Arzt. Morgen geht.", pl: "Dziś nie. Muszę do lekarza. Jutro tak.")
            ],
            words: [
            Gloss(de: "der Lkw", pl: "ciężarówka"),
            Gloss(de: "der Arzt", pl: "lekarz")
            ],
            phrases: ["Kannst du länger bleiben?", "Morgen geht."],
            note: "Odmawiasz i od razu dajesz inny dzień.",
            question: "Czemu dziś nie zostajesz?",
            options: ["Masz lekarza", "Nie chcesz rozmawiać", "Masz urlop cały miesiąc"],
            answer: 0,
            replyPL: "Dziś nie mogę zostać.",
            replyDE: "Heute kann ich nicht länger bleiben."
        ),
        MiniScene(
            id: "s033",
            title: "Zła strona ściany",
            category: "W pracy",
            level: "B1",
            situation: "Zacząłeś z lewej, a najpierw miała być prawa.",
            lines: [
            SayLine(id: "s033-0", who: "Ty", de: "Ich habe links angefangen. War das falsch?", pl: "Zacząłem z lewej. Źle?"),
            SayLine(id: "s033-1", who: "Szef", de: "Ja. Rechts zuerst. Links ist die alte Wand.", pl: "Tak. Najpierw z prawej. Lewa to stara ściana."),
            SayLine(id: "s033-2", who: "Ty", de: "Soll ich alles wieder abbauen?", pl: "Mam wszystko rozebrać?"),
            SayLine(id: "s033-3", who: "Szef", de: "Nur die obere Reihe. Der Rest bleibt.", pl: "Tylko górny rząd. Reszta zostaje.")
            ],
            words: [
            Gloss(de: "die Reihe", pl: "rząd"),
            Gloss(de: "die Wand", pl: "ściana")
            ],
            phrases: ["Rechts zuerst.", "Nur die obere Reihe."],
            note: "Zanim rozbierzesz całość, dopytaj, która część jest zła.",
            question: "Co masz rozebrać?",
            options: ["Tylko górny rząd", "Całą ścianę", "Nic"],
            answer: 0,
            replyPL: "Zacząłem ze złej strony.",
            replyDE: "Ich habe auf der falschen Seite angefangen."
        ),
        MiniScene(
            id: "s034",
            title: "Długa drabina",
            category: "Na budowie",
            level: "A1",
            situation: "Szef chce długą drabinę z przodu na tył placu.",
            lines: [
            SayLine(id: "s034-0", who: "Szef", de: "Hol die Leiter und bring sie nach hinten.", pl: "Przynieś drabinę i zanieś ją do tyłu."),
            SayLine(id: "s034-1", who: "Ty", de: "Die lange oder die kurze?", pl: "Długą czy krótką?"),
            SayLine(id: "s034-2", who: "Szef", de: "Die lange. Die kurze bleibt am Container.", pl: "Długą. Krótka zostaje przy kontenerze."),
            SayLine(id: "s034-3", who: "Ty", de: "Alles klar. Ich bringe sie nach hinten.", pl: "Jasne. Zanoszę ją do tyłu.")
            ],
            words: [
            Gloss(de: "die Leiter", pl: "drabina"),
            Gloss(de: "der Container", pl: "kontener")
            ],
            phrases: ["Hol die Leiter.", "nach hinten"],
            note: "Nach hinten to do tyłu. Nach vorne byłoby do przodu.",
            question: "Którą drabinę niesiesz?",
            options: ["Długą do tyłu", "Krótką do biura", "Obie na dach"],
            answer: 0,
            replyPL: "Zanoszę drabinę do tyłu.",
            replyDE: "Ich bringe die Leiter nach hinten."
        ),
        MiniScene(
            id: "s035",
            title: "Kabel w wykopie",
            category: "Na budowie",
            level: "A2",
            situation: "Widzisz odsłonięty kabel, zanim ktoś wejdzie do wykopu.",
            lines: [
            SayLine(id: "s035-0", who: "Ty", de: "Pass auf, hier liegt ein Kabel offen.", pl: "Uważaj, tu leży odsłonięty kabel."),
            SayLine(id: "s035-1", who: "Kolega", de: "Ist da Strom drauf?", pl: "Jest tam prąd?"),
            SayLine(id: "s035-2", who: "Ty", de: "Ich weiß es nicht. Ich hole den Elektriker.", pl: "Nie wiem. Wołam elektryka."),
            SayLine(id: "s035-3", who: "Kolega", de: "Gut. Ich gehe da nicht rein.", pl: "Dobrze. Nie wchodzę tam.")
            ],
            words: [
            Gloss(de: "das Kabel", pl: "kabel"),
            Gloss(de: "der Elektriker", pl: "elektryk")
            ],
            phrases: ["Hier liegt ein Kabel offen.", "Ich hole den Elektriker."],
            note: "Jak nie wiesz, czy jest prąd, nie sprawdzasz ręką.",
            question: "Co robisz?",
            options: ["Wołasz elektryka", "Przecinasz kabel", "Zalewasz go betonem"],
            answer: 0,
            replyPL: "Tu leży odsłonięty kabel.",
            replyDE: "Hier liegt ein Kabel offen."
        ),
        MiniScene(
            id: "s036",
            title: "Beton wiąże",
            category: "Na budowie",
            level: "A2",
            situation: "Beton stoi prawie czterdzieści minut i robi się twardy.",
            lines: [
            SayLine(id: "s036-0", who: "Ty", de: "Der Beton wird schon fest.", pl: "Beton już twardnieje."),
            SayLine(id: "s036-1", who: "Szef", de: "Wie lange steht der schon?", pl: "Jak długo już stoi?"),
            SayLine(id: "s036-2", who: "Ty", de: "Fast vierzig Minuten.", pl: "Prawie czterdzieści minut."),
            SayLine(id: "s036-3", who: "Szef", de: "Nicht mehr gießen. Ich rufe das Werk an.", pl: "Już nie lać. Dzwonię do wytwórni.")
            ],
            words: [
            Gloss(de: "der Beton", pl: "beton"),
            Gloss(de: "das Werk", pl: "wytwórnia")
            ],
            phrases: ["Der Beton wird fest.", "nicht mehr gießen"],
            note: "Przy betonie fest werden znaczy, że wiąże. Wody nie dolewasz sam.",
            question: "Co z betonem?",
            options: ["Już nie lać", "Dolać wody", "Zostawić w gruszce na jutro"],
            answer: 0,
            replyPL: "Beton już twardnieje.",
            replyDE: "Der Beton wird schon fest."
        ),
        MiniScene(
            id: "s037",
            title: "Za płytki wykop",
            category: "Na budowie",
            level: "B1",
            situation: "Wykop ma sześćdziesiąt centymetrów, a plan mówi osiemdziesiąt.",
            lines: [
            SayLine(id: "s037-0", who: "Szef", de: "Wie tief ist das Loch?", pl: "Jak głęboki jest dół?"),
            SayLine(id: "s037-1", who: "Ty", de: "Sechzig. Im Plan stehen achtzig.", pl: "Sześćdziesiąt. W planie jest osiemdziesiąt."),
            SayLine(id: "s037-2", who: "Szef", de: "Noch zwanzig runter. Nicht breiter.", pl: "Jeszcze dwadzieścia w dół. Nie szerzej."),
            SayLine(id: "s037-3", who: "Ty", de: "Ich messe danach noch einmal.", pl: "Potem zmierzę jeszcze raz.")
            ],
            words: [
            Gloss(de: "das Loch", pl: "dół"),
            Gloss(de: "der Plan", pl: "plan")
            ],
            phrases: ["Im Plan stehen achtzig.", "Nicht breiter."],
            note: "Mówisz obie liczby: swoją i z planu.",
            question: "Ile jeszcze kopać?",
            options: ["Dwadzieścia centymetrów w dół", "Dwa metry wszerz", "Nic"],
            answer: 0,
            replyPL: "W planie jest osiemdziesiąt.",
            replyDE: "Im Plan stehen achtzig."
        ),
        MiniScene(
            id: "s038",
            title: "Wolne w sierpniu",
            category: "Rozmowy z szefem",
            level: "A2",
            situation: "Chcesz konkretny tydzień sierpnia, nie cały miesiąc.",
            lines: [
            SayLine(id: "s038-0", who: "Ty", de: "Kann ich vom zehnten bis zum vierzehnten August frei nehmen?", pl: "Czy mogę wziąć wolne od dziesiątego do czternastego sierpnia?"),
            SayLine(id: "s038-1", who: "Szef", de: "Eine Woche, mitten im Monat.", pl: "Tydzień, w środku miesiąca."),
            SayLine(id: "s038-2", who: "Ty", de: "Ja. Der Rest vom Team ist da.", pl: "Tak. Reszta ekipy jest."),
            SayLine(id: "s038-3", who: "Szef", de: "Trag es ins Formular ein.", pl: "Wpisz to w formularz.")
            ],
            words: [
            Gloss(de: "der Urlaub", pl: "urlop"),
            Gloss(de: "das Formular", pl: "formularz")
            ],
            phrases: ["frei nehmen", "ins Formular eintragen"],
            note: "Podajesz daty od-do. Samo im August jest za szerokie.",
            question: "Kiedy chcesz wolne?",
            options: ["Od 10. do 14. sierpnia", "Cały grudzień", "Jutro godzinę"],
            answer: 0,
            replyPL: "Chcę wolne od dziesiątego do czternastego.",
            replyDE: "Ich möchte vom zehnten bis zum vierzehnten frei haben."
        ),
        MiniScene(
            id: "s039",
            title: "Brakujące nadgodziny",
            category: "Rozmowy z szefem",
            level: "B1",
            situation: "Na pasku nie ma dwunastu godzin z tygodnia od trzeciego.",
            lines: [
            SayLine(id: "s039-0", who: "Ty", de: "Auf der Abrechnung fehlen zwölf Stunden.", pl: "Na rozliczeniu brakuje dwunastu godzin."),
            SayLine(id: "s039-1", who: "Szef", de: "Welche Woche?", pl: "Który tydzień?"),
            SayLine(id: "s039-2", who: "Ty", de: "Die vom dritten. Ich war bis achtzehn Uhr da.", pl: "Ten od trzeciego. Byłem do osiemnastej."),
            SayLine(id: "s039-3", who: "Szef", de: "Schick mir die Zeiten. Ich gebe sie weiter.", pl: "Przyślij godziny. Przekażę je.")
            ],
            words: [
            Gloss(de: "die Abrechnung", pl: "rozliczenie"),
            Gloss(de: "die Überstunde", pl: "nadgodzina")
            ],
            phrases: ["Es fehlen zwölf Stunden.", "Schick mir die Zeiten."],
            note: "Mówisz liczbę i tydzień. Inaczej księgowość zgaduje.",
            question: "Czego brakuje?",
            options: ["Dwunastu godzin z jednego tygodnia", "Całej rocznej wypłaty", "Urlopu"],
            answer: 0,
            replyPL: "Brakuje dwunastu godzin.",
            replyDE: "Es fehlen zwölf Stunden."
        ),
        MiniScene(
            id: "s040",
            title: "Powtórz wolniej",
            category: "Rozmowy z szefem",
            level: "A2",
            situation: "Przy rampie szef mówi za szybko o kolorze palety.",
            lines: [
            SayLine(id: "s040-0", who: "Szef", de: "Die Palette nach Tor drei, nicht die rote.", pl: "Paleta do bramy trzy, nie czerwona."),
            SayLine(id: "s040-1", who: "Ty", de: "Langsamer, bitte. Welche Farbe?", pl: "Wolniej, poproszę. Jaki kolor?"),
            SayLine(id: "s040-2", who: "Szef", de: "Die blaue. Tor drei.", pl: "Niebieska. Brama trzy."),
            SayLine(id: "s040-3", who: "Ty", de: "Blaue Palette, Tor drei. Stimmt das?", pl: "Niebieska paleta, brama trzy. Zgadza się?")
            ],
            words: [
            Gloss(de: "die Palette", pl: "paleta"),
            Gloss(de: "das Tor", pl: "brama")
            ],
            phrases: ["Langsamer, bitte.", "Stimmt das?"],
            note: "Na końcu powtarzasz polecenie. Wtedy słyszysz, czy dobrze złapałeś.",
            question: "Która paleta?",
            options: ["Niebieska do bramy trzy", "Czerwona do bramy jeden", "Wszystkie"],
            answer: 0,
            replyPL: "Proszę wolniej.",
            replyDE: "Langsamer, bitte."
        ),
        MiniScene(
            id: "s041",
            title: "Za ciężka paleta",
            category: "Rozmowy ze współpracownikami",
            level: "A1",
            situation: "Paleta jest za ciężka, żeby nieść ją samemu.",
            lines: [
            SayLine(id: "s041-0", who: "Ty", de: "Kannst du mir kurz helfen? Die ist zu schwer.", pl: "Możesz mi chwilę pomóc? Ta jest za ciężka."),
            SayLine(id: "s041-1", who: "Kolega", de: "Wohin soll sie?", pl: "Dokąd ma iść?"),
            SayLine(id: "s041-2", who: "Ty", de: "Nur bis zur Rampe.", pl: "Tylko do rampy."),
            SayLine(id: "s041-3", who: "Kolega", de: "Ich nehme links.", pl: "Biorę z lewej.")
            ],
            words: [
            Gloss(de: "die Palette", pl: "paleta"),
            Gloss(de: "die Rampe", pl: "rampa")
            ],
            phrases: ["zu schwer", "nur bis zur Rampe"],
            note: "Mówisz, gdzie kończycie. Inaczej kolega niesie za daleko.",
            question: "Dokąd niesiecie?",
            options: ["Tylko do rampy", "Do ciężarówki", "Na dach"],
            answer: 0,
            replyPL: "Możesz mi chwilę pomóc?",
            replyDE: "Kannst du mir kurz helfen?"
        ),
        MiniScene(
            id: "s042",
            title: "Twoja wkrętarka",
            category: "Rozmowy ze współpracownikami",
            level: "A2",
            situation: "Kolega wziął twoją wkrętarkę, a ty jej teraz potrzebujesz.",
            lines: [
            SayLine(id: "s042-0", who: "Ty", de: "Hast du meinen Akkuschrauber?", pl: "Masz moją wkrętarkę?"),
            SayLine(id: "s042-1", who: "Kolega", de: "Ja. Bei mir war der Akku leer.", pl: "Tak. U mnie akumulator był pusty."),
            SayLine(id: "s042-2", who: "Ty", de: "Ich brauche ihn jetzt an der Wand.", pl: "Potrzebuję jej teraz przy ścianie."),
            SayLine(id: "s042-3", who: "Kolega", de: "In fünf Minuten hast du ihn.", pl: "Za pięć minut ją masz.")
            ],
            words: [
            Gloss(de: "der Akkuschrauber", pl: "wkrętarka"),
            Gloss(de: "der Akku", pl: "akumulator")
            ],
            phrases: ["Hast du meinen Akkuschrauber?", "in fünf Minuten"],
            note: "Meinen mówi, że to twoje narzędzie.",
            question: "Kiedy dostaniesz wkrętarkę?",
            options: ["Za pięć minut", "Jutro", "Wcale"],
            answer: 0,
            replyPL: "Masz moją wkrętarkę?",
            replyDE: "Hast du meinen Akkuschrauber?"
        ),
        MiniScene(
            id: "s043",
            title: "Kawa na przerwę",
            category: "Rozmowy ze współpracownikami",
            level: "A2",
            situation: "Zostajesz przy pompie, a kolega idzie po kawę.",
            lines: [
            SayLine(id: "s043-0", who: "Kolega", de: "Ich gehe Pause machen.", pl: "Idę na przerwę."),
            SayLine(id: "s043-1", who: "Ty", de: "Die Pumpe darf nicht allein laufen. Ich komme in zehn Minuten.", pl: "Pompa nie może chodzić sama. Przyjdę za dziesięć minut."),
            SayLine(id: "s043-2", who: "Kolega", de: "Soll ich dir einen Kaffee mitbringen?", pl: "Mam ci przynieść kawę?"),
            SayLine(id: "s043-3", who: "Ty", de: "Ja, schwarz. Danke.", pl: "Tak, czarną. Dzięki.")
            ],
            words: [
            Gloss(de: "die Pumpe", pl: "pompa"),
            Gloss(de: "der Kaffee", pl: "kawa")
            ],
            phrases: ["nicht allein laufen", "schwarz"],
            note: "Schwarz przy kawie znaczy bez mleka.",
            question: "Czemu nie idziesz od razu?",
            options: ["Pompa nie może zostać sama", "Nie lubisz przerwy", "Szef zamknął kontener"],
            answer: 0,
            replyPL: "Kawę czarną, poproszę.",
            replyDE: "Einen Kaffee, schwarz, bitte."
        ),
        MiniScene(
            id: "s044",
            title: "Meldunek",
            category: "W urzędzie",
            level: "A2",
            situation: "Przeprowadziłeś się i masz się zameldować.",
            lines: [
            SayLine(id: "s044-0", who: "Urzędnik", de: "Haben Sie den Ausweis und die Wohnungsgeberbestätigung?", pl: "Ma pan dowód i potwierdzenie od wynajmującego?"),
            SayLine(id: "s044-1", who: "Ty", de: "Den Ausweis ja. Die Bestätigung schicke ich nach.", pl: "Dowód tak. Potwierdzenie doślę."),
            SayLine(id: "s044-2", who: "Urzędnik", de: "Ohne das Papier geht die Anmeldung nicht.", pl: "Bez tego papieru meldunek nie przejdzie."),
            SayLine(id: "s044-3", who: "Ty", de: "Ich hole es heute und komme morgen wieder.", pl: "Wezmę je dziś i wrócę jutro.")
            ],
            words: [
            Gloss(de: "der Ausweis", pl: "dowód"),
            Gloss(de: "die Anmeldung", pl: "meldunek")
            ],
            phrases: ["Ohne das Papier geht es nicht.", "Ich komme morgen wieder."],
            note: "Wohnungsgeberbestätigung to papier od osoby, która ci wynajmuje. Sam dowód nie wystarczy.",
            question: "Czego brakuje?",
            options: ["Papieru od wynajmującego", "Podpisu na formularzu", "Numeru nowego mieszkania"],
            answer: 0,
            replyPL: "Wrócę jutro z papierem.",
            replyDE: "Ich komme morgen mit dem Papier wieder."
        ),
        MiniScene(
            id: "s045",
            title: "Numerek i zły okienko",
            category: "W urzędzie",
            level: "B1",
            situation: "Masz numerek 46, a tablica woła inne stanowisko.",
            lines: [
            SayLine(id: "s045-0", who: "Ty", de: "Meine Nummer ist sechsundvierzig. Welcher Schalter?", pl: "Mój numerek to czterdzieści sześć. Które okienko?"),
            SayLine(id: "s045-1", who: "Ochrona", de: "Schalter drei, nicht eins. Eins ist nur für Firmen.", pl: "Okienko trzy, nie jeden. Jedynka jest tylko dla firm."),
            SayLine(id: "s045-2", who: "Ty", de: "Und wenn ich die Nummer verpasse?", pl: "A jak przegapię numerek?"),
            SayLine(id: "s045-3", who: "Ochrona", de: "Noch einmal ziehen. Der alte gilt dann nicht.", pl: "Bierzesz nowy. Stary wtedy nie działa.")
            ],
            words: [
            Gloss(de: "der Schalter", pl: "okienko"),
            Gloss(de: "die Nummer", pl: "numerek")
            ],
            phrases: ["Schalter drei", "noch einmal ziehen"],
            note: "Schalter to okienko. Nie myl z Schalter na ścianie, czyli włącznikiem.",
            question: "Do którego okienka idziesz?",
            options: ["Do trzeciego", "Do pierwszego", "Do dowolnego"],
            answer: 0,
            replyPL: "Które okienko?",
            replyDE: "Welcher Schalter?"
        ),
        MiniScene(
            id: "s046",
            title: "Nowe konto",
            category: "W banku",
            level: "A2",
            situation: "Chcesz konto, na które firma przeleje wypłatę.",
            lines: [
            SayLine(id: "s046-0", who: "Ty", de: "Ich möchte ein Girokonto eröffnen.", pl: "Chcę otworzyć konto."),
            SayLine(id: "s046-1", who: "Bank", de: "Haben Sie den Ausweis und die Steuer-ID?", pl: "Ma pan dowód i numer podatkowy?"),
            SayLine(id: "s046-2", who: "Ty", de: "Den Ausweis ja. Die Steuer-ID suche ich noch.", pl: "Dowód tak. Numeru podatkowego jeszcze szukam."),
            SayLine(id: "s046-3", who: "Bank", de: "Ohne die Nummer kann ich das Konto nicht fertigmachen.", pl: "Bez tego numeru nie domknę konta.")
            ],
            words: [
            Gloss(de: "das Girokonto", pl: "konto"),
            Gloss(de: "der Ausweis", pl: "dowód"),
            Gloss(de: "die Steuer-ID", pl: "numer podatkowy")
            ],
            phrases: ["ein Girokonto eröffnen", "die Steuer-ID"],
            note: "Steuer-ID jest na pismach z urzędu skarbowego. To nie jest numer konta.",
            question: "Czego jeszcze brakuje do konta?",
            options: ["Numeru podatkowego", "Aktualnego adresu", "Dowodu z meldunkiem"],
            answer: 0,
            replyPL: "Chcę otworzyć konto.",
            replyDE: "Ich möchte ein Girokonto eröffnen."
        ),
        MiniScene(
            id: "s047",
            title: "Zgubiona karta",
            category: "W banku",
            level: "A2",
            situation: "Karty nie ma w portfelu po zmianie.",
            lines: [
            SayLine(id: "s047-0", who: "Ty", de: "Ich möchte meine Karte sperren lassen.", pl: "Chcę zastrzec kartę."),
            SayLine(id: "s047-1", who: "Bank", de: "Ist sie weg oder nur nicht da?", pl: "Zginęła czy tylko jej nie ma?"),
            SayLine(id: "s047-2", who: "Ty", de: "Weg. Ich hatte sie auf der Baustelle.", pl: "Zginęła. Miałem ją na budowie."),
            SayLine(id: "s047-3", who: "Bank", de: "Ich sperre sie jetzt. Eine neue kommt per Post.", pl: "Blokuję ją teraz. Nowa przyjdzie pocztą.")
            ],
            words: [
            Gloss(de: "die Karte", pl: "karta"),
            Gloss(de: "sperren", pl: "zastrzec")
            ],
            phrases: ["die Karte sperren lassen", "per Post"],
            note: "Sperren to blokada. Nie czekasz do jutra, jeśli karty nie ma.",
            question: "Co robi bank?",
            options: ["Blokuje kartę", "Daje ci gotówkę z kasy od razu bez dokumentów", "Zamyka konto na zawsze"],
            answer: 0,
            replyPL: "Chcę zastrzec kartę.",
            replyDE: "Ich möchte meine Karte sperren lassen."
        ),
        MiniScene(
            id: "s048",
            title: "Przelew za czynsz",
            category: "W banku",
            level: "B1",
            situation: "Czynsz ma wyjść piątego, a dziś jest trzeci.",
            lines: [
            SayLine(id: "s048-0", who: "Ty", de: "Ich möchte eine Dauerüberweisung für die Miete.", pl: "Chcę zlecenie stałe na czynsz."),
            SayLine(id: "s048-1", who: "Bank", de: "Welcher Betrag und welcher Tag?", pl: "Jaka kwota i który dzień?"),
            SayLine(id: "s048-2", who: "Ty", de: "Sechshundert Euro, immer am Fünften.", pl: "Sześćset euro, zawsze piątego."),
            SayLine(id: "s048-3", who: "Bank", de: "Empfänger und IBAN, bitte.", pl: "Odbiorca i IBAN, poproszę.")
            ],
            words: [
            Gloss(de: "die Miete", pl: "czynsz"),
            Gloss(de: "die Dauerüberweisung", pl: "zlecenie stałe")
            ],
            phrases: ["Dauerüberweisung", "immer am Fünften"],
            note: "Dauerüberweisung samo schodzi co miesiąc. Einmalige Überweisung robisz ręcznie.",
            question: "Kiedy ma schodzić czynsz?",
            options: ["Piątego", "Codziennie", "Raz w roku"],
            answer: 0,
            replyPL: "Chcę zlecenie stałe na czynsz.",
            replyDE: "Ich möchte eine Dauerüberweisung für die Miete."
        ),
        MiniScene(
            id: "s049",
            title: "Odbiór paczki",
            category: "Na poczcie",
            level: "A1",
            situation: "Masz awizo, a okienko zamyka się o osiemnastej.",
            lines: [
            SayLine(id: "s049-0", who: "Ty", de: "Ich möchte ein Paket abholen.", pl: "Chcę odebrać paczkę."),
            SayLine(id: "s049-1", who: "Poczta", de: "Die Karte und den Ausweis, bitte.", pl: "Awizo i dowód, poproszę."),
            SayLine(id: "s049-2", who: "Ty", de: "Hier. Ist das Schalter zwei?", pl: "Proszę. Czy to okienko dwa?"),
            SayLine(id: "s049-3", who: "Poczta", de: "Ja. Unterschreiben Sie hier.", pl: "Tak. Proszę tu podpisać.")
            ],
            words: [
            Gloss(de: "das Paket", pl: "paczka"),
            Gloss(de: "der Ausweis", pl: "dowód")
            ],
            phrases: ["ein Paket abholen", "unterschreiben"],
            note: "Bez awizo i dowodu paczki często nie wydadzą.",
            question: "Co masz podać?",
            options: ["Awizo i dowód", "Samego numeru z SMS", "Kodu odbioru i dowodu"],
            answer: 0,
            replyPL: "Chcę odebrać paczkę.",
            replyDE: "Ich möchte ein Paket abholen."
        ),
        MiniScene(
            id: "s050",
            title: "Za duża przesyłka",
            category: "Na poczcie",
            level: "A2",
            situation: "Karton z częściami nie mieści się w skrytce.",
            lines: [
            SayLine(id: "s050-0", who: "Ty", de: "Das Paket passt nicht ins Fach.", pl: "Paczka nie mieści się do skrytki."),
            SayLine(id: "s050-1", who: "Poczta", de: "Dann holen Sie es am Schalter.", pl: "To odbiera ją pan przy okienku."),
            SayLine(id: "s050-2", who: "Ty", de: "Bis wann heute?", pl: "Do której dziś?"),
            SayLine(id: "s050-3", who: "Poczta", de: "Bis achtzehn Uhr. Morgen ab acht.", pl: "Do osiemnastej. Jutro od ósmej.")
            ],
            words: [
            Gloss(de: "das Paket", pl: "paczka"),
            Gloss(de: "das Fach", pl: "skrytka")
            ],
            phrases: ["passt nicht ins Fach", "bis achtzehn Uhr"],
            note: "Fach to skrzynka albo przegródka. Schalter to okienko z człowiekiem.",
            question: "Do której odbierzesz paczkę dziś?",
            options: ["Do osiemnastej", "Do północy", "Tylko w niedzielę"],
            answer: 0,
            replyPL: "Paczka nie mieści się do skrytki.",
            replyDE: "Das Paket passt nicht ins Fach."
        ),
        MiniScene(
            id: "s051",
            title: "Oglądanie pokoju",
            category: "Wynajem mieszkania",
            level: "A2",
            situation: "Oglądasz pokój i pytasz, co wchodzi w czynsz.",
            lines: [
            SayLine(id: "s051-0", who: "Wynajmujący", de: "Das Zimmer ist zwölf Quadratmeter.", pl: "Pokój ma dwanaście metrów."),
            SayLine(id: "s051-1", who: "Ty", de: "Ist die Miete warm oder kalt?", pl: "Czynsz jest z mediami czy bez?"),
            SayLine(id: "s051-2", who: "Wynajmujący", de: "Warm, aber Strom zahlen Sie extra.", pl: "Z mediami, ale prąd płaci pan osobno."),
            SayLine(id: "s051-3", who: "Ty", de: "Wann kann ich einziehen?", pl: "Kiedy mogę się wprowadzić?")
            ],
            words: [
            Gloss(de: "die Miete", pl: "czynsz"),
            Gloss(de: "das Zimmer", pl: "pokój"),
            Gloss(de: "der Strom", pl: "prąd")
            ],
            phrases: ["warm oder kalt", "Strom extra"],
            note: "Warm to z ogrzewaniem i często z wodą. Strom prawie zawsze jest obok.",
            question: "Co płacisz osobno?",
            options: ["Prąd", "Nic, wszystko jest w czynszu", "Podatek od domu"],
            answer: 0,
            replyPL: "Czy czynsz jest z mediami?",
            replyDE: "Ist die Miete warm oder kalt?"
        ),
        MiniScene(
            id: "s052",
            title: "Kaucja",
            category: "Wynajem mieszkania",
            level: "B1",
            situation: "Wynajmujący chce trzech kaucji, a ty masz dwie.",
            lines: [
            SayLine(id: "s052-0", who: "Ty", de: "Wie hoch ist die Kaution?", pl: "Jak wysoka jest kaucja?"),
            SayLine(id: "s052-1", who: "Wynajmujący", de: "Drei Kaltmieten.", pl: "Trzy czynsze bez mediów."),
            SayLine(id: "s052-2", who: "Ty", de: "Ich kann zwei jetzt und eine im nächsten Monat.", pl: "Mogę dwie teraz i jedną w przyszłym miesiącu."),
            SayLine(id: "s052-3", who: "Wynajmujący", de: "Das geht, wenn es im Vertrag steht.", pl: "Da się, jeśli będzie w umowie.")
            ],
            words: [
            Gloss(de: "die Kaution", pl: "kaucja"),
            Gloss(de: "der Vertrag", pl: "umowa"),
            Gloss(de: "die Kaltmiete", pl: "czynsz bez mediów")
            ],
            phrases: ["Wie hoch ist die Kaution?", "im Vertrag"],
            note: "Kaltmiete to czynsz bez ogrzewania. Od niego liczy się kaucję.",
            question: "Ile kaucji chce na start?",
            options: ["Dwie teraz, jedna później", "Tylko jedną", "Żadnej"],
            answer: 0,
            replyPL: "Jak wysoka jest kaucja?",
            replyDE: "Wie hoch ist die Kaution?"
        ),
        MiniScene(
            id: "s053",
            title: "Grzejnik zimny",
            category: "Wynajem mieszkania",
            level: "A2",
            situation: "Wieczorem grzejnik jest zimny, a na dworze jest mróz.",
            lines: [
            SayLine(id: "s053-0", who: "Ty", de: "Die Heizung im Schlafzimmer bleibt kalt.", pl: "Grzejnik w sypialni zostaje zimny."),
            SayLine(id: "s053-1", who: "Wynajmujący", de: "Haben Sie entlüftet?", pl: "Odpowietrzył pan?"),
            SayLine(id: "s053-2", who: "Ty", de: "Ja. Es kommt nur Luft, kein Wasser.", pl: "Tak. Idzie samo powietrze, nie woda."),
            SayLine(id: "s053-3", who: "Wynajmujący", de: "Dann kommt morgen der Monteur.", pl: "To jutro przyjdzie monter.")
            ],
            words: [
            Gloss(de: "die Heizung", pl: "ogrzewanie"),
            Gloss(de: "der Monteur", pl: "monter")
            ],
            phrases: ["Die Heizung bleibt kalt.", "morgen der Monteur"],
            note: "Entlüften to odpowietrzyć. Jak idzie samo powietrze, to już nie twoja robota.",
            question: "Kto przyjdzie?",
            options: ["Monter jutro", "Nikt", "Listonosz"],
            answer: 0,
            replyPL: "Grzejnik jest zimny.",
            replyDE: "Die Heizung bleibt kalt."
        ),
        MiniScene(
            id: "s054",
            title: "Paczka dla sąsiada",
            category: "Sąsiedzi",
            level: "A1",
            situation: "Kurier chce zostawić paczkę, a sąsiada nie ma.",
            lines: [
            SayLine(id: "s054-0", who: "Kurier", de: "Können Sie das Paket für Müller annehmen?", pl: "Może pan przyjąć paczkę dla Müllera?"),
            SayLine(id: "s054-1", who: "Ty", de: "Ja. Wohnt er direkt neben mir.", pl: "Tak. Mieszka tuż obok."),
            SayLine(id: "s054-2", who: "Kurier", de: "Bitte hier unterschreiben.", pl: "Proszę tu podpisać."),
            SayLine(id: "s054-3", who: "Ty", de: "Ich sage ihm Bescheid.", pl: "Dam mu znać.")
            ],
            words: [
            Gloss(de: "das Paket", pl: "paczka"),
            Gloss(de: "der Nachbar", pl: "sąsiad")
            ],
            phrases: ["das Paket annehmen", "Bescheid sagen"],
            note: "Annehmen to przyjąć przesyłkę. Potem naprawdę musisz powiedzieć sąsiadowi.",
            question: "Co robisz z paczką?",
            options: ["Przyjmujesz ją i dajesz znać", "Odmawiasz", "Otwierasz ją"],
            answer: 0,
            replyPL: "Przyjmę paczkę.",
            replyDE: "Ich nehme das Paket an."
        ),
        MiniScene(
            id: "s055",
            title: "Miejsce parkingowe",
            category: "Sąsiedzi",
            level: "A2",
            situation: "Ktoś stanął na twoim numerze pod blokiem.",
            lines: [
            SayLine(id: "s055-0", who: "Ty", de: "Das ist mein Stellplatz, Nummer zwölf.", pl: "To moje miejsce, numer dwanaście."),
            SayLine(id: "s055-1", who: "Sąsiad", de: "Ich dachte, das ist für Gäste.", pl: "Myślałem, że to dla gości."),
            SayLine(id: "s055-2", who: "Ty", de: "Nein. Gäste stehen vor dem Haus.", pl: "Nie. Goście stoją przed domem."),
            SayLine(id: "s055-3", who: "Sąsiad", de: "Ich fahre sofort weg.", pl: "Zaraz odjeżdżam.")
            ],
            words: [
            Gloss(de: "der Stellplatz", pl: "miejsce parkingowe"),
            Gloss(de: "der Gast", pl: "gość")
            ],
            phrases: ["mein Stellplatz", "vor dem Haus"],
            note: "Stellplatz to przypisane miejsce. Parkplatz bywa ogólny.",
            question: "Gdzie stoją goście?",
            options: ["Przed domem", "Na numerze dwanaście", "W garażu podziemnym bez zgody"],
            answer: 0,
            replyPL: "To moje miejsce parkingowe.",
            replyDE: "Das ist mein Stellplatz."
        ),
        MiniScene(
            id: "s056",
            title: "Telefon do mamy",
            category: "Rodzina i znajomi",
            level: "A1",
            situation: "Dzwonisz po zmianie i mówisz, że jesteś zdrowy.",
            lines: [
            SayLine(id: "s056-0", who: "Mama", de: "Na, wie war die Arbeit?", pl: "No i jak w pracy?"),
            SayLine(id: "s056-1", who: "Ty", de: "Lang, aber okay. Ich bin schon zu Hause.", pl: "Długo, ale w porządku. Już jestem w domu."),
            SayLine(id: "s056-2", who: "Mama", de: "Hast du gegessen?", pl: "Jadłeś?"),
            SayLine(id: "s056-3", who: "Ty", de: "Noch nicht. Ich mache mir gleich etwas.", pl: "Jeszcze nie. Zaraz coś sobie zrobię.")
            ],
            words: [
            Gloss(de: "die Arbeit", pl: "praca"),
            Gloss(de: "zu Hause", pl: "w domu")
            ],
            phrases: ["Wie war die Arbeit?", "Ich bin schon zu Hause."],
            note: "Zu Hause piszesz osobno. Zuhause jednym słowem też zobaczysz, ale tu masz zwrot.",
            question: "Gdzie jesteś?",
            options: ["Już w domu", "Jeszcze na budowie", "W pociągu"],
            answer: 0,
            replyPL: "Już jestem w domu.",
            replyDE: "Ich bin schon zu Hause."
        ),
        MiniScene(
            id: "s057",
            title: "Odwiedziny w niedzielę",
            category: "Rodzina i znajomi",
            level: "A2",
            situation: "Kolega chce wpaść, a ty masz poranną w poniedziałek.",
            lines: [
            SayLine(id: "s057-0", who: "Kolega", de: "Hast du Sonntag Zeit?", pl: "Masz czas w niedzielę?"),
            SayLine(id: "s057-1", who: "Ty", de: "Nachmittags ja. Abends muss ich früh schlafen.", pl: "Po południu tak. Wieczorem muszę wcześnie spać."),
            SayLine(id: "s057-2", who: "Kolega", de: "Ich komme um drei.", pl: "Przyjdę o trzeciej."),
            SayLine(id: "s057-3", who: "Ty", de: "Gut. Um sechs musst du los.", pl: "Dobrze. O szóstej musisz iść.")
            ],
            words: [
            Gloss(de: "der Sonntag", pl: "niedziela"),
            Gloss(de: "der Nachmittag", pl: "popołudnie")
            ],
            phrases: ["Hast du Sonntag Zeit?", "früh schlafen"],
            note: "Mówisz do której godziny wizyta ma sens, skoro rano jest zmiana.",
            question: "Kiedy kolega ma wyjść?",
            options: ["O szóstej", "O północy", "Zostaje na noc"],
            answer: 0,
            replyPL: "Po południu mam czas.",
            replyDE: "Nachmittags habe ich Zeit."
        ),
        MiniScene(
            id: "s058",
            title: "Złe połączenie",
            category: "Telefonowanie",
            level: "A1",
            situation: "Na dachu ledwo słyszysz szefa.",
            lines: [
            SayLine(id: "s058-0", who: "Ty", de: "Ich verstehe Sie schlecht.", pl: "Źle pana słyszę."),
            SayLine(id: "s058-1", who: "Szef", de: "Wo bist du?", pl: "Gdzie jesteś?"),
            SayLine(id: "s058-2", who: "Ty", de: "Auf dem Dach. Der Wind ist laut.", pl: "Na dachu. Wiatr jest głośny."),
            SayLine(id: "s058-3", who: "Szef", de: "Ruf mich in fünf Minuten noch einmal an.", pl: "Zadzwoń do mnie jeszcze raz za pięć minut.")
            ],
            words: [
            Gloss(de: "das Dach", pl: "dach"),
            Gloss(de: "der Wind", pl: "wiatr")
            ],
            phrases: ["Ich verstehe Sie schlecht.", "noch einmal anrufen"],
            note: "Schlecht verstehen mówisz, gdy łącze jest złe. Nicht verstehen mówisz, gdy nie znasz słów.",
            question: "Co masz zrobić?",
            options: ["Zadzwonić jeszcze raz za pięć minut", "Zostać na linii w wietrze", "Iść do lekarza"],
            answer: 0,
            replyPL: "Źle pana słyszę.",
            replyDE: "Ich verstehe Sie schlecht."
        ),
        MiniScene(
            id: "s059",
            title: "Oddzwonię",
            category: "Telefonowanie",
            level: "A2",
            situation: "Nie możesz rozmawiać, bo stoisz przy pilarce.",
            lines: [
            SayLine(id: "s059-0", who: "Kierownik", de: "Hast du kurz Zeit?", pl: "Masz chwilę?"),
            SayLine(id: "s059-1", who: "Ty", de: "Jetzt nicht. Die Säge läuft.", pl: "Teraz nie. Piła chodzi."),
            SayLine(id: "s059-2", who: "Kierownik", de: "Wann kannst du zurückrufen?", pl: "Kiedy możesz oddzwonić?"),
            SayLine(id: "s059-3", who: "Ty", de: "In zwanzig Minuten, in der Pause.", pl: "Za dwadzieścia minut, na przerwie.")
            ],
            words: [
            Gloss(de: "die Säge", pl: "piła"),
            Gloss(de: "die Pause", pl: "przerwa")
            ],
            phrases: ["Jetzt nicht.", "zurückrufen"],
            note: "Zurückrufen to oddzwonić. Podajesz kiedy, nie tylko später.",
            question: "Kiedy oddzwaniasz?",
            options: ["Za dwadzieścia minut", "Za tydzień", "Wcale"],
            answer: 0,
            replyPL: "Oddzwonię na przerwie.",
            replyDE: "Ich rufe in der Pause zurück."
        ),
        MiniScene(
            id: "s060",
            title: "Przesunąć spotkanie",
            category: "Umawianie spotkań",
            level: "A2",
            situation: "Nie zdążysz do biura na czternastą.",
            lines: [
            SayLine(id: "s060-0", who: "Ty", de: "Können wir den Termin auf fünfzehn Uhr schieben?", pl: "Czy możemy przesunąć spotkanie na piętnastą?"),
            SayLine(id: "s060-1", who: "Biuro", de: "Heute oder morgen?", pl: "Dziś czy jutro?"),
            SayLine(id: "s060-2", who: "Ty", de: "Heute. Um vierzehn stehe ich noch auf der Baustelle.", pl: "Dziś. O czternastej jeszcze będę na budowie."),
            SayLine(id: "s060-3", who: "Biuro", de: "Fünfzehn Uhr geht. Ich trage es um.", pl: "Piętnasta pasuje. Przepisuję.")
            ],
            words: [
            Gloss(de: "der Termin", pl: "spotkanie"),
            Gloss(de: "schieben", pl: "przesunąć")
            ],
            phrases: ["den Termin schieben", "fünfzehn Uhr geht"],
            note: "Schieben przy terminie znaczy przesunąć. Nie pchać fizycznie.",
            question: "Na którą godzinę przesuwacie?",
            options: ["Na piętnastą dziś", "Na przyszły miesiąc", "Odwołujecie"],
            answer: 0,
            replyPL: "Czy możemy przesunąć spotkanie?",
            replyDE: "Können wir den Termin schieben?"
        ),
        MiniScene(
            id: "s061",
            title: "Odwołanie",
            category: "Umawianie spotkań",
            level: "B1",
            situation: "Jesteś chory i nie przyjdziesz na rozmowę o kontrakcie.",
            lines: [
            SayLine(id: "s061-0", who: "Ty", de: "Ich muss den Termin absagen. Ich bin krank.", pl: "Muszę odwołać spotkanie. Jestem chory."),
            SayLine(id: "s061-1", who: "Biuro", de: "Brauchen Sie ein Attest?", pl: "Potrzebuje pan zaświadczenia?"),
            SayLine(id: "s061-2", who: "Ty", de: "Für die Arbeit ja. Für Sie reicht die Absage.", pl: "Do pracy tak. Dla was wystarczy odwołanie."),
            SayLine(id: "s061-3", who: "Biuro", de: "Wir machen einen neuen Termin, wenn Sie gesund sind.", pl: "Zrobimy nowy termin, jak pan wyzdrowieje.")
            ],
            words: [
            Gloss(de: "absagen", pl: "odwołać"),
            Gloss(de: "das Attest", pl: "zaświadczenie")
            ],
            phrases: ["den Termin absagen", "wenn Sie gesund sind"],
            note: "Absagen to odwołać. Verschieben to przesunąć na inną godzinę.",
            question: "Czemu odwołujesz?",
            options: ["Jesteś chory", "Nie chce ci się", "Pomyliłeś adres"],
            answer: 0,
            replyPL: "Muszę odwołać spotkanie.",
            replyDE: "Ich muss den Termin absagen."
        ),
        MiniScene(
            id: "s062",
            title: "Kino",
            category: "Wolny czas",
            level: "A1",
            situation: "Chcesz iść na film po zmianie, ale jesteś zmęczony.",
            lines: [
            SayLine(id: "s062-0", who: "Kolega", de: "Kommst du mit ins Kino?", pl: "Idziesz ze mną do kina?"),
            SayLine(id: "s062-1", who: "Ty", de: "Welcher Film und wie spät?", pl: "Jaki film i o której?"),
            SayLine(id: "s062-2", who: "Kolega", de: "Um acht. Der neue, auf Deutsch.", pl: "O ósmej. Ten nowy, po niemiecku."),
            SayLine(id: "s062-3", who: "Ty", de: "Heute nicht. Ich bin kaputt. Samstag ja.", pl: "Dziś nie. Jestem padnięty. W sobotę tak.")
            ],
            words: [
            Gloss(de: "das Kino", pl: "kino"),
            Gloss(de: "kaputt", pl: "padnięty")
            ],
            phrases: ["Kommst du mit?", "Samstag ja."],
            note: "Kaputt o człowieku znaczy wykończony, nie zepsuty jak maszyna.",
            question: "Kiedy idziesz do kina?",
            options: ["W sobotę", "Dziś o ósmej", "Wcale"],
            answer: 0,
            replyPL: "Dziś jestem zbyt zmęczony.",
            replyDE: "Heute bin ich zu kaputt."
        ),
        MiniScene(
            id: "s063",
            title: "Grill na podwórku",
            category: "Wolny czas",
            level: "A2",
            situation: "Sąsiad zaprasza na grilla, a w niedzielę jest cisza.",
            lines: [
            SayLine(id: "s063-0", who: "Sąsiad", de: "Wir grillen um fünf. Kommst du?", pl: "Grillujemy o piątej. Przyjdziesz?"),
            SayLine(id: "s063-1", who: "Ty", de: "Gern. Soll ich etwas mitbringen?", pl: "Chętnie. Mam coś przynieść?"),
            SayLine(id: "s063-2", who: "Sąsiad", de: "Brot und Getränke. Fleisch haben wir.", pl: "Chleb i picie. Mięso mamy."),
            SayLine(id: "s063-3", who: "Ty", de: "Um acht hören wir auf, wegen der Ruhezeit.", pl: "O ósmej kończymy, przez ciszę nocną.")
            ],
            words: [
            Gloss(de: "grillen", pl: "grillować"),
            Gloss(de: "die Ruhezeit", pl: "cisza nocna")
            ],
            phrases: ["Soll ich etwas mitbringen?", "wegen der Ruhezeit"],
            note: "Ruhezeit to godziny ciszy. Grill po nich denerwuje blok.",
            question: "Co przynosisz?",
            options: ["Chleb i picie", "Sałatkę", "Węgiel do grilla"],
            answer: 0,
            replyPL: "Mam coś przynieść?",
            replyDE: "Soll ich etwas mitbringen?"
        ),
        MiniScene(
            id: "s064",
            title: "Siłownia",
            category: "Sport",
            level: "A1",
            situation: "Chcesz karnet, ale pracujesz na zmiany.",
            lines: [
            SayLine(id: "s064-0", who: "Recepcja", de: "Möchten Sie eine Mitgliedschaft?", pl: "Chce pan karnet?"),
            SayLine(id: "s064-1", who: "Ty", de: "Ja, aber ich arbeite Schicht.", pl: "Tak, ale pracuję na zmiany."),
            SayLine(id: "s064-2", who: "Recepcja", de: "Der Zutritt gilt dann den ganzen Tag.", pl: "Wtedy wejście jest cały dzień."),
            SayLine(id: "s064-3", who: "Ty", de: "Gut. Ich komme oft morgens.", pl: "Dobrze. Często będę rano.")
            ],
            words: [
            Gloss(de: "die Mitgliedschaft", pl: "karnet"),
            Gloss(de: "die Schicht", pl: "zmiana")
            ],
            phrases: ["Ich arbeite Schicht.", "den ganzen Tag"],
            note: "Schicht sagen, zanim kupisz karnet tylko na wieczór.",
            question: "Kiedy chodzisz na siłownię?",
            options: ["Często rano", "Tylko w niedzielę w nocy", "Nigdy"],
            answer: 0,
            replyPL: "Pracuję na zmiany.",
            replyDE: "Ich arbeite Schicht."
        ),
        MiniScene(
            id: "s065",
            title: "Kontuzja kolana",
            category: "Sport",
            level: "A2",
            situation: "Na boisku coś strzeliło w kolanie.",
            lines: [
            SayLine(id: "s065-0", who: "Ty", de: "Mein Knie ist weggeknickt.", pl: "Kolano mi się złożyło."),
            SayLine(id: "s065-1", who: "Kolega", de: "Kannst du auftreten?", pl: "Możesz stanąć?"),
            SayLine(id: "s065-2", who: "Ty", de: "Kaum. Ich höre auf.", pl: "Prawie nie. Kończę."),
            SayLine(id: "s065-3", who: "Kolega", de: "Setz dich. Ich hole Eis.", pl: "Siadaj. Przyniosę lód.")
            ],
            words: [
            Gloss(de: "das Knie", pl: "kolano"),
            Gloss(de: "das Eis", pl: "lód")
            ],
            phrases: ["weggeknickt", "auftreten"],
            note: "Auftreten to stanąć na nodze. Nie myl z auftreten na scenie.",
            question: "Co robisz?",
            options: ["Siadasz i kończysz grę", "Grasz dalej", "Idziesz od razu biegać"],
            answer: 0,
            replyPL: "Kolano mi się złożyło.",
            replyDE: "Mein Knie ist weggeknickt."
        ),
        MiniScene(
            id: "s066",
            title: "Deszcz i dach",
            category: "Pogoda",
            level: "A2",
            situation: "Zaczyna padać, a wy jesteście na dachu.",
            lines: [
            SayLine(id: "s066-0", who: "Szef", de: "Runter vom Dach. Es wird rutschig.", pl: "Z dachu na dół. Robi się ślisko."),
            SayLine(id: "s066-1", who: "Ty", de: "Sollen wir die Plane noch ziehen?", pl: "Mamy jeszcze naciągnąć plandekę?"),
            SayLine(id: "s066-2", who: "Szef", de: "Ja, über den Zement. Dann Pause.", pl: "Tak, na cement. Potem przerwa."),
            SayLine(id: "s066-3", who: "Ty", de: "Ich sichere mich und komme runter.", pl: "Przypnę się i schodzę.")
            ],
            words: [
            Gloss(de: "das Dach", pl: "dach"),
            Gloss(de: "die Plane", pl: "plandeka"),
            Gloss(de: "der Zement", pl: "cement")
            ],
            phrases: ["Runter vom Dach.", "über den Zement"],
            note: "Najpierw zejście, potem materiał. Śliski dach nie czeka.",
            question: "Co robicie z cementem?",
            options: ["Przykrywacie plandeką", "Zostawiacie na deszczu", "Wsypujecie do wykopu"],
            answer: 0,
            replyPL: "Schodzę z dachu.",
            replyDE: "Ich komme vom Dach runter."
        ),
        MiniScene(
            id: "s067",
            title: "Mróz rano",
            category: "Pogoda",
            level: "A2",
            situation: "Narzędzia zostały na dworzu, a w nocy był mróz.",
            lines: [
            SayLine(id: "s067-0", who: "Ty", de: "Die Maschinen standen draußen.", pl: "Maszyny stały na dworzu."),
            SayLine(id: "s067-1", who: "Szef", de: "Laufen sie an?", pl: "Odpalają?"),
            SayLine(id: "s067-2", who: "Ty", de: "Der Kompressor nicht. Das Wasser ist gefroren.", pl: "Kompresor nie. Woda zamarzła."),
            SayLine(id: "s067-3", who: "Szef", de: "Nicht mit Gewalt. Erst auftauen.", pl: "Nie na siłę. Najpierw odtajać.")
            ],
            words: [
            Gloss(de: "der Kompressor", pl: "kompresor"),
            Gloss(de: "gefroren", pl: "zamarznięte")
            ],
            phrases: ["Das Wasser ist gefroren.", "erst auftauen"],
            note: "Auftauen to odtajać. Gewalt przy maszynie kończy się naprawą.",
            question: "Czemu kompresor nie rusza?",
            options: ["Zamarzła woda", "Nie ma paliwa na rok", "Szef go sprzedał"],
            answer: 0,
            replyPL: "Woda zamarzła.",
            replyDE: "Das Wasser ist gefroren."
        ),
        MiniScene(
            id: "s068",
            title: "Zła dostawa śrub",
            category: "Problemy i reklamacje",
            level: "A2",
            situation: "Przyszły ósemki, a zamówione były dziesiątki.",
            lines: [
            SayLine(id: "s068-0", who: "Ty", de: "Das sind die falschen Schrauben.", pl: "To złe śruby."),
            SayLine(id: "s068-1", who: "Dostawca", de: "Was haben Sie bestellt?", pl: "Co pan zamówił?"),
            SayLine(id: "s068-2", who: "Ty", de: "Zehn M10, nicht M8.", pl: "Dziesięć M10, nie M8."),
            SayLine(id: "s068-3", who: "Dostawca", de: "Ich tausche sie heute noch.", pl: "Wymienię je jeszcze dziś.")
            ],
            words: [
            Gloss(de: "die Schraube", pl: "śruba"),
            Gloss(de: "die Lieferung", pl: "dostawa")
            ],
            phrases: ["die falschen Schrauben", "heute noch tauschen"],
            note: "Mówisz numer, nie tylko falsche Schrauben. Inaczej przywiozą znowu to samo.",
            question: "Jakie śruby miały być?",
            options: ["M10", "M8", "Jakiekolwiek"],
            answer: 0,
            replyPL: "To złe śruby.",
            replyDE: "Das sind die falschen Schrauben."
        ),
        MiniScene(
            id: "s069",
            title: "Spóźniona wypłata",
            category: "Problemy i reklamacje",
            level: "B1",
            situation: "Jest ósmy, a wypłata miała być piątego.",
            lines: [
            SayLine(id: "s069-0", who: "Ty", de: "Der Lohn ist immer noch nicht da.", pl: "Wypłaty nadal nie ma."),
            SayLine(id: "s069-1", who: "Księgowość", de: "Welches Konto haben Sie angegeben?", pl: "Jakie konto pan podał?"),
            SayLine(id: "s069-2", who: "Ty", de: "Das neue, seit März. Die IBAN steht im Vertrag.", pl: "Nowe, od marca. IBAN jest w umowie."),
            SayLine(id: "s069-3", who: "Księgowość", de: "Ich prüfe das heute. Sie bekommen eine Mail.", pl: "Sprawdzę to dziś. Dostanie pan maila.")
            ],
            words: [
            Gloss(de: "der Lohn", pl: "wypłata"),
            Gloss(de: "das Konto", pl: "konto")
            ],
            phrases: ["Der Lohn ist nicht da.", "die IBAN im Vertrag"],
            note: "Mówisz, które konto jest aktualne. Stare konto to częsty powód.",
            question: "Co zrobi księgowość?",
            options: ["Sprawdzi dziś i napisze maila", "Każe ci czekać do grudnia", "Wypłaci gotówką na budowie od razu"],
            answer: 0,
            replyPL: "Wypłaty nadal nie ma.",
            replyDE: "Der Lohn ist immer noch nicht da."
        ),
        MiniScene(
            id: "s070",
            title: "Skaleczony palec",
            category: "Awaryjne sytuacje",
            level: "A1",
            situation: "Blacha przecięła ci palec i krew nie staje.",
            lines: [
            SayLine(id: "s070-0", who: "Ty", de: "Ich habe mich geschnitten. Ich brauche den Verbandskasten.", pl: "Skaleczyłem się. Potrzebuję apteczki."),
            SayLine(id: "s070-1", who: "Kolega", de: "Der hängt neben der Tür.", pl: "Wisi obok drzwi."),
            SayLine(id: "s070-2", who: "Ty", de: "Es hört nicht auf zu bluten.", pl: "Krew nie przestaje lecieć."),
            SayLine(id: "s070-3", who: "Kolega", de: "Ich hole den Chef. Du setzt dich.", pl: "Wołam szefa. Ty siadasz.")
            ],
            words: [
            Gloss(de: "der Verbandskasten", pl: "apteczka"),
            Gloss(de: "sich schneiden", pl: "skaleczyć się")
            ],
            phrases: ["Ich habe mich geschnitten.", "neben der Tür"],
            note: "Mówisz, że krew nie staje. Samo skaleczyłem się może poczekać, to nie.",
            question: "Gdzie jest apteczka?",
            options: ["Obok drzwi", "W kontenerze z narzędziami", "W aucie na placu"],
            answer: 0,
            replyPL: "Skaleczyłem się.",
            replyDE: "Ich habe mich geschnitten."
        ),
        MiniScene(
            id: "s071",
            title: "Zamknięty kontener",
            category: "Awaryjne sytuacje",
            level: "B1",
            situation: "Klucz od kontenera został w środku.",
            lines: [
            SayLine(id: "s071-0", who: "Ty", de: "Der Schlüssel ist im Container. Die Tür ist zu.", pl: "Klucz jest w kontenerze. Drzwi są zamknięte."),
            SayLine(id: "s071-1", who: "Szef", de: "Ist jemand drin?", pl: "Czy ktoś jest w środku?"),
            SayLine(id: "s071-2", who: "Ty", de: "Nein. Nur das Werkzeug.", pl: "Nie. Tylko narzędzia."),
            SayLine(id: "s071-3", who: "Szef", de: "Tim hat den Ersatzschlüssel im Büro.", pl: "Tim ma zapasowy klucz w biurze.")
            ],
            words: [
            Gloss(de: "der Schlüssel", pl: "klucz"),
            Gloss(de: "der Ersatzschlüssel", pl: "klucz zapasowy")
            ],
            phrases: ["Die Tür ist zu.", "den Ersatzschlüssel"],
            note: "Mówisz, że nikt nie został w środku. To pierwsza rzecz, o którą pytają.",
            question: "Gdzie jest zapasowy klucz?",
            options: ["U Tima w biurze", "U szefa w szafce", "U kolegi przy rampie"],
            answer: 0,
            replyPL: "Klucz został w środku.",
            replyDE: "Der Schlüssel ist drinnen."
        ),
        MiniScene(
            id: "s072",
            title: "Spóźniony lot",
            category: "Podróże",
            level: "A2",
            situation: "Lot do Polski ma dwie godziny opóźnienia.",
            lines: [
            SayLine(id: "s072-0", who: "Ty", de: "Hat der Flug Verspätung?", pl: "Czy lot ma opóźnienie?"),
            SayLine(id: "s072-1", who: "Obsługa", de: "Zwei Stunden. Gate B vier.", pl: "Dwie godziny. Brama B cztery."),
            SayLine(id: "s072-2", who: "Ty", de: "Bleibt das Gate?", pl: "Brama zostaje?"),
            SayLine(id: "s072-3", who: "Obsługa", de: "Ja. Schauen Sie auf die Tafel.", pl: "Tak. Patrz pan na tablicę.")
            ],
            words: [
            Gloss(de: "der Flug", pl: "lot"),
            Gloss(de: "das Gate", pl: "brama")
            ],
            phrases: ["zwei Stunden Verspätung", "auf die Tafel schauen"],
            note: "Gate może się zmienić. Tafel sprawdzasz jeszcze raz przed wejściem.",
            question: "Ile ma opóźnienia lot?",
            options: ["Dwie godziny", "Dziesięć minut", "Jest odwołany"],
            answer: 0,
            replyPL: "Czy lot ma opóźnienie?",
            replyDE: "Hat der Flug Verspätung?"
        ),
        MiniScene(
            id: "s073",
            title: "Hotel po nocnej jeździe",
            category: "Podróże",
            level: "A2",
            situation: "Przyjeżdżasz późno i recepcja ma twoje nazwisko źle.",
            lines: [
            SayLine(id: "s073-0", who: "Ty", de: "Ich habe ein Zimmer auf den Namen Kacper.", pl: "Mam pokój na nazwisko Kacper."),
            SayLine(id: "s073-1", who: "Recepcja", de: "Ich sehe Sie nicht. Wann haben Sie gebucht?", pl: "Nie widzę pana. Kiedy pan rezerwował?"),
            SayLine(id: "s073-2", who: "Ty", de: "Heute Morgen, über die Firma.", pl: "Dziś rano, przez firmę."),
            SayLine(id: "s073-3", who: "Recepcja", de: "Hier, unter dem Firmennamen. Zimmer 214.", pl: "Tu, pod nazwą firmy. Pokój 214.")
            ],
            words: [
            Gloss(de: "das Zimmer", pl: "pokój"),
            Gloss(de: "die Firma", pl: "firma")
            ],
            phrases: ["auf den Namen", "unter dem Firmennamen"],
            note: "Jak rezerwuje firma, szukaj nazwy firmy, nie tylko swojego imienia.",
            question: "Gdzie jest rezerwacja?",
            options: ["Pod nazwą firmy, pokój 214", "Nie ma jej wcale", "W innym hotelu"],
            answer: 0,
            replyPL: "Mam pokój na nazwisko Kacper.",
            replyDE: "Ich habe ein Zimmer auf den Namen Kacper."
        ),
        MiniScene(
            id: "s074",
            title: "Niedziela i sklep",
            category: "Niemieckie życie codzienne",
            level: "A1",
            situation: "Chcesz kupić śrubę, a jest niedziela.",
            lines: [
            SayLine(id: "s074-0", who: "Ty", de: "Ist der Baumarkt heute auf?", pl: "Czy market budowlany jest dziś otwarty?"),
            SayLine(id: "s074-1", who: "Sąsiad", de: "Sonntag ist zu. Nur die Tankstelle.", pl: "W niedzielę zamknięte. Tylko stacja."),
            SayLine(id: "s074-2", who: "Ty", de: "Haben die Schrauben?", pl: "Mają śruby?"),
            SayLine(id: "s074-3", who: "Sąsiad", de: "Nur kleine. Die großen erst Montag.", pl: "Tylko małe. Duże dopiero w poniedziałek.")
            ],
            words: [
            Gloss(de: "der Baumarkt", pl: "market budowlany"),
            Gloss(de: "die Tankstelle", pl: "stacja benzynowa")
            ],
            phrases: ["Sonntag ist zu.", "erst Montag"],
            note: "W niedzielę większość sklepów stoi. Tankstelle bywa wyjątkiem.",
            question: "Gdzie kupisz coś dziś?",
            options: ["Na stacji, ale tylko małe śruby", "W markecie, który jest zamknięty", "W osiedlowym, też zamkniętym"],
            answer: 0,
            replyPL: "Czy market jest dziś otwarty?",
            replyDE: "Ist der Baumarkt heute auf?"
        ),
        MiniScene(
            id: "s075",
            title: "Butelki i kaucja",
            category: "Niemieckie życie codzienne",
            level: "A2",
            situation: "Wchodzisz do spożywczego z siatką pustych butelek.",
            lines: [
            SayLine(id: "s075-0", who: "Ty", de: "Wo ist der Pfandautomat?", pl: "Gdzie jest automat na kaucję?"),
            SayLine(id: "s075-1", who: "Kasjer", de: "Hinten links, neben dem Brot.", pl: "Z tyłu po lewej, obok chleba."),
            SayLine(id: "s075-2", who: "Ty", de: "Nimmt der auch Dosen?", pl: "Bierze też puszki?"),
            SayLine(id: "s075-3", who: "Kasjer", de: "Ja. Den Bon lösen Sie bei mir ein.", pl: "Tak. Bon realizuje pan u mnie.")
            ],
            words: [
            Gloss(de: "der Pfandautomat", pl: "automat kaucyjny"),
            Gloss(de: "die Dose", pl: "puszka"),
            Gloss(de: "der Bon", pl: "bon")
            ],
            phrases: ["Wo ist der Pfandautomat?", "den Bon einlösen"],
            note: "Bon z automatu nie jest pieniądzem, dopóki nie dasz go przy kasie.",
            question: "Gdzie jest automat?",
            options: ["Z tyłu po lewej", "Przy kasach", "Przy pieczywie"],
            answer: 0,
            replyPL: "Gdzie jest automat na kaucję?",
            replyDE: "Wo ist der Pfandautomat?"
        ),
        MiniScene(
            id: "s076",
            title: "Cisza po dwudziestej drugiej",
            category: "Niemieckie życie codzienne",
            level: "B1",
            situation: "Wiertarka po dziesiątej to proszenie się o sąsiada.",
            lines: [
            SayLine(id: "s076-0", who: "Sąsiad", de: "Es ist nach zehn. Die Bohrmaschine ist zu laut.", pl: "Jest po dziesiątej. Wiertarka jest za głośna."),
            SayLine(id: "s076-1", who: "Ty", de: "Ich höre auf. Eine Dübel fehlt noch.", pl: "Kończę. Został jeszcze jeden kołek."),
            SayLine(id: "s076-2", who: "Sąsiad", de: "Morgen früh, nicht jetzt.", pl: "Jutro rano, nie teraz."),
            SayLine(id: "s076-3", who: "Ty", de: "In Ordnung. Ich mache morgen um acht weiter.", pl: "W porządku. Jutro o ósmej dokończę.")
            ],
            words: [
            Gloss(de: "die Bohrmaschine", pl: "wiertarka"),
            Gloss(de: "der Dübel", pl: "kołek")
            ],
            phrases: ["nach zehn", "morgen um acht"],
            note: "Po 22. hałas w bloku jest złym pomysłem, nawet jeden kołek.",
            question: "Kiedy dokończysz wiercenie?",
            options: ["Jutro o ósmej", "Za pięć minut w nocy", "W niedzielę o północy"],
            answer: 0,
            replyPL: "Kończę na dziś.",
            replyDE: "Ich höre für heute auf."
        ),
        MiniScene(
            id: "s077",
            title: "Ciasto na wynos",
            category: "W kawiarni",
            level: "B1",
            situation: "Chcesz kawałek ciasta dla ekipy, pokrojony osobno.",
            lines: [
            SayLine(id: "s077-0", who: "Ty", de: "Ich hätte gern vier Stück Käsekuchen, einzeln verpackt.", pl: "Poproszę cztery kawałki sernika, osobno pakowane."),
            SayLine(id: "s077-1", who: "Barista", de: "Zum Mitnehmen, verstehe. Gabeln dazu?", pl: "Na wynos, rozumiem. Widłczyki do tego?"),
            SayLine(id: "s077-2", who: "Ty", de: "Ja, und Servietten.", pl: "Tak, i serwetki."),
            SayLine(id: "s077-3", who: "Barista", de: "Macht zwölf Euro.", pl: "Będzie dwanaście euro.")
            ],
            words: [
            Gloss(de: "der Käsekuchen", pl: "sernik"),
            Gloss(de: "die Serviette", pl: "serwetka")
            ],
            phrases: ["einzeln verpackt", "zum Mitnehmen"],
            note: "Einzeln verpackt mówisz, gdy każdy kawałek ma być osobno.",
            question: "Ile płacisz?",
            options: ["Dwanaście euro", "Cztery euro", "Nic, to na koszt firmy bez pytania"],
            answer: 0,
            replyPL: "Poproszę cztery kawałki, osobno.",
            replyDE: "Vier Stück, einzeln, bitte."
        ),
        MiniScene(
            id: "s078",
            title: "Reklamacja wiertarki",
            category: "W sklepie i supermarkecie",
            level: "B1",
            situation: "Wiertarka z marketu stanęła drugiego dnia.",
            lines: [
            SayLine(id: "s078-0", who: "Ty", de: "Die Bohrmaschine läuft nicht mehr. Ich habe den Bon.", pl: "Wiertarka już nie działa. Mam paragon."),
            SayLine(id: "s078-1", who: "Obsługa", de: "Gekauft am Montag. Möchten Sie Umtausch oder Geld?", pl: "Kupiona w poniedziałek. Wymiana czy pieniądze?"),
            SayLine(id: "s078-2", who: "Ty", de: "Geld. Dieselbe hole ich woanders.", pl: "Pieniądze. Taką samą wezmę gdzie indziej."),
            SayLine(id: "s078-3", who: "Obsługa", de: "Ich brauche die Karte, mit der Sie gezahlt haben.", pl: "Potrzebuję karty, którą pan płacił.")
            ],
            words: [
            Gloss(de: "die Bohrmaschine", pl: "wiertarka"),
            Gloss(de: "der Umtausch", pl: "wymiana"),
            Gloss(de: "der Bon", pl: "paragon")
            ],
            phrases: ["Umtausch oder Geld", "die gleiche Karte"],
            note: "Przy zwrocie na kartę często chcą tej samej karty, nie gotówki.",
            question: "Co wybierasz?",
            options: ["Zwrot pieniędzy", "Od razu drugą taką samą", "Naprawę za miesiąc"],
            answer: 0,
            replyPL: "Chcę pieniądze z powrotem.",
            replyDE: "Ich möchte das Geld zurück."
        ),
        MiniScene(
            id: "s079",
            title: "Wynajem auta",
            category: "Podróże",
            level: "B1",
            situation: "Firma każe ci wziąć auto na wyjazd, a ty chcesz pełne ubezpieczenie.",
            lines: [
            SayLine(id: "s079-0", who: "Obsługa", de: "Welches Auto haben Sie reserviert?", pl: "Jakie auto pan zarezerwował?"),
            SayLine(id: "s079-1", who: "Ty", de: "Den Kombi. Mit Vollkasko, bitte.", pl: "Kombi. Z pełnym ubezpieczeniem, poproszę."),
            SayLine(id: "s079-2", who: "Obsługa", de: "Vollkasko ist zwanzig Euro extra am Tag.", pl: "Pełne ubezpieczenie to dwadzieścia euro ekstra dziennie."),
            SayLine(id: "s079-3", who: "Ty", de: "Trotzdem. Ich fahre auf die Baustelle.", pl: "Mimo to. Jadę na budowę.")
            ],
            words: [
            Gloss(de: "das Auto", pl: "auto"),
            Gloss(de: "die Vollkasko", pl: "pełne ubezpieczenie")
            ],
            phrases: ["mit Vollkasko", "trotzdem"],
            note: "Trotzdem znaczy mimo to. Mówisz, czemu dopłacasz.",
            question: "Jakie ubezpieczenie bierzesz?",
            options: ["Pełne", "Żadnego", "Tylko na szybę"],
            answer: 0,
            replyPL: "Poproszę pełne ubezpieczenie.",
            replyDE: "Mit Vollkasko, bitte."
        ),
        MiniScene(
            id: "s080",
            title: "Wypowiedzenie umowy",
            category: "W domu",
            level: "B2",
            situation: "Chcesz wyprowadzić się za trzy miesiące i musisz to napisać.",
            lines: [
            SayLine(id: "s080-0", who: "Ty", de: "Ich möchte den Mietvertrag zum 31. März kündigen.", pl: "Chcę wypowiedzieć umowę najmu na 31 marca."),
            SayLine(id: "s080-1", who: "Wynajmujący", de: "Die Frist ist drei Monate. Das passt.", pl: "Termin to trzy miesiące. Pasuje."),
            SayLine(id: "s080-2", who: "Ty", de: "Ich schicke die Kündigung schriftlich.", pl: "Wyślę wypowiedzenie na piśmie."),
            SayLine(id: "s080-3", who: "Wynajmujący", de: "Ja. Mündlich reicht nicht.", pl: "Tak. Ustnie nie wystarczy.")
            ],
            words: [
            Gloss(de: "die Kündigung", pl: "wypowiedzenie"),
            Gloss(de: "der Mietvertrag", pl: "umowa najmu"),
            Gloss(de: "die Frist", pl: "termin")
            ],
            phrases: ["schriftlich kündigen", "mündlich reicht nicht"],
            note: "Wypowiedzenie mieszkania ma być na piśmie. Rozmowa tego nie załatwia.",
            question: "Jak wypowiadasz umowę?",
            options: ["Na piśmie", "Tylko przez telefon", "Zostawiasz klucz bez słowa"],
            answer: 0,
            replyPL: "Chcę wypowiedzieć umowę na 31 marca.",
            replyDE: "Ich möchte den Vertrag zum 31. März kündigen."
        ),
        MiniScene(
            id: "s081",
            title: "Bezpieczeństwo przy wietrze",
            category: "Rozmowy z szefem",
            level: "B2",
            situation: "Nie chcesz wchodzić na rusztowanie, bo wiatr jest za mocny.",
            lines: [
            SayLine(id: "s081-0", who: "Ty", de: "Bei dem Wind gehe ich nicht aufs Gerüst.", pl: "Przy tym wietrze nie wchodzę na rusztowanie."),
            SayLine(id: "s081-1", who: "Szef", de: "Die anderen sind schon oben.", pl: "Inni już są na górze."),
            SayLine(id: "s081-2", who: "Ty", de: "Trotzdem. Das Gerüst bewegt sich.", pl: "Mimo to. Rusztowanie się rusza."),
            SayLine(id: "s081-3", who: "Szef", de: "Gut. Ihr bleibt unten, bis der Wind nachlässt.", pl: "Dobrze. Zostajecie na dole, aż wiatr osłabnie.")
            ],
            words: [
            Gloss(de: "das Gerüst", pl: "rusztowanie"),
            Gloss(de: "der Wind", pl: "wiatr")
            ],
            phrases: ["nicht aufs Gerüst", "bis der Wind nachlässt"],
            note: "Mówisz, co widzisz: rusztowanie się rusza. To jest powód, nie humor.",
            question: "Co ustalacie?",
            options: ["Zostajecie na dole", "Wchodzisz sam na górę", "Rozbieracie rusztowanie dziś"],
            answer: 0,
            replyPL: "Przy tym wietrze nie wchodzę na górę.",
            replyDE: "Bei dem Wind gehe ich nicht hoch."
        ),
        MiniScene(
            id: "s082",
            title: "Zgaszona żarówka",
            category: "W domu",
            level: "A1",
            situation: "Na klatce jest ciemno i nie widzisz zamka.",
            lines: [
            SayLine(id: "s082-0", who: "Ty", de: "Die Lampe im Flur ist aus.", pl: "Lampa na korytarzu nie świeci."),
            SayLine(id: "s082-1", who: "Sąsiad", de: "Die Sicherung ist unten im Keller.", pl: "Bezpiecznik jest na dole, w piwnicy."),
            SayLine(id: "s082-2", who: "Ty", de: "Welche Tür ist das?", pl: "Które to drzwi?"),
            SayLine(id: "s082-3", who: "Sąsiad", de: "Die graue, gleich links von der Treppe.", pl: "Szare, zaraz na lewo od schodów."),
            SayLine(id: "s082-4", who: "Ty", de: "Danke. Ich schau mal kurz.", pl: "Dzięki. Zerknę na chwilę.")
            ],
            words: [
            Gloss(de: "die Lampe", pl: "lampa"),
            Gloss(de: "die Sicherung", pl: "bezpiecznik"),
            Gloss(de: "der Keller", pl: "piwnica")
            ],
            phrases: ["Die Lampe im Flur ist aus.", "Ich schau mal kurz."],
            note: "Schauen mal jest potoczne: zerknę, sprawdzę. Nie musisz mówić ich werde prüfen.",
            question: "Co nie działa?",
            options: ["Lampa na korytarzu", "Zamek w drzwiach", "Dzwonek do mieszkania"],
            answer: 0,
            replyPL: "Lampa na korytarzu nie świeci.",
            replyDE: "Die Lampe im Flur ist aus."
        ),
        MiniScene(
            id: "s083",
            title: "Zmywarka stoi",
            category: "W domu",
            level: "A2",
            situation: "Zmywarka jest pełna, a ty wychodzisz na szóstą.",
            lines: [
            SayLine(id: "s083-0", who: "Ty", de: "Läuft die Spülmaschine noch?", pl: "Zmywarka jeszcze chodzi?"),
            SayLine(id: "s083-1", who: "Partner", de: "Die ist fertig. Du kannst ausräumen.", pl: "Skończyła. Możesz ją opróżnić."),
            SayLine(id: "s083-2", who: "Ty", de: "Ich muss um sechs raus. Machst du das?", pl: "Muszę wyjść o szóstej. Zrobisz to?"),
            SayLine(id: "s083-3", who: "Partner", de: "Ja, aber stell deine Dose nicht wieder oben drauf.", pl: "Tak, ale nie stawiaj znowu pudełka na górze."),
            SayLine(id: "s083-4", who: "Ty", de: "Alles klar. Die kommt in den Schrank.", pl: "Jasne. Pudełko idzie do szafki.")
            ],
            words: [
            Gloss(de: "die Spülmaschine", pl: "zmywarka"),
            Gloss(de: "die Dose", pl: "pudełko"),
            Gloss(de: "der Schrank", pl: "szafka")
            ],
            phrases: ["Du kannst ausräumen.", "Alles klar."],
            note: "Ausräumen to wyciągnąć rzeczy ze środka. Ausmachen byłoby wyłączyć.",
            question: "Kto opróżni zmywarkę?",
            options: ["Osoba, która zostaje", "Nikt, ma chodzić do rana", "Ty, zanim wyjdziesz o szóstej"],
            answer: 0,
            replyPL: "Możesz opróżnić zmywarkę?",
            replyDE: "Kannst du die Spülmaschine ausräumen?"
        ),
        MiniScene(
            id: "s084",
            title: "Wilgoć w łazience",
            category: "W domu",
            level: "B1",
            situation: "Po prysznicu ściana nie schnie, mimo że wietrzysz.",
            lines: [
            SayLine(id: "s084-0", who: "Ty", de: "Im Bad bleibt die Wand feucht, auch wenn ich lüfte.", pl: "W łazience ściana zostaje wilgotna, nawet jak wietrzę."),
            SayLine(id: "s084-1", who: "Wynajmujący", de: "Wie lange lassen Sie das Fenster auf?", pl: "Jak długo ma pan otwarte okno?"),
            SayLine(id: "s084-2", who: "Ty", de: "Morgens zehn Minuten. Mehr geht nicht, es ist kalt.", pl: "Rano dziesięć minut. Dłużej się nie da, jest zimno."),
            SayLine(id: "s084-3", who: "Wynajmujący", de: "Dann kommt am Freitag jemand und prüft den Lüfter.", pl: "W piątek ktoś przyjdzie i sprawdzi wentylator."),
            SayLine(id: "s084-4", who: "Ty", de: "Passt. Ich bin ab sechzehn Uhr da.", pl: "Pasuje. Od szesnastej będę.")
            ],
            words: [
            Gloss(de: "feucht", pl: "wilgotny"),
            Gloss(de: "der Lüfter", pl: "wentylator"),
            Gloss(de: "lüften", pl: "wietrzyć")
            ],
            phrases: ["Die Wand bleibt feucht.", "Ich bin ab sechzehn Uhr da."],
            note: "Auch wenn znaczy nawet jeśli. Czasownik lüfte zostaje na końcu tej części.",
            question: "Co sprawdzi fachowiec?",
            options: ["Wentylator", "Pralkę", "Zamek w drzwiach"],
            answer: 0,
            replyPL: "Ściana zostaje wilgotna.",
            replyDE: "Die Wand bleibt feucht."
        ),
        MiniScene(
            id: "s085",
            title: "Gdzie jest mleko",
            category: "W sklepie i supermarkecie",
            level: "A1",
            situation: "Stoisz przy pieczywie i nie widzisz chłodziarki.",
            lines: [
            SayLine(id: "s085-0", who: "Ty", de: "Entschuldigung, wo steht die Milch?", pl: "Przepraszam, gdzie stoi mleko?"),
            SayLine(id: "s085-1", who: "Pracownik", de: "Ganz hinten, im Kühlregal links.", pl: "Całkiem z tyłu, w chłodziarce po lewej."),
            SayLine(id: "s085-2", who: "Ty", de: "Auch die ohne Laktose?", pl: "Też to bez laktozy?"),
            SayLine(id: "s085-3", who: "Pracownik", de: "Ja, im selben Regal, zweite Reihe.", pl: "Tak, na tej samej półce, drugi rząd."),
            SayLine(id: "s085-4", who: "Ty", de: "Danke, das finde ich.", pl: "Dzięki, znajdę.")
            ],
            words: [
            Gloss(de: "die Milch", pl: "mleko"),
            Gloss(de: "das Kühlregal", pl: "chłodziarka"),
            Gloss(de: "ohne Laktose", pl: "bez laktozy")
            ],
            phrases: ["Wo steht die Milch?", "im selben Regal"],
            note: "Wo steht pyta o miejsce rzeczy, która stoi. Wo ist też jest dobre, ale przy półce Niemcy często mówią steht.",
            question: "Czego szukasz?",
            options: ["Mleka", "Chleba", "Proszku do prania"],
            answer: 0,
            replyPL: "Gdzie stoi mleko?",
            replyDE: "Wo steht die Milch?"
        ),
        MiniScene(
            id: "s086",
            title: "Brak reszty",
            category: "W sklepie i supermarkecie",
            level: "A2",
            situation: "Płacisz gotówką, a kasa nie ma drobnych.",
            lines: [
            SayLine(id: "s086-0", who: "Ty", de: "Ich zahle mit fünfzig.", pl: "Płacę pięćdziesiątką."),
            SayLine(id: "s086-1", who: "Kasjer", de: "Haben Sie es kleiner? Ich habe kaum Wechselgeld.", pl: "Ma pan drobniej? Prawie nie mam reszty."),
            SayLine(id: "s086-2", who: "Ty", de: "Leider nicht. Geht auch Karte?", pl: "Niestety nie. Karta też przejdzie?"),
            SayLine(id: "s086-3", who: "Kasjer", de: "Ja, Karte ist kein Problem.", pl: "Tak, karta nie jest problemem."),
            SayLine(id: "s086-4", who: "Ty", de: "Dann mit Karte, bitte.", pl: "To kartą, proszę.")
            ],
            words: [
            Gloss(de: "das Wechselgeld", pl: "reszta"),
            Gloss(de: "die Karte", pl: "karta"),
            Gloss(de: "bar", pl: "gotówką")
            ],
            phrases: ["Haben Sie es kleiner?", "Karte ist kein Problem."],
            note: "Kleiner haben znaczy mieć drobniejsze nominały, nie mniejszy portfel.",
            question: "Jak płacisz na końcu?",
            options: ["Kartą", "Pięćdziesiątką i bez reszty", "Bonem zakupowym"],
            answer: 0,
            replyPL: "Czy mogę zapłacić kartą?",
            replyDE: "Kann ich mit Karte zahlen?"
        ),
        MiniScene(
            id: "s087",
            title: "Precle dla ekipy",
            category: "W piekarni",
            level: "A2",
            situation: "Bierzesz śniadanie dla trzech osób z budowy.",
            lines: [
            SayLine(id: "s087-0", who: "Ty", de: "Ich hätte gern sechs Brezeln und drei Käsebrötchen.", pl: "Poproszę sześć precli i trzy bułki z serem."),
            SayLine(id: "s087-1", who: "Ekspedientka", de: "Die Brezeln sind noch warm. Sonst noch was?", pl: "Precle są jeszcze ciepłe. Coś jeszcze?"),
            SayLine(id: "s087-2", who: "Ty", de: "Zwei Kaffee zum Mitnehmen, einer davon schwarz.", pl: "Dwie kawy na wynos, jedna z nich czarna."),
            SayLine(id: "s087-3", who: "Ekspedientka", de: "Zusammen oder einzeln?", pl: "Razem czy osobno?"),
            SayLine(id: "s087-4", who: "Ty", de: "Zusammen. Ich hole das für die Kollegen.", pl: "Razem. Biorę to dla kolegów.")
            ],
            words: [
            Gloss(de: "die Brezel", pl: "precel"),
            Gloss(de: "das Käsebrötchen", pl: "bułka z serem"),
            Gloss(de: "zum Mitnehmen", pl: "na wynos")
            ],
            phrases: ["Ich hätte gern", "zum Mitnehmen", "Zusammen oder einzeln?"],
            note: "Ich hätte gern jest grzeczniejsze niż ich will. W piekarni tak właśnie zamawiasz.",
            question: "Ile precli bierzesz?",
            options: ["Sześć", "Trzy", "Dwa"],
            answer: 0,
            replyPL: "Poproszę sześć precli.",
            replyDE: "Ich hätte gern sechs Brezeln."
        ),
        MiniScene(
            id: "s088",
            title: "Stolik z rezerwacją",
            category: "W restauracji",
            level: "A2",
            situation: "Siadasz, a na stole jest karteczka z nazwiskiem.",
            lines: [
            SayLine(id: "s088-0", who: "Ty", de: "Ist dieser Tisch noch frei?", pl: "Ten stolik jest jeszcze wolny?"),
            SayLine(id: "s088-1", who: "Kelner", de: "Nein, der ist reserviert, auf den Namen Berger.", pl: "Nie, jest zarezerwowany, na nazwisko Berger."),
            SayLine(id: "s088-2", who: "Ty", de: "Ah, okay. Und der am Fenster?", pl: "A, dobrze. A ten przy oknie?"),
            SayLine(id: "s088-3", who: "Kelner", de: "Der ist frei. Ich bringe die Karte.", pl: "Ten jest wolny. Przyniosę kartę."),
            SayLine(id: "s088-4", who: "Ty", de: "Danke. Ich brauche nur eine Minute.", pl: "Dzięki. Potrzebuję tylko minuty.")
            ],
            words: [
            Gloss(de: "reserviert", pl: "zarezerwowany"),
            Gloss(de: "das Fenster", pl: "okno"),
            Gloss(de: "die Karte", pl: "karta dań")
            ],
            phrases: ["Der ist reserviert.", "Der ist frei."],
            note: "Der przy stoliku, bo der Tisch. Nie mów das Tisch.",
            question: "Czemu nie siadasz przy pierwszym stoliku?",
            options: ["Jest zarezerwowany", "Jest za daleko od kuchni", "Kelner każe czekać na szefa"],
            answer: 0,
            replyPL: "Czy ten stolik jest wolny?",
            replyDE: "Ist dieser Tisch frei?"
        ),
        MiniScene(
            id: "s089",
            title: "Za słona zupa",
            category: "W restauracji",
            level: "B1",
            situation: "Zupa jest tak słona, że nie da się jej jeść.",
            lines: [
            SayLine(id: "s089-0", who: "Ty", de: "Entschuldigung, die Suppe ist mir zu salzig.", pl: "Przepraszam, zupa jest dla mnie za słona."),
            SayLine(id: "s089-1", who: "Kelner", de: "Oh, das tut mir leid. Möchten Sie eine andere?", pl: "Przykro mi. Chce pan inną?"),
            SayLine(id: "s089-2", who: "Ty", de: "Ja, oder die Pasta ohne Extra-Salz.", pl: "Tak, albo makaron bez dodatkowej soli."),
            SayLine(id: "s089-3", who: "Kelner", de: "Ich sage das in der Küche. Die Suppe setzen wir ab.", pl: "Powiem w kuchni. Zupę odejmiemy."),
            SayLine(id: "s089-4", who: "Ty", de: "Danke. Ich habe nicht viel Zeit, ich muss zur Schicht.", pl: "Dzięki. Nie mam dużo czasu, muszę na zmianę.")
            ],
            words: [
            Gloss(de: "die Suppe", pl: "zupa"),
            Gloss(de: "salzig", pl: "słony"),
            Gloss(de: "absetzen", pl: "odjąć z rachunku")
            ],
            phrases: ["zu salzig", "Die Suppe setzen wir ab."],
            note: "Zu plus przymiotnik to za bardzo: zu salzig, zu laut, zu teuer. Absetzen na rachunku znaczy zdjąć pozycję.",
            question: "Co jest nie tak z zupą?",
            options: ["Jest za słona", "Jest zimna", "Nie ta, którą zamówiłeś"],
            answer: 0,
            replyPL: "Zupa jest za słona.",
            replyDE: "Die Suppe ist zu salzig."
        ),
        MiniScene(
            id: "s090",
            title: "Cichszy stolik",
            category: "W kawiarni",
            level: "A2",
            situation: "Chcesz napisać wiadomość do szefa, a przy barze jest głośno.",
            lines: [
            SayLine(id: "s090-0", who: "Ty", de: "Haben Sie noch einen ruhigeren Tisch?", pl: "Ma pani jeszcze cichszy stolik?"),
            SayLine(id: "s090-1", who: "Baristka", de: "Hinten an der Wand ist noch einer frei.", pl: "Z tyłu przy ścianie jest jeszcze jeden wolny."),
            SayLine(id: "s090-2", who: "Ty", de: "Gut. Einen Milchkaffee dazu, bitte.", pl: "Dobrze. Do tego kawę z mlekiem, proszę."),
            SayLine(id: "s090-3", who: "Baristka", de: "Zum Hiertrinken?", pl: "Na miejscu?"),
            SayLine(id: "s090-4", who: "Ty", de: "Ja. Ich bleibe ungefähr zwanzig Minuten.", pl: "Tak. Zostanę jakieś dwadzieścia minut.")
            ],
            words: [
            Gloss(de: "ruhig", pl: "cichy"),
            Gloss(de: "der Milchkaffee", pl: "kawa z mlekiem"),
            Gloss(de: "ungefähr", pl: "około")
            ],
            phrases: ["einen ruhigeren Tisch", "Zum Hiertrinken?"],
            note: "Ruhigeren to stopień wyższy: cichszy. Końcówka -en jest tu przez einen Tisch.",
            question: "Czego szukasz?",
            options: ["Cichszego stolika", "Głośniejszego miejsca przy barze", "Stolika na osiem osób"],
            answer: 0,
            replyPL: "Ma pani cichszy stolik?",
            replyDE: "Haben Sie einen ruhigeren Tisch?"
        ),
        MiniScene(
            id: "s091",
            title: "Gdzie jest ulica",
            category: "Na ulicy",
            level: "A2",
            situation: "Szukasz ulicy z ogłoszenia o pokoju i stoisz przy złym skrzyżowaniu.",
            lines: [
            SayLine(id: "s091-0", who: "Ty", de: "Entschuldigung, wie komme ich zur Gartenstraße?", pl: "Przepraszam, jak dojść do Gartenstraße?"),
            SayLine(id: "s091-1", who: "Przechodzień", de: "Die nächste links, dann immer geradeaus.", pl: "Następna w lewo, potem cały czas prosto."),
            SayLine(id: "s091-2", who: "Ty", de: "Ist das weit?", pl: "Daleko to?"),
            SayLine(id: "s091-3", who: "Przechodzień", de: "Nein, fünf Minuten. Die Hausnummer ist auf der rechten Seite.", pl: "Nie, pięć minut. Numer jest po prawej."),
            SayLine(id: "s091-4", who: "Ty", de: "Super, danke schön.", pl: "Świetnie, dziękuję.")
            ],
            words: [
            Gloss(de: "die Straße", pl: "ulica"),
            Gloss(de: "geradeaus", pl: "prosto"),
            Gloss(de: "die Hausnummer", pl: "numer domu")
            ],
            phrases: ["Wie komme ich zur Gartenstraße?", "immer geradeaus"],
            note: "Zur to skrót zu der, bo die Straße. Przy der Bahnhof byłoby zum.",
            question: "Jak idziesz?",
            options: ["W lewo, potem prosto", "W prawo i z powrotem", "Autobusem na dworzec"],
            answer: 0,
            replyPL: "Jak dojść do Gartenstraße?",
            replyDE: "Wie komme ich zur Gartenstraße?"
        ),
        MiniScene(
            id: "s092",
            title: "Materiał blokuje chodnik",
            category: "Na ulicy",
            level: "B1",
            situation: "Paleta stoi na chodniku i ktoś z wózkiem nie może przejść.",
            lines: [
            SayLine(id: "s092-0", who: "Mieszkanka", de: "Können Sie die Palette kurz zur Seite stellen?", pl: "Może pan przesunąć paletę na chwilę na bok?"),
            SayLine(id: "s092-1", who: "Ty", de: "Ja, Moment. Die muss hier bleiben, aber nicht in der Mitte.", pl: "Tak, moment. Musi tu zostać, ale nie na środku."),
            SayLine(id: "s092-2", who: "Mieszkanka", de: "Ich komme mit dem Kinderwagen nicht durch.", pl: "Nie przejdę z wózkiem."),
            SayLine(id: "s092-3", who: "Ty", de: "Ich ziehe sie an die Wand. So, bitte.", pl: "Przeciągam ją pod ścianę. Proszę."),
            SayLine(id: "s092-4", who: "Mieszkanka", de: "Danke. Passen Sie auf, da ist eine Kante.", pl: "Dzięki. Uważaj pan, tam jest krawężnik.")
            ],
            words: [
            Gloss(de: "die Palette", pl: "paleta"),
            Gloss(de: "der Kinderwagen", pl: "wózek"),
            Gloss(de: "die Kante", pl: "krawędź")
            ],
            phrases: ["kurz zur Seite stellen", "Ich ziehe sie an die Wand."],
            note: "Sie przy palecie, bo die Palette. Zur Seite stellen to odsunąć na bok, nie schować do magazynu.",
            question: "Czemu kobieta cię zatrzymuje?",
            options: ["Nie przejdzie z wózkiem", "Chce kupić paletę", "Szuka dworca"],
            answer: 0,
            replyPL: "Przesunę paletę pod ścianę.",
            replyDE: "Ich stelle die Palette an die Wand."
        ),
        MiniScene(
            id: "s093",
            title: "Bilet u kierowcy",
            category: "W autobusie i pociągu",
            level: "A1",
            situation: "Wsiadasz bez aplikacji i chcesz jeden przejazd.",
            lines: [
            SayLine(id: "s093-0", who: "Ty", de: "Einmal bis zum Bahnhof, bitte.", pl: "Poproszę jeden do dworca."),
            SayLine(id: "s093-1", who: "Kierowca", de: "Das macht drei Euro vierzig.", pl: "To będzie trzy euro czterdzieści."),
            SayLine(id: "s093-2", who: "Ty", de: "Mit Karte?", pl: "Kartą?"),
            SayLine(id: "s093-3", who: "Kierowca", de: "Ja. Halten Sie sie einfach dran.", pl: "Tak. Proszę ją po prostu przyłożyć."),
            SayLine(id: "s093-4", who: "Ty", de: "Danke. Und wo muss ich aussteigen?", pl: "Dzięki. A gdzie mam wysiąść?"),
            SayLine(id: "s093-5", who: "Kierowca", de: "Die dritte Haltestelle.", pl: "Trzeci przystanek.")
            ],
            words: [
            Gloss(de: "aussteigen", pl: "wysiąść"),
            Gloss(de: "die Haltestelle", pl: "przystanek"),
            Gloss(de: "einmal", pl: "jeden bilet")
            ],
            phrases: ["Einmal bis zum Bahnhof.", "Die dritte Haltestelle."],
            note: "Einmal plus dokąd to zwykły sposób kupowania biletu u kierowcy.",
            question: "Gdzie wysiadasz?",
            options: ["Na trzecim przystanku", "Przy następnych światłach", "Aż na pętli"],
            answer: 0,
            replyPL: "Poproszę bilet do dworca.",
            replyDE: "Einmal bis zum Bahnhof, bitte."
        ),
        MiniScene(
            id: "s094",
            title: "Autobus zastępczy",
            category: "W autobusie i pociągu",
            level: "B1",
            situation: "Pociąg nie jedzie i tablica każe iść na autobus zastępczy.",
            lines: [
            SayLine(id: "s094-0", who: "Ty", de: "Fährt der Zug nach Köln nicht?", pl: "Pociąg do Kolonii nie jedzie?"),
            SayLine(id: "s094-1", who: "Informacja", de: "Der fällt aus. Nehmen Sie den Schienenersatzverkehr draußen.", pl: "Jest odwołany. Weź pan autobus zastępczy na zewnątrz."),
            SayLine(id: "s094-2", who: "Ty", de: "Wo steht der genau?", pl: "Gdzie dokładnie stoi?"),
            SayLine(id: "s094-3", who: "Informacja", de: "An der Bushaltestelle B, rechts vom Ausgang.", pl: "Na przystanku B, na prawo od wyjścia."),
            SayLine(id: "s094-4", who: "Ty", de: "Brauche ich ein neues Ticket?", pl: "Potrzebuję nowego biletu?"),
            SayLine(id: "s094-5", who: "Informacja", de: "Nein, Ihr Ticket gilt. Zeigen Sie es dem Fahrer.", pl: "Nie, bilet jest ważny. Pokaż go pan kierowcy.")
            ],
            words: [
            Gloss(de: "fällt aus", pl: "jest odwołany"),
            Gloss(de: "der Schienenersatzverkehr", pl: "autobus zastępczy za pociąg"),
            Gloss(de: "gelten", pl: "obowiązywać")
            ],
            phrases: ["Der fällt aus.", "Ihr Ticket gilt."],
            note: "Fällt aus to odwołany kurs. Verspätung to tylko opóźnienie. To nie jest to samo.",
            question: "Co robisz z biletem?",
            options: ["Pokazujesz go kierowcy zastępczemu", "Kupujesz nowy", "Oddajesz go w kasie"],
            answer: 0,
            replyPL: "Pociąg jest odwołany.",
            replyDE: "Der Zug fällt aus."
        ),
        MiniScene(
            id: "s095",
            title: "Bilet na później",
            category: "Na dworcu",
            level: "A2",
            situation: "Spóźniłeś się na pociąg i chcesz jechać następnym.",
            lines: [
            SayLine(id: "s095-0", who: "Ty", de: "Ich habe den Zug um vier verpasst.", pl: "Spóźniłem się na pociąg o czwartej."),
            SayLine(id: "s095-1", who: "Kasjer", de: "Ihr Ticket gilt heute noch, der nächste ist um halb fünf.", pl: "Bilet jest dziś jeszcze ważny, następny jest o wpół do piątej."),
            SayLine(id: "s095-2", who: "Ty", de: "Muss ich etwas dazuzahlen?", pl: "Muszę coś dopłacić?"),
            SayLine(id: "s095-3", who: "Kasjer", de: "Nein. Nur wenn Sie einen früheren Zug am Morgen nehmen.", pl: "Nie. Tylko gdyby pan wziął wcześniejszy rano."),
            SayLine(id: "s095-4", who: "Ty", de: "Gut, dann warte ich hier.", pl: "Dobrze, to poczekam tutaj.")
            ],
            words: [
            Gloss(de: "verpassen", pl: "spóźnić się na"),
            Gloss(de: "dazuzahlen", pl: "dopłacić"),
            Gloss(de: "gelten", pl: "być ważnym")
            ],
            phrases: ["den Zug verpasst", "Ihr Ticket gilt heute noch."],
            note: "Halb fünf to 16:30, nie 17:30. W niemieckim halb jest przed pełną godziną.",
            question: "Czy dopłacasz?",
            options: ["Nie, bilet jest ważny na następny", "Tak, połowę ceny", "Tak, cały nowy bilet"],
            answer: 0,
            replyPL: "Spóźniłem się na pociąg.",
            replyDE: "Ich habe den Zug verpasst."
        ),
        MiniScene(
            id: "s096",
            title: "Gorączka",
            category: "U lekarza",
            level: "A1",
            situation: "Masz gorączkę i nie możesz iść na zmianę.",
            lines: [
            SayLine(id: "s096-0", who: "Ty", de: "Ich habe Fieber und Halsschmerzen.", pl: "Mam gorączkę i ból gardła."),
            SayLine(id: "s096-1", who: "Lekarz", de: "Seit wann?", pl: "Od kiedy?"),
            SayLine(id: "s096-2", who: "Ty", de: "Seit gestern Abend. Arbeiten geht nicht.", pl: "Od wczorajszego wieczora. Praca nie wchodzi w grę."),
            SayLine(id: "s096-3", who: "Lekarz", de: "Ich schreibe Sie heute und morgen krank.", pl: "Wypisuję pana na dziś i na jutro."),
            SayLine(id: "s096-4", who: "Ty", de: "Danke. Den Zettel schicke ich dem Chef.", pl: "Dzięki. Kartkę wyślę szefowi.")
            ],
            words: [
            Gloss(de: "das Fieber", pl: "gorączka"),
            Gloss(de: "krankschreiben", pl: "wypisać zwolnienie"),
            Gloss(de: "der Zettel", pl: "karteczka, druk")
            ],
            phrases: ["Ich habe Fieber.", "Ich schreibe Sie krank."],
            note: "Krankschreiben to oficjalne zwolnienie. Samo ich bin krank szefowi nie zawsze wystarcza.",
            question: "Na jak długo jest zwolnienie?",
            options: ["Na dziś i jutro", "Na cały miesiąc", "Tylko na godzinę"],
            answer: 0,
            replyPL: "Mam gorączkę.",
            replyDE: "Ich habe Fieber."
        ),
        MiniScene(
            id: "s097",
            title: "Przedłużenie zwolnienia",
            category: "U lekarza",
            level: "B2",
            situation: "Plecy nadal bolą i zwolnienie kończy się w piątek.",
            lines: [
            SayLine(id: "s097-0", who: "Ty", de: "Die Krankschreibung geht nur bis Freitag, aber ich kann noch nicht heben.", pl: "Zwolnienie jest tylko do piątku, a ja jeszcze nie mogę dźwigać."),
            SayLine(id: "s097-1", who: "Lekarz", de: "Wie ist der Schmerz beim Bücken?", pl: "Jaki jest ból przy schylaniu?"),
            SayLine(id: "s097-2", who: "Ty", de: "Stark. Auf der Baustelle müsste ich den ganzen Tag tragen.", pl: "Silny. Na budowie musiałbym nosić cały dzień."),
            SayLine(id: "s097-3", who: "Lekarz", de: "Dann verlängere ich bis nächsten Mittwoch. Kein Heben über fünf Kilo.", pl: "To przedłużam do następnej środy. Bez dźwigania ponad pięć kilo."),
            SayLine(id: "s097-4", who: "Ty", de: "Verstanden. Ich sage dem Chef Bescheid, dass ich noch ausfalle.", pl: "Rozumiem. Powiem szefowi, że jeszcze mnie nie będzie.")
            ],
            words: [
            Gloss(de: "verlängern", pl: "przedłużyć"),
            Gloss(de: "das Heben", pl: "dźwiganie"),
            Gloss(de: "ausfallen", pl: "wypaść, nie być")
            ],
            phrases: ["noch nicht heben", "Kein Heben über fünf Kilo."],
            note: "Müsste ich to przypuszczenie: musiałbym. To grzeczniejsze i ostrożniejsze niż ich muss.",
            question: "Do kiedy przedłuża lekarz?",
            options: ["Do następnej środy", "Do końca roku", "Tylko do piątku"],
            answer: 0,
            replyPL: "Nie mogę jeszcze dźwigać.",
            replyDE: "Ich kann noch nicht heben."
        ),
        MiniScene(
            id: "s098",
            title: "Lek i to, co już biorę",
            category: "W aptece",
            level: "B1",
            situation: "Chcesz coś na plecy, ale rano brałeś już tabletkę.",
            lines: [
            SayLine(id: "s098-0", who: "Ty", de: "Ich brauche etwas gegen Rückenschmerzen.", pl: "Potrzebuję czegoś na ból pleców."),
            SayLine(id: "s098-1", who: "Farmaceuta", de: "Nehmen Sie schon ein Schmerzmittel?", pl: "Bierze pan już jakiś lek przeciwbólowy?"),
            SayLine(id: "s098-2", who: "Ty", de: "Heute Morgen eine Tablette Ibuprofen.", pl: "Dziś rano jedną tabletkę ibuprofenu."),
            SayLine(id: "s098-3", who: "Farmaceuta", de: "Dann heute nicht noch einmal. Ab morgen eine nach dem Essen.", pl: "To dziś już nie drugi raz. Od jutra jedną po jedzeniu."),
            SayLine(id: "s098-4", who: "Ty", de: "Alles klar. Und viel trinken, oder?", pl: "Jasne. I dużo pić, tak?"),
            SayLine(id: "s098-5", who: "Farmaceuta", de: "Genau. Wenn es stärker wird, zum Arzt.", pl: "Dokładnie. Jak się nasili, do lekarza.")
            ],
            words: [
            Gloss(de: "die Rückenschmerzen", pl: "ból pleców"),
            Gloss(de: "das Schmerzmittel", pl: "lek przeciwbólowy"),
            Gloss(de: "die Tablette", pl: "tabletka")
            ],
            phrases: ["nicht noch einmal", "eine nach dem Essen"],
            note: "Gegen plus dopełniacz albo biernik przy leku: gegen Rückenschmerzen. Nicht noch einmal to nie kolejny raz.",
            question: "Kiedy następna tabletka?",
            options: ["Od jutra, po jedzeniu", "Od razu druga", "Tylko w nocy bez jedzenia"],
            answer: 0,
            replyPL: "Potrzebuję czegoś na ból pleców.",
            replyDE: "Ich brauche etwas gegen Rückenschmerzen."
        ),
        MiniScene(
            id: "s099",
            title: "Ból przy zimnym",
            category: "U dentysty",
            level: "A1",
            situation: "Zimna woda na budowie daje ostry ból z prawej.",
            lines: [
            SayLine(id: "s099-0", who: "Ty", de: "Rechts oben tut es weh, wenn ich Kaltes trinke.", pl: "Na górze z prawej boli, kiedy piję coś zimnego."),
            SayLine(id: "s099-1", who: "Dentystka", de: "Seit wann ist das so?", pl: "Od kiedy tak jest?"),
            SayLine(id: "s099-2", who: "Ty", de: "Seit drei Tagen. Heute auf der Arbeit richtig stark.", pl: "Od trzech dni. Dziś w pracy naprawdę mocno."),
            SayLine(id: "s099-3", who: "Dentystka", de: "Ich schaue mir den Zahn an. Mund auf, bitte.", pl: "Obejrzę ząb. Proszę otworzyć usta."),
            SayLine(id: "s099-4", who: "Ty", de: "Okay. Sagen Sie Bescheid, wenn ich zumachen soll.", pl: "Dobrze. Proszę powiedzieć, kiedy mam zamknąć.")
            ],
            words: [
            Gloss(de: "der Zahn", pl: "ząb"),
            Gloss(de: "weh tun", pl: "boleć"),
            Gloss(de: "kalt", pl: "zimny")
            ],
            phrases: ["Rechts oben tut es weh.", "Mund auf, bitte."],
            note: "Weh tun rozdziela się: tut weh. Przy wenn czasownik trinke idzie na koniec.",
            question: "Kiedy boli?",
            options: ["Przy zimnym piciu", "Tylko przy gryzieniu chleba", "Wcale, przyszedłeś na kontrolę"],
            answer: 0,
            replyPL: "Ząb boli przy zimnym.",
            replyDE: "Der Zahn tut weh, wenn ich etwas Kaltes trinke."
        ),
        MiniScene(
            id: "s100",
            title: "Ile kosztuje plomba",
            category: "U dentysty",
            level: "B1",
            situation: "Chcesz wiedzieć cenę, zanim się zgodzisz.",
            lines: [
            SayLine(id: "s100-0", who: "Dentystka", de: "Der Zahn braucht eine Füllung.", pl: "Ząb potrzebuje plomby."),
            SayLine(id: "s100-1", who: "Ty", de: "Was kostet das ungefähr?", pl: "Ile to mniej więcej kosztuje?"),
            SayLine(id: "s100-2", who: "Dentystka", de: "Mit Kasse ungefähr neunzig Euro Eigenanteil.", pl: "Z kasą chorych około dziewięćdziesięciu euro dopłaty."),
            SayLine(id: "s100-3", who: "Ty", de: "Und ohne Termin nächste Woche geht das nicht, oder?", pl: "A bez terminu w przyszłym tygodniu się nie da, prawda?"),
            SayLine(id: "s100-4", who: "Dentystka", de: "Doch, Donnerstag um siebzehn Uhr habe ich ein Loch.", pl: "Da się da, w czwartek o siedemnastej mam lukę."),
            SayLine(id: "s100-5", who: "Ty", de: "Den nehme ich. Die Rechnung brauche ich für mich.", pl: "Biorę ten. Rachunek będzie mi potrzebny.")
            ],
            words: [
            Gloss(de: "die Füllung", pl: "plomba"),
            Gloss(de: "der Eigenanteil", pl: "dopłata własna"),
            Gloss(de: "die Kasse", pl: "kasa chorych")
            ],
            phrases: ["Was kostet das ungefähr?", "Eigenanteil"],
            note: "Doch tutaj nie znaczy jednak nie. Po przeczeniu doch znaczy wręcz przeciwnie: da się.",
            question: "Ile dopłacasz?",
            options: ["Około dziewięćdziesięciu euro", "Nic", "Tylko dziewięć euro"],
            answer: 0,
            replyPL: "Ile kosztuje plomba?",
            replyDE: "Was kostet die Füllung?"
        ),
        MiniScene(
            id: "s101",
            title: "Gdzie jest szatnia",
            category: "W pracy",
            level: "A1",
            situation: "Pierwszy dzień i nie wiesz, gdzie zostawić ubranie.",
            lines: [
            SayLine(id: "s101-0", who: "Ty", de: "Wo ist die Umkleide?", pl: "Gdzie jest szatnia?"),
            SayLine(id: "s101-1", who: "Kolega", de: "Hinten links, neben den Duschen.", pl: "Z tyłu po lewej, obok pryszniców."),
            SayLine(id: "s101-2", who: "Ty", de: "Kann ich da meine Jacke lassen?", pl: "Mogę tam zostawić kurtkę?"),
            SayLine(id: "s101-3", who: "Kolega", de: "Ja, nimm dir einen freien Spind und ein Schloss.", pl: "Tak, weź wolną szafkę i kłódkę."),
            SayLine(id: "s101-4", who: "Ty", de: "Alles klar. Helm behalte ich bei mir.", pl: "Jasne. Kask zostawiam przy sobie.")
            ],
            words: [
            Gloss(de: "die Umkleide", pl: "szatnia"),
            Gloss(de: "der Spind", pl: "szafka pracownicza"),
            Gloss(de: "das Schloss", pl: "kłódka")
            ],
            phrases: ["Wo ist die Umkleide?", "einen freien Spind"],
            note: "Neben den Duschen: den, bo po neben przy miejscu jest celownik liczby mnogiej od die Duschen.",
            question: "Gdzie zostawiasz kurtkę?",
            options: ["W wolnej szafce w szatni", "W biurze szefa", "Na palecie na dworze"],
            answer: 0,
            replyPL: "Gdzie jest szatnia?",
            replyDE: "Wo ist die Umkleide?"
        ),
        MiniScene(
            id: "s102",
            title: "Zmiana z piątku na sobotę",
            category: "W pracy",
            level: "B2",
            situation: "Grafik nagle przenosi cię na sobotę i chcesz to wyjaśnić.",
            lines: [
            SayLine(id: "s102-0", who: "Ty", de: "Im Plan steht jetzt Samstag, ich hatte aber Freitag fest.", pl: "W planie jest teraz sobota, a miałem na sztywno piątek."),
            SayLine(id: "s102-1", who: "Szef", de: "Wir brauchen Samstag zwei Leute am Kran.", pl: "W sobotę potrzebujemy dwóch ludzi przy żurawiu."),
            SayLine(id: "s102-2", who: "Ty", de: "Das verstehe ich. Nur: niemand hat mich gefragt.", pl: "Rozumiem. Tylko nikt mnie nie zapytał."),
            SayLine(id: "s102-3", who: "Szef", de: "Stimmt. Wenn du Samstag machst, hast du Montag frei.", pl: "Racja. Jak zrobisz sobotę, poniedziałek masz wolny."),
            SayLine(id: "s102-4", who: "Ty", de: "Einmal geht das. Aber bitte vorher fragen, nicht erst im Plan.", pl: "Raz może być. Ale proszę pytać wcześniej, nie dopiero w planie."),
            SayLine(id: "s102-5", who: "Szef", de: "Mache ich. Danke, dass du es sagst.", pl: "Tak zrobię. Dzięki, że to mówisz.")
            ],
            words: [
            Gloss(de: "der Plan", pl: "grafik"),
            Gloss(de: "fest", pl: "na sztywno"),
            Gloss(de: "vorher", pl: "wcześniej")
            ],
            phrases: ["niemand hat mich gefragt", "Montag frei"],
            note: "Dass du es sagst wysyła czasownik na koniec. To nie jest dass du sagst es.",
            question: "Co dostajesz za sobotę?",
            options: ["Wolny poniedziałek", "Dodatkową premię od razu", "Wolny cały tydzień"],
            answer: 0,
            replyPL: "Nikt mnie nie zapytał.",
            replyDE: "Niemand hat mich gefragt."
        ),
        MiniScene(
            id: "s103",
            title: "Poziomica nie siada",
            category: "Na budowie",
            level: "A2",
            situation: "Belka jest krzywo i szef chce poprawki zanim poleje.",
            lines: [
            SayLine(id: "s103-0", who: "Szef", de: "Die Latte ist nicht im Wasser.", pl: "Łata nie jest w poziomie."),
            SayLine(id: "s103-1", who: "Ty", de: "Ich sehe es. Links ist sie tiefer.", pl: "Widzę. Z lewej jest niżej."),
            SayLine(id: "s103-2", who: "Szef", de: "Unterleg links zwei Millimeter und prüf noch mal.", pl: "Podłóż z lewej dwa milimetry i sprawdź jeszcze raz."),
            SayLine(id: "s103-3", who: "Ty", de: "So? Die Blase ist jetzt in der Mitte.", pl: "Tak? Bąbelek jest teraz na środku."),
            SayLine(id: "s103-4", who: "Szef", de: "Genau. Jetzt kannst du festmachen.", pl: "Dokładnie. Teraz możesz mocować.")
            ],
            words: [
            Gloss(de: "die Latte", pl: "łata"),
            Gloss(de: "die Blase", pl: "bąbelek poziomicy"),
            Gloss(de: "unterlegen", pl: "podłożyć")
            ],
            phrases: ["nicht im Wasser", "Die Blase ist in der Mitte."],
            note: "Im Wasser na budowie znaczy w poziomie, bańka między kreskami. To nie jest wiadro z wodą.",
            question: "Co jest nie tak na początku?",
            options: ["Łata nie jest w poziomie", "Brakuje betonu", "Kabel leży w wykopie"],
            answer: 0,
            replyPL: "Łata nie jest w poziomie.",
            replyDE: "Die Latte ist nicht im Wasser."
        ),
        MiniScene(
            id: "s104",
            title: "Odbiór ściany",
            category: "Na budowie",
            level: "B2",
            situation: "Kierownik patrzy na ścianę i zostawia uwagi.",
            lines: [
            SayLine(id: "s104-0", who: "Kierownik", de: "Die Fuge hier ist zu breit. Das nehme ich so nicht ab.", pl: "Ta spoina jest za szeroka. Tak tego nie odbiorę."),
            SayLine(id: "s104-1", who: "Ty", de: "Wie breit darf sie maximal sein?", pl: "Jak szeroka może być maksymalnie?"),
            SayLine(id: "s104-2", who: "Kierownik", de: "Acht Millimeter. Die drei Felder links müssen neu.", pl: "Osiem milimetrów. Trzy pola z lewej muszą być od nowa."),
            SayLine(id: "s104-3", who: "Ty", de: "Heute schaffen wir zwei. Das dritte morgen früh, bevor der Putz kommt.", pl: "Dziś zrobimy dwa. Trzecie jutro rano, zanim przyjdzie tynk."),
            SayLine(id: "s104-4", who: "Kierownik", de: "Schreiben Sie das so ins Protokoll.", pl: "Proszę tak wpisać do protokołu."),
            SayLine(id: "s104-5", who: "Ty", de: "Mache ich. Foto habe ich auch.", pl: "Zrobię. Zdjęcie też mam.")
            ],
            words: [
            Gloss(de: "die Fuge", pl: "spoina"),
            Gloss(de: "abnehmen", pl: "odebrać robotę"),
            Gloss(de: "das Protokoll", pl: "protokół")
            ],
            phrases: ["nicht abnehmen", "ins Protokoll"],
            note: "Abnehmen przy odbiorze to zaakceptować robotę. Zwykłe nehmen byłoby tylko wziąć.",
            question: "Ile pól robicie od nowa?",
            options: ["Trzy", "Jedno", "Całą ścianę"],
            answer: 0,
            replyPL: "Tak tego nie odbiorę.",
            replyDE: "Das nehme ich so nicht ab."
        ),
        MiniScene(
            id: "s105",
            title: "Spóźnię się dziesięć minut",
            category: "Rozmowy z szefem",
            level: "A1",
            situation: "Stoisz w korku i dzwonisz, zanim zmiana się zacznie.",
            lines: [
            SayLine(id: "s105-0", who: "Ty", de: "Chef, ich stehe im Stau.", pl: "Szefie, stoję w korku."),
            SayLine(id: "s105-1", who: "Szef", de: "Wie lange brauchst du noch?", pl: "Ile jeszcze potrzebujesz?"),
            SayLine(id: "s105-2", who: "Ty", de: "Ungefähr zehn Minuten. Ich bin schon auf der Brücke.", pl: "Około dziesięciu minut. Już jestem na moście."),
            SayLine(id: "s105-3", who: "Szef", de: "Okay, meld dich, wenn du unten bist.", pl: "Dobra, zgłoś się, jak będziesz na dole."),
            SayLine(id: "s105-4", who: "Ty", de: "Mache ich. Bis gleich.", pl: "Zrobię tak. Do zaraz.")
            ],
            words: [
            Gloss(de: "der Stau", pl: "korek"),
            Gloss(de: "die Brücke", pl: "most"),
            Gloss(de: "sich melden", pl: "zgłosić się")
            ],
            phrases: ["Ich stehe im Stau.", "Bis gleich."],
            note: "Bis gleich mówisz, kiedy naprawdę widzicie się za chwilę. Bis später jest dalsze.",
            question: "O ile się spóźnisz?",
            options: ["Około dziesięciu minut", "O godzinę", "Nie przyjdziesz dziś"],
            answer: 0,
            replyPL: "Stoję w korku.",
            replyDE: "Ich stehe im Stau."
        ),
        MiniScene(
            id: "s106",
            title: "Rozmowa o stawce",
            category: "Rozmowy z szefem",
            level: "B1",
            situation: "Jesteś pół roku i robisz więcej niż na początku.",
            lines: [
            SayLine(id: "s106-0", who: "Ty", de: "Können wir kurz über den Lohn sprechen?", pl: "Możemy na chwilę pogadać o stawce?"),
            SayLine(id: "s106-1", who: "Szef", de: "Ja. Was stellst du dir vor?", pl: "Tak. Co sobie wyobrażasz?"),
            SayLine(id: "s106-2", who: "Ty", de: "Ich mache seit sechs Monaten auch die Abnahme mit. Zwei Euro mehr wären fair.", pl: "Od sześciu miesięcy robię też odbiór. Dwa euro więcej byłyby fair."),
            SayLine(id: "s106-3", who: "Szef", de: "Ich kann einen Euro ab Mai zusagen. Den zweiten schauen wir im Sommer.", pl: "Mogę obiecać jedno euro od maja. Drugie zobaczymy latem."),
            SayLine(id: "s106-4", who: "Ty", de: "Einverstanden, wenn es schriftlich im Plan steht.", pl: "Zgoda, jeśli będzie na piśmie w planie."),
            SayLine(id: "s106-5", who: "Szef", de: "Kriegst du. Ich schicke dir die Zeile heute.", pl: "Dostaniesz. Wyślę ci tę linijkę dziś.")
            ],
            words: [
            Gloss(de: "der Lohn", pl: "stawka, wypłata"),
            Gloss(de: "die Abnahme", pl: "odbiór"),
            Gloss(de: "schriftlich", pl: "na piśmie")
            ],
            phrases: ["über den Lohn sprechen", "schriftlich"],
            note: "Wären fair to tryb przypuszczający: byłyby w porządku. Mniej twarde niż ich will.",
            question: "Co szef obiecuje od maja?",
            options: ["Jedno euro więcej", "Dwa euro więcej od jutra", "Nic do przyszłego roku"],
            answer: 0,
            replyPL: "Możemy porozmawiać o stawce?",
            replyDE: "Können wir über den Lohn sprechen?"
        ),
        MiniScene(
            id: "s107",
            title: "Pożycz kask",
            category: "Rozmowy ze współpracownikami",
            level: "A2",
            situation: "Twój kask został w aucie, a na górę idziecie teraz.",
            lines: [
            SayLine(id: "s107-0", who: "Ty", de: "Kann ich kurz deinen zweiten Helm haben?", pl: "Mogę na chwilę wziąć twój drugi kask?"),
            SayLine(id: "s107-1", who: "Kolega", de: "Ja, der liegt im Kontainer, rote Kiste.", pl: "Tak, leży w kontenerze, czerwona skrzynka."),
            SayLine(id: "s107-2", who: "Ty", de: "Ich bringe ihn in der Pause zurück.", pl: "Przyniosę go na przerwie."),
            SayLine(id: "s107-3", who: "Kolega", de: "Passt. Ohne Riemen nimm ihn nicht, der sitzt sonst nicht.", pl: "Dobra. Bez paska go nie bierz, bo inaczej nie siedzi."),
            SayLine(id: "s107-4", who: "Ty", de: "Sehe ich. Danke dir.", pl: "Widzę. Dzięki.")
            ],
            words: [
            Gloss(de: "der Helm", pl: "kask"),
            Gloss(de: "der Riemen", pl: "pasek"),
            Gloss(de: "die Kiste", pl: "skrzynka")
            ],
            phrases: ["deinen zweiten Helm", "in der Pause zurück"],
            note: "Sonst tutaj znaczy w przeciwnym razie, nie inaczej jako przysłówek miejsca.",
            question: "Kiedy oddajesz kask?",
            options: ["Na przerwie", "Jutro rano", "Wcale, zostaje twój"],
            answer: 0,
            replyPL: "Mogę pożyczyć kask?",
            replyDE: "Kann ich deinen Helm haben?"
        ),
        MiniScene(
            id: "s108",
            title: "Kto zostaje w sobotę",
            category: "Rozmowy ze współpracownikami",
            level: "B1",
            situation: "Ekipa nie chce, żeby sobota spadła zawsze na tę samą osobę.",
            lines: [
            SayLine(id: "s108-0", who: "Kolega", de: "Samstag braucht einer am Tor. Ich war letzte Woche dran.", pl: "W sobotę ktoś musi być przy bramie. W zeszłym tygodniu byłem ja."),
            SayLine(id: "s108-1", who: "Ty", de: "Dann mache ich diesen. Aber nicht wieder in zwei Wochen.", pl: "To ja zrobię tę. Ale nie znowu za dwa tygodnie."),
            SayLine(id: "s108-2", who: "Kolega", de: "Einverstanden. Ich schreibe es in die Gruppe.", pl: "Zgoda. Wpiszę to na grupę."),
            SayLine(id: "s108-3", who: "Ty", de: "Schreib auch die Uhrzeit. Ich kann erst ab sieben, nicht um sechs.", pl: "Dopisz też godzinę. Mogę dopiero od siódmej, nie o szóstej."),
            SayLine(id: "s108-4", who: "Kolega", de: "Geht klar. Ich sage dem Chef Bescheid.", pl: "Jasne. Powiem szefowi.")
            ],
            words: [
            Gloss(de: "dran sein", pl: "przypadać na kogoś"),
            Gloss(de: "die Gruppe", pl: "grupa na telefonie"),
            Gloss(de: "erst ab", pl: "dopiero od")
            ],
            phrases: ["Ich war letzte Woche dran.", "erst ab sieben"],
            note: "Dran sein to potoczne: teraz twoja kolej. Erst ab znaczy nie wcześniej niż.",
            question: "Od której możesz w sobotę?",
            options: ["Od siódmej", "Od szóstej", "Wcale nie możesz"],
            answer: 0,
            replyPL: "W zeszłym tygodniu była moja kolej.",
            replyDE: "Letzte Woche war ich dran."
        ),
        MiniScene(
            id: "s109",
            title: "Zły formularz",
            category: "W urzędzie",
            level: "A1",
            situation: "Stoisz przy automacie i drukujesz nie ten wniosek.",
            lines: [
            SayLine(id: "s109-0", who: "Ty", de: "Ist das das Formular für die Anmeldung?", pl: "Czy to formularz do meldunku?"),
            SayLine(id: "s109-1", who: "Urzędniczka", de: "Nein, das ist für den Ausweis. Anmeldung ist das gelbe.", pl: "Nie, to jest do dowodu. Meldunek jest na żółtym."),
            SayLine(id: "s109-2", who: "Ty", de: "Wo liegt das gelbe?", pl: "Gdzie leży żółte?"),
            SayLine(id: "s109-3", who: "Urzędniczka", de: "Im Fach direkt unter dem Automaten.", pl: "W przegródce tuż pod automatem."),
            SayLine(id: "s109-4", who: "Ty", de: "Danke. Ich fülle es noch mal aus.", pl: "Dziękuję. Wypełnię je jeszcze raz.")
            ],
            words: [
            Gloss(de: "das Formular", pl: "formularz"),
            Gloss(de: "die Anmeldung", pl: "meldunek"),
            Gloss(de: "ausfüllen", pl: "wypełnić")
            ],
            phrases: ["das gelbe", "noch mal ausfüllen"],
            note: "Noch mal to jeszcze raz, potocznie. Officjalnie erneut, ale przy okienku noch mal jest normalne.",
            question: "Który formularz bierzesz?",
            options: ["Żółty do meldunku", "Do dowodu", "Do podatku"],
            answer: 0,
            replyPL: "Wypełnię formularz jeszcze raz.",
            replyDE: "Ich fülle das Formular noch mal aus."
        ),
        MiniScene(
            id: "s110",
            title: "Termin na kartę pobytu",
            category: "W urzędzie",
            level: "B2",
            situation: "Termin w systemie jest za daleko i chcesz wcześniejszy.",
            lines: [
            SayLine(id: "s110-0", who: "Ty", de: "Der nächste Termin im System ist erst im September. Geht etwas früher?", pl: "Najbliższy termin w systemie jest dopiero we wrześniu. Da się wcześniej?"),
            SayLine(id: "s110-1", who: "Urzędnik", de: "Nur wenn Sie einen dringenden Grund haben.", pl: "Tylko jeśli ma pan pilny powód."),
            SayLine(id: "s110-2", who: "Ty", de: "Mein Arbeitgeber braucht die Karte für den neuen Vertrag, sonst ruht die Stelle.", pl: "Pracodawca potrzebuje karty do nowej umowy, inaczej stanowisko stoi."),
            SayLine(id: "s110-3", who: "Urzędnik", de: "Legen Sie die Bescheinigung der Firma dazu. Dann kann ich Juni anbieten.", pl: "Proszę dołączyć zaświadczenie z firmy. Wtedy mogę dać czerwiec."),
            SayLine(id: "s110-4", who: "Ty", de: "Die habe ich hier. Reicht die als Scan oder muss sie im Original bleiben?", pl: "Mam ją tutaj. Wystarczy skan, czy ma zostać oryginał?"),
            SayLine(id: "s110-5", who: "Urzędnik", de: "Original zur Akte, Scan schicken Sie zusätzlich an die Mail auf dem Zettel.", pl: "Oryginał do akt, skan proszę dodatkowo na maila z karteczki.")
            ],
            words: [
            Gloss(de: "dringend", pl: "pilny"),
            Gloss(de: "die Bescheinigung", pl: "zaświadczenie"),
            Gloss(de: "die Akte", pl: "akta")
            ],
            phrases: ["einen dringenden Grund", "Original zur Akte"],
            note: "Sonst ruht die Stelle: stanowisko jest wstrzymane. Ruht nie znaczy, że praca zniknęła na zawsze.",
            question: "Co masz dołączyć, żeby dostać czerwiec?",
            options: ["Zaświadczenie z firmy", "Tylko paszport", "Stary bilet kolejowy"],
            answer: 0,
            replyPL: "Da się wcześniej?",
            replyDE: "Geht es früher?"
        ),
        MiniScene(
            id: "s111",
            title: "Wpłata gotówki",
            category: "W banku",
            level: "A1",
            situation: "Chcesz wpłacić gotówkę na konto, z którego schodzi czynsz.",
            lines: [
            SayLine(id: "s111-0", who: "Ty", de: "Ich möchte Geld auf mein Konto einzahlen.", pl: "Chcę wpłacić pieniądze na konto."),
            SayLine(id: "s111-1", who: "Pracownica", de: "Haben Sie die Karte dabei?", pl: "Ma pan kartę przy sobie?"),
            SayLine(id: "s111-2", who: "Ty", de: "Ja. Es sind dreihundert Euro in bar.", pl: "Tak. To trzysta euro gotówką."),
            SayLine(id: "s111-3", who: "Pracownica", de: "Legen Sie die Scheine in den Zähler. Ich drucke die Quittung.", pl: "Proszę włożyć banknoty do liczarki. Wydrukuję potwierdzenie."),
            SayLine(id: "s111-4", who: "Ty", de: "Danke. Die Quittung brauche ich.", pl: "Dzięki. Potwierdzenie mi potrzebne.")
            ],
            words: [
            Gloss(de: "einzahlen", pl: "wpłacić"),
            Gloss(de: "die Quittung", pl: "potwierdzenie"),
            Gloss(de: "der Schein", pl: "banknot")
            ],
            phrases: ["auf mein Konto einzahlen", "die Quittung"],
            note: "Einzahlen to wpłata na konto. Auszahlen byłoby wypłata.",
            question: "Ile wpłacasz?",
            options: ["Trzysta euro", "Trzydzieści euro", "Całą wypłatę"],
            answer: 0,
            replyPL: "Chcę wpłacić pieniądze na konto.",
            replyDE: "Ich möchte Geld auf mein Konto einzahlen."
        ),
        MiniScene(
            id: "s112",
            title: "Limit przelewu",
            category: "W banku",
            level: "B2",
            situation: "Czynsz i kaucja razem nie przechodzą, bo limit dzienny jest za niski.",
            lines: [
            SayLine(id: "s112-0", who: "Ty", de: "Die Überweisung wird abgelehnt. Es sind Miete und Kaution zusammen.", pl: "Przelew jest odrzucany. To czynsz i kaucja razem."),
            SayLine(id: "s112-1", who: "Doradca", de: "Ihr Tageslimit liegt bei tausend Euro. Die Summe ist höher.", pl: "Dzienny limit jest tysiąc euro. Suma jest wyższa."),
            SayLine(id: "s112-2", who: "Ty", de: "Können Sie das Limit heute einmal anheben?", pl: "Może pan dziś jednorazowo podnieść limit?"),
            SayLine(id: "s112-3", who: "Doradca", de: "Ja, nach Freigabe in der App. Danach setzen wir es wieder runter.", pl: "Tak, po zatwierdzeniu w aplikacji. Potem z powrotem go obniżymy."),
            SayLine(id: "s112-4", who: "Ty", de: "Gut. Ich will nicht, dass es dauerhaft so hoch bleibt.", pl: "Dobrze. Nie chcę, żeby na stałe został tak wysoko."),
            SayLine(id: "s112-5", who: "Doradca", de: "Genau so machen wir es. Die Freigabe ist zwanzig Minuten gültig.", pl: "Tak właśnie zrobimy. Zatwierdzenie jest ważne dwadzieścia minut.")
            ],
            words: [
            Gloss(de: "das Tageslimit", pl: "limit dzienny"),
            Gloss(de: "anheben", pl: "podnieść"),
            Gloss(de: "die Freigabe", pl: "zatwierdzenie")
            ],
            phrases: ["wird abgelehnt", "nicht dauerhaft"],
            note: "Danach setzen wir es wieder runter: es to limit. Runtersetzen to obniżyć, przeciwieństwo anheben.",
            question: "Co dzieje się z limitem po przelewie?",
            options: ["Wraca w dół", "Zostaje wysoki na stałe", "Konto się zamyka"],
            answer: 0,
            replyPL: "Przelew został odrzucony.",
            replyDE: "Die Überweisung wurde abgelehnt."
        ),
        MiniScene(
            id: "s113",
            title: "List polecony",
            category: "Na poczcie",
            level: "A2",
            situation: "Wysyłasz wypowiedzenie tak, żeby mieć potwierdzenie.",
            lines: [
            SayLine(id: "s113-0", who: "Ty", de: "Ich möchte diesen Brief als Einschreiben schicken.", pl: "Chcę wysłać ten list polecony."),
            SayLine(id: "s113-1", who: "Okienko", de: "Mit Rückschein oder ohne?", pl: "Z potwierdzeniem odbioru czy bez?"),
            SayLine(id: "s113-2", who: "Ty", de: "Mit Rückschein. Der muss beim Vermieter ankommen.", pl: "Z potwierdzeniem. Ma dojść do wynajmującego."),
            SayLine(id: "s113-3", who: "Okienko", de: "Legen Sie ihn offen hin, ich wiege ihn zuerst.", pl: "Proszę położyć go otwarty, najpierw zważę."),
            SayLine(id: "s113-4", who: "Ty", de: "Hier. Die Adresse steht schon drauf.", pl: "Proszę. Adres już jest na wierzchu.")
            ],
            words: [
            Gloss(de: "das Einschreiben", pl: "list polecony"),
            Gloss(de: "der Rückschein", pl: "potwierdzenie odbioru"),
            Gloss(de: "wiegen", pl: "zważyć")
            ],
            phrases: ["als Einschreiben", "mit Rückschein"],
            note: "Einschreiben to sam list polecony. Rückschein to dodatkowy dowód, że adresat odebrał.",
            question: "Jak wysyłasz list?",
            options: ["Polecony z potwierdzeniem odbioru", "Zwykły list bez śladu", "Pocztówkę"],
            answer: 0,
            replyPL: "Chcę wysłać list polecony.",
            replyDE: "Ich möchte den Brief als Einschreiben schicken."
        ),
        MiniScene(
            id: "s114",
            title: "Paczka uszkodzona",
            category: "Na poczcie",
            level: "B1",
            situation: "Karton z częściami jest rozerwany i nie chcesz go tak odebrać.",
            lines: [
            SayLine(id: "s114-0", who: "Ty", de: "Die Sendung ist aufgerissen. Ich nehme sie so nicht an.", pl: "Przesyłka jest rozerwana. Tak jej nie przyjmę."),
            SayLine(id: "s114-1", who: "Okienko", de: "Wir können einen Schaden vermerken und Fotos machen.", pl: "Możemy zapisać szkodę i zrobić zdjęcia."),
            SayLine(id: "s114-2", who: "Ty", de: "Ja. Innen fehlt eine Schiene, das sieht man schon.", pl: "Tak. W środku brakuje jednej szyny, już to widać."),
            SayLine(id: "s114-3", who: "Okienko", de: "Dann öffnen wir sie hier gemeinsam und schreiben das Protokoll.", pl: "To otworzymy ją tu razem i spiszemy protokół."),
            SayLine(id: "s114-4", who: "Ty", de: "Gut. Eine Kopie brauche ich für die Firma.", pl: "Dobrze. Kopię potrzebuję dla firmy.")
            ],
            words: [
            Gloss(de: "die Sendung", pl: "przesyłka"),
            Gloss(de: "aufgerissen", pl: "rozerwany"),
            Gloss(de: "der Schaden", pl: "szkoda")
            ],
            phrases: ["nicht annehmen", "Schaden vermerken"],
            note: "Annehmen przy paczce to odebrać i uznać, że jest w porządku. Deshalb mówisz so nicht.",
            question: "Czemu nie odbierasz od razu?",
            options: ["Karton jest rozerwany i brakuje szyny", "To nie twoje nazwisko", "Okienko jest nieczynne"],
            answer: 0,
            replyPL: "Tak tej paczki nie przyjmę.",
            replyDE: "Die Sendung nehme ich so nicht an."
        ),
        MiniScene(
            id: "s115",
            title: "Kiedy mogę się wprowadzić",
            category: "Wynajem mieszkania",
            level: "A1",
            situation: "Pokój ci pasuje i pytasz o datę.",
            lines: [
            SayLine(id: "s115-0", who: "Ty", de: "Der Raum gefällt mir. Ab wann kann ich einziehen?", pl: "Pokój mi się podoba. Od kiedy mogę się wprowadzić?"),
            SayLine(id: "s115-1", who: "Wynajmujący", de: "Ab dem Ersten, wenn die Kaution da ist.", pl: "Od pierwszego, jak będzie kaucja."),
            SayLine(id: "s115-2", who: "Ty", de: "Ist die Küche mit drin?", pl: "Kuchnia jest w cenie?"),
            SayLine(id: "s115-3", who: "Wynajmujący", de: "Ja. Waschmaschine auch. Internet zahlen Sie selbst.", pl: "Tak. Pralka też. Internet płaci pan sam."),
            SayLine(id: "s115-4", who: "Ty", de: "Okay. Ich überlege bis morgen.", pl: "Dobrze. Pomyślę do jutra.")
            ],
            words: [
            Gloss(de: "einziehen", pl: "wprowadzić się"),
            Gloss(de: "die Kaution", pl: "kaucja"),
            Gloss(de: "die Waschmaschine", pl: "pralka")
            ],
            phrases: ["Ab wann kann ich einziehen?", "Internet zahlen Sie selbst."],
            note: "Mit drin ist potoczne: wliczone. W ogłoszeniu i przy oglądaniu słyszysz to ciągle.",
            question: "Co płacisz osobno?",
            options: ["Internet", "Pralkę", "Kaucję co miesiąc"],
            answer: 0,
            replyPL: "Od kiedy mogę się wprowadzić?",
            replyDE: "Ab wann kann ich einziehen?"
        ),
        MiniScene(
            id: "s116",
            title: "Protokół zdawczy",
            category: "Wynajem mieszkania",
            level: "B2",
            situation: "Oddajesz mieszkanie i nie chcesz później sporu o dziury po kołkach.",
            lines: [
            SayLine(id: "s116-0", who: "Ty", de: "Ich möchte die Übergabe Punkt für Punkt ins Protokoll.", pl: "Chcę zdanie mieszkania punkt po punkcie do protokołu."),
            SayLine(id: "s116-1", who: "Wynajmujący", de: "Die Dübellöcher in der Küche müssen zu sein.", pl: "Dziury po kołkach w kuchni muszą być zamknięte."),
            SayLine(id: "s116-2", who: "Ty", de: "Die habe ich gespachtelt. Sehen Sie, die Farbe ist noch einen Ton heller.", pl: "Zaszpachlowałem je. Proszę spojrzeć, farba jest jeszcze o ton jaśniejsza."),
            SayLine(id: "s116-3", who: "Wynajmujący", de: "Das akzeptiere ich. Den Schlüsselzähler schreiben wir: zwei Wohnungs-, ein Keller-, ein Briefkastenschlüssel.", pl: "Akceptuję. Liczbę kluczy wpisujemy: dwa od mieszkania, jeden od piwnicy, jeden od skrzynki."),
            SayLine(id: "s116-4", who: "Ty", de: "Und die Kaution zurück innerhalb der vereinbarten Frist, nicht irgendwann.", pl: "A kaucja z powrotem w uzgodnionym terminie, nie kiedyś."),
            SayLine(id: "s116-5", who: "Wynajmujący", de: "Steht so im Vertrag. Sie bekommen eine Kopie jetzt.", pl: "Tak jest w umowie. Kopię dostaje pan teraz.")
            ],
            words: [
            Gloss(de: "die Übergabe", pl: "zdanie mieszkania"),
            Gloss(de: "spachteln", pl: "szpachlować"),
            Gloss(de: "der Briefkasten", pl: "skrzynka na listy")
            ],
            phrases: ["Punkt für Punkt", "innerhalb der Frist"],
            note: "Irgendwann jest wymijające: kiedyś tam. Dlatego dopinasz termin z umowy, a nie obietnicę słowną.",
            question: "Co wynajmujący akceptuje?",
            options: ["Zaszpachlowane dziury", "Zostawienie mebli", "Brak jednego klucza"],
            answer: 0,
            replyPL: "Chcę to w protokole.",
            replyDE: "Ich möchte das im Protokoll haben."
        ),
        MiniScene(
            id: "s117",
            title: "Wierciłeś w niedzielę",
            category: "Sąsiedzi",
            level: "A2",
            situation: "Sąsiadka puka, bo w południe wziąłeś wiertarkę.",
            lines: [
            SayLine(id: "s117-0", who: "Sąsiadka", de: "Es ist Sonntag. Die Bohrmaschine hört man im ganzen Haus.", pl: "Jest niedziela. Wiertarkę słychać w całym domu."),
            SayLine(id: "s117-1", who: "Ty", de: "Sie haben recht. Ich höre sofort auf.", pl: "Ma pani rację. Zaraz przestaję."),
            SayLine(id: "s117-2", who: "Sąsiadka", de: "Montag ab acht ist kein Problem.", pl: "W poniedziałek od ósmej nie ma problemu."),
            SayLine(id: "s117-3", who: "Ty", de: "Dann mache ich den Rest morgen früh. Entschuldigung.", pl: "To resztę zrobię jutro rano. Przepraszam."),
            SayLine(id: "s117-4", who: "Sąsiadka", de: "Schon gut. Danke, dass Sie aufmachen.", pl: "Już dobrze. Dziękuję, że pan otwiera.")
            ],
            words: [
            Gloss(de: "die Bohrmaschine", pl: "wiertarka"),
            Gloss(de: "sofort", pl: "natychmiast"),
            Gloss(de: "der Rest", pl: "reszta")
            ],
            phrases: ["Ich höre sofort auf.", "Montag ab acht"],
            note: "Sie haben recht mówisz, kiedy przyznajesz rację. Krótsze stimmt jest możliwe, ale tu lepiej pełne zdanie.",
            question: "Kiedy dokończysz wiercenie?",
            options: ["W poniedziałek rano", "Za dziesięć minut w niedzielę", "W nocy"],
            answer: 0,
            replyPL: "Zaraz przestaję.",
            replyDE: "Ich höre sofort auf."
        ),
        MiniScene(
            id: "s118",
            title: "Zły pojemnik na śmieci",
            category: "Sąsiedzi",
            level: "B1",
            situation: "Papier wylądował w odpadach resztkowych i sąsiad zwraca uwagę.",
            lines: [
            SayLine(id: "s118-0", who: "Sąsiad", de: "Das Papier gehört nicht in den Restmüll.", pl: "Papier nie należy do odpadów zmieszanych."),
            SayLine(id: "s118-1", who: "Ty", de: "Oh, welche Tonne ist dann für Karton?", pl: "O, który pojemnik jest wtedy na karton?"),
            SayLine(id: "s118-2", who: "Sąsiad", de: "Die blaue. Gelb ist Verpackung, braun ist Bio.", pl: "Niebieski. Żółty to opakowania, brązowy to bio."),
            SayLine(id: "s118-3", who: "Ty", de: "Verstanden. Den Karton hole ich wieder raus und falte ihn.", pl: "Rozumiem. Karton wyjmę z powrotem i złożę."),
            SayLine(id: "s118-4", who: "Sąsiad", de: "Genau. Sonst wird die Tonne nicht geleert.", pl: "Dokładnie. Inaczej pojemnika nie opróżnią.")
            ],
            words: [
            Gloss(de: "der Restmüll", pl: "odpady zmieszane"),
            Gloss(de: "die Tonne", pl: "pojemnik"),
            Gloss(de: "falten", pl: "składać")
            ],
            phrases: ["nicht in den Restmüll", "die blaue Tonne"],
            note: "Gehört nicht in to nie należy do. Przy śmieciach Niemcy poprawiają tak wprost i to nie jest kłótnia.",
            question: "Gdzie ma trafić karton?",
            options: ["Do niebieskiego pojemnika", "Do brązowego", "Do zmieszanych"],
            answer: 0,
            replyPL: "Papier nie idzie do zmieszanych.",
            replyDE: "Papier gehört nicht in den Restmüll."
        ),
        MiniScene(
            id: "s119",
            title: "Kolacja po zmianie",
            category: "Rodzina i znajomi",
            level: "A2",
            situation: "Brat jest w mieście tylko dziś wieczór.",
            lines: [
            SayLine(id: "s119-0", who: "Brat", de: "Kriege ich dich heute noch zu sehen?", pl: "Uda mi się ciebie dziś jeszcze zobaczyć?"),
            SayLine(id: "s119-1", who: "Ty", de: "Ja, aber erst nach der Schicht, so gegen sieben.", pl: "Tak, ale dopiero po zmianie, około siódmej."),
            SayLine(id: "s119-2", who: "Brat", de: "Bei dir oder in der Stadt?", pl: "U ciebie czy w mieście?"),
            SayLine(id: "s119-3", who: "Ty", de: "Bei mir. Ich koche etwas Einfaches, ich bin platt.", pl: "U mnie. Ugotuję coś prostego, jestem padnięty."),
            SayLine(id: "s119-4", who: "Brat", de: "Perfekt. Ich bringe Brot mit.", pl: "Świetnie. Przyniosę chleb.")
            ],
            words: [
            Gloss(de: "die Schicht", pl: "zmiana"),
            Gloss(de: "platt sein", pl: "być padniętym"),
            Gloss(de: "einfach", pl: "prosty")
            ],
            phrases: ["erst nach der Schicht", "ich bin platt"],
            note: "Platt sein to potoczne: wykończony, nie płaski. Gegen sieben to około siódmej, niekoniecznie co do minuty.",
            question: "Gdzie się widzicie?",
            options: ["U ciebie po zmianie", "Na budowie o szóstej", "Jutro na dworcu"],
            answer: 0,
            replyPL: "Jestem padnięty po zmianie.",
            replyDE: "Ich bin nach der Schicht platt."
        ),
        MiniScene(
            id: "s120",
            title: "Nie w tę niedzielę",
            category: "Rodzina i znajomi",
            level: "B1",
            situation: "Mama chce przyjechać, a ty masz odbiór na budowie.",
            lines: [
            SayLine(id: "s120-0", who: "Mama", de: "Ich könnte Sonntag kommen und dir kochen.", pl: "Mogłabym przyjechać w niedzielę i ci ugotować."),
            SayLine(id: "s120-1", who: "Ty", de: "Das ist lieb, aber Sonntag bin ich auf der Abnahme.", pl: "To miłe, ale w niedzielę jestem na odbiorze."),
            SayLine(id: "s120-2", who: "Mama", de: "Auch am Nachmittag?", pl: "Też po południu?"),
            SayLine(id: "s120-3", who: "Ty", de: "Bis ungefähr vier. Danach falle ich nur noch aufs Sofa.", pl: "Mniej więcej do czwartej. Potem już tylko padnę na kanapę."),
            SayLine(id: "s120-4", who: "Mama", de: "Dann die Woche danach. Sag mir den Tag, der wirklich frei ist.", pl: "To w następny tydzień. Powiedz dzień, który naprawdę jest wolny."),
            SayLine(id: "s120-5", who: "Ty", de: "Dienstagabend. Da habe ich früh Schluss.", pl: "Wtorek wieczór. Wtedy wcześnie kończę.")
            ],
            words: [
            Gloss(de: "die Abnahme", pl: "odbiór"),
            Gloss(de: "lieb", pl: "miłe"),
            Gloss(de: "früh Schluss haben", pl: "wcześnie kończyć")
            ],
            phrases: ["Sonntag bin ich auf der Abnahme.", "Dienstagabend"],
            note: "Könnte to ostrożna propozycja. Odmawiasz konkretnym powodem, nie samym nein.",
            question: "Kiedy mama ma przyjechać?",
            options: ["We wtorek wieczorem", "W tę niedzielę rano", "Dziś po zmianie"],
            answer: 0,
            replyPL: "W niedzielę jestem na odbiorze.",
            replyDE: "Sonntag bin ich auf der Abnahme."
        ),
        MiniScene(
            id: "s121",
            title: "Poczta głosowa",
            category: "Telefonowanie",
            level: "B1",
            situation: "Szef nie odbiera, a musisz zostawić konkret.",
            lines: [
            SayLine(id: "s121-0", who: "Automat", de: "Der Anschluss ist nicht erreichbar. Sprechen Sie nach dem Ton.", pl: "Numer jest niedostępny. Proszę mówić po sygnale."),
            SayLine(id: "s121-1", who: "Ty", de: "Hier ist Marek. Ich stehe am Tor drei, die Lieferung ist da.", pl: "Tu Marek. Stoję przy bramie trzy, dostawa jest na miejscu."),
            SayLine(id: "s121-2", who: "Ty", de: "Der Fahrer wartet nur noch fünfzehn Minuten.", pl: "Kierowca czeka jeszcze tylko piętnaście minut."),
            SayLine(id: "s121-3", who: "Ty", de: "Bitte rufen Sie zurück, sonst schicke ich ihn zur Rampe zwei.", pl: "Proszę oddzwonić, inaczej wyślę go na rampę dwa."),
            SayLine(id: "s121-4", who: "Ty", de: "Danke.", pl: "Dziękuję.")
            ],
            words: [
            Gloss(de: "der Anschluss", pl: "numer, linia"),
            Gloss(de: "erreichbar", pl: "osiągalny"),
            Gloss(de: "zurückrufen", pl: "oddzwonić")
            ],
            phrases: ["nach dem Ton", "sonst schicke ich ihn zur Rampe zwei"],
            note: "Na poczcie głosowej mówisz kto, gdzie, co i do kiedy. Inaczej oddzwonienie nic nie daje.",
            question: "Ile kierowca jeszcze czeka?",
            options: ["Piętnaście minut", "Godzinę", "Do jutra"],
            answer: 0,
            replyPL: "Proszę oddzwonić.",
            replyDE: "Bitte rufen Sie zurück."
        ),
        MiniScene(
            id: "s122",
            title: "Kawa po zmianie",
            category: "Umawianie spotkań",
            level: "A1",
            situation: "Umawiasz się z kolegą, ale nie za późno.",
            lines: [
            SayLine(id: "s122-0", who: "Kolega", de: "Kommst du nach der Arbeit noch auf einen Kaffee?", pl: "Wpadniesz po pracy jeszcze na kawę?"),
            SayLine(id: "s122-1", who: "Ty", de: "Ja, aber nicht lange. Um neun will ich zu Hause sein.", pl: "Tak, ale niedługo. O dziewiątej chcę być w domu."),
            SayLine(id: "s122-2", who: "Kolega", de: "Dann um halb sieben am Bäcker an der Ecke?", pl: "To o wpół do siódmej przy piekarni na rogu?"),
            SayLine(id: "s122-3", who: "Ty", de: "Passt. Wenn der Bus sich verspätet, schreibe ich.", pl: "Pasuje. Jak autobus się spóźni, napiszę."),
            SayLine(id: "s122-4", who: "Kolega", de: "Alles klar. Bis nachher.", pl: "Jasne. Do później.")
            ],
            words: [
            Gloss(de: "nachher", pl: "później dziś"),
            Gloss(de: "sich verspäten", pl: "spóźnić się"),
            Gloss(de: "die Ecke", pl: "róg")
            ],
            phrases: ["nicht lange", "Bis nachher."],
            note: "Halb sieben to 18:30. Bis nachher żegnasz się, kiedy widzicie się tego samego dnia.",
            question: "O której się umawiacie?",
            options: ["O wpół do siódmej", "O dziewiątej w domu", "Przed zmianą o piątej"],
            answer: 0,
            replyPL: "Wpadnę na kawę, ale niedługo.",
            replyDE: "Ich komme auf einen Kaffee, aber nicht lange."
        ),
        MiniScene(
            id: "s123",
            title: "Przesunięcie o tydzień",
            category: "Umawianie spotkań",
            level: "B2",
            situation: "Odbiór wypada w dniu, kiedy jesteś u lekarza, i chcesz nowy termin.",
            lines: [
            SayLine(id: "s123-0", who: "Ty", de: "Den Termin am Donnerstag muss ich schieben. Da bin ich beim Arzt, und den kann ich nicht verschieben.", pl: "Termin w czwartek muszę przesunąć. Jestem wtedy u lekarza i tej wizyty nie przesunę."),
            SayLine(id: "s123-1", who: "Kierownik", de: "Nächste Woche Dienstag, gleiche Uhrzeit?", pl: "W następny wtorek, ta sama godzina?"),
            SayLine(id: "s123-2", who: "Ty", de: "Dienstag geht, wenn wir vor zehn anfangen. Danach kommt der Beton.", pl: "Wtorek pasuje, jeśli zaczniemy przed dziesiątą. Potem przyjeżdża beton."),
            SayLine(id: "s123-3", who: "Kierownik", de: "Neun Uhr fünfzehn. Ich verschiebe ihn und schicke die Einladung neu.", pl: "Dziewiąta piętnaście. Przesuwam go i wysyłam zaproszenie od nowa."),
            SayLine(id: "s123-4", who: "Ty", de: "Danke. Bitte den alten Termin löschen, sonst stehen beide im Kalender.", pl: "Dzięki. Proszę skasować stary termin, bo inaczej oba będą w kalendarzu."),
            SayLine(id: "s123-5", who: "Kierownik", de: "Ist gelöscht. Sie bekommen nur noch den neuen.", pl: "Skasowany. Dostanie pan już tylko nowy.")
            ],
            words: [
            Gloss(de: "schieben", pl: "przesunąć potocznie"),
            Gloss(de: "verschieben", pl: "przesunąć"),
            Gloss(de: "löschen", pl: "usunąć")
            ],
            phrases: ["den Termin schieben", "den alten Termin löschen"],
            note: "Schieben przy terminie jest potoczne i normalne w biurze budowy. Officjalnie verschieben.",
            question: "Na kiedy przenosicie odbiór?",
            options: ["Na wtorek o 9:15", "Na ten sam czwartek później", "Na przyszły miesiąc"],
            answer: 0,
            replyPL: "Muszę przesunąć termin.",
            replyDE: "Ich muss den Termin verschieben."
        ),
        MiniScene(
            id: "s124",
            title: "Basen po pracy",
            category: "Wolny czas",
            level: "A2",
            situation: "Chcesz popływać, ale kasjer pyta o bilet jednorazowy.",
            lines: [
            SayLine(id: "s124-0", who: "Ty", de: "Einmal schwimmen, bitte. Wie lange darf ich bleiben?", pl: "Poproszę jednorazowy basen. Jak długo mogę zostać?"),
            SayLine(id: "s124-1", who: "Kasa", de: "Bis zum Ende, heute bis zweiundzwanzig Uhr.", pl: "Do końca, dziś do dwudziestej drugiej."),
            SayLine(id: "s124-2", who: "Ty", de: "Gibt es einen Spind für den Helm? Der darf nicht nass werden.", pl: "Jest szafka na kask? Nie może zmoknąć."),
            SayLine(id: "s124-3", who: "Kasa", de: "Die Schränke sind links. Eine Münze als Pfand.", pl: "Szafki są po lewej. Moneta jako zastaw."),
            SayLine(id: "s124-4", who: "Ty", de: "Gut. Die Münze habe ich.", pl: "Dobrze. Monetę mam.")
            ],
            words: [
            Gloss(de: "schwimmen", pl: "pływać"),
            Gloss(de: "der Spind", pl: "szafka"),
            Gloss(de: "das Pfand", pl: "zastaw")
            ],
            phrases: ["bis zweiundzwanzig Uhr", "eine Münze als Pfand"],
            note: "Pfand to zastaw, tak samo przy wózku i butelce. Tu zostawiasz monetę, żeby dostać klucz.",
            question: "Do której jest basen?",
            options: ["Do dwudziestej drugiej", "Tylko godzinę od wejścia", "Do południa"],
            answer: 0,
            replyPL: "Poproszę jednorazowe pływanie.",
            replyDE: "Einmal schwimmen, bitte."
        ),
        MiniScene(
            id: "s125",
            title: "Jarmark w sobotę",
            category: "Wolny czas",
            level: "B1",
            situation: "Kolega ciągnie cię na jarmark, a ty chcesz wrócić przed ciszą nocną.",
            lines: [
            SayLine(id: "s125-0", who: "Kolega", de: "Samstag ist Markt in der Altstadt. Kommst du mit?", pl: "W sobotę jest jarmark na starówce. Idziesz?"),
            SayLine(id: "s125-1", who: "Ty", de: "Ja, aber ich will vor zehn wieder zu Hause sein.", pl: "Tak, ale chcę być z powrotem w domu przed dziesiątą."),
            SayLine(id: "s125-2", who: "Kolega", de: "Wieso so früh? Der läuft bis elf.", pl: "Czemu tak wcześnie? Trwa do jedenastej."),
            SayLine(id: "s125-3", who: "Ty", de: "Sonntag um sechs fängt meine Schicht an. Und ich will die Bahn noch kriegen.", pl: "W niedzielę o szóstej zaczyna mi się zmiana. I chcę jeszcze złapać kolejkę."),
            SayLine(id: "s125-4", who: "Kolega", de: "Okay, dann treffen wir uns um vier am Brunnen und gehen um neun.", pl: "Dobra, to spotykamy się o czwartej przy fontannie i idziemy o dziewiątej.")
            ],
            words: [
            Gloss(de: "der Markt", pl: "jarmark"),
            Gloss(de: "die Altstadt", pl: "starówka"),
            Gloss(de: "die Bahn kriegen", pl: "złapać kolejkę")
            ],
            phrases: ["vor zehn zu Hause", "die Bahn noch kriegen"],
            note: "Kriegen jest potoczne zamiast bekommen. Die Bahn kriegen to zdążyć na nią.",
            question: "O której wychodzicie z jarmarku?",
            options: ["O dziewiątej", "O jedenastej", "Zostajecie na noc"],
            answer: 0,
            replyPL: "Chcę być w domu przed dziesiątą.",
            replyDE: "Ich will vor zehn zu Hause sein."
        ),
        MiniScene(
            id: "s126",
            title: "Mecz z ekipą",
            category: "Sport",
            level: "A2",
            situation: "Grają po zmianie i brakuje jednej osoby.",
            lines: [
            SayLine(id: "s126-0", who: "Kolega", de: "Uns fehlt einer. Spielst du heute mit?", pl: "Brakuje nam jednego. Grasz dziś?"),
            SayLine(id: "s126-1", who: "Ty", de: "Wie lange? Ich habe morgen früh Schicht.", pl: "Jak długo? Jutro rano mam zmianę."),
            SayLine(id: "s126-2", who: "Kolega", de: "Eine Stunde, lockeres Tempo, kein Turnier.", pl: "Godzina, luźne tempo, to nie turniej."),
            SayLine(id: "s126-3", who: "Ty", de: "Dann ja. Ich bringe eigene Schuhe mit, die auf dem Platz sind nass.", pl: "To tak. Przyniosę własne buty, te na boisku są mokre."),
            SayLine(id: "s126-4", who: "Kolega", de: "Gut. Um achtzehn Uhr an der Halle, nicht auf dem Rasen.", pl: "Dobrze. O osiemnastej przy hali, nie na trawie.")
            ],
            words: [
            Gloss(de: "fehlen", pl: "brakować"),
            Gloss(de: "die Halle", pl: "hala"),
            Gloss(de: "der Rasen", pl: "trawa, boisko")
            ],
            phrases: ["Uns fehlt einer.", "nicht auf dem Rasen"],
            note: "Fehlen działa odwrotnie niż po polsku: uns fehlt einer, dosłownie nam brakuje jednego.",
            question: "Gdzie gracie?",
            options: ["Przy hali", "Na mokrej trawie", "Na budowie"],
            answer: 0,
            replyPL: "Gram dziś godzinę.",
            replyDE: "Ich spiele heute eine Stunde mit."
        ),
        MiniScene(
            id: "s127",
            title: "Karnet na miesiąc",
            category: "Sport",
            level: "B1",
            situation: "Nie chcesz rocznej umowy, bo nie wiesz, jak długo będzie kontrakt.",
            lines: [
            SayLine(id: "s127-0", who: "Ty", de: "Ich hätte gern eine Karte, aber nur monatlich, nicht für ein Jahr.", pl: "Chciałbym karnet, ale tylko miesięczny, nie na rok."),
            SayLine(id: "s127-1", who: "Recepcja", de: "Monatlich können Sie bis zum Dritten kündigen, sonst verlängert er sich.", pl: "Miesięczny może pan wypowiedzieć do trzeciego, inaczej sam się przedłuży."),
            SayLine(id: "s127-2", who: "Ty", de: "Und wenn ich Nachtschicht habe, geht der Tag verloren?", pl: "A jak mam nocną zmianę, dzień przepada?"),
            SayLine(id: "s127-3", who: "Recepcja", de: "Nein. Die Karte gilt den ganzen Kalendertag, auch früh um fünf.", pl: "Nie. Karnet jest ważny cały dzień kalendarzowy, także o piątej rano."),
            SayLine(id: "s127-4", who: "Ty", de: "Dann nehme ich den Monatsvertrag. Jahresbindung will ich nicht.", pl: "To biorę umowę miesięczną. Rocznego wiązania nie chcę.")
            ],
            words: [
            Gloss(de: "monatlich", pl: "miesięcznie"),
            Gloss(de: "kündigen", pl: "wypowiedzieć"),
            Gloss(de: "die Jahresbindung", pl: "wiązanie na rok")
            ],
            phrases: ["nur monatlich", "bis zum Dritten kündigen"],
            note: "Sonst verlängert er sich: sam się przedłuży. Dlatego data wypowiedzenia jest ważniejsza niż sam karnet.",
            question: "Do kiedy możesz wypowiedzieć miesiąc?",
            options: ["Do trzeciego", "W dowolnym dniu", "Tylko w grudniu"],
            answer: 0,
            replyPL: "Chcę karnet tylko na miesiąc.",
            replyDE: "Ich möchte die Karte nur monatlich."
        ),
        MiniScene(
            id: "s128",
            title: "Za gorąco na placu",
            category: "Pogoda",
            level: "A1",
            situation: "W południe nie da się lać betonu bez przerwy na wodę.",
            lines: [
            SayLine(id: "s128-0", who: "Ty", de: "Es ist zu heiß. Ich brauche Wasser.", pl: "Jest za gorąco. Potrzebuję wody."),
            SayLine(id: "s128-1", who: "Szef", de: "Im Schatten stehen die Flaschen. Trink erst, dann weiter.", pl: "W cieniu stoją butelki. Najpierw pij, potem dalej."),
            SayLine(id: "s128-2", who: "Ty", de: "Wie lange Pause?", pl: "Jak długa przerwa?"),
            SayLine(id: "s128-3", who: "Szef", de: "Zehn Minuten. Um eins machen wir länger.", pl: "Dziesięć minut. O pierwszej zrobimy dłuższą."),
            SayLine(id: "s128-4", who: "Ty", de: "Okay. Den Helm lasse ich auf.", pl: "Dobrze. Kasku nie zdejmuję.")
            ],
            words: [
            Gloss(de: "zu heiß", pl: "za gorąco"),
            Gloss(de: "der Schatten", pl: "cień"),
            Gloss(de: "die Flasche", pl: "butelka")
            ],
            phrases: ["Es ist zu heiß.", "Trink erst, dann weiter."],
            note: "Erst, dann to najpierw, potem. Prosty szyk, którego na budowie słyszysz cały dzień.",
            question: "Co robisz najpierw?",
            options: ["Pijesz wodę", "Zdejmujesz kask", "Jedziesz do domu"],
            answer: 0,
            replyPL: "Jest za gorąco.",
            replyDE: "Es ist zu heiß."
        ),
        MiniScene(
            id: "s129",
            title: "Burza nad placem",
            category: "Pogoda",
            level: "B1",
            situation: "Niebo ciemnieje i nie chcecie zostać na rusztowaniu.",
            lines: [
            SayLine(id: "s129-0", who: "Ty", de: "Das zieht schwarz auf. Ich gehe nicht mehr hoch.", pl: "Zbiera się na czarno. Już nie wchodzę na górę."),
            SayLine(id: "s129-1", who: "Szef", de: "Einverstanden. Wir sichern die Plane und dann runter.", pl: "Zgoda. Mocujemy plandekę i na dół."),
            SayLine(id: "s129-2", who: "Kolega", de: "Der Wind hebt die Ecke schon an.", pl: "Wiatr już podnosi róg."),
            SayLine(id: "s129-3", who: "Ty", de: "Ich halte sie. Bind du die Seite fest, bevor es knallt.", pl: "Trzymam ją. Ty zwiąż bok, zanim walnie."),
            SayLine(id: "s129-4", who: "Szef", de: "Fertig. Ab in den Container, bis das durch ist.", pl: "Gotowe. Do kontenera, aż to przejdzie.")
            ],
            words: [
            Gloss(de: "die Plane", pl: "plandeka"),
            Gloss(de: "sichern", pl: "zabezpieczyć"),
            Gloss(de: "der Wind", pl: "wiatr")
            ],
            phrases: ["nicht mehr hoch", "Ab in den Container."],
            note: "Ab in den Container to potoczne: jazda do kontenera. Nie budujesz tu pełnego zdania i tak mówią.",
            question: "Gdzie czekacie na burzę?",
            options: ["W kontenerze", "Na rusztowaniu", "W otwartym wykopie"],
            answer: 0,
            replyPL: "Nie wchodzę już na górę.",
            replyDE: "Ich gehe nicht mehr hoch."
        ),
        MiniScene(
            id: "s130",
            title: "Zła reszta",
            category: "Problemy i reklamacje",
            level: "A1",
            situation: "Dostałeś za mało reszty i widzisz to od razu.",
            lines: [
            SayLine(id: "s130-0", who: "Ty", de: "Entschuldigung, die Rückgabe stimmt nicht.", pl: "Przepraszam, reszta się nie zgadza."),
            SayLine(id: "s130-1", who: "Kasjer", de: "Was fehlt?", pl: "Czego brakuje?"),
            SayLine(id: "s130-2", who: "Ty", de: "Zwei Euro. Ich habe mit zwanzig gezahlt, nicht mit zehn.", pl: "Dwóch euro. Płaciłem dwudziestką, nie dziesiątką."),
            SayLine(id: "s130-3", who: "Kasjer", de: "Stimmt. Hier sind die zwei Euro. Tut mir leid.", pl: "Zgadza się. Tu są dwa euro. Przepraszam."),
            SayLine(id: "s130-4", who: "Ty", de: "Danke. Passt jetzt.", pl: "Dzięki. Teraz się zgadza.")
            ],
            words: [
            Gloss(de: "die Rückgabe", pl: "reszta, zwrot pieniędzy"),
            Gloss(de: "stimmen", pl: "zgadzać się"),
            Gloss(de: "fehlen", pl: "brakować")
            ],
            phrases: ["Die Rückgabe stimmt nicht.", "Passt jetzt."],
            note: "Stimmt nicht mówisz, kiedy kwota albo rachunek się nie zgadza. Krócej niż das ist falsch.",
            question: "Czego brakuje w reszcie?",
            options: ["Dwóch euro", "Dwudziestu euro", "Paragonu"],
            answer: 0,
            replyPL: "Reszta się nie zgadza.",
            replyDE: "Die Rückgabe stimmt nicht."
        ),
        MiniScene(
            id: "s131",
            title: "Zimna woda w czynszu",
            category: "Problemy i reklamacje",
            level: "B2",
            situation: "Drugi miesiąc płacisz za ciepłą wodę, a z kranu leci zimna.",
            lines: [
            SayLine(id: "s131-0", who: "Ty", de: "Ich zahle seit zwei Monaten die Warmmiete, aber morgens kommt nur kaltes Wasser.", pl: "Od dwóch miesięcy płacę czynsz z ogrzewaniem, a rano leci tylko zimna woda."),
            SayLine(id: "s131-1", who: "Zarządca", de: "Haben Sie die Zeiten notiert?", pl: "Notował pan godziny?"),
            SayLine(id: "s131-2", who: "Ty", de: "Ja. Drei Morgen hintereinander, jeweils bis halb acht lauwarm, danach kalt.", pl: "Tak. Trzy poranki z rzędu, za każdym razem do wpół do ósmej letnia, potem zimna."),
            SayLine(id: "s131-3", who: "Zarządca", de: "Dann kürzen wir den Abschlag nicht einfach so. Zuerst prüft der Techniker am Donnerstag.", pl: "Nie obniżymy więc zaliczki ot tak. Najpierw w czwartek sprawdzi technik."),
            SayLine(id: "s131-4", who: "Ty", de: "Einverstanden, wenn der Besuch schriftlich kommt. Mündlich reicht mir nicht mehr.", pl: "Zgoda, jeśli wizyta będzie na piśmie. Ustne już mi nie wystarcza."),
            SayLine(id: "s131-5", who: "Zarządca", de: "Sie bekommen heute die Mail mit Uhrzeit.", pl: "Dostanie pan dziś maila z godziną.")
            ],
            words: [
            Gloss(de: "die Warmmiete", pl: "czynsz z opłatami"),
            Gloss(de: "der Abschlag", pl: "zaliczka"),
            Gloss(de: "kürzen", pl: "obniżyć, uciąć")
            ],
            phrases: ["nur kaltes Wasser", "schriftlich, nicht nur mündlich"],
            note: "Nicht mehr po czasowniku wzmacnia: już nie. Mündlich reicht nicht mehr to koniec obietnic słownych.",
            question: "Czego żądasz oprócz wizyty technika?",
            options: ["Potwierdzenia na piśmie", "Od razu zwrotu całego czynszu", "Nowego mieszkania"],
            answer: 0,
            replyPL: "Rano leci tylko zimna woda.",
            replyDE: "Morgens kommt nur kaltes Wasser."
        ),
        MiniScene(
            id: "s132",
            title: "Ciemno w piwnicy",
            category: "Awaryjne sytuacje",
            level: "A2",
            situation: "Światło pada w połowie schodów i masz tam rower.",
            lines: [
            SayLine(id: "s132-0", who: "Ty", de: "Im Keller ist das Licht aus. Die Treppe ist stockdunkel.", pl: "W piwnicy nie ma światła. Schody są całkiem ciemne."),
            SayLine(id: "s132-1", who: "Sąsiad", de: "Die Lampe spinnt seit gestern. Hast du eine Taschenlampe?", pl: "Lampa wariuje od wczoraj. Masz latarkę?"),
            SayLine(id: "s132-2", who: "Ty", de: "Nur die vom Handy. Ich hole das Fahrrad und komme sofort hoch.", pl: "Tylko tę z telefonu. Biorę rower i zaraz wracam na górę."),
            SayLine(id: "s132-3", who: "Sąsiad", de: "Ich halte die Tür auf. Fass die Leitung nicht an, die hängt lose.", pl: "Potrzymam drzwi. Nie dotykaj przewodu, wisi luzem."),
            SayLine(id: "s132-4", who: "Ty", de: "Mache ich nicht. Danke, dass du wartest.", pl: "Nie dotykam. Dzięki, że czekasz.")
            ],
            words: [
            Gloss(de: "stockdunkel", pl: "ciemno choć oko wykol"),
            Gloss(de: "die Taschenlampe", pl: "latarka"),
            Gloss(de: "die Leitung", pl: "przewód")
            ],
            phrases: ["Fass nicht an die Leitung.", "stockdunkel"],
            note: "Spinnt to potoczne: wariuje, nie działa jak trzeba. Przy rzeczy, nie przy człowieku, jest zwykłe.",
            question: "Czego nie dotykasz?",
            options: ["Luźnego przewodu", "Roweru", "Drzwi"],
            answer: 0,
            replyPL: "W piwnicy jest całkiem ciemno.",
            replyDE: "Im Keller ist es stockdunkel."
        ),
        MiniScene(
            id: "s133",
            title: "Zapach gazu",
            category: "Awaryjne sytuacje",
            level: "B2",
            situation: "Na klatce czuć gaz i ktoś chce zapalić światło.",
            lines: [
            SayLine(id: "s133-0", who: "Ty", de: "Stopp. Hier riecht es nach Gas. Kein Licht einschalten.", pl: "Stop. Tu czuć gaz. Nie włączać światła."),
            SayLine(id: "s133-1", who: "Sąsiad", de: "Sicher? Ich rieche es auch, schwach, aber deutlich.", pl: "Na pewno? Też czuję, słabo, ale wyraźnie."),
            SayLine(id: "s133-2", who: "Ty", de: "Fenster auf, kein Schalter, kein Handy hier im Flur. Wir gehen raus und rufen von draußen an.", pl: "Okna otworzyć, żadnego włącznika, żadnego telefonu tu na klatce. Wychodzimy i dzwonimy z dworu."),
            SayLine(id: "s133-3", who: "Sąsiad", de: "Wen rufen wir, die Feuerwehr oder den Versorger?", pl: "Do kogo dzwonimy, straż czy dostawcę?"),
            SayLine(id: "s133-4", who: "Ty", de: "Bei Gasgeruch die Feuerwehr, 112. Den Versorger können die nachziehen.", pl: "Przy zapachu gazu straż, 112. Dostawcę mogą dociągnąć oni."),
            SayLine(id: "s133-5", who: "Sąsiad", de: "Okay. Ich klopfe noch bei Müller und dann sind wir draußen.", pl: "Dobrze. Zapukam jeszcze do Müllera i jesteśmy na zewnątrz.")
            ],
            words: [
            Gloss(de: "der Gasgeruch", pl: "zapach gazu"),
            Gloss(de: "der Schalter", pl: "włącznik"),
            Gloss(de: "die Feuerwehr", pl: "straż pożarna")
            ],
            phrases: ["Kein Licht einschalten.", "112"],
            note: "Nach Gas riechen: czuć gaz. Przy podejrzeniu nie sprawdzasz zapalniczką i nie gapisz się przy włączniku.",
            question: "Skąd dzwonicie?",
            options: ["Z dworu, na 112", "Z klatki, telefonem przy skrzynce", "Do szefa na budowę"],
            answer: 0,
            replyPL: "Tu czuć gaz.",
            replyDE: "Hier riecht es nach Gas."
        ),
        MiniScene(
            id: "s134",
            title: "Przesiadka",
            category: "Podróże",
            level: "A1",
            situation: "Masz sześć minut i nie wiesz, czy peron jest obok.",
            lines: [
            SayLine(id: "s134-0", who: "Ty", de: "Ich muss umsteigen. Wo ist Gleis neun?", pl: "Muszę się przesiąść. Gdzie jest tor dziewięć?"),
            SayLine(id: "s134-1", who: "Podróżny", de: "Eine Etage tiefer, dann rechts.", pl: "Piętro niżej, potem w prawo."),
            SayLine(id: "s134-2", who: "Ty", de: "Schaffe ich das in sechs Minuten?", pl: "Zdam w sześć minut?"),
            SayLine(id: "s134-3", who: "Podróżny", de: "Ja, wenn Sie die Treppe nehmen und nicht den Aufzug.", pl: "Tak, jeśli pan weźmie schody, a nie windę."),
            SayLine(id: "s134-4", who: "Ty", de: "Danke. Dann laufe ich.", pl: "Dzięki. To biegnę.")
            ],
            words: [
            Gloss(de: "umsteigen", pl: "przesiąść się"),
            Gloss(de: "das Gleis", pl: "tor"),
            Gloss(de: "der Aufzug", pl: "winda")
            ],
            phrases: ["Wo ist Gleis neun?", "nicht den Aufzug"],
            note: "Schaffen to zdążyć, dać radę. Pytanie schaffen Sie das jest bardzo codzienne.",
            question: "Jak zdążysz na przesiadkę?",
            options: ["Schodami, nie windą", "Windą z walizką", "Zostajesz w tym pociągu"],
            answer: 0,
            replyPL: "Gdzie jest tor dziewięć?",
            replyDE: "Wo ist Gleis neun?"
        ),
        MiniScene(
            id: "s135",
            title: "Zagubiona torba",
            category: "Podróże",
            level: "B2",
            situation: "Na taśmie nie ma torby z narzędziami pomiarowymi.",
            lines: [
            SayLine(id: "s135-0", who: "Ty", de: "Mein Koffer ist nicht auf dem Band. Darin ist Messgerät, das ich morgen früh brauche.", pl: "Mojej walizki nie ma na taśmie. W środku jest sprzęt pomiarowy, którego potrzebuję jutro rano."),
            SayLine(id: "s135-1", who: "Obsługa", de: "Füllen Sie das Formular aus. Farbe, Marke, und woran man ihn erkennt.", pl: "Proszę wypełnić formularz. Kolor, marka i po czym go poznać."),
            SayLine(id: "s135-2", who: "Ty", de: "Schwarz, hart, ein rotes Band am Griff. Der Inhalt ist kein normales Gepäck.", pl: "Czarna, twarda, czerwona tasiemka na uchwycie. Zawartość to nie zwykły bagaż."),
            SayLine(id: "s135-3", who: "Obsługa", de: "Wenn er heute Nacht noch ankommt, liefern wir ihn an die Adresse. Sonst Ersatz erst nach Prüfung.", pl: "Jak przyjdzie jeszcze dziś w nocy, dowieziemy go na adres. Inaczej odszkodowanie dopiero po sprawdzeniu."),
            SayLine(id: "s135-4", who: "Ty", de: "Bitte an die Baustellenadresse, nicht an die alte Wohnung. Die steht noch in der Buchung.", pl: "Proszę na adres budowy, nie na stare mieszkanie. Ono nadal jest w rezerwacji."),
            SayLine(id: "s135-5", who: "Obsługa", de: "Ich ändere das. Die Nummer zum Nachfragen steht auf dem Beleg.", pl: "Zmieniam. Numer do dopytania jest na potwierdzeniu.")
            ],
            words: [
            Gloss(de: "das Messgerät", pl: "sprzęt pomiarowy"),
            Gloss(de: "der Beleg", pl: "potwierdzenie"),
            Gloss(de: "nachfragen", pl: "dopytać")
            ],
            phrases: ["nicht auf dem Band", "an die Baustellenadresse"],
            note: "Woran man ihn erkennt wysyła czasownik na koniec. To pytanie zależne, nie woran erkennt man ihn w środku zdania.",
            question: "Gdzie ma dojechać walizka?",
            options: ["Na adres budowy", "Na stare mieszkanie", "Zostaje na lotnisku"],
            answer: 0,
            replyPL: "Walizki nie ma na taśmie.",
            replyDE: "Der Koffer ist nicht auf dem Band."
        ),
        MiniScene(
            id: "s136",
            title: "Cisza w południe",
            category: "Niemieckie życie codzienne",
            level: "A2",
            situation: "W sobotę chcesz ciąć deskę i sąsiad przypomina o ciszy.",
            lines: [
            SayLine(id: "s136-0", who: "Sąsiad", de: "Samstag zwischen dreizehn und fünfzehn Uhr ist hier Mittagsruhe.", pl: "W sobotę między trzynastą a piętnastą jest tu cisza południowa."),
            SayLine(id: "s136-1", who: "Ty", de: "Gilt das auch für eine Handkreissäge draußen?", pl: "To dotyczy też ręcznej piły na dworze?"),
            SayLine(id: "s136-2", who: "Sąsiad", de: "Gerade dafür. Leise Arbeit im Haus geht, die Säge nicht.", pl: "Właśnie tego. Cicha robota w domu może być, piła nie."),
            SayLine(id: "s136-3", who: "Ty", de: "Dann warte ich bis drei. Ich wusste das nicht.", pl: "To poczekam do trzeciej. Nie wiedziałem."),
            SayLine(id: "s136-4", who: "Sąsiad", de: "Alles gut. Nach drei stört es niemanden.", pl: "W porządku. Po trzeciej nikomu to nie przeszkadza.")
            ],
            words: [
            Gloss(de: "die Mittagsruhe", pl: "cisza południowa"),
            Gloss(de: "die Säge", pl: "piła"),
            Gloss(de: "gelten", pl: "obowiązywać")
            ],
            phrases: ["zwischen dreizehn und fünfzehn Uhr", "bis drei warten"],
            note: "Mittagsruhe nie jest prawem całego kraju w jednym brzmieniu, ale w wielu domach i landach tak się żyje. Pytasz, zamiast się kłócić.",
            question: "Kiedy możesz ciąć?",
            options: ["Po piętnastej", "Między trzynastą a piętnastą", "Tylko w niedzielę rano"],
            answer: 0,
            replyPL: "Poczekam do trzeciej.",
            replyDE: "Ich warte bis drei."
        ),
        MiniScene(
            id: "s137",
            title: "Wezwanie z urzędu",
            category: "Niemieckie życie codzienne",
            level: "B2",
            situation: "W skrzynce jest list z terminem i nie chcesz go przegapić.",
            lines: [
            SayLine(id: "s137-0", who: "Ty", de: "Ich habe ein Schreiben vom Amt. Der Termin ist in zehn Tagen, aber ich bin auf Montage.", pl: "Mam pismo z urzędu. Termin jest za dziesięć dni, a ja jestem na wyjeździe służbowym."),
            SayLine(id: "s137-1", who: "Koleżanka", de: "Ignorieren darfst du das nicht. Die Frist läuft trotzdem.", pl: "Nie wolno ci tego zignorować. Termin i tak biegnie."),
            SayLine(id: "s137-2", who: "Ty", de: "Ich will schriftlich um Verlegung bitten, mit dem Einsatzplan als Nachweis.", pl: "Chcę pisemnie poprosić o przeniesienie, z grafikiem jako dowodem."),
            SayLine(id: "s137-3", who: "Koleżanka", de: "Mach das diese Woche. Ruf vorher an und schick dieselbe Begründung per Mail.", pl: "Zrób to w tym tygodniu. Najpierw zadzwoń i wyślij to samo uzasadnienie mailem."),
            SayLine(id: "s137-4", who: "Ty", de: "Und wenn sie nein sagen, fahre ich nachts zurück. Ein Versäumnis wird teuer.", pl: "A jak powiedzą nie, wrócę w nocy. Ominięcie wychodzi drogo."),
            SayLine(id: "s137-5", who: "Koleżanka", de: "Genau. Heb den Brief auf, nicht nur das Foto.", pl: "Dokładnie. Zachowaj list, nie tylko zdjęcie.")
            ],
            words: [
            Gloss(de: "das Schreiben", pl: "pismo"),
            Gloss(de: "die Frist", pl: "termin ustawowy"),
            Gloss(de: "die Verlegung", pl: "przeniesienie terminu")
            ],
            phrases: ["nicht ignorieren", "schriftlich um Verlegung bitten"],
            note: "Trotzdem znaczy mimo to. Frist läuft trotzdem: nawet na wyjeździe czas się nie zatrzymuje.",
            question: "Co robisz z pismem?",
            options: ["Prosisz o przeniesienie i zostawiasz oryginał", "Wyrzucasz kopertę", "Czekasz aż termin minie"],
            answer: 0,
            replyPL: "Nie wolno tego zignorować.",
            replyDE: "Das darf ich nicht ignorieren."
        )
    ]
}
