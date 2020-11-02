import org.junit.Test;
import junit.framework.AssertionFailedError;
import junit.framework.TestResult;
import static org.junit.Assert.*;

public class TestJunit3 extends TestResult {
   // add the error
   public synchronized void addError(Test test, Throwable t) {
      super.addError((junit.framework.Test) test, t);
   }

   // add the failure
   public synchronized void addFailure(Test test, AssertionFailedError t) {
      super.addFailure((junit.framework.Test) test, t);
   }

   @Test
   public void testAdd() {
      TestResult result=new TestResult();   	 
      //count the number of error
      System.out.println("Number of error = " + result.errorCount());
      //count the number of failure
      System.out.println("Number of failure = " + result.failureCount());	
      //count the number of test cases
      System.out.println("Number of test cases = " + result.runCount());
	   String str="ok";
      assertEquals("not ok",str);
   }

   // Marks that the test run should stop
   public synchronized void stop() {
   //stop the test here
   }
}
