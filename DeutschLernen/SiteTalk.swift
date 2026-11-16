import SwiftUI

struct SiteLine: Identifiable {
    var id: String { de }
    let topic: String
    let de: String
    let pl: String
    let question: String
    let options: [String]
    let answer: Int
}

enum SiteTalk {
    static let lines: [SiteLine] = [
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Schaufel und bring sie zur Rampe.\nDu: Alles klar. Ich bringe sie zur Rampe.", pl: "Szef każe przynieść łopatę na rampę.", question: "Co masz przynieść?", options: ["Łopatę", "Młotek", "Drabinę"], answer: 0),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Hammer und bring ihn nach hinten.\nDu: Alles klar. Ich bringe ihn nach hinten.", pl: "Szef każe przynieść młotek do tyłu.", question: "Co masz przynieść?", options: ["Łopatę", "Drabinę", "Młotek"], answer: 2),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Leiter und bring sie in den Keller.\nDu: Alles klar. Ich bringe sie in den Keller.", pl: "Szef każe przynieść drabinę do piwnicy.", question: "Co masz przynieść?", options: ["Młotek", "Drabinę", "Łopatę"], answer: 1),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Helm und bring ihn aufs Dach.\nDu: Alles klar. Ich bringe ihn aufs Dach.", pl: "Szef każe przynieść kask na dach.", question: "Co masz przynieść?", options: ["Kask", "Łopatę", "Młotek"], answer: 0),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Bohrmaschine und bring sie zum Gerüst.\nDu: Alles klar. Ich bringe sie zum Gerüst.", pl: "Szef każe przynieść wiertarkę na rusztowanie.", question: "Co masz przynieść?", options: ["Łopatę", "Młotek", "Wiertarkę"], answer: 2),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Zollstock und bring ihn in die Halle.\nDu: Alles klar. Ich bringe ihn in die Halle.", pl: "Szef każe przynieść metrówkę na halę.", question: "Co masz przynieść?", options: ["Młotek", "Metrówkę", "Łopatę"], answer: 1),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Wasserwaage und bring sie zum Container.\nDu: Alles klar. Ich bringe sie zum Container.", pl: "Szef każe przynieść poziomicę do kontenera.", question: "Co masz przynieść?", options: ["Poziomicę", "Łopatę", "Młotek"], answer: 0),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Eimer und bring es zur Grube.\nDu: Alles klar. Ich bringe es zur Grube.", pl: "Szef każe przynieść wiadro do wykopu.", question: "Co masz przynieść?", options: ["Łopatę", "Młotek", "Wiadro"], answer: 2),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Kelle und bring sie zur Rampe.\nDu: Alles klar. Ich bringe sie zur Rampe.", pl: "Szef każe przynieść kielnię na rampę.", question: "Co masz przynieść?", options: ["Młotek", "Kielnię", "Łopatę"], answer: 1),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Akkuschrauber und bring ihn nach hinten.\nDu: Alles klar. Ich bringe ihn nach hinten.", pl: "Szef każe przynieść wkrętarkę do tyłu.", question: "Co masz przynieść?", options: ["Wkrętarkę", "Łopatę", "Młotek"], answer: 0),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Flex und bring sie in den Keller.\nDu: Alles klar. Ich bringe sie in den Keller.", pl: "Szef każe przynieść szlifierkę do piwnicy.", question: "Co masz przynieść?", options: ["Łopatę", "Młotek", "Szlifierkę"], answer: 2),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Schubkarre und bring sie aufs Dach.\nDu: Alles klar. Ich bringe sie aufs Dach.", pl: "Szef każe przynieść taczkę na dach.", question: "Co masz przynieść?", options: ["Młotek", "Taczkę", "Łopatę"], answer: 1),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Besen und bring ihn zum Gerüst.\nDu: Alles klar. Ich bringe ihn zum Gerüst.", pl: "Szef każe przynieść miotłę na rusztowanie.", question: "Co masz przynieść?", options: ["Miotłę", "Łopatę", "Młotek"], answer: 0),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Säge und bring sie in die Halle.\nDu: Alles klar. Ich bringe sie in die Halle.", pl: "Szef każe przynieść piłę na halę.", question: "Co masz przynieść?", options: ["Łopatę", "Młotek", "Piłę"], answer: 2),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte den Meißel und bring ihn zum Container.\nDu: Alles klar. Ich bringe ihn zum Container.", pl: "Szef każe przynieść dłuto do kontenera.", question: "Co masz przynieść?", options: ["Młotek", "Dłuto", "Łopatę"], answer: 1),
        SiteLine(topic: "Polecenia szefa", de: "Chef: Hol bitte die Lampe und bring sie zur Grube.\nDu: Alles klar. Ich bringe sie zur Grube.", pl: "Szef każe przynieść lampę do wykopu.", question: "Co masz przynieść?", options: ["Lampę", "Łopatę", "Młotek"], answer: 0),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch zehn Sack Zement, nicht die Hälfte.\nDu: Okay, ich hole zehn Sack Zement.", pl: "Potrzebujecie jeszcze: dziesięć worków cementu.", question: "Ile masz przynieść?", options: ["Pięć palet cegieł", "Dwadzieścia metrów kabla", "Dziesięć worków cementu"], answer: 2),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch fünf Paletten Steine, nicht die Hälfte.\nDu: Okay, ich hole fünf Paletten Steine.", pl: "Potrzebujecie jeszcze: pięć palet cegieł.", question: "Ile masz przynieść?", options: ["Dwadzieścia metrów kabla", "Pięć palet cegieł", "Dziesięć worków cementu"], answer: 1),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch zwanzig Meter Kabel, nicht die Hälfte.\nDu: Okay, ich hole zwanzig Meter Kabel.", pl: "Potrzebujecie jeszcze: dwadzieścia metrów kabla.", question: "Ile masz przynieść?", options: ["Dwadzieścia metrów kabla", "Dziesięć worków cementu", "Pięć palet cegieł"], answer: 0),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch acht Schrauben, nicht die Hälfte.\nDu: Okay, ich hole acht Schrauben.", pl: "Potrzebujecie jeszcze: osiem śrub.", question: "Ile masz przynieść?", options: ["Dziesięć worków cementu", "Pięć palet cegieł", "Osiem śrub"], answer: 2),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch drei Eimer Farbe, nicht die Hälfte.\nDu: Okay, ich hole drei Eimer Farbe.", pl: "Potrzebujecie jeszcze: trzy wiadra farby.", question: "Ile masz przynieść?", options: ["Pięć palet cegieł", "Trzy wiadra farby", "Dziesięć worków cementu"], answer: 1),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch vier Rollen Dichtung, nicht die Hälfte.\nDu: Okay, ich hole vier Rollen Dichtung.", pl: "Potrzebujecie jeszcze: cztery rolki uszczelki.", question: "Ile masz przynieść?", options: ["Cztery rolki uszczelki", "Dziesięć worków cementu", "Pięć palet cegieł"], answer: 0),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch sechs Platten Gips, nicht die Hälfte.\nDu: Okay, ich hole sechs Platten Gips.", pl: "Potrzebujecie jeszcze: sześć płyt gipsu.", question: "Ile masz przynieść?", options: ["Dziesięć worków cementu", "Pięć palet cegieł", "Sześć płyt gipsu"], answer: 2),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch zwei Kanister Öl, nicht die Hälfte.\nDu: Okay, ich hole zwei Kanister Öl.", pl: "Potrzebujecie jeszcze: dwa kanistry oleju.", question: "Ile masz przynieść?", options: ["Pięć palet cegieł", "Dwa kanistry oleju", "Dziesięć worków cementu"], answer: 1),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch fünfzehn Dübel, nicht die Hälfte.\nDu: Okay, ich hole fünfzehn Dübel.", pl: "Potrzebujecie jeszcze: piętnaście kołków.", question: "Ile masz przynieść?", options: ["Piętnaście kołków", "Dziesięć worków cementu", "Pięć palet cegieł"], answer: 0),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch sieben Latten, nicht die Hälfte.\nDu: Okay, ich hole sieben Latten.", pl: "Potrzebujecie jeszcze: siedem łat.", question: "Ile masz przynieść?", options: ["Dziesięć worków cementu", "Pięć palet cegieł", "Siedem łat"], answer: 2),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch neun Säcke Sand, nicht die Hälfte.\nDu: Okay, ich hole neun Säcke Sand.", pl: "Potrzebujecie jeszcze: dziewięć worków piasku.", question: "Ile masz przynieść?", options: ["Pięć palet cegieł", "Dziewięć worków piasku", "Dziesięć worków cementu"], answer: 1),
        SiteLine(topic: "Materiały", de: "Chef: Wir brauchen noch zwölf Fliesen, nicht die Hälfte.\nDu: Okay, ich hole zwölf Fliesen.", pl: "Potrzebujecie jeszcze: dwanaście płytek.", question: "Ile masz przynieść?", options: ["Dwanaście płytek", "Dziesięć worków cementu", "Pięć palet cegieł"], answer: 0),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 40 Zentimeter tief, nicht flacher.\nDu: Verstanden, 40 Zentimeter.", pl: "Dół ma mieć 40 centymetrów głębokości.", question: "Jak głęboko?", options: ["80 cm", "40 cm", "60 cm"], answer: 1),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 60 Zentimeter tief, nicht flacher.\nDu: Verstanden, 60 Zentimeter.", pl: "Dół ma mieć 60 centymetrów głębokości.", question: "Jak głęboko?", options: ["60 cm", "40 cm", "80 cm"], answer: 0),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 80 Zentimeter tief, nicht flacher.\nDu: Verstanden, 80 Zentimeter.", pl: "Dół ma mieć 80 centymetrów głębokości.", question: "Jak głęboko?", options: ["40 cm", "60 cm", "80 cm"], answer: 2),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 100 Zentimeter tief, nicht flacher.\nDu: Verstanden, 100 Zentimeter.", pl: "Dół ma mieć 100 centymetrów głębokości.", question: "Jak głęboko?", options: ["60 cm", "100 cm", "40 cm"], answer: 1),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 120 Zentimeter tief, nicht flacher.\nDu: Verstanden, 120 Zentimeter.", pl: "Dół ma mieć 120 centymetrów głębokości.", question: "Jak głęboko?", options: ["120 cm", "40 cm", "60 cm"], answer: 0),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 150 Zentimeter tief, nicht flacher.\nDu: Verstanden, 150 Zentimeter.", pl: "Dół ma mieć 150 centymetrów głębokości.", question: "Jak głęboko?", options: ["40 cm", "60 cm", "150 cm"], answer: 2),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 30 Zentimeter tief, nicht flacher.\nDu: Verstanden, 30 Zentimeter.", pl: "Dół ma mieć 30 centymetrów głębokości.", question: "Jak głęboko?", options: ["60 cm", "30 cm", "40 cm"], answer: 1),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 50 Zentimeter tief, nicht flacher.\nDu: Verstanden, 50 Zentimeter.", pl: "Dół ma mieć 50 centymetrów głębokości.", question: "Jak głęboko?", options: ["50 cm", "40 cm", "60 cm"], answer: 0),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 70 Zentimeter tief, nicht flacher.\nDu: Verstanden, 70 Zentimeter.", pl: "Dół ma mieć 70 centymetrów głębokości.", question: "Jak głęboko?", options: ["40 cm", "60 cm", "70 cm"], answer: 2),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 90 Zentimeter tief, nicht flacher.\nDu: Verstanden, 90 Zentimeter.", pl: "Dół ma mieć 90 centymetrów głębokości.", question: "Jak głęboko?", options: ["60 cm", "90 cm", "40 cm"], answer: 1),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 200 Zentimeter tief, nicht flacher.\nDu: Verstanden, 200 Zentimeter.", pl: "Dół ma mieć 200 centymetrów głębokości.", question: "Jak głęboko?", options: ["200 cm", "40 cm", "60 cm"], answer: 0),
        SiteLine(topic: "Wymiary", de: "Chef: Mach das Loch 25 Zentimeter tief, nicht flacher.\nDu: Verstanden, 25 Zentimeter.", pl: "Dół ma mieć 25 centymetrów głębokości.", question: "Jak głęboko?", options: ["40 cm", "60 cm", "25 cm"], answer: 2),
        SiteLine(topic: "Godziny", de: "Chef: Die Frühschicht ist um sechs. Komm pünktlich.\nDu: Alles klar, um sechs.", pl: "Frühschicht jest o szóstej.", question: "O której?", options: ["O ósmej", "O szóstej", "O siódmej"], answer: 1),
        SiteLine(topic: "Godziny", de: "Chef: Die Frühschicht ist um sieben. Komm pünktlich.\nDu: Alles klar, um sieben.", pl: "Frühschicht jest o siódmej.", question: "O której?", options: ["O siódmej", "O szóstej", "O ósmej"], answer: 0),
        SiteLine(topic: "Godziny", de: "Chef: Die Spätschicht ist um acht. Komm pünktlich.\nDu: Alles klar, um acht.", pl: "Spätschicht jest o ósmej.", question: "O której?", options: ["O szóstej", "O siódmej", "O ósmej"], answer: 2),
        SiteLine(topic: "Godziny", de: "Chef: Die Spätschicht ist um vierzehn. Komm pünktlich.\nDu: Alles klar, um vierzehn.", pl: "Spätschicht jest o czternastej.", question: "O której?", options: ["O siódmej", "O czternastej", "O szóstej"], answer: 1),
        SiteLine(topic: "Godziny", de: "Chef: Die Nachtschicht ist um fünfzehn. Komm pünktlich.\nDu: Alles klar, um fünfzehn.", pl: "Nachtschicht jest o piętnastej.", question: "O której?", options: ["O piętnastej", "O szóstej", "O siódmej"], answer: 0),
        SiteLine(topic: "Godziny", de: "Chef: Die Feierabend ist um sechzehn. Komm pünktlich.\nDu: Alles klar, um sechzehn.", pl: "Feierabend jest o szesnastej.", question: "O której?", options: ["O szóstej", "O siódmej", "O szesnastej"], answer: 2),
        SiteLine(topic: "Godziny", de: "Chef: Die Pause ist um neun. Komm pünktlich.\nDu: Alles klar, um neun.", pl: "Pause jest o dziewiątej.", question: "O której?", options: ["O siódmej", "O dziewiątej", "O szóstej"], answer: 1),
        SiteLine(topic: "Godziny", de: "Chef: Die Pause ist um zwölf. Komm pünktlich.\nDu: Alles klar, um zwölf.", pl: "Pause jest o dwunastej.", question: "O której?", options: ["O dwunastej", "O szóstej", "O siódmej"], answer: 0),
        SiteLine(topic: "Godziny", de: "Chef: Die Schicht ist um dreizehn. Komm pünktlich.\nDu: Alles klar, um dreizehn.", pl: "Schicht jest o trzynastej.", question: "O której?", options: ["O szóstej", "O siódmej", "O trzynastej"], answer: 2),
        SiteLine(topic: "Godziny", de: "Chef: Die Feierabend ist um siebzehn. Komm pünktlich.\nDu: Alles klar, um siebzehn.", pl: "Feierabend jest o siedemnastej.", question: "O której?", options: ["O siódmej", "O siedemnastej", "O szóstej"], answer: 1),
        SiteLine(topic: "Godziny", de: "Chef: Die Nachtschicht ist um achtzehn. Komm pünktlich.\nDu: Alles klar, um achtzehn.", pl: "Nachtschicht jest o osiemnastej.", question: "O której?", options: ["O osiemnastej", "O szóstej", "O siódmej"], answer: 0),
        SiteLine(topic: "Godziny", de: "Chef: Die Frühschicht ist um fünf. Komm pünktlich.\nDu: Alles klar, um fünf.", pl: "Frühschicht jest o piątej.", question: "O której?", options: ["O szóstej", "O siódmej", "O piątej"], answer: 2),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Ohne Helm darfst du nicht aufs Gerüst.\nDu: Verstanden.", pl: "Bez kasku nie wolno na rusztowanie.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów", "Dotykać kabla"], answer: 0),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Zieh die Sicherheitsschuhe an, bevor du in die Grube gehst.\nDu: Verstanden.", pl: "Załóż buty ochronne, zanim wejdziesz do wykopu.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść na rusztowanie bez kasku", "Dotykać kabla", "Wejść do wykopu bez butów"], answer: 2),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Pass auf, hier ist ein offenes Kabel.\nDu: Verstanden.", pl: "Uważaj, tu jest odsłonięty kabel.", question: "Czego nie wolno albo na co uważasz?", options: ["Wejść do wykopu bez butów", "Dotykać kabla", "Iść na rusztowanie bez kasku"], answer: 1),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Der Boden ist nass. Da kann man ausrutschen.\nDu: Verstanden.", pl: "Podłoga jest mokra. Można się poślizgnąć.", question: "Czego nie wolno albo na co uważasz?", options: ["Biec po mokrej podłodze", "Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów"], answer: 0),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Fahr nicht mit dem Stapler, wenn die Batterie rot ist.\nDu: Verstanden.", pl: "Nie jedź wózkiem, gdy bateria jest czerwona.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów", "Jeździć na czerwonej baterii"], answer: 2),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Ohne Brille keine Flex.\nDu: Verstanden.", pl: "Bez okularów nie ma szlifierki.", question: "Czego nie wolno albo na co uważasz?", options: ["Wejść do wykopu bez butów", "Szlifować bez okularów", "Iść na rusztowanie bez kasku"], answer: 1),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Halt Abstand zur Maschine, solange sie läuft.\nDu: Verstanden.", pl: "Trzymaj odstęp od maszyny, dopóki pracuje.", question: "Czego nie wolno albo na co uważasz?", options: ["Wkładać rękę w maszynę", "Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów"], answer: 0),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Die Grube ist nicht gesichert. Geh da nicht ran.\nDu: Verstanden.", pl: "Wykop nie jest zabezpieczony. Nie podchodź.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów", "Stać na krawędzi wykopu"], answer: 2),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Handschuhe an, das Blech ist scharf.\nDu: Verstanden.", pl: "Rękawice, blacha jest ostra.", question: "Czego nie wolno albo na co uważasz?", options: ["Wejść do wykopu bez butów", "Chwytać blachę gołą ręką", "Iść na rusztowanie bez kasku"], answer: 1),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Nicht unter die schwebende Last gehen.\nDu: Verstanden.", pl: "Nie wchodzić pod wiszący ładunek.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść pod ładunkiem", "Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów"], answer: 0),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Der Feuerlöscher hängt neben der Tür.\nDu: Verstanden.", pl: "Gaśnica wisi obok drzwi.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów", "Szukać gaśnicy w aucie"], answer: 2),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Heute kein Feuer, der Wind ist zu stark.\nDu: Verstanden.", pl: "Dziś bez ognia, wiatr jest za mocny.", question: "Czego nie wolno albo na co uważasz?", options: ["Wejść do wykopu bez butów", "Palić na placu", "Iść na rusztowanie bez kasku"], answer: 1),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Die Absperrung bleibt stehen.\nDu: Verstanden.", pl: "Wygrodzenie zostaje.", question: "Czego nie wolno albo na co uważasz?", options: ["Zdejmować taśmę", "Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów"], answer: 0),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Melde jeden Schnitt sofort dem Chef.\nDu: Verstanden.", pl: "Każde skaleczenie od razu zgłoś szefowi.", question: "Czego nie wolno albo na co uważasz?", options: ["Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów", "Ukrywać skaleczenie"], answer: 2),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Trinkwasser ist im Container, nicht aus dem Schlauch.\nDu: Verstanden.", pl: "Woda do picia jest w kontenerze, nie z węża.", question: "Czego nie wolno albo na co uważasz?", options: ["Wejść do wykopu bez butów", "Pić z węża", "Iść na rusztowanie bez kasku"], answer: 1),
        SiteLine(topic: "Bezpieczeństwo", de: "Chef: Bei Gewitter runter vom Gerüst.\nDu: Verstanden.", pl: "Przy burzy schodzimy z rusztowania.", question: "Czego nie wolno albo na co uważasz?", options: ["Zostać na rusztowaniu w burzy", "Iść na rusztowanie bez kasku", "Wejść do wykopu bez butów"], answer: 0),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Bohrmaschine läuft nicht. Der Akku ist leer.\nChef: Sag Bescheid, ich komme.", pl: "Wiertarka nie działa. Akumulator jest pusty.", question: "Co jest nie tak?", options: ["Nie ma ciśnienia", "Piła stoi w drewnie", "Akumulator jest pusty"], answer: 2),
        SiteLine(topic: "Problemy", de: "Du: Chef, Der Kompressor baut keinen Druck auf.\nChef: Sag Bescheid, ich komme.", pl: "Kompresor nie nabija ciśnienia.", question: "Co jest nie tak?", options: ["Piła stoi w drewnie", "Nie ma ciśnienia", "Akumulator jest pusty"], answer: 1),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Säge klemmt im Holz.\nChef: Sag Bescheid, ich komme.", pl: "Piła zacina się w drewnie.", question: "Co jest nie tak?", options: ["Piła stoi w drewnie", "Akumulator jest pusty", "Nie ma ciśnienia"], answer: 0),
        SiteLine(topic: "Problemy", de: "Du: Chef, Der Aufzug bleibt zwischen den Etagen stehen.\nChef: Sag Bescheid, ich komme.", pl: "Winda staje między piętrami.", question: "Co jest nie tak?", options: ["Akumulator jest pusty", "Nie ma ciśnienia", "Winda stanęła"], answer: 2),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Pumpe fördert kein Wasser.\nChef: Sag Bescheid, ich komme.", pl: "Pompa nie podaje wody.", question: "Co jest nie tak?", options: ["Nie ma ciśnienia", "Pompa nie daje wody", "Akumulator jest pusty"], answer: 1),
        SiteLine(topic: "Problemy", de: "Du: Chef, Das Gerüst wackelt auf der linken Seite.\nChef: Sag Bescheid, ich komme.", pl: "Rusztowanie kiwa się z lewej.", question: "Co jest nie tak?", options: ["Rusztowanie jest luźne z lewej", "Akumulator jest pusty", "Nie ma ciśnienia"], answer: 0),
        SiteLine(topic: "Problemy", de: "Du: Chef, Der Beton ist schon zu fest.\nChef: Sag Bescheid, ich komme.", pl: "Beton jest już za twardy.", question: "Co jest nie tak?", options: ["Akumulator jest pusty", "Nie ma ciśnienia", "Beton związał"], answer: 2),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Lieferung ist beschädigt.\nChef: Sag Bescheid, ich komme.", pl: "Dostawa jest uszkodzona.", question: "Co jest nie tak?", options: ["Nie ma ciśnienia", "Dostawa jest uszkodzona", "Akumulator jest pusty"], answer: 1),
        SiteLine(topic: "Problemy", de: "Du: Chef, Im Keller steht Wasser.\nChef: Sag Bescheid, ich komme.", pl: "W piwnicy stoi woda.", question: "Co jest nie tak?", options: ["W piwnicy jest woda", "Akumulator jest pusty", "Nie ma ciśnienia"], answer: 0),
        SiteLine(topic: "Problemy", de: "Du: Chef, Der Schlüssel für den Container fehlt.\nChef: Sag Bescheid, ich komme.", pl: "Nie ma klucza do kontenera.", question: "Co jest nie tak?", options: ["Akumulator jest pusty", "Nie ma ciśnienia", "Brakuje klucza"], answer: 2),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Sicherung ist raus.\nChef: Sag Bescheid, ich komme.", pl: "Wybity bezpiecznik.", question: "Co jest nie tak?", options: ["Nie ma ciśnienia", "Nie ma prądu, bezpiecznik", "Akumulator jest pusty"], answer: 1),
        SiteLine(topic: "Problemy", de: "Du: Chef, Das Maß stimmt nicht. Es ist fünf Zentimeter zu kurz.\nChef: Sag Bescheid, ich komme.", pl: "Wymiar się nie zgadza. Jest o pięć centymetrów za krótki.", question: "Co jest nie tak?", options: ["Za krótkie o 5 cm", "Akumulator jest pusty", "Nie ma ciśnienia"], answer: 0),
        SiteLine(topic: "Problemy", de: "Du: Chef, Der Lkw kommt nicht durch das Tor.\nChef: Sag Bescheid, ich komme.", pl: "Ciężarówka nie mieści się w bramie.", question: "Co jest nie tak?", options: ["Akumulator jest pusty", "Nie ma ciśnienia", "Ciężarówka nie wjeżdża"], answer: 2),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Fliesen sind die falsche Farbe.\nChef: Sag Bescheid, ich komme.", pl: "Płytki są w złym kolorze.", question: "Co jest nie tak?", options: ["Nie ma ciśnienia", "Zły kolor płytek", "Akumulator jest pusty"], answer: 1),
        SiteLine(topic: "Problemy", de: "Du: Chef, Der Anhänger hat einen platten Reifen.\nChef: Sag Bescheid, ich komme.", pl: "Przyczepa ma flaka.", question: "Co jest nie tak?", options: ["Flak w przyczepie", "Akumulator jest pusty", "Nie ma ciśnienia"], answer: 0),
        SiteLine(topic: "Problemy", de: "Du: Chef, die Heizung auf der Baustelle ist aus.\nChef: Sag Bescheid, ich komme.", pl: "Ogrzewanie na budowie jest wyłączone.", question: "Co jest nie tak?", options: ["Akumulator jest pusty", "Nie ma ciśnienia", "Nie ma ogrzewania"], answer: 2),
        SiteLine(topic: "Pomoc", de: "Du: Kannst du mir kurz die Leiter halten?\nKollege: Ja, ich komme.", pl: "Możesz mi chwilę potrzymać drabinę?", question: "O co prosisz?", options: ["Asekurować na dole", "Potrzymać drabinę", "Pomóc przy palecie"], answer: 1),
        SiteLine(topic: "Pomoc", de: "Du: Ich schaffe die Palette nicht alleine.\nKollege: Ja, ich komme.", pl: "Nie uniosę palety sam.", question: "O co prosisz?", options: ["Pomóc przy palecie", "Potrzymać drabinę", "Asekurować na dole"], answer: 0),
        SiteLine(topic: "Pomoc", de: "Du: Kannst du unten sichern, während ich hochgehe?\nKollege: Ja, ich komme.", pl: "Możesz asekurować na dole, jak wchodzę?", question: "O co prosisz?", options: ["Potrzymać drabinę", "Pomóc przy palecie", "Asekurować na dole"], answer: 2),
        SiteLine(topic: "Pomoc", de: "Du: Hilf mir bitte, die Platte zu drehen.\nKollege: Ja, ich komme.", pl: "Pomóż obrócić płytę.", question: "O co prosisz?", options: ["Pomóc przy palecie", "Obrócić płytę", "Potrzymać drabinę"], answer: 1),
        SiteLine(topic: "Pomoc", de: "Du: Kannst du den Chef anrufen? Ich bin auf dem Dach.\nKollege: Ja, ich komme.", pl: "Możesz zadzwonić do szefa? Jestem na dachu.", question: "O co prosisz?", options: ["Zadzwonić do szefa", "Potrzymać drabinę", "Pomóc przy palecie"], answer: 0),
        SiteLine(topic: "Pomoc", de: "Du: Ich brauche jemanden an der Schubkarre.\nKollege: Ja, ich komme.", pl: "Potrzebuję kogoś przy taczce.", question: "O co prosisz?", options: ["Potrzymać drabinę", "Pomóc przy palecie", "Pomóc przy taczce"], answer: 2),
        SiteLine(topic: "Pomoc", de: "Du: Kannst du die Maße noch einmal prüfen?\nKollege: Ja, ich komme.", pl: "Możesz jeszcze raz sprawdzić wymiary?", question: "O co prosisz?", options: ["Pomóc przy palecie", "Sprawdzić wymiary", "Potrzymać drabinę"], answer: 1),
        SiteLine(topic: "Pomoc", de: "Du: Halt bitte das Kabel weg von der Säge.\nKollege: Ja, ich komme.", pl: "Trzymaj kabel z dala od piły.", question: "O co prosisz?", options: ["Odsunąć kabel od piły", "Potrzymać drabinę", "Pomóc przy palecie"], answer: 0),
        SiteLine(topic: "Pomoc", de: "Du: Kannst du mir den Helm vom Container holen?\nKollege: Ja, ich komme.", pl: "Możesz przynieść mi kask z kontenera?", question: "O co prosisz?", options: ["Potrzymać drabinę", "Pomóc przy palecie", "Przynieść kask"], answer: 2),
        SiteLine(topic: "Pomoc", de: "Du: Ich sehe die Markierung nicht. Zeig sie mir.\nKollege: Ja, ich komme.", pl: "Nie widzę znacznika. Pokaż mi go.", question: "O co prosisz?", options: ["Pomóc przy palecie", "Pokazać znacznik", "Potrzymać drabinę"], answer: 1),
        SiteLine(topic: "Pomoc", de: "Du: Kannst du die Tür aufhalten?\nKollege: Ja, ich komme.", pl: "Możesz przytrzymać drzwi?", question: "O co prosisz?", options: ["Przytrzymać drzwi", "Potrzymać drabinę", "Pomóc przy palecie"], answer: 0),
        SiteLine(topic: "Pomoc", de: "Du: Wir müssen zu zweit heben.\nKollege: Ja, ich komme.", pl: "Musimy podnieść we dwóch.", question: "O co prosisz?", options: ["Potrzymać drabinę", "Pomóc przy palecie", "Podnieść we dwóch"], answer: 2),
        SiteLine(topic: "Nie rozumiem", de: "Du: Können Sie das bitte langsamer sagen?\nChef: Klar. Ich sage es noch einmal.", pl: "Czy może pan powiedzieć wolniej?", question: "Co mówisz, gdy nie wchodzi?", options: ["Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego.", "Czy może pan powtórzyć?"], answer: 0),
        SiteLine(topic: "Nie rozumiem", de: "Du: Ich habe das nicht verstanden.\nChef: Klar. Ich sage es noch einmal.", pl: "Nie zrozumiałem tego.", question: "Co mówisz, gdy nie wchodzi?", options: ["Czy może pan powiedzieć wolniej?", "Czy może pan powtórzyć?", "Nie zrozumiałem tego."], answer: 2),
        SiteLine(topic: "Nie rozumiem", de: "Du: Können Sie das bitte wiederholen?\nChef: Klar. Ich sage es noch einmal.", pl: "Czy może pan powtórzyć?", question: "Co mówisz, gdy nie wchodzi?", options: ["Nie zrozumiałem tego.", "Czy może pan powtórzyć?", "Czy może pan powiedzieć wolniej?"], answer: 1),
        SiteLine(topic: "Nie rozumiem", de: "Du: Wie heißt das auf Deutsch?\nChef: Klar. Ich sage es noch einmal.", pl: "Jak to się nazywa po niemiecku?", question: "Co mówisz, gdy nie wchodzi?", options: ["Jak to się nazywa po niemiecku?", "Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego."], answer: 0),
        SiteLine(topic: "Nie rozumiem", de: "Du: Können Sie das bitte aufschreiben?\nChef: Klar. Ich sage es noch einmal.", pl: "Czy może pan to napisać?", question: "Co mówisz, gdy nie wchodzi?", options: ["Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego.", "Czy może pan to napisać?"], answer: 2),
        SiteLine(topic: "Nie rozumiem", de: "Du: Noch einmal, bitte. Langsamer.\nChef: Klar. Ich sage es noch einmal.", pl: "Jeszcze raz, wolniej.", question: "Co mówisz, gdy nie wchodzi?", options: ["Nie zrozumiałem tego.", "Jeszcze raz, wolniej.", "Czy może pan powiedzieć wolniej?"], answer: 1),
        SiteLine(topic: "Nie rozumiem", de: "Du: Ich verstehe das Wort nicht.\nChef: Klar. Ich sage es noch einmal.", pl: "Nie rozumiem tego słowa.", question: "Co mówisz, gdy nie wchodzi?", options: ["Nie rozumiem tego słowa.", "Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego."], answer: 0),
        SiteLine(topic: "Nie rozumiem", de: "Du: Meinen Sie die linke oder die rechte Seite?\nChef: Klar. Ich sage es noch einmal.", pl: "Ma pan na myśli lewą czy prawą stronę?", question: "Co mówisz, gdy nie wchodzi?", options: ["Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego.", "Ma pan na myśli lewą czy prawą stronę?"], answer: 2),
        SiteLine(topic: "Nie rozumiem", de: "Du: Können Sie mir das zeigen?\nChef: Klar. Ich sage es noch einmal.", pl: "Czy może pan mi to pokazać?", question: "Co mówisz, gdy nie wchodzi?", options: ["Nie zrozumiałem tego.", "Czy może pan mi to pokazać?", "Czy może pan powiedzieć wolniej?"], answer: 1),
        SiteLine(topic: "Nie rozumiem", de: "Du: Ich bin neu hier. Bitte etwas einfacher.\nChef: Klar. Ich sage es noch einmal.", pl: "Jestem tu nowy. Proszę trochę prościej.", question: "Co mówisz, gdy nie wchodzi?", options: ["Jestem tu nowy. Proszę trochę prościej.", "Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego."], answer: 0),
        SiteLine(topic: "Nie rozumiem", de: "Du: Ist das jetzt oder später?\nChef: Klar. Ich sage es noch einmal.", pl: "To teraz czy później?", question: "Co mówisz, gdy nie wchodzi?", options: ["Czy może pan powiedzieć wolniej?", "Nie zrozumiałem tego.", "To teraz czy później?"], answer: 2),
        SiteLine(topic: "Nie rozumiem", de: "Du: Welche Tür meinen Sie?\nChef: Klar. Ich sage es noch einmal.", pl: "Które drzwi ma pan na myśli?", question: "Co mówisz, gdy nie wchodzi?", options: ["Nie zrozumiałem tego.", "Które drzwi ma pan na myśli?", "Czy może pan powiedzieć wolniej?"], answer: 1),
        SiteLine(topic: "Koniec pracy", de: "Du: Ich bin fertig. Was soll ich jetzt machen?\nChef: Gut. Dann bis morgen.", pl: "Skończyłem. Co mam teraz zrobić?", question: "Co zgłaszasz?", options: ["Co robić dalej", "Ściana skończona", "Lewa strona gotowa"], answer: 0),
        SiteLine(topic: "Koniec pracy", de: "Du: Die Wand ist fertig.\nChef: Gut. Dann bis morgen.", pl: "Ściana jest gotowa.", question: "Co zgłaszasz?", options: ["Co robić dalej", "Lewa strona gotowa", "Ściana skończona"], answer: 2),
        SiteLine(topic: "Koniec pracy", de: "Du: Wir sind durch mit der linken Seite.\nChef: Gut. Dann bis morgen.", pl: "Skończyliśmy lewą stronę.", question: "Co zgłaszasz?", options: ["Ściana skończona", "Lewa strona gotowa", "Co robić dalej"], answer: 1),
        SiteLine(topic: "Koniec pracy", de: "Du: Ich habe das Werkzeug zurückgebracht.\nChef: Gut. Dann bis morgen.", pl: "Oddałem narzędzia.", question: "Co zgłaszasz?", options: ["Narzędzia oddane", "Co robić dalej", "Ściana skończona"], answer: 0),
        SiteLine(topic: "Koniec pracy", de: "Du: Die Grube ist zu.\nChef: Gut. Dann bis morgen.", pl: "Wykop jest zasypany.", question: "Co zgłaszasz?", options: ["Co robić dalej", "Ściana skończona", "Wykop zasypany"], answer: 2),
        SiteLine(topic: "Koniec pracy", de: "Du: Der Container ist leer.\nChef: Gut. Dann bis morgen.", pl: "Kontener jest pusty.", question: "Co zgłaszasz?", options: ["Ściana skończona", "Kontener pusty", "Co robić dalej"], answer: 1),
        SiteLine(topic: "Koniec pracy", de: "Du: Ich mache jetzt Feierabend.\nChef: Gut. Dann bis morgen.", pl: "Kończę na dziś.", question: "Co zgłaszasz?", options: ["Koniec pracy", "Co robić dalej", "Ściana skończona"], answer: 0),
        SiteLine(topic: "Koniec pracy", de: "Du: Die letzte Palette steht an der Rampe.\nChef: Gut. Dann bis morgen.", pl: "Ostatnia paleta stoi przy rampie.", question: "Co zgłaszasz?", options: ["Co robić dalej", "Ściana skończona", "Ostatnia paleta przy rampie"], answer: 2),
        SiteLine(topic: "Koniec pracy", de: "Du: Ich habe alles geputzt.\nChef: Gut. Dann bis morgen.", pl: "Posprzątałem.", question: "Co zgłaszasz?", options: ["Ściana skończona", "Posprzątane", "Co robić dalej"], answer: 1),
        SiteLine(topic: "Koniec pracy", de: "Du: Das Gerüst ist abgebaut.\nChef: Gut. Dann bis morgen.", pl: "Rusztowanie jest zdjęte.", question: "Co zgłaszasz?", options: ["Rusztowanie zdjęte", "Co robić dalej", "Ściana skończona"], answer: 0),
        SiteLine(topic: "Koniec pracy", de: "Du: Die Rechnung habe ich dem Chef gegeben.\nChef: Gut. Dann bis morgen.", pl: "Fakturę dałem szefowi.", question: "Co zgłaszasz?", options: ["Co robić dalej", "Ściana skończona", "Faktura u szefa"], answer: 2),
        SiteLine(topic: "Koniec pracy", de: "Du: Morgen machen wir die rechte Seite.\nChef: Gut. Dann bis morgen.", pl: "Jutro robimy prawą stronę.", question: "Co zgłaszasz?", options: ["Ściana skończona", "Jutro prawa strona", "Co robić dalej"], answer: 1),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Wann kommt das Geld diesen Monat?\nChef: Ich schaue das heute nach.", pl: "Kiedy w tym miesiącu będzie wypłata?", question: "O co pytasz albo co zgłaszasz?", options: ["Kiedy wypłata", "Trzy dni wolnego", "Czy są nadgodziny"], answer: 0),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Ich brauche nächste Woche drei Tage frei.\nChef: Ich schaue das heute nach.", pl: "W przyszłym tygodniu potrzebuję trzech dni wolnego.", question: "O co pytasz albo co zgłaszasz?", options: ["Kiedy wypłata", "Czy są nadgodziny", "Trzy dni wolnego"], answer: 2),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Steht der Lohn für die Überstunden drauf?\nChef: Ich schaue das heute nach.", pl: "Czy nadgodziny są na pasku?", question: "O co pytasz albo co zgłaszasz?", options: ["Trzy dni wolnego", "Czy są nadgodziny", "Kiedy wypłata"], answer: 1),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Ich war am Freitag krank. Das ist gemeldet.\nChef: Ich schaue das heute nach.", pl: "W piątek byłem chory. Jest zgłoszone.", question: "O co pytasz albo co zgłaszasz?", options: ["Choroba w piątek zgłoszona", "Kiedy wypłata", "Trzy dni wolnego"], answer: 0),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Können Sie den Urlaub für August eintragen?\nChef: Ich schaue das heute nach.", pl: "Czy może pan wpisać urlop na sierpień?", question: "O co pytasz albo co zgłaszasz?", options: ["Kiedy wypłata", "Trzy dni wolnego", "Urlop w sierpniu"], answer: 2),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Die Spesen fehlen auf der Abrechnung.\nChef: Ich schaue das heute nach.", pl: "Na rozliczeniu brakuje diet.", question: "O co pytasz albo co zgłaszasz?", options: ["Trzy dni wolnego", "Brakuje diet", "Kiedy wypłata"], answer: 1),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Ich habe zwölf Überstunden, nicht acht.\nChef: Ich schaue das heute nach.", pl: "Mam dwanaście nadgodzin, nie osiem.", question: "O co pytasz albo co zgłaszasz?", options: ["12 nadgodzin", "Kiedy wypłata", "Trzy dni wolnego"], answer: 0),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Ab wann gilt der neue Stundenlohn?\nChef: Ich schaue das heute nach.", pl: "Od kiedy jest nowa stawka?", question: "O co pytasz albo co zgłaszasz?", options: ["Kiedy wypłata", "Trzy dni wolnego", "Od kiedy nowa stawka"], answer: 2),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Ich brauche die Lohnabrechnung für die Wohnung.\nChef: Ich schaue das heute nach.", pl: "Potrzebuję paska płac do mieszkania.", question: "O co pytasz albo co zgłaszasz?", options: ["Trzy dni wolnego", "Pasek płac do mieszkania", "Kiedy wypłata"], answer: 1),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Kann ich den Freitag als Urlaub nehmen?\nChef: Ich schaue das heute nach.", pl: "Czy mogę wziąć piątek jako urlop?", question: "O co pytasz albo co zgłaszasz?", options: ["Piątek jako urlop", "Kiedy wypłata", "Trzy dni wolnego"], answer: 0),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Die Fahrt zur Baustelle ist nicht bezahlt.\nChef: Ich schaue das heute nach.", pl: "Dojazd na budowę nie jest płatny.", question: "O co pytasz albo co zgłaszasz?", options: ["Kiedy wypłata", "Trzy dni wolnego", "Dojazd nie jest płatny"], answer: 2),
        SiteLine(topic: "Urlop i wypłata", de: "Du: Bitte überweisen Sie den Rest bis Freitag.\nChef: Ich schaue das heute nach.", pl: "Proszę przelać resztę do piątku.", question: "O co pytasz albo co zgłaszasz?", options: ["Trzy dni wolnego", "Reszta do piątku", "Kiedy wypłata"], answer: 1),
        SiteLine(topic: "Dostawy", de: "Chef: Der Lkw steht an Tor 1. Bitte entladen.\nDu: Tor 1, ich fange an.", pl: "Ciężarówka stoi przy bramie 1. Masz rozładować.", question: "Przy której bramie?", options: ["Brama 2", "Brama 3", "Brama 1"], answer: 2),
        SiteLine(topic: "Dostawy", de: "Chef: Der Lkw steht an Tor 2. Bitte entladen.\nDu: Tor 2, ich fange an.", pl: "Ciężarówka stoi przy bramie 2. Masz rozładować.", question: "Przy której bramie?", options: ["Brama 3", "Brama 2", "Brama 1"], answer: 1),
        SiteLine(topic: "Dostawy", de: "Chef: Der Lkw steht an Tor 3. Bitte entladen.\nDu: Tor 3, ich fange an.", pl: "Ciężarówka stoi przy bramie 3. Masz rozładować.", question: "Przy której bramie?", options: ["Brama 3", "Brama 1", "Brama 2"], answer: 0),
        SiteLine(topic: "Dostawy", de: "Chef: Der Lkw steht an Tor 4. Bitte entladen.\nDu: Tor 4, ich fange an.", pl: "Ciężarówka stoi przy bramie 4. Masz rozładować.", question: "Przy której bramie?", options: ["Brama 1", "Brama 2", "Brama 4"], answer: 2),
        SiteLine(topic: "Dostawy", de: "Chef: Der Lkw steht an Tor 5. Bitte entladen.\nDu: Tor 5, ich fange an.", pl: "Ciężarówka stoi przy bramie 5. Masz rozładować.", question: "Przy której bramie?", options: ["Brama 2", "Brama 5", "Brama 1"], answer: 1),
        SiteLine(topic: "Kontakt", de: "Chef: Ruf mich an, wenn du auf dem Hof bist.\nDu: Mache ich.", pl: "Zadzwoń, jak będziesz na placu.", question: "Kiedy masz się odezwać?", options: ["Jak będziesz na placu", "Jak przyjedzie beton", "Jak dostawa się skończy"], answer: 0),
        SiteLine(topic: "Kontakt", de: "Chef: Ruf den Chef an, wenn der Beton da ist.\nDu: Mache ich.", pl: "Zadzwoń do szefa, jak będzie beton.", question: "Kiedy masz się odezwać?", options: ["Jak będziesz na placu", "Jak dostawa się skończy", "Jak przyjedzie beton"], answer: 2),
        SiteLine(topic: "Kontakt", de: "Chef: Schreib mir, wenn die Lieferung durch ist.\nDu: Mache ich.", pl: "Napisz, jak dostawa przejdzie.", question: "Kiedy masz się odezwać?", options: ["Jak przyjedzie beton", "Jak dostawa się skończy", "Jak będziesz na placu"], answer: 1),
        SiteLine(topic: "Kontakt", de: "Chef: Melde dich, bevor du das Gerüst verlässt.\nDu: Mache ich.", pl: "Daj znać, zanim zejdziesz z rusztowania.", question: "Kiedy masz się odezwać?", options: ["Zanim zejdziesz z rusztowania", "Jak będziesz na placu", "Jak przyjedzie beton"], answer: 0),
        SiteLine(topic: "Kontakt", de: "Chef: Ruf an, wenn du den Hausmeister siehst.\nDu: Mache ich.", pl: "Zadzwoń, jak zobaczysz gospodarza.", question: "Kiedy masz się odezwać?", options: ["Jak będziesz na placu", "Jak przyjedzie beton", "Jak zobaczysz gospodarza"], answer: 2),
        SiteLine(topic: "Kontakt", de: "Chef: Sag Bescheid, bevor du die Maschine einschaltest.\nDu: Mache ich.", pl: "Daj znać, zanim włączysz maszynę.", question: "Kiedy masz się odezwać?", options: ["Jak przyjedzie beton", "Zanim włączysz maszynę", "Jak będziesz na placu"], answer: 1),
        SiteLine(topic: "Kontakt", de: "Chef: Ruf mich an, wenn du fertig bist.\nDu: Mache ich.", pl: "Zadzwoń, jak skończysz.", question: "Kiedy masz się odezwać?", options: ["Jak skończysz", "Jak będziesz na placu", "Jak przyjedzie beton"], answer: 0),
        SiteLine(topic: "Kontakt", de: "Chef: Schreib dem Polier, nicht mir.\nDu: Mache ich.", pl: "Napisz do majstra, nie do mnie.", question: "Kiedy masz się odezwać?", options: ["Jak będziesz na placu", "Jak przyjedzie beton", "Do majstra"], answer: 2),
        SiteLine(topic: "Kierunek", de: "Chef: Wir fangen links an, nicht rechts.\nDu: Okay, zuerst links.", pl: "Zaczynacie z lewej, nie z prawej.", question: "Od której strony?", options: ["Z lewej", "Z prawej", "Na górze"], answer: 0),
        SiteLine(topic: "Kierunek", de: "Chef: Wir fangen rechts an, nicht links.\nDu: Okay, zuerst rechts.", pl: "Zaczynacie z prawej, nie z lewej.", question: "Od której strony?", options: ["Z lewej", "Na górze", "Z prawej"], answer: 2),
        SiteLine(topic: "Kierunek", de: "Chef: Wir fangen oben an, nicht unten.\nDu: Okay, zuerst oben.", pl: "Zaczynacie na górze, nie na dole.", question: "Od której strony?", options: ["Z prawej", "Na górze", "Z lewej"], answer: 1),
        SiteLine(topic: "Kierunek", de: "Chef: Wir fangen unten an, nicht oben.\nDu: Okay, zuerst unten.", pl: "Zaczynacie na dole, nie na górze.", question: "Od której strony?", options: ["Na dole", "Z lewej", "Z prawej"], answer: 0),
        SiteLine(topic: "Kierunek", de: "Chef: Wir fangen vorne an, nicht hinten.\nDu: Okay, zuerst vorne.", pl: "Zaczynacie z przodu, nie z tyłu.", question: "Od której strony?", options: ["Z lewej", "Z prawej", "Z przodu"], answer: 2),
        SiteLine(topic: "Kierunek", de: "Chef: Wir fangen hinten an, nicht vorne.\nDu: Okay, zuerst hinten.", pl: "Zaczynacie z tyłu, nie z przodu.", question: "Od której strony?", options: ["Z prawej", "Z tyłu", "Z lewej"], answer: 1),
        SiteLine(topic: "Pogoda", de: "Chef: Bei Regen decken wir den Zement ab.\nDu: Verstanden.", pl: "Jak pada, przykrywamy cement.", question: "Co robicie przez pogodę?", options: ["Beton od +10 stopni", "Nie wchodzić na dach", "Przykryć cement"], answer: 2),
        SiteLine(topic: "Pogoda", de: "Chef: Ab zehn Grad plus können wir betonieren.\nDu: Verstanden.", pl: "Od plus dziesięciu stopni możemy betonować.", question: "Co robicie przez pogodę?", options: ["Nie wchodzić na dach", "Beton od +10 stopni", "Przykryć cement"], answer: 1),
        SiteLine(topic: "Pogoda", de: "Chef: Der Wind ist zu stark fürs Dach.\nDu: Verstanden.", pl: "Wiatr jest za mocny na dach.", question: "Co robicie przez pogodę?", options: ["Nie wchodzić na dach", "Przykryć cement", "Beton od +10 stopni"], answer: 0),
        SiteLine(topic: "Pogoda", de: "Chef: Heute erst ab neun, der Boden ist gefroren.\nDu: Verstanden.", pl: "Dziś dopiero od dziewiątej, grunt jest zmarznięty.", question: "Co robicie przez pogodę?", options: ["Przykryć cement", "Beton od +10 stopni", "Start o dziewiątej, grunt zmarznięty"], answer: 2),
        SiteLine(topic: "Pogoda", de: "Chef: Die Plane muss auf die Steine.\nDu: Verstanden.", pl: "Plama musi iść na cegły.", question: "Co robicie przez pogodę?", options: ["Beton od +10 stopni", "Przykryć cegły", "Przykryć cement"], answer: 1),
        SiteLine(topic: "Pogoda", de: "Chef: Bei Hitze den Beton feucht halten.\nDu: Verstanden.", pl: "W upał beton trzymać wilgotny.", question: "Co robicie przez pogodę?", options: ["Polewać beton", "Przykryć cement", "Beton od +10 stopni"], answer: 0),
        SiteLine(topic: "Pogoda", de: "Chef: Nicht streichen, die Wand ist noch nass.\nDu: Verstanden.", pl: "Nie malować, ściana jest jeszcze mokra.", question: "Co robicie przez pogodę?", options: ["Przykryć cement", "Beton od +10 stopni", "Nie malować mokrej ściany"], answer: 2),
        SiteLine(topic: "Pogoda", de: "Chef: Morgen früh ist Frost. Werkzeug rein.\nDu: Verstanden.", pl: "Jutro rano mróz. Narzędzia do środka.", question: "Co robicie przez pogodę?", options: ["Beton od +10 stopni", "Schować narzędzia", "Przykryć cement"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Stell die Balken im Abstand von 40 Zentimetern.\nDu: Alles klar.", pl: "Ustaw belki co 40 centymetrów.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Dwie warstwy"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Die Fuge darf nicht breiter als fünf Millimeter sein.\nDu: Alles klar.", pl: "Fuga nie może być szersza niż pięć milimetrów.", question: "Co masz zrobić?", options: ["Co 40 cm", "Dwie warstwy", "Maksimum 5 mm"], answer: 2),
        SiteLine(topic: "Roboty", de: "Chef: Zwei Lagen, nicht eine.\nDu: Alles klar.", pl: "Dwie warstwy, nie jedna.", question: "Co masz zrobić?", options: ["Maksimum 5 mm", "Dwie warstwy", "Co 40 cm"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Erst grundieren, dann streichen.\nDu: Alles klar.", pl: "Najpierw grunt, potem malowanie.", question: "Co masz zrobić?", options: ["Najpierw grunt", "Co 40 cm", "Maksimum 5 mm"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Die Dose sitzt auf 30 Zentimeter Höhe.\nDu: Alles klar.", pl: "Puszka jest na wysokości 30 centymetrów.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Na 30 cm"], answer: 2),
        SiteLine(topic: "Roboty", de: "Chef: Das Gefälle läuft zum Ablauf, nicht zur Wand.\nDu: Alles klar.", pl: "Spadek idzie do odpływu, nie do ściany.", question: "Co masz zrobić?", options: ["Maksimum 5 mm", "Spadek do odpływu", "Co 40 cm"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Nicht bohren, da liegt ein Rohr.\nDu: Alles klar.", pl: "Nie wierć, tam jest rura.", question: "Co masz zrobić?", options: ["Nie wiercić, jest rura", "Co 40 cm", "Maksimum 5 mm"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Die Tür muss nach außen aufgehen.\nDu: Alles klar.", pl: "Drzwi muszą otwierać się na zewnątrz.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Drzwi na zewnątrz"], answer: 2),
        SiteLine(topic: "Roboty", de: "Chef: Lass zehn Zentimeter Luft zur Decke.\nDu: Alles klar.", pl: "Zostaw dziesięć centymetrów do sufitu.", question: "Co masz zrobić?", options: ["Maksimum 5 mm", "10 cm do sufitu", "Co 40 cm"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Der Anker kommt in jede zweite Fuge.\nDu: Alles klar.", pl: "Kotwa co drugą fugę.", question: "Co masz zrobić?", options: ["Kotwa co drugą fugę", "Co 40 cm", "Maksimum 5 mm"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Heute nur vorbereiten, nicht gießen.\nDu: Alles klar.", pl: "Dziś tylko przygotować, nie lać.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Dziś bez lania"], answer: 2),
        SiteLine(topic: "Roboty", de: "Chef: Die Folie bleibt bis morgen drauf.\nDu: Alles klar.", pl: "Folia zostaje do jutra.", question: "Co masz zrobić?", options: ["Maksimum 5 mm", "Folia do jutra", "Co 40 cm"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Schneid die Latte auf 180 Zentimeter.\nDu: Alles klar.", pl: "Przytnij łatę na 180 centymetrów.", question: "Co masz zrobić?", options: ["Łata 180 cm", "Co 40 cm", "Maksimum 5 mm"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Der Schacht ist für die Lüftung, nicht für Kabel.\nDu: Alles klar.", pl: "Szyb jest na wentylację, nie na kable.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Szyb na wentylację"], answer: 2),
        SiteLine(topic: "Roboty", de: "Chef: Prüf die Waage, bevor du die Reihe klebst.\nDu: Alles klar.", pl: "Sprawdź poziomicę, zanim przykleisz rząd.", question: "Co masz zrobić?", options: ["Maksimum 5 mm", "Najpierw poziomica", "Co 40 cm"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Die alte Farbe muss runter.\nDu: Alles klar.", pl: "Stara farba musi zejść.", question: "Co masz zrobić?", options: ["Zedrzeć starą farbę", "Co 40 cm", "Maksimum 5 mm"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Nicht mit dem Hammer auf die Fliese.\nDu: Alles klar.", pl: "Nie młotkiem w płytkę.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Nie uderzać w płytkę"], answer: 2),
        SiteLine(topic: "Roboty", de: "Chef: Der Abstand zur Nachbarwand ist 15 Zentimeter.\nDu: Alles klar.", pl: "Odstęp od ściany sąsiada to 15 centymetrów.", question: "Co masz zrobić?", options: ["Maksimum 5 mm", "15 cm od ściany", "Co 40 cm"], answer: 1),
        SiteLine(topic: "Roboty", de: "Chef: Erst sichern, dann schneiden.\nDu: Alles klar.", pl: "Najpierw zabezpiecz, potem tnij.", question: "Co masz zrobić?", options: ["Najpierw zabezpieczyć", "Co 40 cm", "Maksimum 5 mm"], answer: 0),
        SiteLine(topic: "Roboty", de: "Chef: Die Nummer vom Polier ist an der Tür.\nDu: Alles klar.", pl: "Numer do majstra jest na drzwiach.", question: "Co masz zrobić?", options: ["Co 40 cm", "Maksimum 5 mm", "Numer jest na drzwiach"], answer: 2),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der neue Kollege heißt Tim. Zeig ihm die Halle.\nDu: Verstanden.", pl: "Nowy kolega ma na imię Tim. Pokaż mu halę.", question: "O co chodzi?", options: ["Czekać przy bramie 2", "Nie ruszać kabla elektryka", "Pokazać halę Timowi"], answer: 2),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der Polier kommt um zehn. Warte an Tor zwei.\nDu: Verstanden.", pl: "Majster będzie o dziesiątej. Czekaj przy bramie dwa.", question: "O co chodzi?", options: ["Nie ruszać kabla elektryka", "Czekać przy bramie 2", "Pokazać halę Timowi"], answer: 1),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der Elektriker arbeitet oben. Geh ihm nicht ins Kabel.\nDu: Verstanden.", pl: "Elektryk pracuje na górze. Nie wchodź mu w kabel.", question: "O co chodzi?", options: ["Nie ruszać kabla elektryka", "Pokazać halę Timowi", "Czekać przy bramie 2"], answer: 0),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der Kranführer sieht dich nicht. Heb die Hand.\nDu: Verstanden.", pl: "Operator dźwigu cię nie widzi. Podnieś rękę.", question: "O co chodzi?", options: ["Pokazać halę Timowi", "Czekać przy bramie 2", "Podnieść rękę"], answer: 2),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Die Praktikantin darf nicht an die Flex.\nDu: Verstanden.", pl: "Praktykantka nie może przy szlifierce.", question: "O co chodzi?", options: ["Czekać przy bramie 2", "Praktykantka bez szlifierki", "Pokazać halę Timowi"], answer: 1),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der Maler kommt erst morgen.\nDu: Verstanden.", pl: "Malarz przyjdzie dopiero jutro.", question: "O co chodzi?", options: ["Malarz jutro", "Pokazać halę Timowi", "Czekać przy bramie 2"], answer: 0),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Sag dem Fahrer, er soll den Motor ausmachen.\nDu: Verstanden.", pl: "Powiedz kierowcy, żeby zgasił silnik.", question: "O co chodzi?", options: ["Pokazać halę Timowi", "Czekać przy bramie 2", "Zgasić silnik"], answer: 2),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der Gerüstbauer ist krank. Heute bauen wir nicht auf.\nDu: Verstanden.", pl: "Rusztowaniowiec jest chory. Dziś nie stawiamy.", question: "O co chodzi?", options: ["Czekać przy bramie 2", "Dziś bez rusztowania", "Pokazać halę Timowi"], answer: 1),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Zwei Mann bleiben im Keller, der Rest kommt hoch.\nDu: Verstanden.", pl: "Dwóch zostaje w piwnicy, reszta na górę.", question: "O co chodzi?", options: ["Dwóch w piwnicy", "Pokazać halę Timowi", "Czekać przy bramie 2"], answer: 0),
        SiteLine(topic: "Ludzie na budowie", de: "Chef: Der Auftraggeber schaut um elf vorbei.\nDu: Verstanden.", pl: "Zleceniodawca wpadnie o jedenastej.", question: "O co chodzi?", options: ["Pokazać halę Timowi", "Czekać przy bramie 2", "Zleceniodawca o 11"], answer: 2),
        SiteLine(topic: "Porządek", de: "Chef: Kehr die Rampe, bevor der Lkw kommt.\nDu: Mache ich.", pl: "Zamieć rampę, zanim przyjedzie ciężarówka.", question: "Co masz zrobić?", options: ["Śruby do skrzynek", "Zamieść rampę", "Odsunąć bęben"], answer: 1),
        SiteLine(topic: "Porządek", de: "Chef: Die Kabeltrommel darf nicht im Weg stehen.\nDu: Mache ich.", pl: "Bęben z kablem nie może stać na drodze.", question: "Co masz zrobić?", options: ["Odsunąć bęben", "Zamieść rampę", "Śruby do skrzynek"], answer: 0),
        SiteLine(topic: "Porządek", de: "Chef: Sortier die Schrauben zurück in die Kisten.\nDu: Mache ich.", pl: "Posegreguj śruby z powrotem do skrzynek.", question: "Co masz zrobić?", options: ["Zamieść rampę", "Odsunąć bęben", "Śruby do skrzynek"], answer: 2),
        SiteLine(topic: "Porządek", de: "Chef: Der Müllcontainer ist voll. Drück ihn nicht weiter.\nDu: Mache ich.", pl: "Kontener na śmieci jest pełny. Nie dopychaj.", question: "Co masz zrobić?", options: ["Odsunąć bęben", "Nie dopychać śmieci", "Zamieść rampę"], answer: 1),
        SiteLine(topic: "Porządek", de: "Chef: Spül die Kellen aus, bevor der Mörtel hart ist.\nDu: Mache ich.", pl: "Opłucz kielnie, zanim zaprawa stwardnieje.", question: "Co masz zrobić?", options: ["Opłukać kielnie", "Zamieść rampę", "Odsunąć bęben"], answer: 0),
        SiteLine(topic: "Porządek", de: "Chef: Die Halle wird um sechzehn abgeschlossen.\nDu: Mache ich.", pl: "Halę zamykają o szesnastej.", question: "Co masz zrobić?", options: ["Zamieść rampę", "Odsunąć bęben", "Zamknięcie o 16"], answer: 2),
        SiteLine(topic: "Porządek", de: "Chef: Licht aus, wenn du als Letzter gehst.\nDu: Mache ich.", pl: "Zgaś światło, jak wychodzisz ostatni.", question: "Co masz zrobić?", options: ["Odsunąć bęben", "Zgasić światło", "Zamieść rampę"], answer: 1),
        SiteLine(topic: "Porządek", de: "Chef: Die nassen Lappen kommen nicht auf die Heizung.\nDu: Mache ich.", pl: "Mokre szmaty nie kładź na grzejnik.", question: "Co masz zrobić?", options: ["Szmaty nie na grzejnik", "Zamieść rampę", "Odsunąć bęben"], answer: 0),
        SiteLine(topic: "Pomiar", de: "Chef: Miss noch einmal nach. Die Wand ist 3 Meter 20, nicht 3 Meter.\nDu: 3 Meter 20, ich messe nach.", pl: "Ściana ma 3 metry 20, nie 3 metry.", question: "Jaka długość?", options: ["90 cm", "3 m 20", "2 m 50"], answer: 1),
        SiteLine(topic: "Pomiar", de: "Chef: Die Deckenhöhe ist 2 Meter 50.\nDu: 2 Meter 50, notiert.", pl: "Wysokość sufitu to 2 metry 50.", question: "Jaka wysokość?", options: ["2 m 50", "3 m 20", "90 cm"], answer: 0),
        SiteLine(topic: "Pomiar", de: "Chef: Das Fenster sitzt 90 Zentimeter über dem Boden.\nDu: 90 Zentimeter, okay.", pl: "Okno jest 90 centymetrów nad podłogą.", question: "Na jakiej wysokości?", options: ["3 m 20", "2 m 50", "90 cm"], answer: 2),
        SiteLine(topic: "Pomiar", de: "Chef: Die Öffnung ist 80 mal 200.\nDu: 80 breit, 200 hoch.", pl: "Otwór ma 80 na 200.", question: "Jaki otwór?", options: ["2 m 50", "80 na 200", "3 m 20"], answer: 1),
        SiteLine(topic: "Maszyna", de: "Chef: Der Mixer bleibt an, bis der Mörtel glatt ist.\nDu: Ich warte, bis er glatt ist.", pl: "Mieszalnik zostaje włączony, aż zaprawa będzie gładka.", question: "Kiedy go wyłączyć?", options: ["Krótko", "Wyciągnąć wtyczkę", "Gdy zaprawa jest gładka"], answer: 2),
        SiteLine(topic: "Maszyna", de: "Chef: Den Rüttler nur kurz, sonst setzt sich das Wasser ab.\nDu: Kurz, verstanden.", pl: "Wibrator tylko krótko, inaczej woda się oddzieli.", question: "Jak długo wibrować?", options: ["Wyciągnąć wtyczkę", "Krótko", "Gdy zaprawa jest gładka"], answer: 1),
        SiteLine(topic: "Maszyna", de: "Chef: Die Säge erst ausstecken, dann das Blatt wechseln.\nDu: Erst der Stecker, dann das Blatt.", pl: "Najpierw wyciągnij wtyczkę, potem zmień tarczę.", question: "Co najpierw?", options: ["Wyciągnąć wtyczkę", "Gdy zaprawa jest gładka", "Krótko"], answer: 0),
        SiteLine(topic: "Maszyna", de: "Chef: Der Hubwagen bleibt stehen, wenn die Gabel unten ist.\nDu: Gabel unten, dann stehen lassen.", pl: "Wózek paletowy zostawiasz z widłami na dole.", question: "Jak zostawić wózek?", options: ["Gdy zaprawa jest gładka", "Krótko", "Widły na dole"], answer: 2),
    ]

    static var listen: [CoachData.ListenQ] {
        lines.map { CoachData.ListenQ(de: $0.de, pl: $0.pl, question: $0.question, options: $0.options, answer: $0.answer) }
    }

    static var topics: [String] {
        var seen: [String] = []
        for line in lines where !seen.contains(line.topic) { seen.append(line.topic) }
        return seen
    }
}

