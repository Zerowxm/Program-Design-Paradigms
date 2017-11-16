import java.util.*;

/**
 * Created by Zero on 11/14/2017.
 */
//
public class Player0 implements Player, Comparable {
    String n; // the name of this player
    boolean underContract; // the mark under a contract or not of this player
    boolean isInjure; // the mark of this player injure
    boolean isSuspended; // the mark of this player Suspended
    private final Integer rand; // random number for hashCode()

    public Player0(String n) {
        this.n = n;
        underContract = true;
        isInjure = false;
        isSuspended = false;
        rand = new Random().nextInt();
    }

    // Returns the name of this player.
    // Example:
    //     Players.make("Gordon Wayhard").name()  =>  "Gordon Wayhard"
    public String name() {
        return n;
    }

    // Returns true iff this player is
    //     under contract, and
    //     not injured, and
    //     not suspended
    // Example:
    //     Player gw = Players.make ("Gordon Wayhard");
    //     System.out.println (gw.available());  // prints true
    //     gw.changeInjuryStatus (true);
    //     System.out.println (gw.available());  // prints false
    public boolean available() {
        return !isInjure && !isSuspended && underContract;
    }

    // Returns true iff this player is under contract (employed).
    // Example:
    //     Player ih = Players.make ("Isaac Homas");
    //     System.out.println (ih.underContract());  // prints true
    //     ih.changeContractStatus (false);
    //     System.out.println (ih.underContract());  // prints false
    //     ih.changeContractStatus (true);
    //     System.out.println (ih.underContract());  // prints true
    public boolean underContract() {
        return underContract;
    }

    // Returns true iff this player is injured.
    public boolean isInjured() {
        return isInjure;
    }

    // Returns true iff this player is suspended.
    public boolean isSuspended() {
        return isSuspended;
    }

    // Changes the underContract() status of this player
    // to the specified boolean.
    public void changeContractStatus(boolean newStatus) {
        underContract = newStatus;
    }

    // Changes the isInjured() status of this player
    // to the specified boolean.
    public void changeInjuryStatus(boolean newStatus) {
        isInjure = newStatus;
    }

    // Changes the isSuspended() status of this player
    // to the specified boolean.
    public void changeSuspendedStatus(boolean newStatus) {
        isSuspended = newStatus;
    }

    // true if the given object is the same referrence of this object
    @Override
    public boolean equals(Object o) {
        return this == o;
    }

    // Returns: the unique hashCode of this object
    @Override
    public int hashCode() {
        return n.hashCode()+rand + Objects.hash(n,rand);
    }

    @Override
    public String toString() {
        return "Player{" +
                "n='" + n + '\'' +
                ", available=" + available() +
                ", underContract=" + underContract +
                ", isInjure=" + isInjure +
                ", isSuspended=" + isSuspended +
                '}';
    }

    // Implemented the comparable interface
    // Given: an object
    // Returns: hashCode of the given objcet if it is Player
    @Override
    public int compareTo(Object o) throws ClassCastException {
        if (!(o instanceof Player))
            throw new ClassCastException("A Person object expected.");
        Player player = (Player) o;
        return player.hashCode();
    }
}
