package br.ufsm.lpbd.banking.aspect;

import br.ufsm.lpbd.banking.core.Account;
import br.ufsm.lpbd.banking.exception.InsufficientBalanceException;

// Exercicio 5.3
aspect InsufficientBalanceAspect {

    pointcut debitExecution(Account account, float amount):
        execution(* Account.debit(float)) && target(account) && args(amount) && within(br.ufsm.lpbd.banking.core.*);

    before(Account account, float amount): debitExecution(account, amount) {
        checkBalance(account, amount);
    }

    private void checkBalance(Account account, float amount) {
        float balanceAfterDebit = account.getBalance() - amount;
        if (balanceAfterDebit < 100.0) {
            throw new InsufficientBalanceException("Insufficient balance after debit. Current balance: " + account.getBalance());
        }
    }
}
