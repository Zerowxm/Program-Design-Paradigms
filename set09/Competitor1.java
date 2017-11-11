// Constructor template for Competitor1:
//     new Competitor1 (Competitor c1)
//
// Interpretation: the competitor represents an individual or team
// the outranked represents a mark and true if this competitor has been visited

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.*;
import java.util.stream.Collectors;
// You may import other interfaces and classes here.

class Competitor1 implements Competitor {

    String n;  // the name of this competitor

    Competitor1(String s) {
        n = s;
    }

    // returns the name of this competitor
    public String name() {
        return n;
    }

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor
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
    public List<String> outranks(List<Outcome> outcomes) {
        List<String> ns = onDefeatedOrTied(outcomes);
        int length = ns.size();
        Set<String> outranked_name = new HashSet<>();
        while (true) {
            for (String c : ns)
                outranked_name.addAll(onDefeatedOrTied(c, outcomes));
            ns.addAll(outranked_name);
            ns = ns.stream().distinct().collect(Collectors.toList());
            if (length == ns.size()) break;
            else length = ns.size();
        }
        return ns;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order
    public List<String> outrankedBy(List<Outcome> outcomes) {
        List<String> ns = onDefeatedOrTiedBy(outcomes);
        int length = ns.size();
        Set<String> outranked_name = new HashSet<>();
        while (true) {
            for (String c : ns)
                outranked_name.addAll(onDefeatedOrTiedBy(c, outcomes));
            ns.addAll(outranked_name);
            ns = ns.stream().distinct().collect(Collectors.toList());
            if (length == ns.size()) break;
            else length = ns.size();
        }
        return ns;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.
    public List<String> powerRanking(List<Outcome> outcomes) {
        List<String> competitors = competitorsOfOutcomes(outcomes);
        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                < competitor(c2).outrankedBy(outcomes).size() ? -1 : 1);

        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                == competitor(c2).outrankedBy(outcomes).size() &&
                competitor(c1).outranks(outcomes).size()
                        > competitor(c2).outranks(outcomes).size() ? -1 : 1);

        competitors.sort((c1, c2) -> competitor(c1).outrankedBy(outcomes).size()
                == competitor(c2).outrankedBy(outcomes).size() &&
                competitor(c1).outranks(outcomes).size()
                        == competitor(c2).outranks(outcomes).size() &&
                defeatedSum(c1, outcomes) / mentionSum(c1, outcomes)
                        > defeatedSum(c2, outcomes) / mentionSum(c2, outcomes) ? -1 : 1);

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
    Returns: A set of competitors in the given list defeated or tied by this competitor
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
     */
    private Boolean isMention(String c, Outcome o) {
        return o.first().name().equals(c) || o.second().name().equals(c);
    }

    /*
    GIVEN: an Outcome o
    RETURNS: true iff this competitor is mentioned by o
     */
    private Boolean isMention(Outcome o) {
        return o.first().equals(this) || o.second().equals(this);
    }

    @Override
    public boolean equals(Object obj) {
        return  ((Competitor) obj).name().equals(n);
    }

    @Override
    public String toString() {
        return name();
    }

    public static void main(String[] args) {
        List<Outcome> outcomes = creatOutcomes(defeated("A", "B"), tie("B", "C"));
        List<Outcome> outcomes2 = creatOutcomes(defeated("A", "B"), defeated("B", "A"));
        List<Outcome> outcomes3 = creatOutcomes(defeated("A", "B"),
                tie("B", "C"), tie("C", "D"));

        checkTrue(listEqual(competitor("A").outrankedBy(outcomes),
                Collections.emptyList()), "Test1");
        checkTrue(listEqual(competitor("B").outrankedBy(outcomes2),
                Arrays.asList("A", "B")), "Test2");
        checkTrue(listEqual(competitor("C").outrankedBy(outcomes),
                Arrays.asList("A", "B", "C")), "Test3");
        checkTrue(competitor("A").hasDefeated(competitor("B"), outcomes), "Test 4");
        checkTrue(competitor("B").hasDefeated(competitor("C"), outcomes), "Test 5");

        checkTrue(listEqual(competitor("A").outranks(outcomes3),
                Arrays.asList("C", "B", "D")), "Test6");
        checkTrue(listEqual(competitor("B").outranks(outcomes2),
                Arrays.asList("A", "B")), "Test7");
        checkTrue(listEqual(competitor("C").outranks(outcomes3),
                Arrays.asList("B", "C", "D")), "Test8");
        checkTrue(competitor("A").name().equals("A"), "Test9");

        List<Outcome> outcomes4 = creatOutcomes(defeated("A", "D"),
                defeated("A", "E"),
                defeated("C", "B"),
                defeated("C", "F"),
                tie("D", "B"),
                defeated("F", "E"));
        checkTrue(listEqual(competitor("A").powerRanking(outcomes4),
                Arrays.asList("A", "F", "E", "B", "C", "D")), "Test10");

        List<Outcome> outcomes5 = creatOutcomes(defeated("A", "B"),
                defeated("B", "C"),
                defeated("C", "F"),
                defeated("F", "A"),
                defeated("F", "I"),
                defeated("F", "I"),
                defeated("A", "E"),
                defeated("E", "H"),
                tie("B", "A"),
                tie("A", "G"));
        checkTrue(listEqual(competitor("A").powerRanking(outcomes5),
                Arrays.asList("G", "A", "F", "B", "C", "E", "I", "H")), "Test11");
        Competitor A = competitor("A");
        checkTrue(listEqual(A.powerRanking(creatOutcomes(defeated("A", "B"),
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
                Arrays.asList("T", "U", "W", "Z", "V", "Y", "R", "A", "J", "N", "F",
                        "I", "M", "G", "K", "Q", "X", "B", "P", "C", "E", "D", "H", "S", "L")),
                "Test12");

        checkTrue(listEqual(A.powerRanking(creatOutcomes(defeated("C", "E"),
                defeated("D", "C"),
                tie("D", "B"))), Arrays.asList("B", "D", "C", "E")), "Test13");

        checkTrue(listEqual(A.powerRanking(creatOutcomes(defeated("A", "B"),
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
                tie("J", "P"))), Arrays.asList("F", "I", "M", "G", "K", "O", "A", "C",
                "E", "J", "N", "P", "B", "L", "D", "H")), "Test14");
        System.out.println("Test passed:" + testCount);
    }

    /*
    Given: two lists of string
    Returns: true if they contain the same strings
     */
    private static Boolean listEqual(List<String> sl1, List<String> sl2) {
        if (sl1.containsAll(sl2) && sl2.containsAll(sl1))
            return true;
        else {
            System.out.println(sl1 + "|" + sl2);
            return false;
        }
    }

    private static int testCount;

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
     */
    private static List<Outcome> creatOutcomes(Outcome... outcomes) {
        List<Outcome> newOutcomes = new ArrayList();
        for (Outcome o : outcomes) {
            newOutcomes.add(o);
        }
        return newOutcomes;
    }

    /*
    Given: a name of a competitor
    Returns: a Competitor
     */
    private static Competitor competitor(String name) {
        return new Competitor1(name);
    }
}
