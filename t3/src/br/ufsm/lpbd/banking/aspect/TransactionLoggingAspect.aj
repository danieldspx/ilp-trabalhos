package br.ufsm.lpbd.banking.aspect;

import br.ufsm.lpbd.banking.core.Account;

// Exercicio 5.2
public aspect TransactionLoggingAspect {
    pointcut transactionExecution(Account account, float amount) :
        execution(* Account.debit(float)) && args(amount) && target(account);
    
    pointcut creditExecution(Account account, float amount) :
        execution(* Account.credit(float)) && args(amount) && target(account);

    before(Account account, float amount) : transactionExecution(account, amount) || creditExecution(account, amount) {
        System.out.println("[ANTES] Operação " + thisJoinPointStaticPart.getSignature().getName() + " Número da conta: " + account.getAccountNumber() + " Quantia: " + amount);
    }

    after(Account account, float amount) : transactionExecution(account, amount) || creditExecution(account, amount) {
        System.out.println("[DEPOIS] Saldo da conta: " + account.getBalance());
    }
}
