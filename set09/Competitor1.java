// Constructor template for Competitor1:
//     new Competitor1 (Competitor c1)
//
// Interpretation: the competitor represents an individual or team

// Note:  In Java, you cannot assume a List is mutable, because all
// of the List operations that change the state of a List are optional.
// Mutation of a Java list is allowed only if a precondition or other
// invariant says the list is mutable and you are allowed to change it.

import java.util.List;
import java.util.UnsupportedOperationException;

// You may import other interfaces and classes here.

class Competitor1 implements Competitor {

    // You should define your fields here.

    Competitor1 (String s) {

        // Your code goes here.

    }

    // returns the name of this competitor

    public String name () {

        // Your code goes here.

    }

    // GIVEN: another competitor and a list of outcomes
    // RETURNS: true iff one or more of the outcomes indicates this
    //     competitor has defeated or tied the given competitor

    public boolean hasDefeated (Competitor c2, List<Outcome> outcomes) {

        // Your code should replace the line below.

        throw new UnsupportedOperationException();

    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that are outranked by this competitor,
    //     without duplicates, in alphabetical order

    public List<String> outranks (List<Outcome> outcomes) {

        // Your code should replace the line below.

        throw new UnsupportedOperationException();

    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     the outcomes that outrank this competitor,
    //     without duplicates, in alphabetical order

    public List<String> outrankedBy (List<Outcome> outcomes) {

        // Your code should replace the line below.

        throw new UnsupportedOperationException();

    }

    // GIVEN: a list of outcomes
    // RETURNS: a list of the names of all competitors mentioned by
    //     one or more of the outcomes, without repetitions, with
    //     the name of competitor A coming before the name of
    //     competitor B in the list if and only if the power-ranking
    //     of A is higher than the power ranking of B.

    public List<String> powerRanking (List<Outcome> outcomes) {

        // Your code should replace the line below.

        throw new UnsupportedOperationException();

    }

    // You may define help methods here.
    // You may also define a main method for testing.
}
