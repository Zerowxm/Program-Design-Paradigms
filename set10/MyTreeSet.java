import java.util.Comparator;
import java.util.TreeSet;

/**
 * Created by Zero on 11/14/2017.
 */
public class MyTreeSet extends TreeSet<Player> {
    public MyTreeSet() {
        super(Comparator.comparing(Player::hashCode));
    }
}
