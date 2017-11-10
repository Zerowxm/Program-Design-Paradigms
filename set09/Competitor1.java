// Constructor template for Competitor1:
//     new Competitor1 (Competitor c1)
//     new Competitor1 (Competitor c1, Boolean outranked)
//
// Interpretation: the competitor represents an individual or team
// the outranked represents a mark and true if this competitor has been visited

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
    Boolean isMarked; // the visited mark of this competitor
    int outranksNum;
    int outrankedNum;
    double percentage;
    Competitor1 (String s) {
        n = s;
        isMarked = false;
    }

    Competitor1 (String s, Boolean isMarked) {
        n = s;
        this.isMarked =  isMarked;
    }

    Competitor1 (String s, List<Outcome> outcomes){
        n = s;
        isMarked = false;
        outrankedNum = outrankedBy(outcomes).size();
        outranksNum = outranks(outcomes).size();
        percentage = noLosingPercentage(outcomes);
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
        List<Outcome> marked_outcomes;
        Consumer<Competitor> toString = (Competitor p) -> ns.add(p.name());
        names.forEach(toString);
        if (isMarked){
            return ns;
        }else {
            marked_outcomes = markOutcome(outcomes);
            for (Competitor c : names){
                ns.addAll(c.outranks(marked_outcomes));
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
        List<Outcome> marked_outcomes;
        for (Competitor c : names){
            ns.add(c.name());
        }
        if (isMarked){
            return ns;
        }else {
            isMarked = true;
            marked_outcomes =  markOutcome(outcomes);
            for (Competitor c : names){
                ns.addAll(c.outrankedBy(marked_outcomes));
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
            List<Competitor> competitors = competitorsOfoutcomes(outcomes);
            List<Competitor> markedCompetitors = new ArrayList();

         markedCompetitors = competitors.stream()
                .filter(p -> p.).collect(Collectors.toList());
        outrankedNum = outrankedBy(outcomes).size();
        outranksNum = outranks(outcomes).size();
        percentage = noLosingPercentage(outcomes);
        isMarked = true;
        if (isMarked){

        }
        List<Outcome> mark_outcomes = markOutcome(outcomes);
        for (Competitor c : competitors){
            c.powerRanking(outcomes);
        }
        competitors.sort((c1,c2) ->{
        return c1.outrankedBy(outcomes).size() < c2.outrankedBy(outcomes).size()? -1:1;});
        competitors.sort((c1,c2) ->{
                return c1.outrankedBy(outcomes).size() == c2.outrankedBy(outcomes).size() &&
                        c1.outranks(outcomes).size() > c2.outranks(outcomes).size()? 1:-1;
           });
        List<Outcome> beerDrinkers = outcomes.stream()
                .filter(p -> isMention(p)).collect(Collectors.toList());
        competitors.sort((c1,c2) ->{
            return c1.outrankedBy(outcomes).size() == c2.outrankedBy(outcomes).size() &&
                    c1.outranks(outcomes).size() == c2.outranks(outcomes).size()
                    ? 1:-1;
        });
        return null;
    }




    private List<Competitor> competitorsOfoutcomes(List<Outcome> outcomes){
        Set<Competitor> names = new HashSet();
        for (Outcome o : outcomes){
                names.add(o.first());
                names.add(o.second());
        }
        return new ArrayList(names);
    }

    /*
    Given: a list of outcomes
    Returns: a list like the given one except changing this competitor
    to a marked one (set isMarked to true)
     */
    private List<Outcome> markOutcome(List<Outcome> outcomes){
        List<Outcome> olst = new ArrayList();
        for (Outcome o : outcomes){
            Competitor c1;
            Competitor c2;
            if (o.isTie() && isMemberInTie(o)){
                if (o.first().equals(this)){
                    c1 = competitorOutranked(o.first().name());
                    c2 = o.second();
                }else {
                    c1 = o.first();
                    c2 = competitorOutranked(o.second().name());
                }
                olst.add(new Tie1(c1,c2));
            }else if(!o.isTie() && isMention(o)) {
                if (o.winner().equals(this)){
                    c1 = o.loser();
                    c2 = competitorOutranked(o.winner().name());
                }else {
                    c1 = competitorOutranked(o.loser().name());
                    c2 = o.winner();
                }
                     olst.add(new Defeat1(c2,c1));
                }
                else {
                    olst.add(o);
                }
            }
        return olst;
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

    /*
    Given: a list of outcomes
    Returns: the number of outcomes in which this competitordefeats or ties 
       another competitor divided by the number of outcomes that mention this competitor
     */
    private double noLosingPercentage(List<Outcome> olst){
        int outranksNum = 0;
        int mentionNum = 0;
        for(Outcome o : olst){
            if (defeatedOrTie(o))
                outranksNum++;
            
            else if (isMention(o))
                mentionNum++;
        }
        return outranksNum / mentionNum;
    }

    /*
    GIVEN: an Outcome o
    RETURNS: true iff this competitor is mentioned by o
     */
    private Boolean isMention(Outcome o){
        return o.isTie()? isMemberInTie(o) : 
        o.winner().equals(this)|| o.loser().equals(this);
    }

    private Boolean defeatedOrTie(Outcome o){
        if (o.isTie())
            return isMemberInTie(o);
        else
        return o.winner().equals(this);
    }

    @Override
    public boolean equals(Object obj) {
        return  n == ((Competitor)obj).name();
    }

    @Override
    public String toString() {
        return name() + " "+ isMarked;
    }
    public static void main(String[] args) {
        List<Outcome> outcomes = creatOutcomes(defeated("A", "B"), tie("B", "C"));
        List<Outcome> outcomes2 = creatOutcomes(defeated("A", "B"), defeated("B", "A"));

        checkTrue(listEqual(competitor("A").outrankedBy(outcomes),
         Collections.emptyList()),"Test1");
        checkTrue(listEqual(competitor("B").outrankedBy(outcomes2),
            Arrays.asList("A","B")),"Test2");
        checkTrue(listEqual(competitor("C").outrankedBy(outcomes),
         Arrays.asList("A","B","C")),"Test3");
        checkTrue(competitor("A").hasDefeated(competitor("B"),outcomes),"Test 4");
        checkTrue(competitor("B").hasDefeated(competitor("C"),outcomes),"Test 5");

        outcomes = creatOutcomes(defeated("A", "B"), tie("B", "C"),tie("C","D"));
        outcomes2 = creatOutcomes(defeated("A", "B"), defeated("B", "A"));
        checkTrue(listEqual(competitor("A").outranks(outcomes),
            Arrays.asList("C","B","D")),"Test6");
        checkTrue(listEqual(competitor("B").outranks(outcomes2),
            Arrays.asList("A","B")),"Test7");
        checkTrue(listEqual(competitor("C").outranks(outcomes),
         Arrays.asList("B","C","D")),"Test8");
        checkTrue(competitor("A").name() == "A","Test9");

        System.out.println("Test passed:" + testCount);
    }

    /*
    Given: two lists of string
    Returns: true if they contain the same strings
     */
    private static Boolean listEqual(List<String> sl1,List<String> sl2){
        if(sl1.containsAll(sl2) && sl2.containsAll(sl1))
            return true;
        else {
            System.out.println(sl1+"|"+sl2);
            return false;
        }
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
