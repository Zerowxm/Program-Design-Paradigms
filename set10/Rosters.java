import java.util.HashSet;
import java.util.Set;
import java.util.TreeSet;

/**
 * Created by Zero on 11/14/2017.
 */
public class Rosters {
    public static Roster empty(){
        return new Roster0(new MyTreeSet());
    }

    public static Roster make(Set<Player> players){
        return new Roster0(players);
    }
}
