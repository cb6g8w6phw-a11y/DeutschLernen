import Foundation

enum ListenMake {
    static func d(_ title: String, _ audio: String, _ ask: String, _ a: String, _ b: String, _ c: String, _ pl: String) -> Drill {
        Drill(title: title, audio: audio, ask: ask, options: [a, b, c], answer: 0, de: audio, pl: pl)
    }
}

enum LifeListen {
    static let groups: [(String, [(String, [Drill])])] = [
        ("Załatwianie", [
            ("Sklep", sklep),
            ("Reklamacja", reklamacja)
        ]),
        ("Zdrowie", [
            ("Lekarz", lekarz),
            ("Apteka", apteka)
        ]),
        ("Dzień", [
            ("Dojazd", dojazd),
            ("Warsztat", warsztat),
            ("Sąsiad", sasiad),
            ("Znajomi", znajomi)
        ])
    ]

    private static let sklep: [Drill] = [
        ListenMake.d("Wymiana", "Ich möchte das umtauschen. Ich habe den Bon.", "Co chcesz?", "Wymienić towar, masz paragon", "Kupić bilet", "Wezwać lekarza", "Chcę to wymienić. Mam paragon."),
        ListenMake.d("Mleko", "Wo steht die Milch?", "O co pytasz?", "Gdzie jest mleko", "Gdzie jest dworzec", "Gdzie jest młotek", "Gdzie stoi mleko?"),
        ListenMake.d("Pieczywo", "Ich nehme das Brot und sechs Eier.", "Co bierzesz?", "Chleb i sześć jajek", "Tylko wodę", "Dwa kilo gwoździ", "Biorę chleb i sześć jajek."),
        ListenMake.d("Karta", "Kann ich mit Karte zahlen?", "O co pytasz?", "Czy możesz zapłacić kartą", "Czy możesz wziąć auto na raty", "Czy możesz wejść bez kasku", "Czy mogę zapłacić kartą?"),
        ListenMake.d("Rozmiar", "Haben Sie das in Größe L?", "O co pytasz?", "Czy jest rozmiar L", "Czy jest bilet do Berlina", "Czy jest zwolnienie", "Czy ma pan to w rozmiarze L?"),
        ListenMake.d("Cena", "Das ist mir zu teuer. Haben Sie etwas Billigeres?", "Co mówisz?", "Za drogo, prosisz o coś tańszego", "To jest za darmo", "To jest za ciężkie na dach", "Za drogo. Ma pan coś tańszego?"),
        ListenMake.d("Torba", "Ich brauche noch eine Tüte.", "Czego potrzebujesz?", "Torby", "Drabiny", "Lekarza", "Potrzebuję jeszcze torby."),
        ListenMake.d("Jabłka", "Zwei Kilo Äpfel, bitte.", "Ile bierzesz?", "Dwa kilo jabłek", "Dwa worki cementu", "Dwa bilety", "Dwa kilo jabłek, poproszę."),
        ListenMake.d("Kasa", "Die Kasse ist hinten rechts.", "Gdzie jest kasa?", "Z tyłu po prawej", "Z przodu po lewej", "Na dworcu", "Kasa jest z tyłu po prawej."),
        ListenMake.d("Chleb", "Haben Sie noch Brot von heute?", "O co pytasz?", "Czy jest dzisiejszy chleb", "Czy jest wczorajszy beton", "Czy jest stara gazeta", "Czy jest jeszcze dzisiejszy chleb?"),
        ListenMake.d("Kurczak", "Ich hätte gern ein Hähnchen, aber nicht vom Grill.", "Co chcesz?", "Kurczaka, nie z grilla", "Kebaba", "Tylko sałatę", "Poproszę kurczaka, ale nie z grilla."),
        ListenMake.d("Pakowanie", "Können Sie das bitte in zwei Tüten packen?", "O co prosisz?", "O spakowanie do dwóch toreb", "O dostawę na budowę", "O wymianę bez paragonu", "Czy może pan to spakować do dwóch toreb?")
    ]

    private static let reklamacja: [Drill] = [
        ListenMake.d("Oddanie", "Das Gerät geht nicht. Ich möchte es zurückgeben.", "O co chodzi?", "Sprzęt nie działa, chcesz oddać", "Szukasz apteki", "Pytasz o autobus", "Sprzęt nie działa. Chcę go oddać."),
        ListenMake.d("Gwarancja", "Der Staubsauger hat noch Garantie. Hier ist der Bon.", "Co mówisz?", "Odkurzacz jest jeszcze na gwarancji, masz paragon", "Odkurzacz jest pożyczony", "Nie masz żadnego dokumentu", "Odkurzacz ma jeszcze gwarancję. Tu jest paragon."),
        ListenMake.d("Dziura", "Das Shirt hat ein Loch. Ich habe es nicht getragen.", "Jaki problem?", "W koszulce jest dziura, nie nosiłeś jej", "Koszulka jest tylko za długa", "Koszulka jest z budowy", "W koszulce jest dziura. Nie nosiłem jej."),
        ListenMake.d("Pieniądze", "Ich will mein Geld zurück, nicht einen Gutschein.", "Czego chcesz?", "Zwrotu pieniędzy, nie bonu", "Wymiany na większy rozmiar", "Nowej gwarancji bez zwrotu", "Chcę zwrot pieniędzy, nie bon."),
        ListenMake.d("Akumulator", "Der Akku hält nur zehn Minuten.", "Co jest nie tak?", "Akumulator działa tylko dziesięć minut", "Akumulator jest za ciężki", "Brakuje tylko instrukcji", "Akumulator trzyma tylko dziesięć minut."),
        ListenMake.d("Wczoraj", "Gestern gekauft, heute schon kaputt.", "Kiedy się zepsuło?", "Kupione wczoraj, dziś już zepsute", "Zepsute od roku", "Nadal działa", "Kupione wczoraj, dziś już zepsute."),
        ListenMake.d("Kolor", "Die Farbe stimmt nicht. Auf dem Bild war sie blau.", "Co się nie zgadza?", "Kolor, na zdjęciu był niebieski", "Rozmiar buta", "Cena na paragonie jest niższa", "Kolor się nie zgadza. Na zdjęciu był niebieski."),
        ListenMake.d("Serwis", "Können Sie das an die Werkstatt schicken?", "O co prosisz?", "Żeby wysłali to do serwisu", "Żeby to wyrzucili", "Żeby dali drugie bez powodu", "Czy może pan wysłać to do serwisu?"),
        ListenMake.d("Dostawa", "Die Lieferung ist nicht angekommen.", "Co się stało?", "Dostawa nie doszła", "Sam odebrałeś wczoraj", "Paczka jest w twoim aucie", "Dostawa nie doszła."),
        ListenMake.d("Paragon", "Ich habe die Quittung dabei.", "Co masz przy sobie?", "Paragon", "Kask", "Kluczyki od busa", "Mam przy sobie paragon."),
        ListenMake.d("Brak w pudełku", "Das Teil fehlt in der Packung.", "Czego brakuje?", "Części w opakowaniu", "Kasy w sklepie", "Instrukcji po polsku, część jest", "W opakowaniu brakuje części."),
        ListenMake.d("Kierownik", "Ich möchte mit dem Filialleiter sprechen.", "Z kim chcesz rozmawiać?", "Z kierownikiem sklepu", "Z lekarzem", "Z sąsiadem", "Chcę rozmawiać z kierownikiem sklepu.")
    ]

