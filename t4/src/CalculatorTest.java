import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

public class CalculatorTest {
    public static void main(String[] args) {
        testCalculatorInterpreter();
    }

    public static void testCalculatorInterpreter() {
        String[] expressions = {
                "3 + 5 * (10 - 2)",
                "20 / (4 * 2)",
                "10 + 2 * 6"
        };

        for (String expression : expressions) {
            int result = evaluateExpression(expression);
            System.out.println("Expression: " + expression + " Result: " + result);
        }
    }

    public static int evaluateExpression(String input) {
        CalculatorLexer lexer = new CalculatorLexer(CharStreams.fromString(input));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        CalculatorParser parser = new CalculatorParser(tokens);

        ParseTree tree = parser.expression();
        CalculatorVisitorImpl visitor = new CalculatorVisitorImpl();
        return visitor.visit(tree);
    }
}
