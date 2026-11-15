import SwiftUI

struct GLesson: Identifiable, Hashable {
    let id: String
    let topic: String
    let level: String
    let title: String
    let explain: String
    let pattern: String
    let examples: [Gloss]
    let work: [Gloss]
    let ask: String
    let options: [String]
    let answer: Int
    let order: [String]
    let extra: String
    let cloze: String
    let clozeOptions: [String]
    let clozeAnswer: Int
    let replyPL: String
    let replyDE: String
    let must: [String]
}

enum GrammarBook {
    static let topics = [
        "Szyk zdania", "Budowanie pytań", "Czas teraźniejszy Präsens", "Czas przeszły Perfekt", "Czas przeszły Präteritum",
        "Czasowniki modalne: können, müssen, sollen, dürfen, wollen, mögen", "Rodzajniki der, die, das", "Przypadki Nominativ, Akkusativ, Dativ, Genitiv", "Przyimki i ich przypadki", "Wechselpräpositionen",
        "Czasowniki rozdzielnie złożone", "Czasowniki zwrotne", "Odmiana czasowników", "Przeczenia nicht i kein", "Zaimek osobowy i dzierżawczy",
        "Zdania podrzędne z weil, dass, wenn, obwohl", "Spójniki und, aber, oder, denn, sondern", "Stopniowanie przymiotników", "Przymiotniki i końcówki", "Tryb rozkazujący Imperativ",
        "Konstrukcje z zu", "Futur", "Strona bierna Passiv", "Typowe niemieckie konstrukcje potoczne"
    ]