    private static let lekarz: [Drill] = [
        ListenMake.d("Plecy", "Mir tut der Rücken weh. Ich brauche eine Krankschreibung.", "Czego potrzebujesz?", "Zwolnienia, bolą cię plecy", "Nowej opony", "Klucza do mieszkania", "Boli mnie plecy. Potrzebuję zwolnienia."),
        ListenMake.d("Gorączka", "Ich habe seit drei Tagen Fieber.", "Od kiedy?", "Od trzech dni masz gorączkę", "Od rana boli cię tylko ząb", "Od wczoraj kaszlesz raz i już przeszło", "Od trzech dni mam gorączkę."),
        ListenMake.d("Kolano", "Mein Knie ist geschwollen. Ich kann nicht knien.", "Co jest z kolanem?", "Spuchnięte, nie możesz klękać", "Tylko siniak na ręce", "Nic nie boli", "Kolano jest spuchnięte. Nie mogę klękać."),
        ListenMake.d("Skierowanie", "Ich brauche eine Überweisung zum Orthopäden.", "O co prosisz?", "O skierowanie do ortopedy", "O syrop na kaszel", "O godzinę przerwy", "Potrzebuję skierowania do ortopedy."),
        ListenMake.d("Tabletka", "Die Tablette nehme ich morgens und abends.", "Kiedy bierzesz tabletkę?", "Rano i wieczorem", "Tylko w południe", "Raz w tygodniu", "Tabletkę biorę rano i wieczorem."),
        ListenMake.d("Alergia", "Ich bin gegen Penicillin allergisch.", "Co mówisz lekarzowi?", "Że jesteś uczulony na penicylinę", "Że nie bierzesz żadnych leków", "Że alergia jest tylko na pyłek", "Jestem uczulony na penicylinę."),
        ListenMake.d("Noc", "Die Schmerzen sind nachts schlimmer.", "Kiedy boli bardziej?", "W nocy", "Tylko przy jedzeniu", "Wcale", "Ból jest gorszy w nocy."),
        ListenMake.d("Ręka", "Ich kann den Arm nicht heben.", "Czego nie możesz?", "Podnieść ręki", "Mówić", "Spać wcale, ręka jest sprawna", "Nie mogę podnieść ręki."),
        ListenMake.d("Termin", "Haben Sie heute noch einen Termin?", "O co pytasz?", "Czy jest jeszcze dziś termin", "Czy apteka jest otwarta", "Czy bus jedzie", "Czy ma pan jeszcze dziś termin?"),
        ListenMake.d("Zaświadczenie", "Ich brauche die Bescheinigung für die Arbeit.", "Po co ci papier?", "Dla pracy", "Dla warsztatu samochodowego", "Dla szkoły dziecka", "Potrzebuję zaświadczenia do pracy."),
        ListenMake.d("Zawroty", "Mir ist schwindlig, wenn ich aufstehe.", "Co się dzieje?", "Kręci ci się w głowie, gdy wstajesz", "Boli cię tylko ząb", "Masz katar od godziny", "Kręci mi się w głowie, gdy wstaję."),
        ListenMake.d("Do piątku", "Die Krankschreibung gilt bis Freitag.", "Do kiedy zwolnienie?", "Do piątku", "Do poniedziałku", "Tylko na dziś rano", "Zwolnienie jest ważne do piątku.")
    ]

