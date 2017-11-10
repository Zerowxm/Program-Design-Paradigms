// Constructor template for Tie1:
//     new Tie1 (Competitor c1, Competitor c2)
// Interpretation:
//     c1 and c2 have engaged in a contest that ended in a tie

public class Tie1 implements Outcome {

    // You should define your fields here.
    Competitor c1; // the first competitor of this outcome
    Competitor c2; // the second competitor of this outcome

    Tie1 (Competitor c1, Competitor c2) {
        this.c1 = c1;
        this.c2 = c2;
    }

    // RETURNS: true iff this outcome represents a tie

    public boolean isTie () {
        return true;
    }

    // RETURNS: one of the competitors

    public Competitor first () {
        return c1;
    }

    // RETURNS: the other competitor
    public Competitor second () {
        return c2;
    }

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the winner of this outcome
    public Competitor winner () {
        return null;
    }

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the loser of this outcome

    public Competitor loser () {
        return null;
    }

    @Override
    public String toString() {
        return c1.name() + c2.name();
    }
}
