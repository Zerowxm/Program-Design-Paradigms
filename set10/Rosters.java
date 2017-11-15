import java.util.HashSet;
import java.util.Set;

/**
 * Created by Zero on 11/14/2017.
 */
public class Rosters {
    public static Roster empty(){
        return new Roster0(new MyTreeSet());
    }

    public static int readyCounter(Set<Player> players){
        int count = 0;
        for (Player p : players){
            if (p.available()) count++;
        }
        return count;
    }

    public static Roster makeReady(Set<Player> players){
        Set<Player> newPlayers = new MyTreeSet();
        for (Player p : players){
            if (p.available()){
                newPlayers.add(p);
            }
            else newPlayers.add(Players.make(p.name()));
        }
        return make(newPlayers);
    }

    public static Roster make(Set<Player> players){
        return new Roster0(players);
    }
}