    private static let apteka: [Drill] = [
        ListenMake.d("Gardło", "Haben Sie etwas gegen Halsschmerzen?", "Czego szukasz?", "Czegoś na ból gardła", "Chleba", "Biletu", "Ma pan coś na ból gardła?"),
        ListenMake.d("Maść", "Ich brauche diese Salbe. Hier ist das Rezept.", "Co masz?", "Maść i receptę", "Syrop bez recepty", "Tylko witaminę", "Potrzebuję tej maści. Tu jest recepta."),
        ListenMake.d("Krople", "Wie oft soll ich die Tropfen nehmen?", "O co pytasz?", "Jak często brać krople", "Ile to kosztuje", "Gdzie jest lekarz", "Jak często mam brać krople?"),
        ListenMake.d("Bez recepty", "Haben Sie das Medikament ohne Rezept?", "O co pytasz?", "Czy lek jest bez recepty", "Czy lek jest tylko w szpitalu", "Czy to jest karma dla psa", "Czy ten lek jest bez recepty?"),
        ListenMake.d("Ibuprofen", "Ich bin allergisch gegen Ibuprofen.", "Co zgłaszasz?", "Uczulenie na ibuprofen", "Uczulenie na pył", "Że nie masz alergii", "Jestem uczulony na ibuprofen."),
        ListenMake.d("Puste", "Die Packung von gestern war leer.", "Co mówisz?", "Wczorajsze opakowanie było puste", "Opakowanie jest pełne", "Wczoraj nic nie kupowałeś", "Wczorajsze opakowanie było puste."),
        ListenMake.d("Zapisać", "Können Sie mir aufschreiben, wie ich es nehmen soll?", "O co prosisz?", "Żeby zapisali, jak brać lek", "Żeby zadzwonili do szefa", "Żeby od razu dali zastrzyk", "Czy może pan zapisać, jak mam to brać?"),
        ListenMake.d("Ciśnienie", "Ich nehme schon Blutdrucktabletten.", "Co już bierzesz?", "Tabletki na ciśnienie", "Witaminę C", "Nic", "Już biorę tabletki na ciśnienie."),
        ListenMake.d("Opatrunek", "Haben Sie Verbandszeug für eine kleine Wunde?", "Czego szukasz?", "Opatrunku na małą ranę", "Gipsu na nogę", "Maści tylko na plecy", "Ma pan opatrunek na małą ranę?"),
        ListenMake.d("Dla syna", "Das Fiebermittel ist für meinen Sohn. Er ist sechs.", "Dla kogo lek?", "Dla sześcioletniego syna", "Dla ciebie", "Dla sąsiada", "Lek na gorączkę jest dla mojego syna. Ma sześć lat."),
        ListenMake.d("Tańsza", "Ich möchte die günstigere Packung.", "Którą chcesz?", "Tańsze opakowanie", "Największą, niezależnie od ceny", "Tę z reklamy, bez nazwy", "Chcę tańsze opakowanie."),
        ListenMake.d("Z jedzeniem", "Muss ich die Tabletten zum Essen nehmen?", "O co pytasz?", "Czy tabletki brać z jedzeniem", "Czy wolno je tylko w nocy", "Czy zawsze trzeba je kruszyć", "Czy tabletki mam brać z jedzeniem?")
    ]

    private static let dojazd: [Drill] = [
        ListenMake.d("Spóźnienie", "Der Bus hat Verspätung. Ich bin in zwanzig Minuten da.", "Co mówisz?", "Autobus się spóźnia, będziesz za 20 minut", "Zostajesz w domu", "Nie masz dziś pracy", "Autobus ma opóźnienie. Będę za dwadzieścia minut."),
        ListenMake.d("Który bus", "Welcher Bus fährt zum Bahnhof?", "O co pytasz?", "Który autobus jedzie na dworzec", "Który jedzie prosto na budowę", "Który jest nocny do Polski", "Który autobus jedzie na dworzec?"),
        ListenMake.d("Wysiadam", "Ich steige an der nächsten Haltestelle aus.", "Co robisz?", "Wysiadziesz na następnym przystanku", "Jedziesz do końca trasy", "Przesiadasz się w pociąg za miastem", "Wysiadam na następnym przystanku."),
        ListenMake.d("Odwołany", "Der Zug fällt heute aus.", "Co z pociągiem?", "Dziś jest odwołany", "Jedzie pięć minut wcześniej", "Ma tylko minutę opóźnienia", "Pociąg jest dziś odwołany."),
        ListenMake.d("Bilet", "Eine Fahrkarte in die Stadt, bitte.", "Co kupujesz?", "Bilet do miasta", "Bilet miesięczny na rok", "Bilet dla dziecka do Berlina", "Poproszę bilet do miasta."),
        ListenMake.d("Przesiadka", "Wo muss ich umsteigen?", "O co pytasz?", "Gdzie się przesiąść", "Gdzie jest kasa", "Gdzie jest parking", "Gdzie mam się przesiąść?"),
        ListenMake.d("Trzy minuty", "Mein Anschluss fährt in drei Minuten.", "Ile masz czasu?", "Trzy minuty na przesiadkę", "Pół godziny", "Godzinę", "Moja przesiadka odjeżdża za trzy minuty."),
        ListenMake.d("Awaria", "Die S-Bahn steht. Es gibt eine Störung.", "Czemu stoisz?", "Jest awaria, S-Bahn stoi", "Czekasz na kolegę", "Jesteś na złym peronie, ale pociąg jedzie", "S-Bahn stoi. Jest awaria."),
        ListenMake.d("Aplikacja", "Ich habe mein Ticket in der App.", "Gdzie masz bilet?", "W aplikacji", "Na papierze, który został w domu", "Kupisz go dopiero za chwilę", "Bilet mam w aplikacji."),
        ListenMake.d("Raz na godzinę", "Der Bus kommt nur einmal in der Stunde.", "Jak często jest autobus?", "Raz na godzinę", "Co dziesięć minut", "Co pięć minut", "Autobus przyjeżdża tylko raz na godzinę."),
        ListenMake.d("Peron", "Ist das der richtige Bahnsteig?", "O co pytasz?", "Czy to właściwy peron", "Czy to kasa biletowa", "Czy to autobus numer pięć", "Czy to właściwy peron?"),
        ListenMake.d("Nie zdążę", "Ich schaffe die Frühschicht nicht. Der Bus kam nicht.", "Czemu nie zdążysz?", "Autobus nie przyjechał", "Szef odwołał zmianę", "Jesteś już na miejscu", "Nie zdążę na poranną. Autobus nie przyjechał.")
    ]

