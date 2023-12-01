package br.ufsm.lpbd.banking.aspect;

import br.ufsm.lpbd.banking.core.Account;
import br.ufsm.lpbd.banking.core.OverdraftAccount;
import br.ufsm.lpbd.banking.exception.InsufficientBalanceException;

public aspect OverdraftProtectionAspect {

    pointcut debitCall(Account account, float amount) :
        call(* Account.debit(float)) && args(amount) && target(account);

    void around(Account account, float amount) throws InsufficientBalanceException : debitCall(account, amount) {
        if (account instanceof OverdraftAccount) {
            proceed(account, amount);
        } else {
            handleNonOverdraftAccount(account, amount);
        }
    }

    private void handleNonOverdraftAccount(Account account, float amount) throws InsufficientBalanceException {
        float currentBalance = account.getBalance();
        float safeValue = (float) 100.00;
        float discountBalance = currentBalance - amount;

        if (discountBalance >= safeValue) {
            proceed(account, amount);
        } else {
            handleInsufficientBalance(account, amount, discountBalance, safeValue);
        }
    }

    private void handleInsufficientBalance(Account account, float amount, float discountBalance, float safeValue) throws InsufficientBalanceException {
        float valueToDiscount = safeValue + (-1 * discountBalance);
        OverdraftAccount overdraftAccount = getCustomerOverdraftAccount(account);
        float overdraftBalance = overdraftAccount.getBalance();
        float overdraftDiscountBalance = overdraftBalance - valueToDiscount;

        if (overdraftDiscountBalance >= safeValue) {
            float tax = (float) (valueToDiscount * 0.01);
            overdraftAccount.debit(valueToDiscount);
            account.credit(valueToDiscount);
            account.registerTax(tax);

            proceed(account, amount);
        } else {
            throw new InsufficientBalanceException("Saldo insuficiente!");
        }
    }

    private OverdraftAccount getCustomerOverdraftAccount(Account account) {
        return (OverdraftAccount) account.getCustomer().getOverdraftAccounts().get(0);
    }
}
