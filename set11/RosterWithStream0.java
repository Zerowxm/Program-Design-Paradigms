import java.util.*;
import java.util.function.*;
import java.util.stream.*;

/**
 * Created by Zero on 11/14/2017.
 */
// new RosterWithStream0(Set<Player> players)
// players is a set of Player
// Rosters.empty() is a static factory method that returns an
// empty roster.

final public class RosterWithStream0 implements RosterWithStream {
    final private Set<Player> players; // a immutable list of players of this roster

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
        Set<Player> pl = new MyTreeSet();
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
            Set<Player> pl = new MyTreeSet();
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
        .collect(Collectors.toCollection(MyTreeSet::new));
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

    private class StreamRosters implements Stream<Player> {
        Stream<Player> stream;

        public StreamRosters(Stream<Player> stream) {
            this.stream = stream;
        }

        @Override
        public Stream<Player> filter(Predicate<? super Player> predicate) {
            return stream.filter(predicate);
        }

        @Override
        public <R> Stream<R> map(Function<? super Player, ? extends R> mapper) {
            return stream.map(mapper);
        }

        @Override
        public IntStream mapToInt(ToIntFunction<? super Player> mapper) {
            return stream.mapToInt(mapper);
        }

        @Override
        public LongStream mapToLong(ToLongFunction<? super Player> mapper) {
            return stream.mapToLong(mapper);
        }

        @Override
        public DoubleStream mapToDouble(ToDoubleFunction<? super Player> mapper) {
            return stream.mapToDouble(mapper);
        }

        @Override
        public <R> Stream<R> flatMap(Function<? super Player, ? extends Stream<? extends R>> mapper) {
            return stream.flatMap(mapper);
        }

        @Override
        public IntStream flatMapToInt(Function<? super Player, ? extends IntStream> mapper) {
            return stream.flatMapToInt(mapper);
        }

        @Override
        public LongStream flatMapToLong(Function<? super Player, ? extends LongStream> mapper) {
            return stream.flatMapToLong(mapper);
        }

        @Override
        public DoubleStream flatMapToDouble(Function<? super Player, ? extends DoubleStream> mapper) {
            return stream.flatMapToDouble(mapper);
        }

        @Override
        public Stream<Player> distinct() {
            return stream;
        }

        @Override
        public Stream<Player> sorted() {
            return stream;
        }

        @Override
        public Stream<Player> sorted(Comparator<? super Player> comparator) {
            return stream.sorted(comparator);
        }

        @Override
        public Stream<Player> peek(Consumer<? super Player> action) {
            return stream.peek(action);
        }

        @Override
        public Stream<Player> limit(long maxSize) {
            return stream.limit(maxSize);
        }

        @Override
        public Stream<Player> skip(long n) {
            return stream.skip(n);
        }

        @Override
        public void forEach(Consumer<? super Player> action) {
            stream.forEach(action);
        }

        @Override
        public void forEachOrdered(Consumer<? super Player> action) {
            stream.forEachOrdered(action);
        }

        @Override
        public Object[] toArray() {
            return stream.toArray();
        }

        @Override
        public <A> A[] toArray(IntFunction<A[]> generator) {
            return stream.toArray(generator);
        }

        @Override
        public Player reduce(Player identity, BinaryOperator<Player> accumulator) {
            return stream.reduce(identity,accumulator);
        }

        @Override
        public Optional<Player> reduce(BinaryOperator<Player> accumulator) {
            return stream.reduce(accumulator);
        }

        @Override
        public <U> U reduce(U identity, BiFunction<U, ? super Player, U> accumulator, BinaryOperator<U> combiner) {
            return stream.reduce(identity,accumulator,combiner);
        }

        @Override
        public <R> R collect(Supplier<R> supplier, BiConsumer<R, ? super Player> accumulator, BiConsumer<R, R> combiner) {
            return null;
        }

        @Override
        public <R, A> R collect(Collector<? super Player, A, R> collector) {
            return null;
        }

        @Override
        public Optional<Player> min(Comparator<? super Player> comparator) {
            return null;
        }

        @Override
        public Optional<Player> max(Comparator<? super Player> comparator) {
            return null;
        }

        @Override
        public long count() {
            return 0;
        }

        @Override
        public boolean anyMatch(Predicate<? super Player> predicate) {
            return false;
        }

        @Override
        public boolean allMatch(Predicate<? super Player> predicate) {
            return false;
        }

        @Override
        public boolean noneMatch(Predicate<? super Player> predicate) {
            return false;
        }

        @Override
        public Optional<Player> findFirst() {
            return null;
        }

        @Override
        public Optional<Player> findAny() {
            return null;
        }

        @Override
        public Iterator<Player> iterator() {
            return null;
        }

        @Override
        public Spliterator<Player> spliterator() {
            return null;
        }

        @Override
        public boolean isParallel() {
            return false;
        }

        @Override
        public Stream<Player> sequential() {
            return null;
        }

        @Override
        public Stream<Player> parallel() {
            return null;
        }

        @Override
        public Stream<Player> unordered() {
            return null;
        }

        @Override
        public Stream<Player> onClose(Runnable closeHandler) {
            return null;
        }

        @Override
        public void close() {

        }
    }

    //Returns true if o is Roster, and o and this roster have the same players
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

    /*
    Returns: the hashcode of this roster
     */
    @Override
    public int hashCode() {
        return players.hashCode();
    }
}