    private static let warsztat: [Drill] = [
        ListenMake.d("Stukanie", "Vorne klopft es, wenn ich über ein Schlagloch fahre.", "Co jest z autem?", "Z przodu stuka na dziurze", "Nie ma paliwa", "Jest nowe", "Z przodu stuka, gdy wjadę w dziurę."),
        ListenMake.d("Nie odpala", "Die Batterie ist leer. Er springt nicht an.", "Czemu nie odpala?", "Pusta bateria", "Brak koła", "Zły klucz od mieszkania", "Bateria jest pusta. Nie odpala."),
        ListenMake.d("Opony", "Ich brauche neue Winterreifen.", "Czego potrzebujesz?", "Nowych opon zimowych", "Tylko nowego oleju", "Nowych wycieraczek", "Potrzebuję nowych opon zimowych."),
        ListenMake.d("Hamulce", "Die Bremsen quietschen.", "Co piszczy?", "Hamulce", "Radio", "Drzwi", "Piszczą hamulce."),
        ListenMake.d("Dziś", "Können Sie heute noch draufschauen?", "O co prosisz?", "Żeby dziś jeszcze obejrzeli auto", "Żeby oddali auto bez naprawy", "Żeby pomalowali je na czarno", "Czy może pan jeszcze dziś na to spojrzeć?"),
        ListenMake.d("Olej", "Das Öl ist schwarz. Es muss gewechselt werden.", "Co z olejem?", "Jest czarny, do wymiany", "Jest świeży", "Nie trzeba nic robić", "Olej jest czarny. Trzeba go wymienić."),
        ListenMake.d("Kontrolka", "Die Kontrolleuchte ist an.", "Co się świeci?", "Kontrolka", "Lampka w kabinie", "Kierunkowskaz na sekundę", "Świeci się kontrolka."),
        ListenMake.d("Odbiór", "Ich hole das Auto morgen nach der Schicht ab.", "Kiedy odbierasz?", "Jutro po zmianie", "Dziś w południe", "Za miesiąc", "Odbiorę auto jutro po zmianie."),
        ListenMake.d("Wydech", "Der Auspuff ist durch.", "Co jest uszkodzone?", "Wydech", "Tylko zadrapany zderzak", "Lusterko", "Wydech jest przebity."),
        ListenMake.d("Cena", "Was kostet das ungefähr?", "O co pytasz?", "O przybliżoną cenę", "O godzinę otwarcia", "O numer stanowiska", "Ile to mniej więcej kosztuje?"),
        ListenMake.d("Światło", "Das linke Abblendlicht ist kaputt.", "Co nie działa?", "Lewe światło mijania", "Prawe światło stop", "Klakson", "Lewe światło mijania jest zepsute."),
        ListenMake.d("Zastępcze", "Können Sie mir ein Ersatzauto geben?", "O co prosisz?", "O auto zastępcze", "O taksówkę do Polski", "O rower służbowy", "Czy może pan dać mi auto zastępcze?")
    ]

    private static let sasiad: [Drill] = [
        ListenMake.d("Muzyka", "Können Sie die Musik etwas leiser machen?", "O co prosisz?", "Żeby ściszył muzykę", "Żeby pożyczył wiertarkę", "Żeby otworzył okno", "Czy może pan trochę ściszyć muzykę?"),
        ListenMake.d("Pies", "Ihr Hund bellt seit einer Stunde.", "Co mówisz?", "Pies szczeka od godziny", "Pies jest spokojny", "To radio, nie pies", "Pana pies szczeka od godziny."),
        ListenMake.d("Rower", "Im Flur steht ein Fahrrad. Da darf es nicht stehen.", "O co chodzi?", "Rower stoi na korytarzu, nie wolno", "Rower jest w piwnicy, jak trzeba", "Prosisz o pożyczenie roweru", "Na korytarzu stoi rower. Nie może tam stać."),
        ListenMake.d("Paczka", "Können Sie das Paket für mich annehmen?", "O co prosisz?", "Żeby odebrał twoją paczkę", "Żeby zamówił paczkę", "Żeby wyrzucił paczkę", "Czy może pan odebrać za mnie paczkę?"),
        ListenMake.d("Fachowiec", "Morgen kommt der Handwerker. Er klingelt bei Ihnen, wenn ich nicht da bin.", "Co będzie jutro?", "Fachowiec zadzwoni do sąsiada, jak cię nie będzie", "Sąsiad robi remont u ciebie", "Nikt nie przyjdzie", "Jutro przyjdzie fachowiec. Zadzwoni do pana, jeśli mnie nie będzie."),
        ListenMake.d("Grzejnik", "Die Heizung bei mir ist kalt. Bei Ihnen auch?", "O co pytasz?", "Czy u niego też zimny grzejnik", "Czy u niego jest za gorąco", "Czy sprzedaje termostat", "U mnie grzejnik jest zimny. U pana też?"),
        ListenMake.d("Wiercenie", "Ich bohre nur eine Stunde, dann ist Ruhe.", "Co obiecujesz?", "Godzinę wiercenia, potem spokój", "Hałas przez cały dzień", "Że wcale nie wiercisz", "Wiercę tylko godzinę, potem będzie cisza."),
        ListenMake.d("Sól", "Können Sie mir bis morgen Salz leihen?", "O co prosisz?", "O pożyczenie soli do jutra", "O pożyczenie auta", "O klucz do piwnicy na stałe", "Czy może pan pożyczyć mi sól do jutra?"),
        ListenMake.d("Śmieci", "Der Müll muss bis sieben unten stehen.", "Do której śmieci?", "Do siódmej na dole", "Do południa", "W ogóle nie wystawiać", "Śmieci muszą stać na dole do siódmej."),
        ListenMake.d("Kapie", "Bei mir tropft es von Ihrer Wohnung durch die Decke.", "Co mówisz?", "Że od jego mieszkania kapie ci przez sufit", "Że u ciebie jest sucho", "Że to twój kran, nie jego", "U mnie kapie przez sufit z pana mieszkania."),
        ListenMake.d("Kwiaty", "Ich bin bis Sonntag weg. Können Sie die Blumen gießen?", "O co prosisz?", "Żeby podlewał kwiaty do niedzieli", "Żeby karmił psa", "Żeby odebrał dziecko", "Nie będzie mnie do niedzieli. Czy może pan podlać kwiaty?"),
        ListenMake.d("Piwnica", "Die Tür zum Keller klemmt.", "Co jest z drzwiami?", "Drzwi do piwnicy się zacinają", "Drzwi są otwarte na oścież", "Zamek jest nowy i działa", "Drzwi do piwnicy się zacinają.")
    ]

