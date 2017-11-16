import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Collectors;

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
        }
        Set<Player> pl = new MyTreeSet();
        pl.addAll(players);
        pl.add(p);
        return Rosters.make(pl);
    }

    @Override
    public Roster without(Player p) {
        if (!players.contains(p)) {
            return this;
        } else {
//            Set<Player> pl = new HashSet<>(players);
            Set<Player> pl = new MyTreeSet();
            pl.addAll(players);
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
        int count = 0;
        for (Player p : players) {
            if (p.available()) count++;
        }
        return count;
    }

    @Override
    public Roster readyRoster() {
        Set<Player> newPlayers = players.stream().filter(Player::available).collect(Collectors.toCollection(MyTreeSet::new));
        return Rosters.make(newPlayers);
    }

    @Override
    public Iterator<Player> iterator() {
        return players.stream()
                .sorted(Comparator.comparing(Player::name))
                .collect(Collectors.toList()).iterator();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Roster0 players1 = (Roster0) o;

        return !(players != null ? !players.equals(players1.players) : players1.players != null);

    }

    @Override
    public int hashCode() {
        return players != null ? players.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "Roster{" +
                "players=" + players +
                '}';
    }

    private static final class RosterIterator implements Iterator<Player> {
        int position;
        Set<Player> players;

        public RosterIterator(Set<Player> players) {
            this.players = players;
            position = 0;
        }

        public boolean hasNext() {
            return position < players.size() - 1;
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