    static let stored: [GLesson] = [
        g("szyk-a1", "Szyk zdania", "A1", "Czasownik na drugim miejscu", "W zwykłym zdaniu czasownik jest drugi. Nie na końcu i nie zawsze zaraz po podmiocie.", "Ich arbeite heute.", [gl("Ich arbeite heute.", "Pracuję dziś."), gl("Heute arbeite ich.", "Dziś pracuję.")], [gl("Ich hole den Helm.", "Biorę kask.")], "Gdzie stoi czasownik?", ["Na końcu", "Na drugim miejscu", "Na początku zawsze"], 1, ["Ich", "arbeite", "heute"], "morgen", "Ich ___ heute auf der Baustelle.", ["arbeite", "arbeiten", "gearbeitet"], 0, "Dziś pracuję.", "Heute arbeite ich.", ["arbeite"]),
        g("szyk-a2", "Szyk zdania", "A2", "Potem, dziś, rano", "Jak zaczniesz od czasu, czasownik i tak zostaje drugi.", "Morgen fange ich um sechs an.", [gl("Morgen fange ich um sechs an.", "Jutro zaczynam o szóstej.")], [gl("Um sieben beginnt die Schicht.", "O siódmej zaczyna się zmiana.")], "Co jest drugie?", ["fange", "morgen", "ich"], 0, ["Morgen", "fange", "ich", "um", "sechs", "an"], "heute", "___ fange ich um sechs an.", ["Morgen", "Ich", "An"], 0, "Jutro zaczynam o szóstej.", "Morgen fange ich um sechs an.", ["fange", "an"]),
        g("pyt-a1", "Budowanie pytań", "A1", "Pytanie z czasownikiem na początku", "W pytaniu tak/nie czasownik idzie na początek.", "Kommst du heute?", [gl("Kommst du heute?", "Przychodzisz dziś?"), gl("Hast du den Helm?", "Masz kask?")], [gl("Ist der Chef da?", "Szef jest?")], "Jak zaczyna się pytanie?", ["Od czasownika", "Od ich zawsze", "Od bitte"], 0, ["Kommst", "du", "heute"], "morgen", "___ du den Schlüssel?", ["Hast", "Haben", "Hat"], 0, "Masz czas?", "Hast du Zeit?", ["hast"]),
        g("pras-a1", "Czas teraźniejszy Präsens", "A1", "Ich, du, er", "W teraźniejszym czasie końcówka zmienia się z osobą. Er/sie/es często dostaje -t.", "Ich mache das. Er macht das.", [gl("Ich mache das.", "Robię to."), gl("Er macht das.", "On to robi.")], [gl("Der Chef sagt Bescheid.", "Szef daje znać.")], "Co pasuje do er?", ["mache", "machst", "macht"], 2, ["Er", "macht", "Pause"], "machen", "Du ___ die Leiter.", ["holst", "holt", "holen"], 0, "On robi przerwę.", "Er macht Pause.", ["macht"]),
        g("perf-a1", "Czas przeszły Perfekt", "A1", "Habe plus ge-", "O przeszłości w mowie: habe albo bin i forma z ge- na końcu.", "Ich habe gearbeitet.", [gl("Ich habe gearbeitet.", "Pracowałem."), gl("Ich bin gekommen.", "Przyszedłem.")], [gl("Ich habe den Helm geholt.", "Przyniosłem kask.")], "Co stoi na końcu?", ["habe", "gearbeitet", "ich"], 1, ["Ich", "habe", "gearbeitet"], "bin", "Ich habe den Schlüssel ___.", ["gesucht", "suchen", "gesuchtet"], 0, "Pracowałem dziś.", "Ich habe heute gearbeitet.", ["habe", "gearbeitet"]),
        g("perf-a2", "Czas przeszły Perfekt", "A2", "Bin przy ruchu", "Kommen, gehen, fahren biorą bin, nie habe.", "Ich bin zur Arbeit gefahren.", [gl("Ich bin gekommen.", "Przyszedłem."), gl("Ich habe gesagt.", "Powiedziałem.")], [gl("Ich bin aufs Gerüst gestiegen.", "Wszedłem na rusztowanie.")], "Które zdanie jest dobre?", ["Ich bin gekommen.", "Ich habe gekommen.", "Ich bin gesagt."], 0, ["Ich", "bin", "zur", "Arbeit", "gefahren"], "habe", "Ich ___ zur Baustelle gefahren.", ["bin", "habe", "ist"], 0, "Pojechałem do pracy.", "Ich bin zur Arbeit gefahren.", ["bin", "gefahren"]),
        g("prat-a2", "Czas przeszły Präteritum", "A2", "War i hatte", "W mowie przeszłość częściej jest w Perfekt. War i hatte słyszysz jednak codziennie.", "Ich war krank. Ich hatte keine Zeit.", [gl("Ich war krank.", "Byłem chory."), gl("Ich hatte keine Zeit.", "Nie miałem czasu.")], [gl("Der Chef war nicht da.", "Szefa nie było.")], "Jak powiesz byłem?", ["Ich bin gewesen tylko", "Ich war", "Ich hatte war"], 1, ["Ich", "war", "krank"], "hatte", "Ich ___ keine Zeit.", ["hatte", "habe", "war"], 0, "Byłem chory.", "Ich war krank.", ["war"]),
        g("mod-a1", "Czasowniki modalne: können, müssen, sollen, dürfen, wollen, mögen", "A1", "Muss i bezokolicznik na końcu", "Modalny jest drugi, a właściwa czynność idzie na koniec, bez zu.", "Ich muss den Chef anrufen.", [gl("Ich muss heute arbeiten.", "Muszę dziś pracować."), gl("Ich kann dir helfen.", "Mogę ci pomóc.")], [gl("Ich muss das Werkzeug holen.", "Muszę przynieść narzędzie.")], "Gdzie jest anrufen?", ["Zaraz po muss", "Na końcu", "Na początku"], 1, ["Ich", "muss", "den", "Chef", "anrufen"], "zu", "Ich muss die Leiter ___.", ["holen", "zu holen", "geholt"], 0, "Muszę zadzwonić do szefa.", "Ich muss den Chef anrufen.", ["muss", "anrufen"]),
        g("mod-a2", "Czasowniki modalne: können, müssen, sollen, dürfen, wollen, mögen", "A2", "Darf, soll, will", "Darf to wolno. Soll to mam zrobić, bo ktoś każe. Will to chcę.", "Darf ich kurz telefonieren?", [gl("Soll ich die Palette holen?", "Mam przynieść paletę?"), gl("Ich will um vier gehen.", "Chcę iść o czwartej.")], [gl("Du darfst ohne Helm nicht hoch.", "Bez kasku nie wolno ci na górę.")], "Co znaczy darf?", ["Muszę", "Wolno mi", "Chcę"], 1, ["Darf", "ich", "kurz", "Pause", "machen"], "muss", "___ ich die Schrauben holen?", ["Soll", "Zu", "Geholt"], 0, "Wolno mi iść na przerwę?", "Darf ich Pause machen?", ["darf"]),
        g("art-a1", "Rodzajniki der, die, das", "A1", "Der, die, das przy słowie", "Rodzajnik jest częścią słowa. Uczysz się der Helm, nie samo Helm.", "der Helm, die Leiter, das Gerüst", [gl("der Helm", "kask"), gl("die Leiter", "drabina"), gl("das Werkzeug", "narzędzie")], [gl("die Pause", "przerwa")], "Jaki rodzajnik przy Leiter?", ["der", "die", "das"], 1, ["Hol", "die", "Leiter"], "der", "Ohne ___ geht hier nichts.", ["Helm", "der Helm", "die Helm"], 1, "Przynieś drabinę.", "Hol die Leiter.", ["die", "leiter"]),
        g("prz-a1", "Przypadki Nominativ, Akkusativ, Dativ, Genitiv", "A1", "Wen widzisz: den", "Jak coś jest celem czynności, der zmienia się w den. Die i das zostają.", "Ich hole den Helm.", [gl("Ich sehe den Chef.", "Widzę szefa."), gl("Ich hole die Leiter.", "Biorę drabinę.")], [gl("Ich brauche den Akkuschrauber.", "Potrzebuję wkrętarki.")], "Co po hole, gdy słowo jest der?", ["der", "den", "dem"], 1, ["Ich", "hole", "den", "Hammer"], "der", "Ich sehe ___ Chef.", ["den", "der", "dem"], 0, "Biorę młotek.", "Ich hole den Hammer.", ["den"]),
        g("prz-a2", "Przypadki Nominativ, Akkusativ, Dativ, Genitiv", "A2", "Komu: dem", "Po mit i bei oraz przy dawaniu der zmienia się w dem.", "Ich spreche mit dem Chef.", [gl("mit dem Kollegen", "z kolegą"), gl("Ich gebe dem Chef Bescheid.", "Mówię szefowi.")], [gl("Ich fahre mit dem Bus.", "Jadę autobusem.")], "Jaka forma po mit?", ["den Chef", "dem Chef", "der Chef"], 1, ["Ich", "spreche", "mit", "dem", "Chef"], "den", "Ich fahre mit ___ Bus.", ["dem", "den", "der"], 0, "Rozmawiam z szefem.", "Ich spreche mit dem Chef.", ["mit", "dem"]),
        g("przy-a1", "Przyimki i ich przypadki", "A1", "Mit, bei, zu", "Mit i bei biorą dem. Zu też często dem: zum Arzt.", "Ich gehe zum Arzt.", [gl("mit dem Kollegen", "z kolegą"), gl("bei der Arbeit", "w pracy")], [gl("Ich muss zum Chef.", "Muszę do szefa.")], "Jak powiesz do lekarza?", ["zu der Arzt", "zum Arzt", "mit Arzt"], 1, ["Ich", "gehe", "zum", "Arzt"], "bei", "Ich arbeite ___ der Firma.", ["bei", "mit", "zu"], 0, "Idę do lekarza.", "Ich gehe zum Arzt.", ["zum"]),
        g("wechs-a2", "Wechselpräpositionen", "A2", "In i auf: dokąd czy gdzie", "Dokąd: in den Keller, aufs Dach. Gdzie: im Keller, auf dem Dach.", "Ich gehe in den Keller.", [gl("Ich bin im Keller.", "Jestem w piwnicy."), gl("Leg es auf den Tisch.", "Połóż to na stół.")], [gl("Komm auf die Baustelle.", "Chodź na budowę.")], "Które znaczy dokąd?", ["im Büro", "in den Keller", "auf dem Dach"], 1, ["Ich", "gehe", "in", "den", "Keller"], "im", "Die Leiter steht auf ___ Dach.", ["dem", "den", "das"], 0, "Idę do piwnicy.", "Ich gehe in den Keller.", ["in", "den"]),
        g("trenn-a1", "Czasowniki rozdzielnie złożone", "A1", "Anrufen rozdziela się", "W zdaniu an idzie na koniec: ich rufe an. W bezokoliczniku wraca: anrufen.", "Ich rufe den Chef an.", [gl("Ich rufe dich an.", "Zadzwonię do ciebie."), gl("Ich muss anrufen.", "Muszę zadzwonić.")], [gl("Fang hinten an.", "Zacznij z tyłu.")], "Gdzie jest an?", ["Przy rufe", "Na końcu", "Przed den"], 1, ["Ich", "rufe", "den", "Chef", "an"], "anrufe", "Ich ___ morgen an.", ["rufe", "anrufe", "gerufen"], 0, "Dzwonię do szefa.", "Ich rufe den Chef an.", ["rufe", "an"]),
        g("zwr-a2", "Czasowniki zwrotne", "A2", "Ich dusche mich", "Przy zwrotnym jest mich albo mir. Nie każdy czasownik go potrzebuje.", "Ich dusche mich.", [gl("Ich ziehe mich um.", "Przebieram się."), gl("Ich wasche mir die Hände.", "Myję ręce.")], [gl("Wir treffen uns um sieben.", "Spotykamy się o siódmej.")], "Co pasuje?", ["Ich dusche mich.", "Ich dusche mir.", "Ich mich dusche."], 0, ["Ich", "dusche", "mich"], "dir", "Wir treffen ___ um sechs.", ["uns", "mich", "sich"], 0, "Przebieram się.", "Ich ziehe mich um.", ["ziehe", "mich"]),
        g("odm-a1", "Odmiana czasowników", "A1", "Du i końcówka -st", "Przy du często jest -st: du kommst, du holst, du machst.", "Du holst die Leiter.", [gl("Du kommst morgen.", "Przychodzisz jutro."), gl("Er kommt heute.", "On przychodzi dziś.")], [gl("Du bringst den Helm.", "Przynosisz kask.")], "Co powie szef do ciebie?", ["du holt", "du holst", "du holen"], 1, ["Du", "holst", "die", "Leiter"], "holt", "Du ___ um sechs.", ["kommst", "kommt", "kommen"], 0, "Przynosisz drabinę.", "Du holst die Leiter.", ["holst"]),
        g("nicht-a1", "Przeczenia nicht i kein", "A1", "Nicht przy czasowniku, kein przy rzeczy", "Keine Zeit, kein Helm. Nicht verstehen, nicht arbeiten.", "Ich habe keinen Helm.", [gl("Ich habe keine Zeit.", "Nie mam czasu."), gl("Ich verstehe das nicht.", "Nie rozumiem tego.")], [gl("Ohne Helm geht das nicht.", "Bez kasku się nie da.")], "Co neguje rzeczownik?", ["nicht", "kein", "nie"], 1, ["Ich", "habe", "keinen", "Helm"], "nicht", "Ich verstehe das ___.", ["nicht", "kein", "keine"], 0, "Nie mam kasku.", "Ich habe keinen Helm.", ["keinen"]),
        g("zaim-a1", "Zaimek osobowy i dzierżawczy", "A1", "Mein, dein, sein", "Dzierżawczy stoi przed rzeczownikiem i dopasowuje się do niego.", "mein Helm, meine Pause", [gl("Das ist mein Schlüssel.", "To mój klucz."), gl("Wo ist deine Tasche?", "Gdzie jest twoja torba?")], [gl("Sein Kollege ist krank.", "Jego kolega jest chory.")], "Które pasuje do die Pause?", ["mein Pause", "meine Pause", "meinen Pause"], 1, ["Das", "ist", "mein", "Schlüssel"], "meine", "Wo ist ___ Tasche?", ["deine", "dein", "deinen"], 0, "To mój klucz.", "Das ist mein Schlüssel.", ["mein"]),
        g("weil-a2", "Zdania podrzędne z weil, dass, wenn, obwohl", "A2", "Weil spycha czasownik na koniec", "Po weil czasownik idzie na koniec. To nie jest zwykłe zdanie.", "Ich komme später, weil der Bus Verspätung hat.", [gl("weil ich krank bin", "bo jestem chory"), gl("weil der Chef das sagt", "bo szef tak mówi")], [gl("Ich bleibe hier, weil das Material fehlt.", "Zostaję, bo brakuje materiału.")], "Gdzie jest hat?", ["Zaraz po weil", "Na końcu", "Na początku"], 1, ["weil", "der", "Bus", "Verspätung", "hat"], "hat der", "Ich komme später, weil ich krank ___.", ["bin", "ich bin", "bin ich"], 0, "Spóźniam się, bo autobus ma opóźnienie.", "Ich komme später, weil der Bus Verspätung hat.", ["weil", "hat"]),
        g("weil-b1", "Zdania podrzędne z weil, dass, wenn, obwohl", "B1", "Dass i wenn", "Dass i wenn też wysyłają czasownik na koniec.", "Sag Bescheid, wenn du fertig bist.", [gl("Ich denke, dass das reicht.", "Myślę, że to wystarczy."), gl("Wenn es regnet, hören wir auf.", "Jak pada, kończymy.")], [gl("Ruf an, wenn der Beton da ist.", "Zadzwoń, jak będzie beton.")], "Co jest dobre?", ["wenn du fertig bist", "wenn du bist fertig", "wenn bist du fertig"], 0, ["Ruf", "an", "wenn", "du", "fertig", "bist"], "weil", "Sag Bescheid, ___ du da bist.", ["wenn", "und", "aber"], 0, "Zadzwoń, jak skończysz.", "Ruf an, wenn du fertig bist.", ["wenn", "bist"]),
        g("spoj-a1", "Spójniki und, aber, oder, denn, sondern", "A1", "Und i aber nie ruszają szyku", "Po und, aber, oder, denn szyk zostaje zwykły: czasownik drugi.", "Ich komme, aber ich habe wenig Zeit.", [gl("Ich hole Zement und Sand.", "Biorę cement i piasek."), gl("Ich will, denn ich muss zum Arzt.", "Chcę, bo muszę do lekarza.")], [gl("Das geht, aber nicht heute.", "Da się, ale nie dziś.")], "Co robi aber?", ["Wysyła czasownik na koniec", "Zostawia zwykły szyk", "Kasuje czasownik"], 1, ["Ich", "komme", "aber", "ich", "habe", "wenig", "Zeit"], "weil", "Ich bleibe, ___ ich bin müde.", ["denn", "weil", "wenn"], 0, "Przyjdę, ale mam mało czasu.", "Ich komme, aber ich habe wenig Zeit.", ["aber"]),
        g("stop-a2", "Stopniowanie przymiotników", "A2", "Schnell, schneller, am schnellsten", "Krótki przymiotnik często dostaje -er. Najwyższy stopień to am ...-sten.", "Er spricht schneller.", [gl("Das ist teurer.", "To jest droższe."), gl("am wichtigsten", "najważniejsze")], [gl("Die linke Seite ist länger.", "Lewa strona jest dłuższa.")], "Jak powiesz szybciej?", ["mehr schnell", "schneller", "am schnell"], 1, ["Er", "spricht", "schneller"], "schnell", "Das ist ___.", ["teurer", "teuerer", "mehr teuer"], 0, "Mów wolniej.", "Sprechen Sie langsamer.", ["langsamer"]),
        g("przym-b1", "Przymiotniki i końcówki", "B1", "Końcówka przed rzeczownikiem", "Przed rzeczownikiem przymiotnik dostaje końcówkę. Po der często -e.", "der neue Helm", [gl("der neue Kollege", "nowy kolega"), gl("die lange Leiter", "długa drabina"), gl("ein neuer Helm", "jakiś nowy kask")], [gl("die nasse Wand", "mokra ściana")], "Co pasuje?", ["der neue Helm", "der neuen Helm", "der neuer Helm"], 0, ["Hol", "den", "neuen", "Hammer"], "neu", "Die ___ Wand muss trocknen.", ["nasse", "nass", "nassen"], 0, "Przynieś nowy kask.", "Hol den neuen Helm.", ["neuen"]),
        g("imp-a1", "Tryb rozkazujący Imperativ", "A1", "Hol, pass auf, kommen Sie", "Do kolegi: hol, komm, pass auf. Do obcego i szefa: kommen Sie, holen Sie.", "Hol die Leiter!", [gl("Pass auf!", "Uważaj!"), gl("Kommen Sie bitte mit.", "Proszę iść ze mną.")], [gl("Bring den Helm mit.", "Weź kask ze sobą.")], "Jak powiesz koledze?", ["Holen Sie die Leiter.", "Hol die Leiter.", "Du holst die Leiter."], 1, ["Hol", "bitte", "die", "Leiter"], "holen", "___ auf, hier ist ein Kabel.", ["Pass", "Passe", "Passen Sie nur"], 0, "Uważaj.", "Pass auf!", ["pass"]),
        g("zu-b1", "Konstrukcje z zu", "B1", "Zu przed czynnością", "Po vergessen, versuchen, vorhaben jest zu plus bezokolicznik. Przy modalnych zu nie ma.", "Ich vergesse, den Chef anzurufen.", [gl("Ich versuche, pünktlich zu kommen.", "Próbuję przyjść punktualnie."), gl("Ich habe vor, früher zu gehen.", "Zamierzam wyjść wcześniej.")], [gl("Vergiss nicht, den Helm aufzusetzen.", "Nie zapomnij założyć kasku.")], "Gdzie jest zu?", ["Po muss", "Po vergessen", "Nigdy"], 1, ["Ich", "vergesse", "den", "Chef", "anzurufen"], "muss", "Vergiss nicht, Bescheid zu ___.", ["sagen", "sagt", "gesagt"], 0, "Zapominam zadzwonić do szefa.", "Ich vergesse, den Chef anzurufen.", ["vergesse", "anzurufen"]),
        g("fut-a2", "Futur", "A2", "Werden plus bezokolicznik", "Przyszłość często mówisz teraźniejszym: morgen komme ich. Werden słychać przy obietnicy i groźbie.", "Ich werde das heute noch machen.", [gl("Das wird knapp.", "Będzie ciasno z czasem."), gl("Ich rufe dich morgen an.", "Zadzwonię jutro.")], [gl("Der Beton wird morgen kommen.", "Beton przyjdzie jutro.")], "Co jest naturalne o jutrze?", ["Morgen komme ich.", "Ich werde morgen kommen tylko tak wolno", "Ich kam morgen."], 0, ["Ich", "werde", "das", "machen"], "komme", "Das ___ knapp.", ["wird", "werden", "wurde"], 0, "Jutro przyjdę.", "Morgen komme ich.", ["morgen", "komme"]),
        g("pas-b1", "Strona bierna Passiv", "B1", "Es wird gemacht", "Jak liczy się czynność, nie osoba: wird plus ge- na końcu.", "Das wird morgen gemacht.", [gl("Der Helm wird kontrolliert.", "Kask jest sprawdzany."), gl("Die Palette wurde geliefert.", "Paleta została dostarczona.")], [gl("Hier wird nicht geraucht.", "Tu się nie pali.")], "Co znaczy das wird gemacht?", ["Ja to zrobiłem wczoraj", "To zostanie zrobione", "Ja muszę natychmiast"], 1, ["Das", "wird", "morgen", "gemacht"], "habe", "Hier wird nicht ___.", ["geraucht", "rauchen", "rauchte"], 0, "To zrobią jutro.", "Das wird morgen gemacht.", ["wird", "gemacht"]),
        g("pot-a2", "Typowe niemieckie konstrukcje potoczne", "A2", "Passt, genau, kriege", "Na budowie słyszysz kurze formy. W pełnym zdaniu i tak trzymaj szyk.", "Passt. Ich kriege das hin.", [gl("Kriegst du das hin?", "Dasz radę?"), gl("Mach langsam.", "Spokojnie."), gl("Ist klar.", "Jasne.")], [gl("Ich bin gleich durch.", "Zaraz kończę.")], "Co znaczy passt?", ["Nie pasuje rozmiar tylko", "W porządku, tak może być", "Jest za późno"], 1, ["Ich", "kriege", "das", "hin"], "bekomme", "___ klar.", ["Ist", "Bin", "Hat"], 0, "Dasz radę.", "Kriegst du das hin?", ["kriegst"]),
        g("pot-b1", "Typowe niemieckie konstrukcje potoczne", "B1", "Hab ich, bin ich", "W mowie hab i bin spadają na początek, gdy potwierdzasz: Hab ich schon gemacht.", "Hab ich schon erledigt.", [gl("Bin ich schon.", "Już jestem."), gl("Mach ich gleich.", "Zaraz zrobię.")], [gl("Krieg ich hin.", "Dam radę.")], "Co to za szyk?", ["Potwierdzenie: czasownik pierwszy", "Błąd, bo zawsze ich pierwsze", "Pytanie o imię"], 0, ["Mach", "ich", "gleich"], "ich mache", "___ ich schon gesagt.", ["Hab", "Hat", "Hatte"], 0, "Zaraz to zrobię.", "Mach ich gleich.", ["mach"]),
        g("gen-b2", "Przypadki Nominativ, Akkusativ, Dativ, Genitiv", "B2", "Wegen i des", "Wegen bierze dopełniacz, ale w mowie często słyszysz wegen dem. W urzędzie lepiej wegen des Regens.", "Wegen des Regens hören wir auf.", [gl("wegen des Sturms", "z powodu burzy"), gl("trotz des Lärms", "mimo hałasu")], [gl("Wegen der Lieferung warten wir.", "Czekamy przez dostawę.")], "Co jest staranniej w urzędzie?", ["wegen dem Regen", "wegen des Regens", "wegen den Regen"], 1, ["Wegen", "des", "Regens", "hören", "wir", "auf"], "dem", "Wir warten wegen ___ Lieferung.", ["der", "des", "den"], 0, "Kończymy przez deszcz.", "Wegen des Regens hören wir auf.", ["wegen"]),
        g("b2-weil", "Zdania podrzędne z weil, dass, wenn, obwohl", "B2", "Obwohl", "Obwohl znaczy mimo że. Czasownik i tak ląduje na końcu.", "Ich komme, obwohl ich krank bin.", [gl("obwohl es regnet", "mimo że pada"), gl("obwohl der Chef nein gesagt hat", "mimo że szef powiedział nie")], [gl("Wir arbeiten, obwohl das Material spät kommt.", "Pracujemy, mimo że materiał jest późno.")], "Co znaczy obwohl?", ["bo", "mimo że", "jeśli"], 1, ["obwohl", "ich", "krank", "bin"], "weil", "Ich arbeite, obwohl ich müde ___.", ["bin", "bin ich", "ich bin"], 0, "Przyjdę, mimo że jestem chory.", "Ich komme, obwohl ich krank bin.", ["obwohl", "bin"])
    ]

