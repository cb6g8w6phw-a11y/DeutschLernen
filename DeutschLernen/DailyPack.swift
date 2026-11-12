import Foundation

enum DailyPack {
    static let lines: [(de: String, pl: String)] = [
        ("Guten Morgen, ich bin da.", "Dzień dobry, już jestem."),
        ("Ich fange um sechs Uhr an.", "Zaczynam o szóstej."),
        ("Die Frühschicht geht bis zwei.", "Poranna zmiana trwa do drugiej."),
        ("Ich komme zehn Minuten später.", "Przyjdę dziesięć minut później."),
        ("Der Bus hatte Verspätung.", "Autobus miał opóźnienie."),
        ("Kann mich jemand ablösen?", "Czy ktoś może mnie zastąpić?"),
        ("Die Pause ist um neun.", "Przerwa jest o dziewiątej."),
        ("Ich brauche noch Material.", "Jeszcze potrzebuję materiału."),
        ("Das Werkzeug fehlt.", "Brakuje narzędzia."),
        ("Wo soll ich anfangen?", "Od czego mam zacząć?"),
        ("Das ist schon fertig.", "To już jest gotowe."),
        ("Das muss noch mal gemacht werden.", "To trzeba zrobić jeszcze raz."),
        ("Die Qualität stimmt nicht.", "Jakość się nie zgadza."),
        ("Der Karton ist beschädigt.", "Karton jest uszkodzony."),
        ("Ich scanne das noch mal.", "Zeskanuję to jeszcze raz."),
        ("Die Rampe ist frei.", "Rampa jest wolna."),
        ("Der Lkw wartet schon.", "Ciężarówka już czeka."),
        ("Ich brauche eine Unterschrift.", "Potrzebuję podpisu."),
        ("Das passt nicht auf die Palette.", "To nie wchodzi na paletę."),
        ("Zieh die Sicherheitsschuhe an.", "Załóż buty robocze."),
        ("Setz den Helm auf.", "Załóż kask."),
        ("Der Bereich ist gesperrt.", "Strefa jest zamknięta."),
        ("Pass auf, da ist eine Kante.", "Uważaj, tam jest krawędź."),
        ("Hol bitte die Schaufel.", "Przynieś proszę łopatę."),
        ("Reich mir die Wasserwaage.", "Podaj mi poziomicę."),
        ("Das Maß stimmt nicht.", "Wymiar się nie zgadza."),
        ("Wir müssen das noch ausrichten.", "Musimy to jeszcze wypoziomować."),
        ("Bohr nicht in die Leitung.", "Nie wierć w przewód."),
        ("Das Gerüst wackelt.", "Rusztowanie się chwieje."),
        ("Unten frei!", "Uwaga na dole!"),
        ("Wo sind die Handschuhe?", "Gdzie są rękawice?"),
        ("Ohne Schuhe kommst du nicht rein.", "Bez butów nie wejdziesz."),
        ("Ich habe mir den Finger geschnitten.", "Skaleczłem się w palec."),
        ("Hol den Ersthelfer.", "Zawołaj ratownika."),
        ("Ich bin krank und komme nicht.", "Jestem chory i nie przyjdę."),
        ("Ich brauche eine Krankschreibung.", "Potrzebuję zwolnienia."),
        ("Mir ist schwindlig.", "Kręci mi się w głowie."),
        ("Der Termin ist um halb drei.", "Wizyta jest o wpół do trzeciej."),
        ("Ich bin gegen Penicillin allergisch.", "Jestem uczulony na penicylinę."),
        ("Die Tabletten nehme ich abends.", "Tabletki biorę wieczorem."),
        ("Kann ich mit Karte zahlen?", "Czy mogę zapłacić kartą?"),
        ("Ich hätte gern noch ein Wasser.", "Poproszę jeszcze wodę."),
        ("Die Rechnung, bitte.", "Rachunek, poproszę."),
        ("Zum Mitnehmen, bitte.", "Na wynos, poproszę."),
        ("Das ist mir zu teuer.", "To dla mnie za drogie."),
        ("Haben Sie etwas Günstigeres?", "Czy macie coś tańszego?"),
        ("Ich möchte das umtauschen.", "Chcę to wymienić."),
        ("Ich habe den Bon dabei.", "Mam paragon przy sobie."),
        ("Wo ist die Kasse?", "Gdzie jest kasa?"),
        ("Das Sonderangebot gilt nur heute.", "Promocja jest tylko dziś."),
        ("Der Zug fällt aus.", "Pociąg jest odwołany."),
        ("Wo muss ich umsteigen?", "Gdzie mam się przesiąść?"),
        ("Ich stehe im Stau.", "Stoję w korku."),
        ("Der Tank ist fast leer.", "Bak jest prawie pusty."),
        ("Wo kann ich hier parken?", "Gdzie mogę tu zaparkować?"),
        ("Ich habe mich verfahren.", "Pomyliłem drogę."),
        ("Mein Führerschein ist im Auto.", "Prawo jazdy mam w aucie."),
        ("Die Heizung bleibt kalt.", "Ogrzewanie jest zimne."),
        ("Der Wasserhahn tropft.", "Kran kapie."),
        ("Ich melde den Schaden.", "Zgłaszam usterkę."),
        ("Wann kommt der Handwerker?", "Kiedy przyjdzie fachowiec?"),
        ("Die Miete geht am Ersten ab.", "Czynsz schodzi pierwszego."),
        ("Der Lohn ist noch nicht da.", "Wypłata jeszcze nie weszła."),
        ("Ich brauche eine Quittung.", "Potrzebuję pokwitowania."),
        ("Können Sie das bitte wiederholen?", "Może pan to powtórzyć?"),
        ("Langsamer, bitte.", "Wolniej, proszę."),
        ("Das habe ich nicht verstanden.", "Tego nie zrozumiałem."),
        ("Wie schreibt man das?", "Jak się to pisze?"),
        ("Ein Moment, ich schaue nach.", "Chwilę, sprawdzę."),
        ("Ich rufe später zurück.", "Oddzwonię później."),
        ("Schreib mir, wenn du da bist.", "Napisz, jak będziesz na miejscu."),
        ("Können wir den Termin verschieben?", "Czy możemy przesunąć termin?"),
        ("Ich habe einen Termin um zehn.", "Mam termin o dziesiątej."),
        ("Welche Unterlagen fehlen noch?", "Jakich dokumentów jeszcze brakuje?"),
        ("Ich verstehe das Formular nicht.", "Nie rozumiem formularza."),
        ("Mein Name ist falsch geschrieben.", "Moje nazwisko jest źle napisane."),
        ("Samstag habe ich frei.", "W sobotę mam wolne."),
        ("Ich arbeite diese Woche sechs Tage.", "W tym tygodniu pracuję sześć dni."),
        ("Wer macht die Übergabe?", "Kto robi przekazanie zmiany?"),
        ("Die Schicht ist unterbesetzt.", "Na zmianie brakuje ludzi."),
        ("Ich gehe kurz zur Toilette.", "Idę na chwilę do toalety."),
        ("Der Drucker klemmt.", "Drukarka się zacina."),
        ("Der Auftrag ist storniert.", "Zlecenie jest anulowane."),
        ("Der Gang muss frei bleiben.", "Alejka musi zostać wolna."),
        ("Der Hubwagen ist kaputt.", "Paleciak jest zepsuty."),
        ("Ich sichere die Ladung.", "Zabezpieczam ładunek."),
        ("Die Gabeln sind zu breit.", "Widły są za szerokie."),
        ("Mir fehlt ein Ersatzteil.", "Brakuje mi części."),
        ("Der Ölstand ist zu niedrig.", "Poziom oleju jest za niski."),
        ("Die Batterie ist leer.", "Akumulator jest pusty."),
        ("Der Reifen hat zu wenig Luft.", "W oponie jest za mało powietrza."),
        ("Das Teil muss bestellt werden.", "Część trzeba zamówić."),
        ("Ich rufe den Abschleppdienst.", "Dzwonię po lawetę."),
        ("Niemand ist verletzt.", "Nikt nie jest ranny."),
        ("Ich mache Fotos vom Schaden.", "Robię zdjęcia szkody."),
        ("Die Tür klemmt.", "Drzwi się zacinają."),
        ("Das Fenster schließt nicht.", "Okno się nie domyka."),
        ("Der Strom ist weg.", "Nie ma prądu."),
        ("Ich brauche einen neuen Schlüssel.", "Potrzebuję nowego klucza."),
        ("Der Nachbar ist zu laut.", "Sąsiad jest za głośny.")
    ]