struct SiteCourseView: View {
    var body: some View {
        List {
            Section {
                Text("\(SiteTalk.lines.count) dialogów z budowy. To prawdziwe zdania, nie licznik na pokaz.")
                    .font(.footnote)
                    .foregroundStyle(Theme.text2)
            }
            ForEach(SiteTalk.topics, id: \.self) { topic in
                Section(topic) {
                    ForEach(SiteTalk.lines.filter { $0.topic == topic }) { line in
                        NavigationLink(line.pl) { SitePlay(line: line) }
                    }
                }
            }
        }
        .navigationTitle("Dialogi z budowy")
        .containerBackground(for: .navigation) { Color.black }
    }
}

struct SiteTopicView: View {
    let topic: String
    var body: some View {
        List(SiteTalk.lines.filter { $0.topic == topic }) { line in
            NavigationLink(line.pl) { SitePlay(line: line) }
        }
        .navigationTitle(topic)
        .containerBackground(for: .navigation) { Color.black }
    }
}

struct SitePlay: View {
    @EnvironmentObject var store: LearningStore
    let line: SiteLine
    @State private var played = false
    @State private var picked: Int?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text(line.topic).font(.caption.weight(.bold)).foregroundStyle(Theme.ok)
                VoiceSexButtons()
                PaceButtons()
                Button {
                    played = true
                    Talk.de(line.de, rate: Speaker.savedPace())
                } label: {
                    Label(played ? "Odtwórz jeszcze raz" : "Posłuchaj bez tekstu", systemImage: "speaker.wave.2.fill")
                        .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(MatteGlassButton())
                if played {
                    Text(line.question).font(.title3.bold())
                    ForEach(line.options.indices, id: \.self) { i in
                        Button(line.options[i]) {
                            guard picked == nil else { return }
                            picked = i
                            let ok = i == line.answer
                            store.noteListen(ok: ok)
                            if !ok { HardBook.add(de: line.de, pl: line.pl) }
                        }
                        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                        .padding(.horizontal, 12)
                        .foregroundStyle(.white)
                        .background(fill(i), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                }
                if picked != nil {
                    Text(line.de).font(.headline)
                    Text(line.pl).foregroundStyle(Theme.text2)
                    Text(picked == line.answer ? "Dobrze." : "Poprawnie: \(line.options[line.answer])")
                        .foregroundStyle(picked == line.answer ? Theme.ok : Theme.bad)
                }
            }
            .padding(20)
        }
        .navigationTitle("Dialog")
        .containerBackground(for: .navigation) { Color.black }
        .onDisappear { Talk.stop() }
    }
    private func fill(_ i: Int) -> Color {
        guard let picked else { return Color.white.opacity(0.08) }
        if i == line.answer { return Theme.ok.opacity(0.85) }
        if i == picked { return Theme.bad.opacity(0.85) }
        return Color.white.opacity(0.08)
    }
}

