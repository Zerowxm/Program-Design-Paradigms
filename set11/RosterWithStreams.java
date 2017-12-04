import java.util.HashSet;
import java.util.Set;

/**
 * Created by Zero on 11/14/2017.
 */
public class RosterWithStreams {

    // RosterWithStreams.empty() is a static factory method that returns an
    // empty roster.
    public static RosterWithStream empty(){
        return new RosterWithStream0(new HashSet<>());
    }

    // RosterWithStreams.make(Set<Player> players) is a static factory method 
    // that returns a roster with the given players
    public static RosterWithStream make(Set<Player> players){
        return new RosterWithStream0(players);
    }


}
