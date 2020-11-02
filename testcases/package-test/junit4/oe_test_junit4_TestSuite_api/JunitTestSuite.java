import junit.framework.*;

public class JunitTestSuite {
   public static void main(String[] a) {
      //add the test's in the suite
      //TestSuite suite = new TestSuite(TestJunit1.class, TestJunit2.class);
      //suite.addTest(new JUnit4TestAdapter(TestJunit3.class));
      TestSuite suite = new TestSuite(TestJunit1.class, TestJunit3.class);
      suite.addTestSuite(TestJunit2.class);
      TestResult result = new TestResult();
      suite.run(result);
      System.out.println("Number of testSuite cases = " + suite.testCount());
      System.out.println("Number of test cases = " + result.runCount());
      //test setName
      suite.setName("testNewName");
      String newName= suite.getName();
      System.out.println("Test Suite Name = "+ newName);
   }
}
