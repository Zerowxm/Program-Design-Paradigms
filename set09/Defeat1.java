// Constructor template for Defeat1:
//     new Defeat1 (Competitor c1, Competitor c2)
// Interpretation:
//     c1 and c2 have engaged in a contest that ended with
//         c1 defeating c2


public class Defeat1 implements Outcome {

    // You should define your fields here.
    Competitor winner; //the winner competitor of this outcome
    Competitor loser; // the loser competitor of this outcome

    Defeat1 (Competitor c1, Competitor c2) {
        winner = c1;
        loser = c2;
    }

    // RETURNS: true iff this outcome represents a tie

    public boolean isTie () {
        return false;
    }

    // RETURNS: one of the competitors

    public Competitor first () {
        return winner;
    }

    // RETURNS: the other competitor

    public Competitor second () {
        return loser;
    }

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the winner of this outcome

    public Competitor winner () {
        return winner;
    }

    // GIVEN: no arguments
    // WHERE: this.isTie() is false
    // RETURNS: the loser of this outcome

    public Competitor loser () {
        return loser;
    }

    @Override
    public String toString() {
        return winner.name() + loser.name();
    }
}