    private static let znajomi: [Drill] = [
        ListenMake.d("Wieczór", "Hast du heute Abend Zeit?", "O co pyta?", "Czy masz czas wieczorem", "Czy jesteś w pracy", "Czy masz kask", "Masz dziś wieczorem czas?"),
        ListenMake.d("Kawa", "Wollen wir einen Kaffee trinken?", "Co proponuje?", "Kawę", "Piwo na budowie w trakcie roboty", "Wizytę u lekarza", "Napijemy się kawy?"),
        ListenMake.d("Później", "Ich komme eine halbe Stunde später.", "Co mówisz?", "Spóźnisz się pół godziny", "Będziesz wcześniej", "W ogóle nie przyjdziesz", "Przyjdę pół godziny później."),
        ListenMake.d("Dworzec", "Treffen wir uns am Bahnhof?", "Gdzie się spotykacie?", "Na dworcu", "Na budowie", "Pod twoim domem", "Spotkamy się na dworcu?"),
        ListenMake.d("Spacer", "Hast du Lust auf einen Spaziergang?", "Na co cię zaprasza?", "Na spacer", "Na mecz w telewizji", "Do lekarza", "Masz ochotę na spacer?"),
        ListenMake.d("Gotuję", "Ich koche heute. Komm vorbei, wenn du magst.", "Co proponujesz?", "Że gotujesz i może wpaść", "Że idziecie do restauracji", "Że nie masz czasu", "Dziś gotuję. Wpadnij, jeśli chcesz."),
        ListenMake.d("Odbiór", "Kannst du mich vom Training abholen?", "O co prosi?", "Żebyś odebrał go z treningu", "Żebyś zawiózł go na lotnisko", "Żebyś został w domu", "Odbierzesz mnie z treningu?"),
        ListenMake.d("Grill", "Lass uns am Samstag grillen.", "Kiedy grill?", "W sobotę", "W poniedziałek rano", "Dziś w pracy", "Zróbmy grilla w sobotę."),
        ListenMake.d("Zmęczony", "Ich bin müde. Ein andermal, ja?", "Co odpowiadasz?", "Jesteś zmęczony, innym razem", "Chętnie dziś", "Już wychodzisz do niego", "Jestem zmęczony. Innym razem, dobrze?"),
        ListenMake.d("Picie", "Bring bitte etwas zu trinken mit.", "Co masz przynieść?", "Coś do picia", "Ciasto", "Kask", "Weź proszę coś do picia."),
        ListenMake.d("Ósma", "Um acht vor der Kneipe?", "Gdzie i o której?", "O ósmej przed knajpą", "O siódmej na dworcu", "O dziewiątej w pracy", "O ósmej przed knajpą?"),
        ListenMake.d("Napiszę", "Ich schreibe dir, wenn ich losfahre.", "Co zrobisz?", "Napisziesz, jak wyjedziesz", "Zadzwonisz rano do szefa", "Nic nie dasz znać", "Napiszę, jak wyjadę.")
    ]
}

enum WorkListen {
    static func more(_ name: String) -> [Drill] {
        extra[name] ?? []
    }

