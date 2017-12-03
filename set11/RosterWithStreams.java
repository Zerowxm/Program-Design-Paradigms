import java.util.Set;
import java.util.function.Predicate;

/**
 * Created by Zero on 11/14/2017.
 */
public class RosterWithStreams {

    // RosterWithStreams.empty() is a static factory method that returns an
    // empty roster.
    public static RosterWithStream empty(){
        return new RosterWithStream0(new MyTreeSet());
    }

    // RosterWithStreams.make(Set<Player> players) is a static factory method 
    // that returns a roster with the given players
    public static RosterWithStream make(Set<Player> players){
        return new RosterWithStream0(players);
    }

    public static Predicate<Player> isAvailable() {
        return p -> p.available() == true;
    }

    public static Predicate<Player> isInjure() {
        return p -> p.isInjured() == true;
    }

    public static Predicate<Player> isSuspended() {
        return p -> p.isSuspended() == true;
    }

    public static Predicate<Player> isUnderContract() {
        return p -> p.underContract() == true;
    }
}
