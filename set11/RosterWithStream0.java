import java.util.*;
import java.util.stream.*;

/**
 * Created by Zero on 11/14/2017.
 */
// new RosterWithStream0(Set<Player> players)
// players is a set of Player
// Rosters.empty() is a static factory method that returns an
// empty roster.

final public class RosterWithStream0 implements RosterWithStream {
    // a immutable list of players of this roster
    final private Set<Player> players; 

    public RosterWithStream0(Set<Player> players) {
        this.players = players;
    }

    // Returns a roster consisting of the given player together
    // with all players on this roster.
    // Example:
    //     r.with(p).with(p)  =>  r.with(p)
    @Override
    public RosterWithStream with(Player p) {
        if (players.contains(p)) {
            return this;
        }
        Set<Player> pl = new HashSet<>();
        pl.addAll(players);
        pl.add(p);
        return RosterWithStreams.make(pl);
    }

    // Returns a roster consisting of all players on this roster
    // except for the given player.
    // Examples:
    //     Rosters.empty().without(p)  =>  Rosters.empty()
    //     r.without(p).without(p)     =>  r.without(p)
    @Override
    public RosterWithStream without(Player p) {
        if (!players.contains(p)) {
            return this;
        } else {
            Set<Player> pl = new HashSet<>();
            pl.addAll(players);
            pl.remove(p);
            return RosterWithStreams.make(pl);
        }
    }

    // Returns true iff the given player is on this roster.
    // Examples:
    //
    //     Rosters.empty().has(p)  =>  false
    //
    // If r is any roster, then
    //
    //     r.with(p).has(p)     =>  true
    //     r.without(p).has(p)  =>  false
    @Override
    public boolean has(Player p) {
        return players.contains(p);
    }

    // Returns the number of players on this roster.
    // Examples:
    //     Rosters.empty().size()  =>  0
    // If r is a roster with r.size() == n, and r.has(p) is false, then
    //     r.without(p).size()          =>  n
    //     r.with(p).size               =>  n+1
    //     r.with(p).with(p).size       =>  n+1
    //     r.with(p).without(p).size()  =>  n
    @Override
    public int size() {
        return players.size();
    }

    // Returns the number of players on this roster whose current
    // status indicates they are available.
    @Override
    public int readyCount() {
        int count = 0;
        for (Player p : players) {
            if (p.available()) count++;
        }
        return count;
    }

    // Returns a roster consisting of all players on this roster
    // whose current status indicates they are available.
    @Override
    public RosterWithStream readyRoster() {
        Set<Player> newPlayers = players.stream().filter(Player::available)
        .collect(Collectors.toCollection(HashSet::new));
        return RosterWithStreams.make(newPlayers);
    }

    // Returns an iterator that generates each player on this
    // roster exactly once, in alphabetical order by name.
    @Override
    public Iterator<Player> iterator() {
        return players.stream()
                .sorted(Comparator.comparing(Player::name))
                .collect(Collectors.toList()).iterator();
    }

    @Override
    public Stream<Player> stream() {
        return players.stream()
                .sorted(Comparator.comparing(Player::name))
                .collect(Collectors.toList()).stream();
    }

    //Returns true if o is Roster, 
    //and o and this roster have the same players
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        RosterWithStream0 players1 = (RosterWithStream0) o;
        return players.equals(players1.players);
    }

    @Override
    public String toString() {
        return "RosterWithStream{" +
                "players=" + players +
                '}';
    }

    //Returns: the hashcode of this roster
    @Override
    public int hashCode() {
        return players.hashCode();
    }
}
