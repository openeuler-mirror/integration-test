import org.junit.Test;
import java.util.ArrayList;
import static junit.framework.TestCase.fail;
import org.junit.Rule;
import org.junit.rules.ExpectedException;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.is;

public class ExceptionTest {
    //@Test(expected…)
    @Test(expected = ArithmeticException.class)
    public void testDivisionWithException() {
        int i = 1 / 0;
    }

    @Test(expected = IndexOutOfBoundsException.class)
    public void testEmptyList() {
        new ArrayList<>().get(0);
    }

    //try/catch with assert/fail
    @Test
    public void testDivisionWithException2() {
        try {
            int i = 1 / 0;
            fail(); 
        } catch (ArithmeticException e) {
            assertThat(e.getMessage(),is("/ by zero"));
        }
	}

    //ExpectedException Rule
    @Rule
    public ExpectedException thrown = ExpectedException.none();

    @Test
    public void testDivisionWithException3() {
        thrown.expect(ArithmeticException.class);
        thrown.expectMessage(containsString("/ by zero"));
        int i = 1 / 0;
	}
}

