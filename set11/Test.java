import java.util.*;
import java.util.stream.Collectors;

public class Test {
    public static void main(String[] args) {
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
        Player p1 = Players.make("a");
        p1.changeContractStatus(false);

        Player p2 = Players.make("b");
        p2.changeSuspendedStatus(true);
        Player p3 = Players.make("c");
        p3.changeSuspendedStatus(true);

        Player p4 = Players.make("d");
        Player p5 = Players.make("e");
        Player p6 = Players.make("f");
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

        checkEqual(rosters.size(),13,"Test Size");

        List<String> names = new ArrayList<>();
        for (Player player : rosters) {
            names.add(player.name());
        }
        checkEqual(names.stream().sorted().collect(Collectors.toList()), names, "Test Iterator");
        checkEqual(RosterWithStreams.empty().stream().count(),(long)0,"Test Stream1");

        checkEqual(RosterWithStreams.empty().stream().findFirst().isPresent(),false,"Test Stream2");

        checkEqual(RosterWithStreams.empty().with(p).stream().findFirst().get(),p,"Test Stream3");
        checkEqual(someReady.stream().filter(Player::available).count(),
                (long)someReady.readyCount(),"Test Stream5");
        System.out.println("Test passed: " + testCount);


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
}