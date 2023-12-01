public class CalculatorVisitorImpl extends CalculatorBaseVisitor<Integer> {
    @Override
    public Integer visitExpression(CalculatorParser.ExpressionContext ctx) {
        int result = visit(ctx.term(0));
        for (int i = 1; i < ctx.term().size(); i++) {
            if (ctx.ADD(i - 1) != null) {
                result += visit(ctx.term(i));
            } else if (ctx.SUB(i - 1) != null) {
                result -= visit(ctx.term(i));
            }
        }
        return result;
    }

    @Override
    public Integer visitTerm(CalculatorParser.TermContext ctx) {
        int result = visit(ctx.factor(0));
        for (int i = 1; i < ctx.factor().size(); i++) {
            if (ctx.MUL(i - 1) != null) {
                result *= visit(ctx.factor(i));
            } else if (ctx.DIV(i - 1) != null) {
                int divisor = visit(ctx.factor(i));
                if (divisor != 0) {
                    result /= divisor;
                } else {
                    throw new ArithmeticException("Divisão por zero");
                }
            }
        }
        return result;
    }

    @Override
    public Integer visitFactor(CalculatorParser.FactorContext ctx) {
        if (ctx.NUMBER() != null) {
            return Integer.parseInt(ctx.NUMBER().getText());
        } else {
            return visit(ctx.expression());
        }
    }
}
