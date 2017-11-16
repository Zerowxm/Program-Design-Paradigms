import java.util.Set;

/**
 * Created by Zero on 11/14/2017.
 */
public class Rosters {

    // Rosters.empty() is a static factory method that returns an
    // empty roster.
    public static Roster empty(){
        return new Roster0(new MyTreeSet());
    }

    // Rosters.make(Set<Player> players) is a static factory method that returns a roster
    // with the given players
    public static Roster make(Set<Player> players){
        return new Roster0(players);
    }
}