    static var words: [Word] {
        lines.map { Word(de: $0.de, pl: $0.pl, ex: $0.de, exPl: $0.pl, topic: "Codziennie", level: "A2") }
    }

    static var say: [CoachData.Prompt] {
        lines.map { CoachData.Prompt(pl: $0.pl, de: $0.de) }
    }

    static var listen: [CoachData.ListenQ] {
        lines.enumerated().map { index, line in
            let a = lines[(index + 17) % lines.count].pl
            let b = lines[(index + 41) % lines.count].pl
            let options = [line.pl, a, b].shuffled()
            return CoachData.ListenQ(
                de: line.de,
                pl: line.pl,
                question: "Co usłyszałeś?",
                options: options,
                answer: options.firstIndex(of: line.pl) ?? 0
            )
        }
    }

    static let grammar: [GrammarItem] = {
        var items: [GrammarItem] = []
        func article(_ word: String, _ kind: String, _ why: String) {
            let options = ["der", "die", "das"]
            items.append(GrammarItem(title: "Der, die, das", prompt: "___ \(word)", options: options, answer: options.firstIndex(of: kind) ?? 0, why: why))
        }
        for word in ["Tisch", "Stuhl", "Helm", "Chef", "Bus", "Schlüssel", "Termin", "Lohn", "Kollege", "Auftrag", "Drucker", "Lkw", "Hammer", "Schrank", "Hubwagen"] {
            article(word, "der", "\(word) jest rodzaju męskiego: der \(word).")
        }
        for word in ["Tür", "Schaufel", "Pause", "Schicht", "Palette", "Rampe", "Kasse", "Rechnung", "Heizung", "Miete", "Leiter", "Kiste", "Nachricht", "Versicherung", "Toilette"] {
            article(word, "die", "\(word) jest rodzaju żeńskiego: die \(word).")
        }
        for word in ["Auto", "Werkzeug", "Fenster", "Formular", "Maß", "Gerüst", "Wasser", "Zimmer", "Teil", "Lager", "Essen", "Geld", "Problem", "Protokoll", "Band"] {
            article(word, "das", "\(word) jest rodzaju nijakiego: das \(word).")
        }
        let rest: [GrammarItem] = [
            GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ 26 Jahre alt.", options: ["bin", "habe", "mache"], answer: 0, why: "Wiek: ich bin … Jahre alt."),
            GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ heute Frühschicht.", options: ["bin", "habe", "mache"], answer: 1, why: "Masz zmianę: ich habe Frühschicht."),
            GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ die Palette fertig.", options: ["bin", "habe", "mache"], answer: 2, why: "Robisz coś: ich mache die Palette fertig."),
            GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ krank.", options: ["bin", "habe", "mache"], answer: 0, why: "Stan: ich bin krank."),
            GrammarItem(title: "bin, habe, mache", prompt: "Ich ___ Hunger.", options: ["bin", "habe", "mache"], answer: 1, why: "Głód: ich habe Hunger."),
            GrammarItem(title: "kann, muss, will", prompt: "Ich ___ um sechs anfangen.", options: ["kann", "muss", "will"], answer: 0, why: "Mogę: ich kann."),
            GrammarItem(title: "kann, muss, will", prompt: "Ich ___ den Helm aufsetzen.", options: ["kann", "muss", "will"], answer: 1, why: "Musisz: ich muss."),
            GrammarItem(title: "kann, muss, will", prompt: "Ich ___ nach Hause.", options: ["kann", "muss", "will"], answer: 2, why: "Chcę: ich will nach Hause."),
            GrammarItem(title: "Czas przeszły", prompt: "Gestern ___ ich gearbeitet.", options: ["bin", "habe", "werde"], answer: 1, why: "arbeiten: ich habe gearbeitet."),
            GrammarItem(title: "Czas przeszły", prompt: "Gestern ___ ich zu spät gekommen.", options: ["bin", "habe", "werde"], answer: 0, why: "kommen bierze sein."),
            GrammarItem(title: "Czas przeszły", prompt: "Ich ___ das schon gesagt.", options: ["bin", "habe", "werde"], answer: 1, why: "sagen: ich habe gesagt."),
            GrammarItem(title: "Czas przeszły", prompt: "Ich ___ nach Hause gegangen.", options: ["bin", "habe", "werde"], answer: 0, why: "gehen: ich bin gegangen."),
            GrammarItem(title: "Czas przeszły", prompt: "Sie ___ den Karton gescannt.", options: ["ist", "hat", "wird"], answer: 1, why: "scannen: sie hat gescannt."),
            GrammarItem(title: "Czas przeszły", prompt: "Er ___ mit dem Bus gefahren.", options: ["ist", "hat", "wird"], answer: 0, why: "fahren: er ist gefahren."),
            GrammarItem(title: "Czas przyszły", prompt: "Morgen ___ ich früher kommen.", options: ["habe", "bin", "werde"], answer: 2, why: "Jutro: ich werde kommen."),
            GrammarItem(title: "Czas przyszły", prompt: "Ich ___ das morgen bestellen.", options: ["werde", "bin", "habe"], answer: 0, why: "Zamówię: ich werde bestellen."),
            GrammarItem(title: "Szyk zdania", prompt: "Dziś pracuję.", options: ["Heute arbeite ich.", "Heute ich arbeite.", "Ich heute arbeite."], answer: 0, why: "Po Heute czasownik jest drugi."),
            GrammarItem(title: "Szyk zdania", prompt: "Bo jestem chory.", options: ["Ich komme nicht, weil ich krank bin.", "Ich komme nicht, weil ich bin krank.", "Weil ich bin krank."], answer: 0, why: "Po weil czasownik na końcu."),
            GrammarItem(title: "Szyk zdania", prompt: "Potem idę na przerwę.", options: ["Dann mache ich Pause.", "Dann ich mache Pause.", "Ich dann Pause mache."], answer: 0, why: "Dann + czasownik + ich."),
            GrammarItem(title: "Przyimki", prompt: "Idę do pracy.", options: ["Ich gehe zur Arbeit.", "Ich gehe zu Arbeit.", "Ich gehe nach Arbeit."], answer: 0, why: "die Arbeit: zur Arbeit."),
            GrammarItem(title: "Przyimki", prompt: "Jadę do domu.", options: ["Ich fahre nach Hause.", "Ich fahre zu Hause.", "Ich fahre nach Haus zu."], answer: 0, why: "Do domu: nach Hause."),
            GrammarItem(title: "Przyimki", prompt: "Jestem w domu.", options: ["Ich bin zu Hause.", "Ich bin nach Hause.", "Ich bin zur Hause."], answer: 0, why: "W domu: zu Hause."),
            GrammarItem(title: "Przyimki", prompt: "Jadę do Berlina.", options: ["Ich fahre nach Berlin.", "Ich fahre zu Berlin.", "Ich fahre in Berlin."], answer: 0, why: "Miasta: nach Berlin."),
            GrammarItem(title: "Przyimki", prompt: "Pracuję w magazynie.", options: ["Ich arbeite im Lager.", "Ich arbeite in Lager.", "Ich arbeite auf Lager."], answer: 0, why: "in dem = im Lager."),
            GrammarItem(title: "Przyimki", prompt: "O szóstej.", options: ["Um sechs Uhr.", "Am sechs Uhr.", "Zu sechs Uhr."], answer: 0, why: "Godzina: um sechs Uhr."),
            GrammarItem(title: "Przyimki", prompt: "W poniedziałek.", options: ["Am Montag.", "Um Montag.", "Im Montag."], answer: 0, why: "Dzień: am Montag."),
            GrammarItem(title: "Przyimki", prompt: "W maju.", options: ["Im Mai.", "Am Mai.", "Um Mai."], answer: 0, why: "Miesiąc: im Mai."),
            GrammarItem(title: "Przyimki", prompt: "Z autobusem.", options: ["Ich fahre mit dem Bus.", "Ich fahre mit den Bus.", "Ich fahre mit der Bus."], answer: 0, why: "mit + celownik: dem Bus."),
            GrammarItem(title: "Zaimek", prompt: "Moja zmiana.", options: ["Meine Schicht fängt um sechs an.", "Mein Schicht fängt um sechs an.", "Meiner Schicht fängt an."], answer: 0, why: "die Schicht: meine."),
            GrammarItem(title: "Zaimek", prompt: "Mój szef.", options: ["Mein Chef ist noch nicht da.", "Meine Chef ist noch nicht da.", "Meins Chef ist da."], answer: 0, why: "der Chef: mein."),
            GrammarItem(title: "Przypadek", prompt: "Pomagam koledze.", options: ["Ich helfe dem Kollegen.", "Ich helfe den Kollegen.", "Ich helfe der Kollegen."], answer: 0, why: "helfen + celownik."),
            GrammarItem(title: "Przypadek", prompt: "Widzę szefa.", options: ["Ich sehe den Chef.", "Ich sehe dem Chef.", "Ich sehe der Chef."], answer: 0, why: "sehen + biernik."),
            GrammarItem(title: "Przypadek", prompt: "Daję mu klucz.", options: ["Ich gebe ihm den Schlüssel.", "Ich gebe ihn den Schlüssel.", "Ich gebe ihm der Schlüssel."], answer: 0, why: "jemu + rzecz: ihm den."),
            GrammarItem(title: "Przeczenie", prompt: "Nie mam czasu.", options: ["Ich habe keine Zeit.", "Ich habe nicht Zeit.", "Ich habe kein Zeit."], answer: 0, why: "die Zeit: keine Zeit."),
            GrammarItem(title: "Przeczenie", prompt: "Nie mam pieniędzy.", options: ["Ich habe kein Geld.", "Ich habe kein Geld nicht.", "Ich habe nicht Geld."], answer: 0, why: "Raz wystarczy: kein."),
            GrammarItem(title: "Pytanie", prompt: "Gdzie jest magazyn?", options: ["Wo ist das Lager?", "Wo das Lager ist?", "Ist wo das Lager?"], answer: 0, why: "Wo + czasownik."),
            GrammarItem(title: "Pytanie", prompt: "Kiedy zaczynamy?", options: ["Wann fangen wir an?", "Wann wir fangen an?", "Fangen wann wir an?"], answer: 0, why: "Wann + czasownik."),
            GrammarItem(title: "Liczba", prompt: "Jedna łopata.", options: ["eine Schaufel", "ein Schaufel", "einer Schaufel"], answer: 0, why: "die Schaufel: eine."),
            GrammarItem(title: "Liczba", prompt: "Jeden młotek.", options: ["ein Hammer", "eine Hammer", "ein Hammers"], answer: 0, why: "der Hammer: ein."),
            GrammarItem(title: "Liczba", prompt: "Jedno auto.", options: ["ein Auto", "eine Auto", "einer Auto"], answer: 0, why: "das Auto: ein."),
            GrammarItem(title: "Porównanie", prompt: "To jest cięższe.", options: ["Das ist schwerer.", "Das ist mehr schwer.", "Das ist zu schwerer."], answer: 0, why: "Porównanie: schwerer."),
            GrammarItem(title: "Rozkaz", prompt: "Załóż kask.", options: ["Setz den Helm auf!", "Du setzt den Helm auf!", "Setzt du den Helm!"], answer: 0, why: "Do kolegi: Setz … auf."),
            GrammarItem(title: "Czas", prompt: "6:30.", options: ["halb sieben", "sechs und halb", "halb sechs"], answer: 0, why: "6:30 to halb sieben."),
            GrammarItem(title: "Czas", prompt: "7:15.", options: ["Viertel nach sieben", "Viertel vor sieben", "viertel acht"], answer: 0, why: "15 po: Viertel nach."),
            GrammarItem(title: "Czas", prompt: "7:45.", options: ["Viertel vor acht", "Viertel nach acht", "drei Viertel acht"], answer: 0, why: "Za piętnaście ósma: Viertel vor acht."),
            GrammarItem(title: "Modalne", prompt: "Muszę iść do lekarza.", options: ["Ich muss zum Arzt gehen.", "Ich muss gehen zum Arzt.", "Ich muss zum Arzt zu gehen."], answer: 0, why: "Czasownik główny na końcu."),
            GrammarItem(title: "Przymiotnik", prompt: "Nowy klucz.", options: ["ein neuer Schlüssel", "ein neue Schlüssel", "ein neues Schlüssel"], answer: 0, why: "der Schlüssel: ein neuer."),
            GrammarItem(title: "Przymiotnik", prompt: "Nowa zmiana.", options: ["eine neue Schicht", "eine neuer Schicht", "eine neues Schicht"], answer: 0, why: "die Schicht: eine neue."),
            GrammarItem(title: "Przymiotnik", prompt: "Nowe auto.", options: ["ein neues Auto", "ein neue Auto", "ein neuer Auto"], answer: 0, why: "das Auto: ein neues."),
            GrammarItem(title: "dass", prompt: "On jest chory.", options: ["Ich glaube, dass er krank ist.", "Ich glaube, dass er ist krank.", "Ich glaube, dass ist er krank."], answer: 0, why: "Po dass czasownik na końcu."),
            GrammarItem(title: "Pytanie zależne", prompt: "Gdzie jest szef?", options: ["Ich weiß nicht, wo der Chef ist.", "Ich weiß nicht, wo ist der Chef.", "Ich weiß nicht, wo der Chef."], answer: 0, why: "wo der Chef ist."),
            GrammarItem(title: "Szyk zdania", prompt: "Dlatego się spóźniam.", options: ["Deshalb komme ich später.", "Deshalb ich komme später.", "Ich deshalb komme später."], answer: 0, why: "Deshalb + czasownik drugi."),
            GrammarItem(title: "Przyimki", prompt: "Od poniedziałku do piątku.", options: ["Von Montag bis Freitag.", "Seit Montag bis Freitag.", "Ab Montag bis Freitag."], answer: 0, why: "Od–do: von … bis."),
            GrammarItem(title: "Przyimki", prompt: "Czekam na autobus.", options: ["Ich warte auf den Bus.", "Ich warte für den Bus.", "Ich warte an den Bus."], answer: 0, why: "czekać na: warten auf."),
            GrammarItem(title: "Przyimki", prompt: "Myślę o pracy.", options: ["Ich denke an die Arbeit.", "Ich denke auf die Arbeit.", "Ich denke über die Arbeit zu."], answer: 0, why: "myśleć o: denken an."),
            GrammarItem(title: "Przeczenie", prompt: "Nic nie rozumiem.", options: ["Ich verstehe nichts.", "Ich verstehe nicht nichts.", "Ich verstehe kein nichts."], answer: 0, why: "Jedno przeczenie: nichts.")
        ]
        items += rest
        return Array(items.prefix(100))
    }()

