// Constructor template for Competitor1:
//     new Competitor1 (String c1)
//
// Interpretation: the competitor represents an individual or team
// the outranked represents a mark and true if this competitor has been visited

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.*;

class Competitor1 implements Competitor {

    String n;  // the name of this competitor

    Competitor1(String s) {
        n = s;
    }

    // returns the name of this competitor
    // Examples: new Competitor1("A").name() => "A"
    public String name() {
        return n;
    }

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor
    // Examples: new Competitor1("A").hasDefeated(competitor("B"),
    // createOutcomes(defeated("A", "B"), tie("B", "C")) => true
    public boolean hasDefeated(Competitor c2, List<Outcome> outcomes) {
        for (Outcome o : outcomes)
            if (o.isTie() && isMention(o) && isMention(c2.name(), o))
                return true;
            else if (!o.isTie() && o.winner().equals(this) && o.loser().equals(c2))
                return true;
        return false;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that are outranked by this competitor,
    //     without duplicates, in alphabetical order
    // Examples: competitor("A").outranks(createOutcomes(defeated("A", "B"),
    //    tie("B", "C"), tie("C", "D"))) => Arrays.asList("C", "B", "D")
    //    competitor("B").outranks(createOutcomes(defeated("A", "B"),
    //    defeated("B","A"))) =>Arrays.asList("A", "B")
    public List<String> outranks(List<Outcome> outcomes) {
        //the list of names outranked by this competitor so far
        List<String> ns = onDefeatedOrTied(outcomes);
        //the list of names needed to find competitors they outrank
        Set<String> toOutrankList = new HashSet<>(ns);
        //halting measure: the length of toOutrankedList
        //when the competitors in toOutrankedList do not outrank any competitors
        //except who are in ns,since the total number of competitors is limited,
        //it will break the loop.
        while (!toOutrankList.isEmpty()) {
            Set<String> tmp = new HashSet<>(toOutrankList);
            for (String c : toOutrankList)
                tmp.addAll(onDefeatedOrTied(c, outcomes));
            tmp.removeAll(ns);
            ns.addAll(tmp);
            toOutrankList = tmp;
        }
        return ns;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order
    // Examples:competitor("A").outrankedBy(createOutcomes(defeated("A", "B"),
    // tie("B", "C"))) => Collections.emptyList()
    // competitor("C").outrankedBy(createOutcomes(defeated("A", "B"),
    //        tie("B", "C")))  =>   Arrays.asList("A", "B", "C")
    public List<String> outrankedBy(List<Outcome> outcomes) {
        //the list of names outrank this competitor so far
        List<String> ns = onDefeatedOrTiedBy(outcomes);
        //the list of names needed to find competitors outranked by them
        Set<String> toOutrankList = new HashSet<>(ns);
        //halting measure: the length of toOutrankedList
        //when the competitors in toOutrankedList aren't outranked by any competitors
        //except who are in ns,since the total number of competitors is limited,
        //it will break the loop.
        while (!toOutrankList.isEmpty()) {
            Set<String> tmp = new HashSet<>(toOutrankList);
            for (String c : toOutrankList)
                tmp.addAll(onDefeatedOrTiedBy(c, outcomes));
            tmp.removeAll(ns);
            ns.addAll(tmp);
            toOutrankList = tmp;
        }
        return ns;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.
    //     Examples:competitor("A").powerRanking(createOutcomes(
    // defeated("A", "B"),
    // defeated("B", "C"),
    // defeated("C", "F"),
    // defeated("F", "A"),
    // defeated("F", "I"),
    // defeated("F", "I"),
    // defeated("A", "E"),
    // defeated("E", "H"),
    // tie("B", "A"),
    // tie("A", "G")) =>
    // Arrays.asList("G", "A", "F", "B", "C", "E", "I", "H")
    public List<String> powerRanking(List<Outcome> outcomes) {
        //the list of all names in outcomes
        List<String> competitors = competitorsOfOutcomes(outcomes);
        // sort competitors by the number of names they outrank
        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                < competitor(c2).outrankedBy(outcomes).size() ? -1 : 1);
        //sort by the number of names outrank them when the number of names they outrank are the same
        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                == competitor(c2).outrankedBy(outcomes).size() &&
                competitor(c1).outranks(outcomes).size()
                        > competitor(c2).outranks(outcomes).size() ? -1 : 1);
        //sort by the non-losing-percentage when both the number of names they outrank
        // and are outranked are the same
        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                == competitor(c2).outrankedBy(outcomes).size() &&
                competitor(c1).outranks(outcomes).size()
                        == competitor(c2).outranks(outcomes).size() &&
                defeatedSum(c1, outcomes) / mentionSum(c1, outcomes)
                        > defeatedSum(c2, outcomes) / mentionSum(c2, outcomes) ?
                -1 : 1);
        //sort by str.CompareTo when three conditions above are the same
        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                == competitor(c2).outrankedBy(outcomes).size() &&
                competitor(c1).outranks(outcomes).size()
                        == competitor(c2).outranks(outcomes).size() &&
                defeatedSum(c1, outcomes) / mentionSum(c1, outcomes)
                        == defeatedSum(c2, outcomes) / mentionSum(c2, outcomes) &&
                c1.compareTo(c2) == -1 ? -1 : 1);
        return competitors;
    }

    /*
    Given: a name of competitor and a list of outcomes
    Returns: the number of outcomes that c defeated or tied the other
    Examples: new Competitor1("A").defeatedSum(competitor("B"),
    createOutcomes(defeated("A", "B"), tie("B", "C"))) => 1
     */
    private double defeatedSum(String c, List<Outcome> outcomes) {
        int count = 0;
        for (Outcome o : outcomes)
            if (o.isTie() && isMention(c, o))
                count++;
            else if (!o.isTie() && o.winner().name().equals(c))
                count++;
        return count;
    }

    /*
    Given: a name of competitor and a list of outcomes
    Returns: the number of outcomes that c are mentioned
    Examples: new Competitor1("A").mentionSum(competitor("B"),
    createOutcomes(defeated("A", "B"), tie("B", "C"))) => 2
     */
    private double mentionSum(String c, List<Outcome> outcomes) {
        int count = 0;
        for (Outcome o : outcomes)
            if (isMention(c, o))
                count++;
        return count;
    }

    /*
        Given: a list of outcomes
        Returns: the list of names of the competitors in the outcomes
        Examples:competitor("B").competitorsOfOutcomes(
        createOutcomes(defeated("A", "B"), tie("B", "C")))
        => Arrays.asList("A","B","C")
         */
    private List<String> competitorsOfOutcomes(List<Outcome> outcomes) {
        Set<String> names = new HashSet<>();
        for (Outcome o : outcomes) {
            names.add(o.first().name());
            names.add(o.second().name());
        }
        return new ArrayList<>(names);
    }

    /*
    Given: a list of outcomes
    Returns: A set of competitors in the given list defeated or tied
    by this competitor
    Examples:competitor("B").onDefeatedOrTied(
    createOutcomes(defeated("A", "B"), tie("B", "C"))) => Arrays.asList("C")
     */
    private List<String> onDefeatedOrTied(List<Outcome> outcomes) {
        Set<String> names = new HashSet<>();
        for (Outcome o : outcomes)
            if (o.isTie() && isMention(o)) {
                names.add(o.first().name());
                names.add(o.second().name());
            } else if (!o.isTie() && o.winner().equals(this))
                names.add(o.loser().name());
        return new ArrayList<>(names);
    }

    /*
    Given: a name of a competitor and a list of outcomes
    Returns: A list of competitors in the given list that
    defeated or tied by given competitor
    Examples:competitor("B").onDefeatedOrTied(competitor("B"),
    createOutcomes(defeated("A", "B"), tie("B", "C"))) => Arrays.asList("C")
    */
    private List<String> onDefeatedOrTied(String c, List<Outcome> outcomes) {
        Set<String> names = new HashSet<>();
        for (Outcome o : outcomes)
            if (o.isTie() && isMention(c, o)) {
                names.add(o.first().name());
                names.add(o.second().name());
            } else if (!o.isTie() && o.winner().name().equals(c))
                names.add(o.loser().name());
        return new ArrayList<>(names);
    }

    /*
    Given: a list of outcomes
    Returns: A set of competitors in the given list that
    defeats or ties this competitor
    Examples:competitor("B").onDefeatedOrTiedBy(
    createOutcomes(defeated("A", "B"), tie("B", "C"))) => Arrays.asList("A","C")
    */
    private List<String> onDefeatedOrTiedBy(List<Outcome> outcomes) {
        Set<String> names = new HashSet<>();
        for (Outcome o : outcomes)
            if (o.isTie() && isMention(o)) {
                names.add(o.first().name());
                names.add(o.second().name());
            } else if (!o.isTie() && o.loser().equals(this))
                names.add(o.winner().name());
        return new ArrayList<>(names);
    }

    /*
    Given: a name of a competitor and a list of outcomes
    Returns: A set of competitors in the given list that
    defeats or ties the given competitor
    Examples:competitor("B").onDefeatedOrTiedBy(competitor("B"),
    createOutcomes(defeated("A", "B"), tie("B", "C"))) => Arrays.asList("A","C")
    */
    private List<String> onDefeatedOrTiedBy(String c, List<Outcome> outcomes) {
        Set<String> names = new HashSet<>();
        for (Outcome o : outcomes)
            if (o.isTie() && isMention(c, o)) {
                names.add(o.first().name());
                names.add(o.second().name());
            } else if (!o.isTie() && o.loser().name().equals(c))
                names.add(o.winner().name());
        return new ArrayList<>(names);
    }

    /*
    Given: a name of a competitor and a outcome
    Returns: true is the given competitor is in the given contest
    Exmaples: competitor("B").isMention("B",tie("B", "C")) => true
     */
    private Boolean isMention(String c, Outcome o) {
        return o.first().name().equals(c) || o.second().name().equals(c);
    }

    /*
    GIVEN: an Outcome o
    RETURNS: true iff this competitor is mentioned by o
    competitor("B").isMention(tie("B", "C")) => true
     */
    private Boolean isMention(Outcome o) {
        return o.first().equals(this) || o.second().equals(this);
    }

    /*
    Given: a object obj
    Returns: if the given one is Competitor and the name of obj is equal to n
    Examples:competitor("B").equals(tie("A","B")) => false
    competitor("B").equals(competitor("B")) => true
     */
    public boolean equals(Object obj) {
        return obj instanceof Competitor && ((Competitor) obj).name().equals(n);
    }

    /*
    Returns: the name of this competitor
     */
    public String toString() {
        return name();
    }

    /*
        Given: two lists of string
        Returns: true if they contain the same strings
        Examples: competitor("B").listEqual(Arrays.asList("A","B"),
        Arrays.asList("B","A")) => true
        competitor("B").listEqual(Arrays.asList("C","B"),
        Arrays.asList("B","A")) => false
         */
    private static Boolean listEqual(List<String> sl1, List<String> sl2) {
        if (sl1.containsAll(sl2) && sl2.containsAll(sl1))
            return true;
        else {
            System.out.println(sl1 + "|" + sl2);
            return false;
        }
    }


    /*
    Given: a boolean and a string 
    Effect: testCount add 1 iff result is true else print the test fail msg
     */
    private static void checkTrue(Boolean result, String name) {
        if (result) testCount++;
        else System.out.println("test failed at " + name);
    }

    /*
    Given: the names of two competitors
    Returns: a Outcome represents the first one defeated the second one
     */
    private static Outcome defeated(String winner, String loser) {
        return new Defeat1(competitor(winner), competitor(loser));
    }

    /*
    Gthe names of two competitors
    Returns: a Outcome represents the first one tied the second one
     */
    private static Outcome tie(String c1, String c2) {
        return new Tie1(competitor(c1), competitor(c2));
    }

    /*
    Given: any number of outcomes
    Returns: a list of outcomes
    Examples:createOutcomes(defeated("A", "B"), tie("B", "C")) =>
    Arrays.asList(defeated("A", "B"), tie("B", "C"))
     */
    private static List<Outcome> createOutcomes(Outcome... outcomes) {
        List<Outcome> newOutcomes = new ArrayList<>();
        Collections.addAll(newOutcomes, outcomes);
        return newOutcomes;
    }

    /*
    Given: a name of a competitor
    Returns: a Competitor
     */
    private static Competitor competitor(String name) {
        return new Competitor1(name);
    }

    //Tests
    private static int testCount = 0;// number of tests

    public static void main(String[] args) {
        //Test Competitor
        List<Outcome> outcomes = createOutcomes(defeated("A", "B"), tie("B", "C"));
        List<Outcome> outcomes2 = createOutcomes(defeated("A", "B"),
                defeated("B", "A"));
        List<Outcome> outcomes3 = createOutcomes(defeated("A", "B"),
                tie("B", "C"), tie("C", "D"));
        Competitor A = competitor("A");
        Competitor B = competitor("B");
        Competitor C = competitor("C");

        checkTrue(listEqual(A.outrankedBy(outcomes),
                Collections.emptyList()), "Test1");
        checkTrue(listEqual(B.outrankedBy(outcomes2),
                Arrays.asList("A", "B")), "Test2");
        checkTrue(listEqual(C.outrankedBy(outcomes),
                Arrays.asList("A", "B", "C")), "Test3");

        checkTrue(A.hasDefeated(B, outcomes), "Test 4");
        checkTrue(B.hasDefeated(C, outcomes), "Test 5");

        checkTrue(listEqual(A.outranks(outcomes3),
                Arrays.asList("C", "B", "D")), "Test6");
        checkTrue(listEqual(B.outranks(outcomes2),
                Arrays.asList("A", "B")), "Test7");
        checkTrue(listEqual(C.outranks(outcomes3),
                Arrays.asList("B", "C", "D")), "Test8");

        checkTrue(A.name().equals("A"), "Test9");

        checkTrue(listEqual(A.powerRanking(createOutcomes(
                defeated("A", "D"),
                defeated("A", "E"),
                defeated("C", "B"),
                defeated("C", "F"),
                tie("D", "B"),
                defeated("F", "E"))),
                Arrays.asList("A", "F", "E", "B", "C", "D")), "Test10");

        checkTrue(listEqual(A.powerRanking(createOutcomes(
                defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "F"),
                defeated("F", "A"),
                defeated("F", "I"),
                defeated("F", "I"),
                defeated("A", "E"),
                defeated("E", "H"),
                tie("B", "A"),
                tie("A", "G"))),
                Arrays.asList("G", "A", "F", "B", "C", "E", "I", "H")), "Test11");

        checkTrue(listEqual(A.powerRanking(createOutcomes(
                defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "D"),
                tie("D", "E"),
                defeated("E", "H"),
                tie("F", "I"),
                tie("G", "K"),
                defeated("H", "L"),
                defeated("I", "M"),
                tie("J", "N"),
                tie("P", "B"),
                tie("C", "E"),
                defeated("J", "P"),
                tie("Q", "P"),
                defeated("R", "K"),
                tie("S", "L"),
                defeated("T", "A"),
                defeated("U", "B"),
                defeated("V", "E"),
                defeated("W", "P"),
                tie("X", "B"),
                defeated("Y", "E"),
                defeated("Z", "P"))),
                Arrays.asList("T", "U", "W", "Z", "V", "Y", "R", "A", "J", "N",
                        "F", "I", "M", "G", "K", "Q", "X",
                        "B", "P", "C", "E", "D", "H", "S", "L")),
                "Test12");

        checkTrue(listEqual(A.powerRanking(createOutcomes(
                defeated("C", "E"),
                defeated("D", "C"),
                tie("D", "B"))), Arrays.asList("B", "D", "C", "E")), "Test13");

        checkTrue(listEqual(A.powerRanking(createOutcomes(
                defeated("A", "B"),
                tie("B", "C"),
                defeated("C", "D"),
                tie("D", "E"),
                defeated("E", "H"),
                tie("F", "I"),
                tie("G", "K"),
                defeated("H", "L"),
                defeated("I", "M"),
                tie("J", "N"),
                defeated("K", "O"),
                tie("L", "P"),
                defeated("M", "K"),
                tie("N", "L"),
                defeated("O", "A"),
                tie("P", "B"),
                tie("C", "E"),
                tie("J", "P"))), Arrays.asList("F", "I", "M", "G", "K", "O",
                "A", "C", "E", "J", "N", "P", "B", "L", "D", "H")), "Test14");

        checkTrue(listEqual(competitor("F").outrankedBy(createOutcomes(
                defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "D"),
                defeated("D", "E"),
                defeated("E", "H"),
                defeated("F", "I"),
                defeated("G", "K"),
                defeated("H", "L"),
                defeated("I", "M"),
                defeated("J", "N"),
                defeated("K", "O"),
                defeated("L", "P"),
                defeated("M", "K"),
                defeated("N", "L"),
                defeated("O", "A"),
                defeated("P", "B"),
                tie("C", "E"))), Collections.emptyList()), "Test15");

        checkTrue(listEqual(competitor("E").outrankedBy(createOutcomes(
                defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "D"),
                defeated("D", "E"),
                defeated("E", "H"),
                defeated("F", "I"),
                defeated("G", "K"),
                defeated("H", "L"),
                defeated("I", "M"),
                defeated("J", "N"),
                defeated("K", "O"),
                defeated("L", "P"),
                defeated("M", "K"),
                defeated("N", "L"),
                defeated("O", "A"),
                defeated("P", "B"),
                tie("C", "E"),
                tie("J", "P"))),
                Arrays.asList("A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                        "K", "L", "M", "N", "O", "P")), "Test16");

        checkTrue(listEqual(competitor("F").outranks(createOutcomes(
                defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "D"),
                defeated("D", "E"),
                defeated("E", "H"),
                defeated("F", "I"),
                defeated("G", "K"),
                defeated("H", "L"),
                defeated("I", "M"),
                defeated("J", "N"),
                defeated("K", "O"),
                defeated("L", "P"),
                defeated("M", "K"),
                defeated("N", "L"),
                defeated("O", "A"),
                defeated("P", "B"),
                tie("C", "E"))),
                Arrays.asList("A", "B", "C", "D", "E",
                        "H", "I", "K", "L", "M", "O", "P")), "Test17");
        checkTrue(listEqual(competitor("E").outranks(createOutcomes(
                defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "D"),
                defeated("D", "E"),
                defeated("E", "H"),
                defeated("F", "I"),
                defeated("G", "K"),
                defeated("H", "L"),
                defeated("I", "M"),
                defeated("J", "N"),
                defeated("K", "O"),
                defeated("L", "P"),
                defeated("M", "K"),
                defeated("N", "L"),
                defeated("O", "A"),
                defeated("P", "B"),
                tie("C", "E"),
                tie("J", "P"))),
                Arrays.asList("B", "C", "D", "E", "H", "J", "L", "N", "P")),
                "Test18");

        // Test Outcome
        Outcome tie = new Tie1(A, B);
        checkTrue(tie.isTie(), "Test19");
        checkTrue(tie.first().name().equals("A")
                && tie.second().name().equals("B"), "Test20");

        Outcome defeat = new Defeat1(competitor("A"), B);
        checkTrue(defeat.winner().name().equals("A")
                && defeat.loser().name().equals("B"), "Test21");

        System.out.println("Test passed:" + testCount);
    }
}