    private static let extra: [String: [Drill]] = [
        "Polecenia": [
            ListenMake.d("Kontener", "Stell die Palette vor den Container, nicht dahinter.", "Gdzie paleta?", "Przed kontenerem", "Za kontenerem", "Na dachu", "Postaw paletę przed kontenerem, nie za nim."),
            ListenMake.d("Wąż", "Roll den Schlauch auf und häng ihn an den Haken.", "Co ze wężem?", "Zwiń i powieś na haku", "Zostaw na rampie", "Wyrzuć", "Zwiń wąż i powieś go na haku."),
            ListenMake.d("Miara", "Miss noch einmal nach, bevor du schneidest.", "Co najpierw?", "Zmierzyć jeszcze raz, potem ciąć", "Ciąć od razu", "Malować", "Zmierz jeszcze raz, zanim przetniesz."),
            ListenMake.d("Gruz", "Der Schutt kommt in den großen Container, nicht in den kleinen.", "Gdzie gruz?", "Do dużego kontenera", "Do małego", "Do busa", "Gruz idzie do dużego kontenera, nie do małego."),
            ListenMake.d("Kable", "Leg die Kabel an die Wand, nicht in den Gang.", "Gdzie kable?", "Pod ścianę, nie na przejście", "Na środek korytarza", "Na rusztowanie", "Połóż kable pod ścianą, nie na przejściu."),
            ListenMake.d("Folia", "Deck das Fenster mit Folie ab, bevor wir schleifen.", "Co przed szlifowaniem?", "Zasłonić okno folią", "Zdjąć folię", "Otworzyć okno na oścież", "Zasłoń okno folią, zanim będziemy szlifować."),
            ListenMake.d("Pomoc", "Hol den Markus dazu. Allein schaffen wir das nicht.", "Kogo zawołać?", "Markusa, samemu nie dacie rady", "Szefa z biura", "Nikogo", "Zawołaj Markusa. Sami tego nie ogarniemy.")
        ],
        "Narzędzia": [
            ListenMake.d("Klucz", "Der Schraubenschlüssel liegt im Koffer, Fach drei.", "Gdzie klucz?", "W walizce, przegródka trzy", "W aucie na siedzeniu", "Na rusztowaniu", "Klucz leży w walizce, przegródka trzy."),
            ListenMake.d("Tarcza", "Die Scheibe ist stumpf. Nimm eine neue.", "Co z tarczą?", "Tępa, weź nową", "Nowa, zostaw", "Brak tarczy w magazynie, użyj tej", "Tarcza jest tępa. Weź nową."),
            ListenMake.d("Miarka", "Der Zollstock ist geknickt. Hol einen anderen.", "Co z miarką?", "Złamana, weź inną", "Jest nowa", "Zostaw ją na dachu", "Miarka jest złamana. Weź inną."),
            ListenMake.d("Przedłużacz", "Das Verlängerungskabel reicht nicht bis zur Grube.", "Czego brakuje?", "Przedłużacz nie sięga do wykopu", "Przedłużacz jest za długi", "Nie potrzeba prądu", "Przedłużacz nie sięga do wykopu."),
            ListenMake.d("Wiadro", "Spül den Eimer aus, bevor du den Kleber anmachst.", "Co najpierw?", "Wypłukać wiadro, potem klej", "Od razu sypać klej", "Wyrzucić wiadro", "Wypłucz wiadro, zanim rozrobisz klej."),
            ListenMake.d("Rękawice", "Die Handschuhe sind nass. Nimm das trockene Paar.", "Które rękawice?", "Suchą parę", "Mokrą", "Żadnych", "Rękawice są mokre. Weź suchą parę."),
            ListenMake.d("Nożyk", "Die Klinge ist locker. Zieh sie fest, bevor du schneidest.", "Co z nożykiem?", "Dokręć ostrze, potem tnij", "Tnij od razu", "Wyrzuć całe narzędzie", "Ostrze jest luźne. Dokręć je, zanim tniesz."),
            ListenMake.d("Latarka", "Die Lampe liegt im Transporter, Beifahrersitz.", "Gdzie latarka?", "W transporcie, fotel pasażera", "W kontenerze", "U szefa w biurze", "Lampa leży w transporcie, na fotelu pasażera."),
            ListenMake.d("Zszywacz", "Der Tacker hat keine Klammern mehr.", "Czego brakuje?", "Zszywek", "Farby", "Wody", "W zszywaczu skończyły się zszywki.")
        ],
        "Materiały": [
            ListenMake.d("Klej", "Der Fliesenkleber reicht nicht. Hol noch einen Sack.", "Czego brakuje?", "Jednego worka kleju", "Jednej płytki", "Wody do picia", "Kleju do płytek nie starczy. Weź jeszcze worek."),
            ListenMake.d("Piasek", "Der Sand ist nass. Den können wir heute nicht nehmen.", "Co z piaskiem?", "Mokry, dziś się nie nadaje", "Suchy, można brać", "Już zużyty do końca", "Piasek jest mokry. Dziś go nie weźmiemy."),
            ListenMake.d("Deski", "Die Bretter sind verzogen. Leg sie zurück.", "Co z deskami?", "Powykręcane, odłóż je", "Proste, montuj", "Już przycięte dobrze", "Deski są powykręcane. Odłóż je."),
            ListenMake.d("Farba", "Die Farbe ist die falsche. Wir brauchen weiß, nicht grau.", "Jaka farba?", "Biała, nie szara", "Szara", "Czarna", "Farba jest zła. Potrzebna biała, nie szara."),
            ListenMake.d("Silikon", "Der Silikon ist hart. Mach eine neue Kartusche auf.", "Co z silikonem?", "Stwardniał, otwórz nowy", "Jest świeży", "Wylej go na podłogę", "Silikon jest twardy. Otwórz nowy kartusz."),
            ListenMake.d("Wełna", "Die Dämmung fehlt an der rechten Wand.", "Gdzie brakuje ocieplenia?", "Na prawej ścianie", "Na lewej", "Na podłodze biura", "Na prawej ścianie brakuje ocieplenia."),
            ListenMake.d("Fuga", "Die Fuge ist noch nass. Nicht draufgehen.", "Czego nie robić?", "Nie wchodzić, fuga jest mokra", "Już można chodzić", "Zmyć fugę od razu", "Fuga jest jeszcze mokra. Nie wchodź."),
            ListenMake.d("Gips", "Wir haben nur noch eine halbe Tüte Gips.", "Ile gipsu?", "Pół worka", "Dziesięć worków", "Nic nie zostało i nie było", "Zostało tylko pół worka gipsu."),
            ListenMake.d("Folia ochronna", "Die Abdeckfolie ist gerissen. Hol eine neue Rolle.", "Co z folią?", "Podarta, weź nową rolkę", "Nowa, zostaw", "Nie potrzebna", "Folia jest podarta. Weź nową rolkę.")
        ],
        "Wymiary": [
            ListenMake.d("Szerokość", "Die Öffnung ist neunzig Zentimeter breit, nicht achtzig.", "Jak szeroko?", "90 cm", "80 cm", "60 cm", "Otwór ma dziewięćdziesiąt centymetrów, nie osiemdziesiąt."),
            ListenMake.d("Wysokość", "Die Tür ist zwei Meter zehn hoch.", "Jak wysokie drzwi?", "2,10 m", "1,80 m", "2,40 m", "Drzwi mają dwa metry dziesięć."),
            ListenMake.d("Spadek", "Das Rohr braucht ein Gefälle nach links.", "Gdzie spadek?", "W lewo", "W prawo", "W górę", "Rura potrzebuje spadku w lewo."),
            ListenMake.d("Poziom", "Die erste Reihe muss in der Wasserwaage sein.", "Jaki ma być pierwszy rząd?", "W poziomie", "Pod skosem", "Jak wyjdzie", "Pierwszy rząd musi być w poziomie."),
            ListenMake.d("Otwór", "Lass zehn Millimeter Luft zur Wand.", "Ile luzu przy ścianie?", "10 mm", "10 cm", "Metr", "Zostaw dziesięć milimetrów luzu od ściany."),
            ListenMake.d("Długość", "Das Rohr ist einen halben Meter zu kurz.", "Co z rurą?", "Za krótka o pół metra", "Za długa o dwa metry", "W sam raz", "Rura jest o pół metra za krótka."),
            ListenMake.d("Kąt", "Der Winkel stimmt nicht. Es muss neunzig Grad sein.", "Jaki kąt?", "90 stopni", "45 stopni", "Jak wyjdzie", "Kąt się nie zgadza. Ma być dziewięćdziesiąt stopni."),
            ListenMake.d("Ilość", "Wir brauchen zwölf Latten, nicht zehn.", "Ile łat?", "Dwanaście", "Dziesięć", "Dwie", "Potrzebujemy dwunastu łat, nie dziesięciu."),
            ListenMake.d("Środek", "Markier die Mitte, dann teilen wir nach links und rechts.", "Od czego zacząć?", "Od środka, potem w lewo i w prawo", "Od samego rogu", "Bez znacznika", "Zaznacz środek, potem dzielimy w lewo i w prawo.")
        ],
        "Nie rozumiem": [
            ListenMake.d("Głośniej", "Können Sie das bitte lauter sagen? Hier ist es laut.", "O co prosisz?", "Żeby powiedział głośniej, bo jest hałas", "Żeby napisał po polsku", "Żeby skończył rozmowę", "Czy może pan powiedzieć głośniej? Tu jest głośno."),
            ListenMake.d("Zapisać", "Können Sie mir das aufschreiben? Ich will nichts falsch machen.", "O co prosisz?", "Żeby to zapisał, żebyś nie zrobił źle", "Żeby krzyczał", "Żeby poszedł", "Czy może pan mi to zapisać? Nie chcę zrobić źle."),
            ListenMake.d("Które", "Welche Schraube meinen Sie? Die lange oder die kurze?", "O co dopytujesz?", "Którą śrubę, długą czy krótką", "Którą godzinę", "Którą bramę na parking", "Którą śrubę ma pan na myśli? Długą czy krótką?"),
            ListenMake.d("Jeszcze raz wolno", "Noch einmal, bitte langsam.", "O co prosisz?", "O powtórzenie powoli", "O przerwę", "O inne zadanie", "Jeszcze raz, proszę powoli."),
            ListenMake.d("Nie to", "Das habe ich anders verstanden.", "Co mówisz?", "Że zrozumiałeś inaczej", "Że wszystko jasne", "Że już skończyłeś", "Zrozumiałem to inaczej."),
            ListenMake.d("Pokazać", "Können Sie es mir einmal zeigen?", "O co prosisz?", "Żeby ci raz pokazał", "Żeby tylko krzyknął z dołu", "Żeby wysłał maila po polsku", "Czy może pan mi to raz pokazać?"),
            ListenMake.d("Słowo", "Was heißt das Wort? Ich kenne es nicht.", "Czego nie znasz?", "Tego słowa", "Godziny przerwy", "Numeru buta", "Co znaczy to słowo? Nie znam go."),
            ListenMake.d("Potwierdź", "Habe ich das richtig verstanden: erst links, dann rechts?", "Co sprawdzasz?", "Czy najpierw lewo, potem prawo", "Czy dziś jest wypłata", "Czy bus jedzie", "Dobrze zrozumiałem: najpierw lewo, potem prawo?"),
            ListenMake.d("Chwila", "Einen Moment, ich hole den Kollegen. Er übersetzt.", "Co robisz?", "Wołasz kolegę, który przetłumaczy", "Kończysz zmianę", "Idziesz do lekarza", "Chwila, zawołam kolegę. On przetłumaczy.")
        ],
        "Godziny i pieniądze": [
            ListenMake.d("Przerwa", "Die Pause ist um neun, nicht um zehn.", "Kiedy przerwa?", "O dziewiątej", "O dziesiątej", "W południe", "Przerwa jest o dziewiątej, nie o dziesiątej."),
            ListenMake.d("Koniec", "Feierabend ist heute um vier.", "Kiedy koniec?", "Dziś o czwartej", "Dziś o siódmej", "Jutro rano", "Fajrant jest dziś o czwartej."),
            ListenMake.d("Spóźnienie", "Ich komme zwanzig Minuten später. Der Bus stand.", "Co zgłaszasz?", "Spóźnienie dwadzieścia minut, bus stał", "Że nie przyjdziesz wcale", "Że jesteś już na miejscu", "Będę dwadzieścia minut później. Autobus stał."),
            ListenMake.d("Zaliczka", "Kann ich einen Vorschuss bekommen? Die Miete ist diese Woche.", "O co prosisz?", "O zaliczkę, bo w tym tygodniu czynsz", "O urlop na miesiąc", "O nowe buty", "Czy mogę dostać zaliczkę? Czynsz jest w tym tygodniu."),
            ListenMake.d("Stawka", "Der Stundenlohn stimmt nicht. Es fehlen zwei Stunden.", "Co się nie zgadza?", "Brakuje dwóch godzin na stawce", "Za dużo godzin", "Pensja jest wyższa niż umowa", "Stawka godzinowa się nie zgadza. Brakuje dwóch godzin."),
            ListenMake.d("Sobota", "Am Samstag kann ich nicht. Ich habe schon eine andere Schicht.", "Co z sobotą?", "Nie możesz, masz już inną zmianę", "Możesz od rana", "Bierzesz urlop na rok", "W sobotę nie mogę. Mam już inną zmianę."),
            ListenMake.d("Wypłata gotówką", "Kommt das Geld aufs Konto oder bar?", "O co pytasz?", "Czy na konto, czy gotówką", "Czy jest przerwa", "Czy jest nadgodzina", "Pieniądze przychodzą na konto czy gotówką?"),
            ListenMake.d("Chorobowe", "Ich bin krank. Die Krankschreibung schicke ich heute.", "Co zgłaszasz?", "Jesteś chory i dziś wyślesz zwolnienie", "Jutro bierzesz urlop na życzenie", "Pracujesz normalnie", "Jestem chory. Zwolnienie wyślę dziś.")
        ],
        "Maszyny i bezpieczeństwo": [
            ListenMake.d("Mokro", "Der Boden ist nass. Nicht mit der Maschine darüber.", "Czego nie robić?", "Nie jechać maszyną po mokrej podłodze", "Nie pić wody", "Nie rozmawiać", "Podłoga jest mokra. Nie jedź po niej maszyną."),
            ListenMake.d("Blokada", "Zieh den Stecker, bevor du das Messer wechselst.", "Co przed wymianą noża?", "Wyciągnąć wtyczkę", "Zostawić maszynę włączoną", "Polać wodą", "Wyciągnij wtyczkę, zanim wymienisz nóż."),
            ListenMake.d("Strefa", "Hinter die Absperrung darf niemand.", "Kto może za barierę?", "Nikt", "Każdy z kaskiem", "Tylko goście", "Za barierę nie może nikt."),
            ListenMake.d("Ręce", "Fass das Sägeblatt nicht an. Es ist noch heiß.", "Czego nie dotykać?", "Tarczy, jest jeszcze gorąca", "Kasku", "Rękawic na stole", "Nie dotykaj tarczy. Jest jeszcze gorąca."),
            ListenMake.d("Dźwig", "Stell dich nicht unter die Last.", "Gdzie nie stać?", "Pod ładunkiem", "Obok bariery", "W szatni", "Nie stawaj pod ładunkiem."),
            ListenMake.d("Gaśnica", "Die Feuerlöscher hängen neben der Tür.", "Gdzie gaśnica?", "Obok drzwi", "W aucie szefa", "Na dachu", "Gaśnice wiszą obok drzwi."),
            ListenMake.d("Buty", "Ohne Sicherheitsschuhe kommst du nicht aufs Gelände.", "Bez czego nie wejdziesz?", "Bez butów roboczych", "Bez kurtki przeciwdeszczowej", "Bez telefonu", "Bez butów roboczych nie wejdziesz na teren.")
        ],
        "Koniec dnia": [
            ListenMake.d("Klucze", "Häng die Schlüssel an das Brett, nicht in die Tasche.", "Gdzie klucze?", "Na tablicę, nie do kieszeni", "Do domu", "Do busa kolegi", "Powieś klucze na tablicy, nie do kieszeni."),
            ListenMake.d("Światło", "Mach das Licht im Container aus.", "Co zgasić?", "Światło w kontenerze", "Światło na ulicy", "Nic", "Zgaś światło w kontenerze."),
            ListenMake.d("Brama", "Ist das Tor zu? Prüf es noch einmal.", "Co sprawdzić?", "Czy brama jest zamknięta", "Czy bus ma paliwo", "Czy jest przerwa", "Czy brama jest zamknięta? Sprawdź jeszcze raz."),
            ListenMake.d("Zdjęcie", "Schick ein Foto, wenn die rechte Wand fertig ist.", "Kiedy zdjęcie?", "Gdy prawa ściana będzie gotowa", "Rano przed robotą", "Nigdy", "Wyślij zdjęcie, gdy prawa ściana będzie gotowa."),
            ListenMake.d("Lista", "Trag ein, was du heute gemacht hast.", "Co wpisać?", "Co dziś zrobiłeś", "Co jesz na kolację", "Numer buta", "Wpisz, co dziś zrobiłeś."),
            ListenMake.d("Prysznic", "Die Dusche ist frei. Danach schließt du ab.", "Co po prysznicu?", "Zamykasz", "Zostawiasz otwarte", "Wołasz szefa", "Prysznic jest wolny. Potem zamykasz."),
            ListenMake.d("Jutro rano", "Morgen früh treffen wir uns an Tor eins, um sechs.", "Gdzie jutro?", "Przy bramie jeden, o szóstej", "Przy bramie trzy, o ósmej", "W biurze w południe", "Jutro rano spotykamy się przy bramie jeden, o szóstej."),
            ListenMake.d("Zostało", "Lass das Werkzeug nicht draußen. Es soll regnen.", "Czemu nie zostawiać narzędzi?", "Ma padać", "Jest ładnie i sucho", "Szef tak lubi", "Nie zostawiaj narzędzi na zewnątrz. Ma padać."),
            ListenMake.d("Podpis", "Unterschreib die Stundenzettel, bevor du gehst.", "Co przed wyjściem?", "Podpisać listę godzin", "Zatankować prywatne auto", "Zadzwonić do lekarza", "Podpisz listę godzin, zanim wyjdziesz.")
        ]
    ]
}
