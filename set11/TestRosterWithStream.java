import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Created by Zero on 12/1/2017.
 */
public class TestRosterWithStream {
    public static void main(String[] args) {
        Player p1 = Players.make("a");
        p1.changeContractStatus(false);
        Player p2 = Players.make("b");
        p2.changeSuspendedStatus(true);
        Player p3 = Players.make("c");
        p3.changeSuspendedStatus(true);
        Player p4 = Players.make("d");
        Player p5 = Players.make("e");
        Player p6 = Players.make("f");
        RosterWithStream rosterWithStream = RosterWithStreams.empty()
                .with(p1).with(p2).with(p3).with(p4).with(p5).with(p6);
        checkTrue(!rosterWithStream.stream()
                .allMatch(RosterWithStreams.isAvailable()), "Test allMatch");
        checkTrue(!rosterWithStream.stream()
                .allMatch(RosterWithStreams.isUnderContract()), "Test allMatch");
        checkTrue(rosterWithStream.stream()
                .anyMatch(RosterWithStreams.isAvailable()), "Test anyMatch");
        checkTrue(rosterWithStream.stream()
                .anyMatch(RosterWithStreams.isUnderContract()), "Test anyMatch");
        checkEqual(RosterWithStreams.empty()
                .stream().count(), (long) 0, "Test Stream count");
        checkEqual(RosterWithStreams.empty()
                .stream().findFirst().isPresent(), false, "Test findFirst isPresent");
        checkEqual(RosterWithStreams.empty().with(p2).with(p1)
                .stream().findFirst().get(), p1, "Test findFirst");
        checkEqual(RosterWithStreams.empty()
                .stream().findFirst(), Optional.empty(), "Test findFirst");

        checkTrue(rosterWithStream.stream().findAny().isPresent(), "Test findAny");
        checkTrue(!RosterWithStreams.empty()
                .stream().findAny().isPresent(), "Test findAny");
        checkEqual(rosterWithStream.stream().filter(Player::available).count(),
                (long) rosterWithStream.readyCount(), "Test Stream filter");

        assertStreamEquals(rosterWithStream.stream().distinct()
                , rosterWithStream.stream());

        testForEach(rosterWithStream);
        testMap(rosterWithStream);
        testMapReduce(rosterWithStream);

        testFunctions();
    }

    static int testCount; // Test count

    //Given: the lists and the name of this test
    //Effect testCount add1 and if the given lists are not equal, printing the error msg
    private static <T> void checkEqual(T s1, T s2, String name) {
        testCount++;
        if (!s1.equals(s2)) {
            System.out.println(s1 + "\n" + s2);
            System.out.println(name + " Fail");
        }
    }

    /*
    Given: a boolean and a string
    Effect: testCount add 1 iff result is true else print the test fail msg
     */
    private static void checkTrue(Boolean result, String name) {
        testCount++;
        if (!result) {
            System.out.println("test failed at " + name);
        }
    }

    static void assertStreamEquals(Stream<?> s1, Stream<?> s2) {
        Iterator<?> iter1 = s1.iterator(), iter2 = s2.iterator();
        while (iter1.hasNext() && iter2.hasNext())
            checkEqual(iter1.next(), iter2.next(), "Test stream");
    }

    static void testForEach(RosterWithStream rosterWithStream) {
        StringBuilder builder1 = new StringBuilder();
        rosterWithStream.stream().forEach(p -> builder1.append(p.toString()));
        Iterator<Player> iterator = rosterWithStream.stream().iterator();
        StringBuilder builder2 = new StringBuilder();
        while (iterator.hasNext()) {
            builder2.append(iterator.next().toString());
        }
        checkEqual(builder1.toString(), builder2.toString(), "Test forEach");
    }

    static void testMap(RosterWithStream rosterWithStream) {
        Stream<String> upperCase = rosterWithStream.stream()
                .map(p -> p.name().toUpperCase());
        Iterator<Player> iter1 = rosterWithStream.stream().iterator();
        Iterator<String> iter2 = upperCase.iterator();
        while (iter1.hasNext() && iter2.hasNext())
            checkEqual(iter1.next().name().toUpperCase(), iter2.next(),
                    "Test Map");
    }