    static var lessons: [GLesson] { stored + GrammarExtra.all }

    static func g(_ id: String, _ topic: String, _ level: String, _ title: String, _ explain: String, _ pattern: String, _ examples: [Gloss], _ work: [Gloss], _ ask: String, _ options: [String], _ answer: Int, _ order: [String], _ extra: String, _ cloze: String, _ clozeOptions: [String], _ clozeAnswer: Int, _ replyPL: String, _ replyDE: String, _ must: [String]) -> GLesson {
        GLesson(id: id, topic: topic, level: level, title: title, explain: explain, pattern: pattern, examples: examples, work: work, ask: ask, options: options, answer: answer, order: order, extra: extra, cloze: cloze, clozeOptions: clozeOptions, clozeAnswer: clozeAnswer, replyPL: replyPL, replyDE: replyDE, must: must)
    }

    static func gl(_ de: String, _ pl: String) -> Gloss { Gloss(de: de, pl: pl) }

    static func doneIDs() -> Set<String> { Set(UserDefaults.standard.stringArray(forKey: "grammarDone") ?? []) }

    static func mark(_ id: String, pattern: String) {
        var list = UserDefaults.standard.stringArray(forKey: "grammarDone") ?? []
        if !list.contains(id) { list.append(id) }
        UserDefaults.standard.set(list, forKey: "grammarDone")
        UserDefaults.standard.set(id, forKey: "grammarLast")
        UserDefaults.standard.set(pattern, forKey: "freshPattern")
    }
}

