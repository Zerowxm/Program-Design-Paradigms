import java.util.*;
import java.util.function.Consumer;

/**
 * Created by Zero on 11/14/2017.
 */
final public class Roster0 implements Roster {
    final private Set<Player> players;

    public Roster0(Set<Player> players) {
        this.players = players;
    }

    @Override
    public Roster with(Player p) {
        if (players.contains(p)) {
            return this;
        } else {
            Set<Player> pl = new MyTreeSet();
            pl.addAll(players);
            pl.add(p);
            return Rosters.make(pl);
        }
    }

    @Override
    public Roster without(Player p) {
        if (!players.contains(p)) {
            return this;
        } else {
            Set<Player> pl = new HashSet<>(players);
            pl.remove(p);
            return Rosters.make(pl);
        }
    }

    @Override
    public boolean has(Player p) {
        return players.contains(p);
    }

    @Override
    public int size() {
        return players.size();
    }

    @Override
    public int readyCount() {
        return 0;
    }

    @Override
    public Roster readyRoster() {
        return Rosters.makeReady(players);
    }

    @Override
    public Iterator<Player> iterator() {
        return players.iterator();
    }

    private static final class RosterIterator implements Iterator<Player> {
        int position;
        Set<Player> players;

        public RosterIterator(Set<Player> players) {
            this.players = players;
            position = 0;
        }

        public boolean hasNext() {
            return position<players.size()-1;
        }

        public Player next() {
            if (this.hasNext()) {
                return null;
            }
            throw new NoSuchElementException();
        }

        public void remove() {
            throw new UnsupportedOperationException();
        }
    }
}
