// Constructor template for Competitor1:
//     new Competitor1 (Competitor c1)
//
// Interpretation: the competitor represents an individual or team

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Collectors;
// You may import other interfaces and classes here.

class Competitor1 implements Competitor {

    String n;  // the name of this competitor
    Boolean isOutranked;

    Competitor1 (String s) {
        n = s;
        isOutranked = false;
    }

    Competitor1 (String s, Boolean isOutranked) {
        n = s;
        this.isOutranked =  isOutranked;
    }

    // returns the name of this competitor
    public String name () {
        return n;
    }

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor
    public boolean hasDefeated (Competitor c2, List<Outcome> outcomes) {
        for (Outcome o : outcomes){
            if (o.isTie()){
                if ((o.first().equals(this)&&o.second().equals(c2)) ||
                        (o.first().equals(c2)&&o.second().equals(this))){
                    return true;
                }
            }else {
                if(o.winner().equals(this) && o.loser().equals(c2)){
                    return true;
                }
            }
        }
        return false;
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that are outranked by this competitor,
    //     without duplicates, in alphabetical order
    public List<String> outranks (List<Outcome> outcomes) {
        Set<Competitor>names = onDefeatedOrTied(outcomes);
        List<String> ns = new ArrayList();
        Consumer<Competitor> toString = (Competitor p) -> ns.add(p.name());
        names.forEach(toString);

        if (isOutranked){
            return ns;
        }else {
            isOutranked = true;
            markOutcome(outcomes);
            for (Competitor c : names){
                ns.addAll(c.outranks(outcomes));
            }
        }
        return ns.stream().distinct().collect(Collectors.toList());
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order

    public List<String> outrankedBy (List<Outcome> outcomes) {
        Set<Competitor>names = onDefeatedOrTiedBy(outcomes);
        List<String> ns = new ArrayList();
        for (Competitor c : names){
            ns.add(c.name());
        }
        if (isOutranked){
            return ns;
        }else {
            isOutranked = true;
            markOutcome(outcomes);
            for (Competitor c : names){
                ns.addAll(c.outrankedBy(outcomes));
            }
        }
        return ns.stream().distinct().collect(Collectors.toList());
    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.
    public List<String> powerRanking (List<Outcome> outcomes) {
        throw new UnsupportedOperationException();
    }

    /*
    Given: a list of outcomes
    Returns: a list like the given one except changing this competitor
    to a marked one (set isOutranked to true)
     */
    private void markOutcome(List<Outcome> outcomes){
        for (int i = 0; i < outcomes.size(); i++){
            Competitor c1;
            Competitor c2;
            if (outcomes.get(i).isTie() && isMemberInTie(outcomes.get(i))){
                if (outcomes.get(i).first().equals(this)){
                    c1 = competitorOutranked(outcomes.get(i).first().name());
                    c2 = outcomes.get(i).second();
                }else {
                    c1 = outcomes.get(i).first();
                    c2 = competitorOutranked(outcomes.get(i).second().name());
                }
                outcomes.set(i,new Tie1(c1,c2));
            }else if(!outcomes.get(i).isTie()) {
                if (outcomes.get(i).winner().equals(this)){
                     c1 = outcomes.get(i).loser();
                     c2 = competitorOutranked(outcomes.get(i).winner().name());
                }else if (outcomes.get(i).loser().equals(this)){
                    c1 = competitor(outcomes.get(i).loser().name());
                    c2 = outcomes.get(i).winner();
                }
                else {
                    continue;
                }
                outcomes.set(i,new Defeat1(c2,c1));
            }
        }
    }
   
    /*
    Given: a list of outcomes
    Returns: A set of competitors in the given list defeated or tied by this competitor
     */
    private Set<Competitor> onDefeatedOrTied (List<Outcome> outcomes){
        Set<Competitor> names = new HashSet();
        for (Outcome o : outcomes){
            if (o.isTie() && isMemberInTie(o)){
                names.add(o.first());
                names.add(o.second());
            }else {
                if (!o.isTie()&&o.winner().equals(this)){
                    names.add(o.loser());
                }
            }
        }
        return names;
    }

    /*
    Given: a list of outcomes
    Returns: A set of competitors in the given list that
    defeats or ties this competitor
    */
    private Set<Competitor> onDefeatedOrTiedBy (List<Outcome> outcomes){
        Set<Competitor> names = new HashSet();
        for (Outcome o : outcomes){
            if (o.isTie() && isMemberInTie(o)){
                names.add(o.first());
                names.add(o.second());
            }else {
                if (!o.isTie()&&o.loser().equals(this)){
                    names.add(o.winner());
                }
            }
        }
        return names;
    }

    /*
    Given: a outcome
    Returns: true is this competitor is in the given contest
     */
    private Boolean isMemberInTie (Outcome o){
        return o.first().equals(this) || o.second().equals(this);
    }

    @Override
    public boolean equals(Object obj) {
        return  n == ((Competitor)obj).name();
    }

    @Override
    public String toString() {
        return name() + " "+ isOutranked;
    }
    public static void main(String[] args) {
        Competitor A = competitor("A");
        Competitor B = competitor("B");
        Competitor C = competitor("C");
        Competitor D = competitor("D");
        List<Outcome> outcomes = creatOutcomes(defeated("A", "B"), tie("B", "C"));
        List<Outcome> outcomes2 = creatOutcomes(defeated("A", "B"), defeated("B", "A"));

        checkTrue(listEqual(A.outrankedBy(outcomes), Collections.emptyList()),"Test1");
        checkTrue(listEqual(B.outrankedBy(outcomes2),Arrays.asList("A","B")),"Test2");
        checkTrue(listEqual(C.outrankedBy(outcomes), Arrays.asList("A","B","C")),"Test3");
        checkTrue(A.hasDefeated(B,outcomes),"Test 4");
        checkTrue(B.hasDefeated(C,outcomes),"Test 5");
        checkTrue(listEqual(.outranks(outcomes), Arrays.asList("C","B")),"Test6");
        checkTrue(listEqual(B.outranks(outcomes2),Arrays.asList("A","B")),"Test7");
        checkTrue(listEqual(C.outranks(outcomes), Arrays.asList("A","B","C")),"Test8");
        System.out.println("Test passed:" + testCount);
    }

    /*
    Given: two lists of string
    Returns: true if they contain the same strings
     */
    private static Boolean listEqual(List<String> sl1,List<String> sl2){
        return sl1.containsAll(sl2) && sl2.containsAll(sl1);
    }

    private static int testCount;
    private static void checkTrue(Boolean result, String name){
        if (result) testCount++;
        else System.out.println("test failed at "+name);
    }
    /*
    Given: the names of two competitors
    Returns: a Outcome represents the first one defeated the second one
     */
    private static Outcome defeated(String winner, String loser){
        return new Defeat1(competitor(winner), competitor(loser));
    }

    /*
    Gthe names of two competitors
    Returns: a Outcome represents the first one tied the second one
     */
    private static Outcome tie(String c1,String c2){
        return new Tie1(competitor(c1), competitor(c2));
    }

    /*
    Given: any number of outcomes
    Returns: a list of outcomes
     */
    private static List<Outcome> creatOutcomes(Outcome... outcomes){
        List<Outcome> olst = new ArrayList();
        for (Outcome o : outcomes){
            olst.add(o);
        }
        return olst;
    }

    /*
    Given: a name of a competitor
    Returns: a Competitor
     */
    private static Competitor competitor(String name){
        return new Competitor1(name);
    }

    /*
    Given: a name of a competitor
    Returns: a Competitor
     */
    private static Competitor competitorOutranked(String name){
        return new Competitor1(name,true);
    }
}