    static void testMapReduce(RosterWithStream rosterWithStream) {
        checkTrue(rosterWithStream.stream()
                .map(p -> {p.changeContractStatus(false);
                    return p;})
                .reduce(Players.make("Available"),
                        (p1, p2) -> p1.available()? p1 :p2 ).available(),
                "Test Reduce");
    }

    static void testFunctions(){
        Player p1 = Players.make("a");
        p1.changeContractStatus(false);
        Player p2 = Players.make("b");
        p2.changeSuspendedStatus(true);
        Player p3 = Players.make("c");
        p3.changeSuspendedStatus(true);
        Player p4 = Players.make("d");
        Player p5 = Players.make("e");
        Player p6 = Players.make("f");
        Player gw = Players.make("Gordon Wayhard");
        checkEqual(gw.name(),
                "Gordon Wayhard", "Test name");
        checkTrue(gw.available(), "Test available");
        gw.changeInjuryStatus(true);
        checkTrue(!gw.available(), "Test available");
        checkTrue(gw.isInjured(), "Test Injure");

        Player ih = Players.make("Isaac Homas");
        checkTrue(ih.underContract(), "Test underContract");

        ih.changeContractStatus(false);
        checkTrue(!ih.underContract(), "Test underContract");

        ih.changeContractStatus(true);
        checkTrue(ih.underContract(), "Test underContract");

        ih.changeSuspendedStatus(true);
        checkTrue(!ih.available(), "Test Suspended");
        checkTrue(ih.isSuspended(), "Test Suspended");

        RosterWithStream r = RosterWithStreams.empty();
        Player p = Players.make("Xiao ming");
        r = r.with(p);
        checkEqual(r.with(p).with(p), r.with(p), "Test with()");

        checkEqual(RosterWithStreams.empty().without(p), RosterWithStreams.empty(), "Test without()");
        checkEqual(r.without(p).without(p), r.without(p), "Test without()");

        checkTrue(!RosterWithStreams.empty().has(p), "Test has()");

        checkTrue(RosterWithStreams.empty().with(p).has(p), "Test has()");

        checkTrue(!RosterWithStreams.empty().with(p).without(p).has(p), "Test has()");

        checkEqual(RosterWithStreams.empty().size(), 0, "Test size()");
        checkEqual(RosterWithStreams.empty().without(p).size(), 0, "Test size()");
        checkEqual(RosterWithStreams.empty().with(p).without(p).size(), 0, "Test size()");
        checkEqual(RosterWithStreams.empty().with(p).size(), 1, "Test size()");
        checkEqual(RosterWithStreams.empty().with(p).with(p).size(), 1, "Test size()");

        RosterWithStream allReady = RosterWithStreams.empty();

        allReady = allReady.with(p4).with(p5).with(p6);
        allReady = allReady.with(p4).with(p5).with(p6);

        RosterWithStream someReady = RosterWithStreams.empty();
        someReady = someReady.with(p1).with(p2).with(p3).with(p4).with(p5).with(p6);

        checkEqual(allReady.readyCount(), allReady.size(), "Test readyCount()");
        checkEqual(someReady.readyCount(), allReady.size(), "Test readyCount()");
        checkEqual(allReady.readyRoster(), allReady, "Test readyRoster()");

        checkEqual(someReady.readyRoster(), allReady, "Test readyRoster()");

        RosterWithStream rosters = allReady.with(p1).with(p2).with(p3).with(Players.make("Xiao ming"));
        rosters = rosters.with(p1).with(p2).with(p3).with(Players.make("Guang fan"));
        p1.changeSuspendedStatus(true);
        rosters = rosters.with(p1).with(p2).with(p3);
        rosters = rosters.with(p1).with(p2).with(p3).with(Players.make("a"));
        rosters = rosters.with(p1).with(p2).with(p3).with(Players.make("b"));
        rosters = rosters.with(p1).with(p2).with(p3).with(Players.make("jjj"));
        rosters = rosters.with(p1).with(p2).with(p3).with(Players.make("jjj"));
        rosters = rosters.with(p1).with(p2).with(p3).with(Players.make("jojo"));

        checkEqual(rosters.size(), 13, "Test Size");

        List<String> names = new ArrayList<>();
        for (Player player : rosters) {
            names.add(player.name());
        }
        checkEqual(names.stream().sorted().collect(Collectors.toList()), names, "Test Iterator");
        System.out.println("Test passed: " + testCount);
    }
}