struct GrammarLibraryView: View {
    @State private var level = "Wszystko"
    @State private var refresh = 0

    var body: some View {
        let _ = refresh
        List {
            Section {
                Text("Ukończone lekcje: \(GrammarBook.doneIDs().count) z \(GrammarBook.lessons.count).")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
                Picker("Poziom", selection: $level) {
                    Text("Wszystko").tag("Wszystko")
                    Text("A1").tag("A1")
                    Text("A2").tag("A2")
                    Text("B1").tag("B1")
                    Text("B2").tag("B2")
                }
                .pickerStyle(.segmented)
            }
            ForEach(GrammarBook.topics, id: \.self) { topic in
                let items = GrammarBook.lessons.filter { $0.topic == topic && (level == "Wszystko" || $0.level == level) }
                if !items.isEmpty {
                    Section(topic) {
                        ForEach(items) { lesson in
                            NavigationLink {
                                GrammarLessonView(lesson: lesson)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(lesson.title)
                                        Text(lesson.level).font(.caption).foregroundStyle(Theme.text2)
                                    }
                                    Spacer()
                                    if GrammarBook.doneIDs().contains(lesson.id) {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.ok)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Wzorce gramatyczne")
        .containerBackground(for: .navigation) { Color.black }
        .onAppear { refresh += 1 }
    }
}

struct GrammarLessonView: View {
    @EnvironmentObject var store: LearningStore
    let lesson: GLesson
    @State private var step = 0
    @State private var picked: Int?
    @State private var built: [String] = []
    @State private var clozePick: Int?
    @State private var typed = ""
    @State private var made = ""
    @State private var note = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("\(lesson.level) · \(lesson.topic)").font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                Text(lesson.title).font(.title2.bold())
                if step == 0 { teach }
                if step == 1 { choose }
                if step == 2 { orderStep }
                if step == 3 { clozeStep }
                if step == 4 { writeStep }
            }
            .padding(16)
        }
        .navigationTitle("Wzorzec")
        .containerBackground(for: .navigation) { Color.black }
        .onDisappear { Talk.stop() }
    }

    private var teach: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lesson.explain)
            Text(lesson.pattern).font(.title3.bold()).foregroundStyle(Theme.ok)
            ForEach(lesson.examples) { item in
                VStack(alignment: .leading) {
                    Text(item.de).font(.headline)
                    Text(item.pl).foregroundStyle(Theme.text2)
                }
            }
            Text("Z pracy").font(.headline)
            ForEach(lesson.work) { item in
                Text("\(item.de) — \(item.pl)").font(.subheadline)
            }
            Button { Talk.de(lesson.pattern, rate: Speaker.savedPace()) } label: { Label("Posłuchaj wzorca", systemImage: "speaker.wave.2") }
                .buttonStyle(.glass)
            Button("Ćwiczę") { step = 1 }.primaryButton()
        }
    }

    private var choose: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lesson.ask).font(.headline)
            ForEach(lesson.options.indices, id: \.self) { index in
                Button(lesson.options[index]) {
                    guard picked == nil else { return }
                    picked = index
                    if index != lesson.answer { store.noteSkill("grammar", ok: false) }
                }
                .frame(maxWidth: .infinity, minHeight: 48)
                .foregroundStyle(.white)
                .background(index == lesson.answer && picked != nil ? Theme.ok.opacity(0.8) : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            if let picked {
                MerkeBox(text: picked == lesson.answer ? "Dobrze. Wzorzec: \(lesson.pattern)" : "Jeszcze nie. \(lesson.explain)")
                if picked == lesson.answer {
                    Button("Ułóż zdanie") { step = 2 }.primaryButton()
                } else {
                    Button("Jeszcze raz") { self.picked = nil }.primaryButton()
                }
            }
        }
    }

    private var orderStep: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(built.isEmpty ? "Stukaj słowa po kolei." : built.joined(separator: " ")).font(.title3.bold())
            let pool = (lesson.order + [lesson.extra]).filter { word in built.filter { $0 == word }.count < (lesson.order + [lesson.extra]).filter { $0 == word }.count }
            ForEach(Array(pool.enumerated()), id: \.offset) { _, word in
                Button(word) { built.append(word) }
                    .buttonStyle(.glass)
            }
            HStack {
                Button("Cofnij") {
                    if !built.isEmpty { built.removeLast() }
                    note = ""
                }
                .buttonStyle(.glass)
                Button("Od nowa") { built = []; note = "" }
                    .buttonStyle(.glass)
            }
            Button("Sprawdź szyk") {
                if built == lesson.order {
                    note = "Szyk jest dobry."
                    step = 3
                } else {
                    note = "Jeszcze nie. Wzorzec: \(lesson.order.joined(separator: " "))."
                    built = []
                    HardBook.add(de: lesson.replyDE, pl: lesson.replyPL)
                }
            }
            .primaryButton()
            .disabled(built.count < lesson.order.count)
            if !note.isEmpty { Text(note).foregroundStyle(Theme.text2) }
        }
    }

    private var clozeStep: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lesson.cloze).font(.title3.bold())
            ForEach(lesson.clozeOptions.indices, id: \.self) { index in
                Button(lesson.clozeOptions[index]) { clozePick = index }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(clozePick == index ? Theme.ok.opacity(0.3) : Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            Button("Dalej") {
                if clozePick == lesson.clozeAnswer { step = 4 } else {
                    note = "Luka: \(lesson.clozeOptions[lesson.clozeAnswer])."
                    store.noteSkill("grammar", ok: false)
                }
            }
            .primaryButton()
            .disabled(clozePick == nil)
            if !note.isEmpty, step == 3 { Text(note) }
        }
    }

    private var writeStep: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(lesson.replyPL).font(.headline)
            TextField("Po niemiecku", text: $typed)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            Button("Sprawdź tłumaczenie") {
                if Normalizer.same(typed, lesson.replyDE) {
                    note = "Dobrze."
                    finish()
                } else {
                    note = "Wzorzec: \(lesson.replyDE)"
                    HardBook.add(de: lesson.replyDE, pl: lesson.replyPL)
                }
            }
            .primaryButton()
            Text("Albo ułóż własne zdanie z: \(lesson.must.joined(separator: ", "))").font(.footnote).foregroundStyle(Theme.text2)
            TextField("Twoje zdanie", text: $made)
                .textFieldStyle(.roundedBorder)
            Button("Sprawdź własne") {
                let low = made.lowercased()
                let ok = lesson.must.allSatisfy { low.contains($0.lowercased()) } && made.split(separator: " ").count >= 3
                if ok {
                    note = "Jest wzorzec. Zdanie zostaje do rozmowy."
                    finish()
                } else {
                    note = "W zdaniu mają być: \(lesson.must.joined(separator: ", "))."
                }
            }
            .buttonStyle(.glass)
            if !note.isEmpty { MerkeBox(text: note) }
        }
    }

    private func finish() {
        GrammarBook.mark(lesson.id, pattern: lesson.pattern)
        store.noteSkill("grammar", ok: true)
        UserDefaults.standard.set(lesson.pattern, forKey: "freshPattern")
    }
}