    static let fixes: [FixItem] = {
        var rows: [FixItem] = [
            FixItem(id: "alter", wrong: "Ich habe 26 Jahre.", right: "Ich bin 26 Jahre alt.", why: "Wiek: ich bin … Jahre alt."),
            FixItem(id: "zeit", wrong: "Ich bin 8 Uhr.", right: "Es ist 8 Uhr.", why: "Godzina: es ist."),
            FixItem(id: "wo", wrong: "Ich gehe zu Arbeit.", right: "Ich gehe zur Arbeit.", why: "Do pracy: zur Arbeit."),
            FixItem(id: "heim", wrong: "Ich gehe nach Hause zu.", right: "Ich gehe nach Hause.", why: "Do domu: nach Hause."),
            FixItem(id: "arzt", wrong: "Ich muss zum Arzt gehen morgen.", right: "Ich muss morgen zum Arzt gehen.", why: "Czas stoi przed resztą."),
            FixItem(id: "perfekt", wrong: "Ich habe gegangen.", right: "Ich bin gegangen.", why: "gehen bierze sein."),
            FixItem(id: "artikel", wrong: "Ich brauche ein Schaufel.", right: "Ich brauche eine Schaufel.", why: "die Schaufel: eine."),
            FixItem(id: "kennen", wrong: "Ich weiß ihn.", right: "Ich kenne ihn.", why: "Osobę: kennen."),
            FixItem(id: "uhr", wrong: "Um sechs Uhr dreißig.", right: "Um halb sieben.", why: "6:30: um halb sieben."),
            FixItem(id: "geld", wrong: "Ich habe kein Geld nicht.", right: "Ich habe kein Geld.", why: "Nie dokładaj drugiego nie."),
            FixItem(id: "hunger", wrong: "Ich bin Hunger.", right: "Ich habe Hunger.", why: "Głód: ich habe Hunger."),
            FixItem(id: "kalt", wrong: "Ich habe kalt.", right: "Mir ist kalt.", why: "Zimno mi: mir ist kalt."),
            FixItem(id: "frage", wrong: "Wo du arbeitest?", right: "Wo arbeitest du?", why: "Pytanie: czasownik przed du."),
            FixItem(id: "warum", wrong: "Warum du kommst später?", right: "Warum kommst du später?", why: "Warum + czasownik."),
            FixItem(id: "sagt", wrong: "Der Chef sagen das.", right: "Der Chef sagt das.", why: "On mówi: sagt."),
            FixItem(id: "wir", wrong: "Wir arbeitet heute.", right: "Wir arbeiten heute.", why: "my: arbeiten."),
            FixItem(id: "du", wrong: "Du arbeitet zu schnell.", right: "Du arbeitest zu schnell.", why: "ty: arbeitest."),
            FixItem(id: "er", wrong: "Er arbeiten im Lager.", right: "Er arbeitet im Lager.", why: "on: arbeitet."),
            FixItem(id: "kann", wrong: "Ich kann das zu machen.", right: "Ich kann das machen.", why: "Po kann nie ma zu."),
            FixItem(id: "muss", wrong: "Ich muss gehen zum Chef.", right: "Ich muss zum Chef gehen.", why: "gehen na końcu."),
            FixItem(id: "gestern", wrong: "Gestern ich habe gearbeitet.", right: "Gestern habe ich gearbeitet.", why: "Po Gestern czasownik jest drugi."),
            FixItem(id: "weil", wrong: "Weil ich bin krank.", right: "Weil ich krank bin.", why: "Po weil czasownik na końcu."),
            FixItem(id: "berlin", wrong: "Ich fahre zu Berlin.", right: "Ich fahre nach Berlin.", why: "Do miasta: nach."),
            FixItem(id: "zuhause", wrong: "Ich bin nach Hause.", right: "Ich bin zu Hause.", why: "W domu: zu Hause."),
            FixItem(id: "um", wrong: "Am sechs Uhr.", right: "Um sechs Uhr.", why: "Godzina: um."),
            FixItem(id: "montag", wrong: "Im Montag.", right: "Am Montag.", why: "Dzień: am Montag."),
            FixItem(id: "mai", wrong: "Am Mai.", right: "Im Mai.", why: "Miesiąc: im Mai."),
            FixItem(id: "mit", wrong: "mit den Bus", right: "mit dem Bus", why: "mit + celownik: dem Bus."),
            FixItem(id: "helfe", wrong: "Ich helfe ihn.", right: "Ich helfe ihm.", why: "helfen + celownik: ihm."),
            FixItem(id: "sehe", wrong: "Ich sehe ihm.", right: "Ich sehe ihn.", why: "sehen + biernik: ihn."),
            FixItem(id: "hammer", wrong: "eine Hammer", right: "ein Hammer", why: "der Hammer: ein."),
            FixItem(id: "tuer", wrong: "ein Tür", right: "eine Tür", why: "die Tür: eine."),
            FixItem(id: "auto", wrong: "ein neue Auto", right: "ein neues Auto", why: "das Auto: ein neues."),
            FixItem(id: "gross", wrong: "der großer Karton", right: "der große Karton", why: "Po der: große."),
            FixItem(id: "schwer", wrong: "mehr schwer", right: "schwerer", why: "Porównanie: schwerer."),
            FixItem(id: "heute", wrong: "Heute ich scanne die Palette.", right: "Heute scanne ich die Palette.", why: "Heute + czasownik."),
            FixItem(id: "schaufel", wrong: "Gib mir den Schaufel.", right: "Gib mir die Schaufel.", why: "die Schaufel."),
            FixItem(id: "kasse", wrong: "Wo ist der Kasse?", right: "Wo ist die Kasse?", why: "die Kasse."),
            FixItem(id: "pause", wrong: "Der Pause ist lang.", right: "Die Pause ist lang.", why: "die Pause."),
            FixItem(id: "lkw", wrong: "Die Lkw ist da.", right: "Der Lkw ist da.", why: "der Lkw."),
            FixItem(id: "nichts", wrong: "Ich verstehe nicht nichts.", right: "Ich verstehe nichts.", why: "Jedno przeczenie: nichts."),
            FixItem(id: "niemand", wrong: "Niemand ist nicht da.", right: "Niemand ist da.", why: "niemand już znaczy nikt."),
            FixItem(id: "dass", wrong: "Ich glaube, dass er ist krank.", right: "Ich glaube, dass er krank ist.", why: "dass + czasownik na końcu."),
            FixItem(id: "spaeter", wrong: "Sag ihm, dass ich komme später.", right: "Sag ihm, dass ich später komme.", why: "dass ich später komme."),
            FixItem(id: "woist", wrong: "Ich weiß nicht, wo ist der Chef.", right: "Ich weiß nicht, wo der Chef ist.", why: "wo der Chef ist."),
            FixItem(id: "gefaellt", wrong: "Das gefällt mich nicht.", right: "Das gefällt mir nicht.", why: "Podoba mi się: mir."),
            FixItem(id: "warte", wrong: "Ich warte für den Bus.", right: "Ich warte auf den Bus.", why: "czekać na: warten auf."),
            FixItem(id: "denke", wrong: "Ich denke auf die Arbeit.", right: "Ich denke an die Arbeit.", why: "myśleć o: denken an."),
            FixItem(id: "vonbis", wrong: "Seit Montag bis Freitag.", right: "Von Montag bis Freitag.", why: "Od–do: von … bis."),
            FixItem(id: "angst", wrong: "Ich habe Angst vor den Chef.", right: "Ich habe Angst vor dem Chef.", why: "vor + celownik: dem Chef."),
            FixItem(id: "langsam", wrong: "Mehr langsam, bitte.", right: "Langsamer, bitte.", why: "Wolniej: langsamer.")
        ]
        let who = ["ich", "du", "er", "wir", "ihr", "sie"]
            ("machen", ["mache", "machst", "macht", "machen", "macht", "machen"], ["macht", "mache", "machen", "macht", "machen", "macht"]),
            ("kommen", ["komme", "kommst", "kommt", "kommen", "kommt", "kommen"], ["kommt", "komme", "kommen", "kommt", "kommen", "kommt"]),
            ("fahren", ["fahre", "fährst", "fährt", "fahren", "fahrt", "fahren"], ["fährt", "fahre", "fahren", "fährt", "fahren", "fährt"]),
            ("gehen", ["gehe", "gehst", "geht", "gehen", "geht", "gehen"], ["geht", "gehe", "gehen", "geht", "gehen", "geht"]),
            ("sehen", ["sehe", "siehst", "sieht", "sehen", "seht", "sehen"], ["sieht", "sehe", "sehen", "sieht", "sehen", "sieht"]),
            ("geben", ["gebe", "gibst", "gibt", "geben", "gebt", "geben"], ["gibt", "gebe", "geben", "gibt", "geben", "gibt"]),
            ("nehmen", ["nehme", "nimmst", "nimmt", "nehmen", "nehmt", "nehmen"], ["nimmt", "nehme", "nehmen", "nimmt", "nehmen", "nimmt"]),
            ("sprechen", ["spreche", "sprichst", "spricht", "sprechen", "sprecht", "sprechen"], ["spricht", "spreche", "sprechen", "spricht", "sprechen", "spricht"]),
            ("lesen", ["lese", "liest", "liest", "lesen", "lest", "lesen"], ["liest", "lese", "lesen", "liest", "lesen", "liest"])
        ]
        let who = ["ich", "du", "er", "wir", "ihr", "sie"]
        var n = 0
        for verb in verbs {
            for i in 0..<6 where rows.count < 100 {
                let wrong = "\(who[i].prefix(1).uppercased())\(who[i].dropFirst()) \(verb.2[i]) das."
                let right = "\(who[i].prefix(1).uppercased())\(who[i].dropFirst()) \(verb.1[i]) das."
                rows.append(FixItem(id: "v\(n)", wrong: wrong, right: right, why: "\(who[i]) + \(verb.0): \(verb.1[i])."))
                n += 1
            }
        }
        return Array(rows.prefix(100))
    }()
}
